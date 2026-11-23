#!/usr/bin/env bash
# Read-only check of every DustyStudy repo against the repo baseline that
# scripts/repo-baseline.sh applies. Makes no changes; prints a Markdown
# report of drift to stdout. Exits 0 when clean, 2 when any repo drifts,
# and anything else (1 from set -e) when the audit itself fails.
#
#   GH_TOKEN=<fine-grained PAT> scripts/baseline-audit.sh > report.md
#
# The report is posted to a public repo, so private repos are counted but
# not named. SHOW_PRIVATE=1 names them too, for a local run.
#
# Checks: branch rules (PR required, no force-push, enforce_admins on classic
# protection, no ruleset bypass actors, the Gitleaks, Trivy and zizmor scan
# checks required), squash-only merging, wiki off,
# Dependabot alerts and security updates, Actions SHA pinning, read-only
# default token, fork PR approval, dependabot.yml, workflows not disabled,
# and on public repos secret scanning, push protection, private
# vulnerability reporting and CodeQL (default setup or the repo's own workflow).
#
# The token needs read access to every repo: Actions: read (workflow list),
# Administration: read (branch protection, rulesets, Actions and security
# settings, merge settings), Contents: read, Metadata: read. Without
# Administration: read those settings read as missing and are reported as
# gaps. A ruleset's bypass actors are only returned to a token that can edit
# the ruleset, so a read-only token reports them as unknown. GITHUB_TOKEN cannot see other repos' settings, so the weekly
# workflow uses a PAT stored as BASELINE_AUDIT_TOKEN.
#
# Fix a drifting repo with: scripts/repo-baseline.sh <repo>
set -euo pipefail

OWNER=DustyStudy

ok() { gh api "$@" >/dev/null 2>&1; }
# get <fallback> <gh api args>: the value, or the fallback if the call fails
# (gh prints the error body to stdout, so `|| echo` alone would append it).
get() { local fb=$1 out; shift; out=$(gh api "$@" 2>/dev/null) && echo "$out" || echo "$fb"; }

# REPOS="a b" limits the audit to those repos.
repos=${REPOS:-$(gh api --paginate "user/repos?affiliation=owner&per_page=100" \
  --jq ".[] | select(.owner.login == \"$OWNER\" and (.archived | not) and (.fork | not)) | .name" | sort)}

drift=0
private_drift=0
rows=""
for name in $repos; do
  R=repos/$OWNER/$name
  meta=$(gh api "$R")
  private=$(jq -r .private <<<"$meta")
  branch=$(jq -r .default_branch <<<"$meta")
  gaps=()

  # Branch protection: a "Protect main"-style ruleset or classic protection
  # that requires a pull request. Private repos can't have either on Free.
  if [ "$private" = true ]; then
    :
  elif ok "$R/branches/$branch/protection/required_pull_request_reviews"; then
    ea=$(get false "$R/branches/$branch/protection/enforce_admins" --jq .enabled)
    [ "$ea" = true ] || gaps+=("enforce_admins off")
  else
    has_pr_rule=$(get false "$R/rules/branches/$branch" --jq 'any(.[]; .type == "pull_request")')
    [ "$has_pr_rule" = true ] || gaps+=("no PR-required ruleset on $branch")
    blocks_force=$(get false "$R/rules/branches/$branch" --jq 'any(.[]; .type == "non_fast_forward")')
    [ "$blocks_force" = true ] || gaps+=("force-push to $branch allowed")
  fi

  # Bypass actors are exempt from a ruleset's rules. Each rule on the branch
  # names its (active) ruleset; the actors are in the ruleset itself. Checked
  # on the classic path too: a repo can have both.
  if [ "$private" = false ]; then
    bypass=$(for id in $(get "" "$R/rules/branches/$branch" --jq '[.[].ruleset_id] | unique | .[]'); do
      get unknown "$R/rulesets/$id" --jq '.bypass_actors | if . == null then "unknown" else length end'
    done)
    if grep -q '[1-9]' <<<"$bypass"; then gaps+=("ruleset has bypass actors")
    elif grep -q unknown <<<"$bypass"; then gaps+=("ruleset bypass actors unknown"); fi
  fi

  # Secret scanning and push protection are free on public repos only.
  if [ "$private" = false ]; then
    ss=$(jq -r '.security_and_analysis.secret_scanning.status // "unknown"' <<<"$meta")
    pp=$(jq -r '.security_and_analysis.secret_scanning_push_protection.status // "unknown"' <<<"$meta")
    [ "$ss" = enabled ] || gaps+=("secret scanning $ss")
    [ "$pp" = enabled ] || gaps+=("push protection $pp")
  fi

  wfs=$(get "" "$R/contents/.github/workflows" --jq '.[].name')

  # Public-only: the features are free there, and forks can open PRs.
  if [ "$private" = false ]; then
    req=$(get "" "$R/rules/branches/$branch" \
      --jq '.[] | select(.type == "required_status_checks") | .parameters.required_status_checks[].context')
    req+=$'\n'$(get "" "$R/branches/$branch/protection/required_status_checks" --jq '.checks[].context')
    for c in 'Secrets (Gitleaks)' 'Vulnerabilities and misconfiguration (Trivy)' 'Workflow security (zizmor)'; do
      grep -qF "$c" <<<"$req" || gaps+=("$c not required")
    done
    pvr=$(get false "$R/private-vulnerability-reporting" --jq .enabled)
    [ "$pvr" = true ] || gaps+=("private vulnerability reporting off")
    cql=$(get unknown "$R/code-scanning/default-setup" --jq .state)
    # A repo's own (advanced) CodeQL workflow replaces default setup.
    [ "$cql" = configured ] || grep -qi codeql <<<"$wfs" || gaps+=("CodeQL default setup not configured")
    fork=$(get unknown "$R/actions/permissions/fork-pr-contributor-approval" --jq .approval_policy)
    [ "$fork" = all_external_contributors ] || gaps+=("fork PR approval below all_external_contributors")
  fi

  jq -e '.allow_squash_merge == true and .allow_merge_commit == false and .allow_rebase_merge == false' \
    <<<"$meta" >/dev/null || gaps+=("merge settings not squash-only")

  [ "$(jq -r .has_wiki <<<"$meta")" = false ] || gaps+=("wiki on")

  ok "$R/vulnerability-alerts" || gaps+=("Dependabot alerts off")
  dsu=$(get false "$R/automated-security-fixes" --jq .enabled)
  [ "$dsu" = true ] || gaps+=("Dependabot security updates off")

  pin=$(get unknown "$R/actions/permissions" --jq '.sha_pinning_required // false')
  [ "$pin" = true ] || gaps+=("Actions SHA pinning not required")
  tok=$(get unknown "$R/actions/permissions/workflow" --jq .default_workflow_permissions)
  [ "$tok" = read ] || gaps+=("default GITHUB_TOKEN is $tok")

  # Dependabot keeps action SHA pins current, so it's only needed where
  # there are workflows. CODEOWNERS isn't checked: with one maintainer it
  # changes nothing (the template still ships one).
  if [ -n "$wfs" ]; then
    ok "$R/contents/.github/dependabot.yml" || gaps+=("no .github/dependabot.yml")
    # GitHub turns off a public repo's scheduled workflows after 60 days with
    # no commits, so the weekly scans stop without failing anything; one
    # disabled by hand stops them just the same.
    off=$(get "?" "$R/actions/workflows" --paginate \
      --jq '[.workflows[] | select(.state != "active") | "\(.name) (\(.state))"] | join(", ")')
    if [ "$off" = "?" ]; then gaps+=("can't list workflows (token needs Actions: read)")
    elif [ -n "$off" ]; then gaps+=("workflows not active: $off"); fi
  fi

  if [ ${#gaps[@]} -gt 0 ]; then
    drift=$((drift + 1))
    if [ "$private" = true ] && [ -z "${SHOW_PRIVATE:-}" ]; then
      private_drift=$((private_drift + 1))
      continue
    fi
    vis=$([ "$private" = true ] && echo private || echo public)
    joined=$(printf '%s; ' "${gaps[@]}")
    rows+="| [$name](https://github.com/$OWNER/$name) | $vis | ${joined%; } |"$'\n'
  fi
done

total=$(wc -w <<<"$repos")
echo "## Repo baseline audit"
echo
echo "Checked $total repos; $drift drift from the baseline."
echo
if [ "$drift" -gt 0 ]; then
  if [ -n "$rows" ]; then
    echo "| Repo | Visibility | Gaps |"
    echo "|---|---|---|"
    printf '%s' "$rows"
    echo
  fi
  if [ "$private_drift" -gt 0 ]; then
    echo "$private_drift private repo(s) also drift; they are not named here. Run \`SHOW_PRIVATE=1 scripts/baseline-audit.sh\` locally to list them."
    echo
  fi
  echo "Fix one repo with \`scripts/repo-baseline.sh <repo>\` (try \`DRY_RUN=1\` first). Private repos are not checked for branch rules or secret scanning: GitHub Free doesn't offer them on private repos."
  exit 2
fi
