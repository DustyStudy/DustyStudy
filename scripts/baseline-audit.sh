#!/usr/bin/env bash
# Read-only check of every DustyStudy repo against the repo baseline that
# scripts/repo-baseline.sh applies. Makes no changes; prints a Markdown
# report of drift to stdout and exits 1 when any repo drifts.
#
#   GH_TOKEN=<fine-grained PAT> scripts/baseline-audit.sh > report.md
#
# The token needs read access to every repo: Administration (read),
# Contents (read), Metadata (read). GITHUB_TOKEN cannot see other repos'
# settings, so the weekly workflow uses a PAT stored as BASELINE_AUDIT_TOKEN.
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
    :
  else
    has_pr_rule=$(get false "$R/rules/branches/$branch" --jq 'any(.[]; .type == "pull_request")')
    [ "$has_pr_rule" = true ] || gaps+=("no PR-required ruleset on $branch")
    blocks_force=$(get false "$R/rules/branches/$branch" --jq 'any(.[]; .type == "non_fast_forward")')
    [ "$blocks_force" = true ] || gaps+=("force-push to $branch allowed")
  fi

  # Secret scanning and push protection are free on public repos only.
  if [ "$private" = false ]; then
    ss=$(jq -r '.security_and_analysis.secret_scanning.status // "unknown"' <<<"$meta")
    pp=$(jq -r '.security_and_analysis.secret_scanning_push_protection.status // "unknown"' <<<"$meta")
    [ "$ss" = enabled ] || gaps+=("secret scanning $ss")
    [ "$pp" = enabled ] || gaps+=("push protection $pp")
  fi

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
  if ok "$R/contents/.github/workflows"; then
    ok "$R/contents/.github/dependabot.yml" || gaps+=("no .github/dependabot.yml")
  fi

  if [ ${#gaps[@]} -gt 0 ]; then
    drift=$((drift + 1))
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
  echo "| Repo | Visibility | Gaps |"
  echo "|---|---|---|"
  printf '%s' "$rows"
  echo
  echo "Fix one repo with \`scripts/repo-baseline.sh <repo>\` (try \`DRY_RUN=1\` first). Private repos are not checked for branch rules or secret scanning: GitHub Free doesn't offer them on private repos."
  exit 1
fi
