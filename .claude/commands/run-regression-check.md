---
description: Execute a regression check (baseline, blast-radius prioritized tests, diff-based comparison) and log a PASS/FAIL entry with a doc-hash snapshot. This is the only command that writes regression verdicts.
argument-hint: "[feature-name] (omit for a core/base functionality run)"
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# run-regression-check

**Scope:** If `$ARGUMENTS` is provided, this is a **feature-scoped run** — treat it as `{{FEATURE_NAME}}`, and log to `{{FEATURE_NAME}}/{{FEATURE_NAME}}.RegressionCheckQA.md`. If `$ARGUMENTS` is empty, this is a **core run** against base/shared functionality — log to the root `RegressionCheckQA.md`.

**Naming convention check:** Per `CLAUDE.md`, feature names are PascalCase, single compressed word, no hyphens or underscores (e.g. `PayIns`, not `pay-ins` or `pay_ins` or `payins`). If `{{FEATURE_NAME}}` is provided but doesn't match this, stop and tell the user the name doesn't follow the project's convention, showing the corrected form, rather than silently proceeding.

This command is the sole producer of regression verdicts and doc-hash snapshots in either log. No other command should write a `Regression status` or a doc-hash snapshot field — they only read what this command writes.

====================================================================================================================================================================

## STEP 1 - ESTABLISH A BASELINE

- Check out main/master and characterize current behavior — what the app actually does today, correct or not. The question is "did this change," not "is this right."
- Where possible, snapshot actual outputs (API responses, DB state, rendered pages, CLI output) for key flows on the old branch. Use the Bash tool to capture these to temp files for comparison in Step 4.
- Mine existing logs, metrics, or manual QA checklists for what "normal operation" looks like.

## STEP 2 - PRIORITIZE BY BLAST RADIUS

Identify, in this order:
- **Direct dependents:** anything that imports, calls, or shares state/data with the code `{{FEATURE_NAME}}` (or this core change) touches.
- **Shared resources:** DB schema/migrations, shared config, shared utility functions, auth/session logic, global state.
- **Critical paths:** checkout, login, data save/load, and any other "if this breaks, it's an incident" flow — test these regardless of whether the change touches them.

Guiding question: "what could this branch touch that it isn't supposed to?" — not "what should this branch do?"

## STEP 3 - RUN TESTS, IN ORDER OF ROI

1. **Smoke tests** — does the app start, do core pages/endpoints respond, does build/deploy succeed.
2. **Golden/snapshot tests** on existing critical flows — capture current output as correct, diff against it.
3. **Contract tests** at integration boundaries touched by the change.
4. **Targeted unit tests** around the diff — existing logic the change touches, not new feature logic.
5. **A few end-to-end tests** on the 3–5 most important user journeys, run against both branches if feasible.

Use whatever test runner the project already has (detect via `package.json`, `pytest.ini`, etc.) — run via Bash and capture pass/fail per suite.

## STEP 4 - COMPARE

Apply whichever of these fit the project:
- **Diff-based testing:** same inputs through old vs. new branch, diff the outputs against the Step 1 baseline.
- **Shadow/parallel run**, if feasible.
- **Feature-flag check:** flag-off equals old behavior exhaustively; flag-on tested separately.

## STEP 5 - COMPUTE METRICS AND DETERMINE STATUS

- **Diff coverage:** % of changed/added lines exercised by at least one test.
- **Critical path pass rate:** are must-not-break flows green.
- **Escape count:** carry forward from the previous entry's follow-ups, if any were flagged as unresolved.
- **Status:** `PASS` if critical paths are green and no unexplained diffs against baseline; `FAIL` if either is violated; `PARTIAL` if some scope was skipped (say why in Notes).

## STEP 6 - SNAPSHOT DOCUMENTATION STATE (feature-scoped runs only)

If `{{FEATURE_NAME}}` was provided:
- Check whether `{{FEATURE_NAME}}/{{FEATURE_NAME}}.DeveloperDocumentation.md` exists. If so, use the Bash tool to run `sha256sum` on it and capture the hash. If not, mark `Exists: NO`.
- Check whether `{{FEATURE_NAME}}/how-to-{{FEATURE_NAME}}.md` exists. If so, `sha256sum` it and capture the hash. If not, mark `Exists: NO`.
- These hashes represent "the doc content that was true when this regression check passed/failed" — `document-feature.md`'s drift check compares against these later. Do not estimate or reuse an old hash; compute fresh.

## STEP 7 - LOG THE ENTRY

Append to the target log identified in Scope above (never overwrite prior entries):

**Core run** — append to root `RegressionCheckQA.md`:
```
### Entry — {{DATE_RUN}}
- **Date:** {{DATE_RUN}}  <!-- ISO 8601, YYYY-MM-DD -->
- **Run by:** {{NAME}}
- **Branch tested:** {{BRANCH_NAME}}
- **Commit SHA:** {{COMMIT_SHA}}
- **Scope:** {{full regression | smoke only | targeted}}
- **Status:** {{PASS | FAIL | PARTIAL}}
- **Diff coverage:** {{PERCENT}}
- **Critical path pass rate:** {{PERCENT}}
- **Escape count:** {{N}}
- **Notes:** {{free text}}
```

**Feature-scoped run** — append to `{{FEATURE_NAME}}/{{FEATURE_NAME}}.RegressionCheckQA.md`:
```
### Entry — {{DATE_RUN}}
- **Date:** {{DATE_RUN}}  <!-- ISO 8601, YYYY-MM-DD -->
- **Branch:** {{BRANCH_NAME}}
- **Commit SHA:** {{COMMIT_SHA}}
- **Regression status:** {{PASS | FAIL | PARTIAL}}
- **Diff coverage:** {{PERCENT}}
- **Critical path pass rate:** {{PERCENT}}
- **Escape count:** {{N}}

**Developer Documentation Snapshot** (captured at time of this run)
- File: `{{FEATURE_NAME}}.DeveloperDocumentation.md`
- Exists: {{YES | NO}}
- Content hash (sha256): {{HASH | N/A}}

**User Documentation Snapshot** (captured at time of this run)
- File: `how-to-{{FEATURE_NAME}}.md`
- Exists: {{YES | NO}}
- Content hash (sha256): {{HASH | N/A}}

**Notes:** {{free text}}
```

If this is the feature's first-ever entry, also populate the sub-log's header (`Feature branch created`, `Branched from core log entry dated` — pulled from the current latest entry in the root `RegressionCheckQA.md`).
