#!/usr/bin/env bash
# Applies the repo baseline to one DustyStudy repo. Safe to re-run.
#
#   scripts/repo-baseline.sh <repo> [extra required check]...
#   DRY_RUN=1 scripts/repo-baseline.sh <repo>     # print the writes only
#
# Pass the repo's own CI jobs (tests, lint, CodeQL) as extra required checks;
# only the security-scan jobs are picked up automatically. Use the names a
# pull request reports, not push-only jobs such as a release.
#
# Run it after creating a repo, and again after the repo's first CI run on
# its default branch: only scan checks that have already passed there become
# required, so a new repo is never blocked waiting on a check that never runs.
# After renaming or removing a CI job, update the required checks before
# merging the PR that does it, or that PR blocks itself.
#
# Needs gh authenticated as a repo admin, and jq.
set -euo pipefail

OWNER=DustyStudy
REPO=${1:?usage: $0 <repo> [extra required check]...}
shift
R=repos/$OWNER/$REPO

api() { # writes go through here so DRY_RUN can print them instead
  if [ -n "${DRY_RUN:-}" ]; then
    echo "DRY_RUN: gh api $*" >&2
    case " $* " in *" --input - "*) jq -c . >&2 ;; esac
  else
    gh api "$@"
  fi
}

private=$(gh api "$R" --jq .private)
branch=$(gh api "$R" --jq .default_branch)

# --- Merging: squash only, so main stays linear; tidy merged branches.
api -X PATCH "$R" --silent \
  -F allow_squash_merge=true -F allow_merge_commit=false -F allow_rebase_merge=false \
  -F delete_branch_on_merge=true
echo "merge settings: squash only, delete merged branches"

# --- Security features. Secret scanning on a private repo needs GitHub
# Advanced Security, so it is only turned on for public ones.
api -X PUT "$R/vulnerability-alerts" --silent
api -X PUT "$R/automated-security-fixes" --silent
echo "dependabot: alerts and security updates on"
if [ "$private" = false ]; then
  api -X PATCH "$R" --silent \
    -F 'security_and_analysis[secret_scanning][status]=enabled' \
    -F 'security_and_analysis[secret_scanning_push_protection][status]=enabled'
  api -X PUT "$R/private-vulnerability-reporting" --silent
  echo "secret scanning, push protection, private vulnerability reporting: on"
fi

# --- Actions: require full-SHA pins and a read-only default token. The
# allowed-actions policy and "Actions can create PRs" (release-please needs
# it) are kept as the repo has them.
allowed=$(gh api "$R/actions/permissions" --jq .allowed_actions)
can_approve=$(gh api "$R/actions/permissions/workflow" --jq .can_approve_pull_request_reviews)
api -X PUT "$R/actions/permissions" --silent \
  -F enabled=true -f allowed_actions="$allowed" -F sha_pinning_required=true
api -X PUT "$R/actions/permissions/workflow" --silent \
  -f default_workflow_permissions=read -F can_approve_pull_request_reviews="$can_approve"
echo "actions: SHA pinning required, default token read-only"

# --- Required checks: the security-scan jobs (shared workflow, the hub's
# self-call, or a local copy) that last passed on the default branch, plus
# any passed as arguments.
sha=$(gh api "$R/commits/$branch" --jq .sha)
scan_re='^((Security )?scan / )?(Secrets [(]Gitleaks[)]|Vulnerabilities and misconfiguration [(]Trivy[)]|Workflow security [(]zizmor[)]|Misconfiguration [(]Checkov[)])$'
checks=$(gh api "$R/commits/$sha/check-runs?per_page=100" --jq \
  "[.check_runs[] | select(.app.slug == \"github-actions\" and .conclusion == \"success\") | .name | select(test(\"$scan_re\"))]")
checks=$(jq -c -n --argjson a "$checks" '$ARGS.positional + $a | unique' --args "$@")

# --- Branch protection. A repo that already uses classic protection keeps
# it (its settings and checks stay; the new checks are added). Anything
# else gets a "Protect main" ruleset. Either way a PR must be up to date
# with the base branch and have its review threads resolved.
if current=$(gh api "$R/branches/$branch/protection" 2>/dev/null); then
  # PUT replaces the whole rule, so every current setting is carried over.
  # Push restrictions do not exist on a personal account's repos.
  jq --argjson add "$checks" '{
      required_status_checks: {strict: true,
        checks: ([.required_status_checks.checks[]?.context] + $add | unique | map({context: ., app_id: 15368}))},
      enforce_admins: .enforce_admins.enabled,
      required_pull_request_reviews: (.required_pull_request_reviews // null | if . then
        {dismiss_stale_reviews, require_code_owner_reviews, require_last_push_approval, required_approving_review_count}
        else . end),
      restrictions: null,
      required_linear_history: .required_linear_history.enabled,
      allow_force_pushes: .allow_force_pushes.enabled,
      allow_deletions: .allow_deletions.enabled,
      block_creations: .block_creations.enabled,
      required_conversation_resolution: true,
      lock_branch: .lock_branch.enabled,
      allow_fork_syncing: .allow_fork_syncing.enabled}' <<<"$current" |
    api -X PUT "$R/branches/$branch/protection" --input - --silent
  echo "classic protection kept; required checks now include: $(jq -r 'join(", ")' <<<"$checks")"
else
  id=$(gh api "$R/rulesets" --jq '.[] | select(.name == "Protect main") | .id')
  if [ -n "$id" ]; then
    # Keep every existing rule (code scanning, etc.); only merge in the checks.
    body=$(gh api "$R/rulesets/$id" | jq --argjson add "$checks" '
      {name, target, enforcement, conditions, bypass_actors, rules} |
      (.rules[] | select(.type == "pull_request") | .parameters.required_review_thread_resolution) = true |
      if any(.rules[]; .type == "required_status_checks") then
        .rules |= map(if .type == "required_status_checks" then
          .parameters.strict_required_status_checks_policy = true |
          .parameters.required_status_checks |= ((map(.context) + $add) | unique | map({context: ., integration_id: 15368}))
          else . end)
      elif ($add | length) > 0 then
        .rules += [{type: "required_status_checks", parameters: {strict_required_status_checks_policy: true,
          required_status_checks: ($add | map({context: ., integration_id: 15368}))}}]
      else . end')
    api -X PUT "$R/rulesets/$id" --input - --silent <<<"$body"
  else
    body=$(jq -n --argjson names "$checks" '{
      name: "Protect main", target: "branch", enforcement: "active",
      conditions: {ref_name: {include: ["~DEFAULT_BRANCH"], exclude: []}},
      rules: ([
        {type: "deletion"}, {type: "non_fast_forward"}, {type: "required_linear_history"},
        {type: "pull_request", parameters: {
          required_approving_review_count: 0, dismiss_stale_reviews_on_push: false,
          require_code_owner_review: false, require_last_push_approval: false,
          required_review_thread_resolution: true}}
      ] + (if ($names | length) > 0 then [{type: "required_status_checks", parameters: {
          strict_required_status_checks_policy: true,
          required_status_checks: ($names | map({context: ., integration_id: 15368}))}}] else [] end))}')
    api -X POST "$R/rulesets" --input - --silent <<<"$body"
  fi
  all=$(jq -c '[.rules[] | select(.type == "required_status_checks") | .parameters.required_status_checks[].context]' <<<"$body")
  echo "ruleset \"Protect main\"; required checks: $(jq -r 'join(", ")' <<<"$all")"
fi

# A required check that a workflow no longer produces blocks every PR. The
# script never removes checks (some, like dependency-review, only run on
# PRs), so flag the ones not seen on the latest default-branch commit.
seen=$(gh api "$R/commits/$sha/check-runs?per_page=100" --jq '[.check_runs[].name]')
required=$({ gh api "$R/branches/$branch/protection/required_status_checks" --jq '[.checks[].context]' 2>/dev/null || echo '[]'; } )
[ -n "${all:-}" ] && required=$all
jq -r --argjson seen "$seen" '.[] | select(. as $c | $seen | index($c) | not)' <<<"$required" |
  while read -r c; do echo "check: required but not reported on $branch's latest commit (PR-only or renamed?): $c" >&2; done
