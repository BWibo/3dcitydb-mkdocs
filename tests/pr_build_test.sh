#!/usr/bin/env bash
#
# Local build-contract test for the per-PR documentation preview.
#
# Runs the exact build the CI does (mkdocs.pr.yml + the PR_* env vars) and
# asserts the preview contract, without deploying anything:
#   - the build succeeds
#   - the preview banner (PR number + URL) is rendered
#   - the page is marked noindex
#   - the mike version selector / versions.json reference is absent
#
# Kept only on the `bwibo` testing fork (docs.brunowillenborg.de); not merged
# to origin. Run from the repo root:
#
#   bash tests/pr_build_test.sh
#
set -euo pipefail

PR_NUMBER="${PR_NUMBER:-999}"
PR_URL="${PR_URL:-https://github.com/BWibo/3dcitydb-mkdocs/pull/${PR_NUMBER}}"
SITE_URL="${SITE_URL:-https://docs.brunowillenborg.de/pr/${PR_NUMBER}/}"

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$(mktemp -d)"
trap 'rm -rf "$OUT"' EXIT

cd "$REPO_ROOT"

echo "==> Building PR preview (PR #${PR_NUMBER}) into ${OUT}"
SITE_URL="$SITE_URL" PR_NUMBER="$PR_NUMBER" PR_URL="$PR_URL" \
  mkdocs build -f mkdocs.pr.yml -d "$OUT" --strict

INDEX="$OUT/index.html"

fail=0
assert_contains() { # <file> <needle> <message>
  if grep -qF "$2" "$1"; then
    echo "  PASS: $3"
  else
    echo "  FAIL: $3"
    fail=1
  fi
}
assert_absent() { # <file> <needle> <message>
  if grep -qF "$2" "$1"; then
    echo "  FAIL: $3"
    fail=1
  else
    echo "  PASS: $3"
  fi
}

echo "==> Asserting preview contract on ${INDEX}"
assert_contains "$INDEX" "Preview of pull request #${PR_NUMBER}" "banner shows PR number"
assert_contains "$INDEX" "$PR_URL" "banner links to the PR"
assert_contains "$INDEX" 'name="robots" content="noindex, nofollow"' "page is noindex"
assert_absent   "$INDEX" "md-version" "no version selector markup"
assert_absent   "$INDEX" "versions.json" "no versions.json reference"

if [ "$fail" -ne 0 ]; then
  echo "==> RESULT: FAILED"
  exit 1
fi
echo "==> RESULT: PASSED"
