#!/usr/bin/env bash
# Creates a repo from DustyStudy/repo-template, waits for its first CI run on
# main, then applies the baseline. Use this instead of `gh repo create`, so
# every repo gets the shared security scans and their required checks.
#
#   scripts/new-repo.sh <repo> [--public]    # private unless --public
#
# Required checks are only added after a scan passes on the default branch.
# If the first run fails, the baseline still applies; fix the failure, then
# run scripts/repo-baseline.sh <repo> again. Needs gh authenticated as the
# owner, and jq.
set -euo pipefail

OWNER=DustyStudy
REPO=${1:?usage: $0 <repo> [--public]}
VISIBILITY=--private
[ "${2:-}" = --public ] && VISIBILITY=--public
HERE=$(cd "$(dirname "$0")" && pwd)

gh repo create "$OWNER/$REPO" --template "$OWNER/repo-template" "$VISIBILITY"
echo "created $OWNER/$REPO from repo-template"

# The template's first commit starts the CI run; wait for it so the baseline
# sees the scan results.
run=""
for _ in $(seq 1 30); do
  run=$(gh run list -R "$OWNER/$REPO" --workflow ci.yml --branch main --limit 1 \
    --json databaseId --jq '.[0].databaseId // empty')
  [ -n "$run" ] && break
  sleep 10
done
if [ -n "$run" ]; then
  gh run watch "$run" -R "$OWNER/$REPO" --exit-status ||
    echo "first CI run failed: baseline still applies, failing scans stay optional" >&2
else
  echo "no CI run on main after 5 minutes; check Actions for $OWNER/$REPO" >&2
fi

"$HERE/repo-baseline.sh" "$REPO"
