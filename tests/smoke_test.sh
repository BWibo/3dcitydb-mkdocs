#!/usr/bin/env bash
#
# Deployed-preview smoke test for the per-PR documentation preview.
#
# Checks a live preview on the testing deployment (docs.brunowillenborg.de):
#   - /pr/<num>/ returns HTTP 200
#   - the preview banner and noindex are present in the served HTML
#   - the root versions.json does NOT list the PR (version menu unaffected)
#
# Kept only on the `bwibo` testing fork; not merged to origin. Usage:
#
#   bash tests/smoke_test.sh <pr-number> [base-url]
#
# Defaults base-url to https://docs.brunowillenborg.de
set -euo pipefail

PR_NUMBER="${1:?usage: smoke_test.sh <pr-number> [base-url]}"
BASE_URL="${2:-https://docs.brunowillenborg.de}"
BASE_URL="${BASE_URL%/}"

PREVIEW_URL="${BASE_URL}/pr/${PR_NUMBER}/"
VERSIONS_URL="${BASE_URL}/versions.json"

fail=0

echo "==> GET ${PREVIEW_URL}"
code="$(curl -s -o /dev/null -w '%{http_code}' "$PREVIEW_URL")"
if [ "$code" = "200" ]; then
  echo "  PASS: preview returns 200"
else
  echo "  FAIL: preview returned HTTP $code"
  fail=1
fi

html="$(curl -s "$PREVIEW_URL")"
if grep -qF "Preview of pull request #${PR_NUMBER}" <<<"$html"; then
  echo "  PASS: banner present in served HTML"
else
  echo "  FAIL: banner missing in served HTML"
  fail=1
fi
if grep -qF 'name="robots" content="noindex, nofollow"' <<<"$html"; then
  echo "  PASS: served page is noindex"
else
  echo "  FAIL: served page missing noindex"
  fail=1
fi

echo "==> GET ${VERSIONS_URL} (PR must be absent)"
versions="$(curl -s "$VERSIONS_URL")"
if grep -qF "\"pr/${PR_NUMBER}\"" <<<"$versions" || grep -qF "\"${PR_NUMBER}\"" <<<"$versions"; then
  echo "  FAIL: versions.json unexpectedly references the PR"
  fail=1
else
  echo "  PASS: versions.json does not list the PR (menu unaffected)"
fi

if [ "$fail" -ne 0 ]; then
  echo "==> RESULT: FAILED"
  exit 1
fi
echo "==> RESULT: PASSED"
