# PR preview tests

Lightweight tests for the per-PR documentation preview feature.

> **Scope:** these tests live **only on the `bwibo` testing fork**
> (`BWibo/3dcitydb-mkdocs`, served at `docs.brunowillenborg.de`). They are **not**
> merged to `origin` — keep them on a separate `test-*` branch / commit that stays off
> the upstream PR. The feature code (workflows, `mkdocs.pr.yml`, `overrides/`) is what
> merges to `origin`.

## `pr_build_test.sh` — local build contract

Builds the preview exactly as CI does and asserts the output contract (banner, `noindex`,
no version selector). No deployment needed.

```bash
bash tests/pr_build_test.sh
# override the simulated PR:
PR_NUMBER=123 bash tests/pr_build_test.sh
```

Requires the doc toolchain from `requirements.txt` (`mkdocs`, `mike`, plugins) on `PATH`.

## `smoke_test.sh` — deployed preview

Checks a live preview after the deploy workflow has run on the testing deployment:

```bash
bash tests/smoke_test.sh <pr-number>
# against a different host:
bash tests/smoke_test.sh <pr-number> https://docs.brunowillenborg.de
```

Asserts the preview URL returns 200 with the banner + `noindex`, and that the root
`versions.json` does **not** list the PR (the version menu stays unaffected).

## Suggested end-to-end run on `bwibo`

1. Push the feature branch to `bwibo` and open a PR there.
2. Watch **Build PR preview** → **Deploy PR preview**; confirm the bot comment appears.
3. `bash tests/smoke_test.sh <pr#>`.
4. Close the PR, run **Cleanup PR previews** via *workflow_dispatch*, and confirm
   `https://docs.brunowillenborg.de/pr/<pr#>/` now returns 404.
