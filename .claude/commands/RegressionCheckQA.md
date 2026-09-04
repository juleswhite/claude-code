# Regression Check QA — Core Log

> This is the **base log**, scoped to shared/core application functionality (not any single feature). Entries here are written exclusively by `/run-regression-check` (invoked with no arguments). This file is append-only — newest entry on top. Do not overwrite prior entries, and do not hand-edit a `Status` field after the fact.
>
> When a new feature branch is created, it gets its own sub-log at `{{FEATURE_NAME}}/{{FEATURE_NAME}}.RegressionCheckQA.md`, which records which core-log entry (by date) it branched from.

---

## Methodology (executed by `/run-regression-check`, documented here for reference)

1. **Establish a baseline first** — check out main/master, characterize current behavior, snapshot outputs for key flows as the comparison point.
2. **Prioritize by blast radius** — direct dependents, shared resources (schema, config, auth/session, global state), and critical paths (checkout, login, save/load), regardless of whether the change touches them.
3. **Run tests in order of ROI** — smoke tests, golden/snapshot tests, contract tests, targeted unit tests around the diff, then a handful of end-to-end tests on top user journeys.
4. **Compare** — diff-based testing against baseline, shadow/parallel run if feasible, or feature-flag-off-equals-old-behavior verification.
5. **Track metrics** — diff coverage, critical path pass rate, escape count (bugs found post-run that this pass missed, fed back in as new tests).

---

## Entries

<!-- Written by /run-regression-check. Newest entry on top. Date format is ISO 8601 (YYYY-MM-DD) throughout. -->

### Entry — 2026-08-07 (follow-up)
- **Date:** 2026-08-07
- **Run by:** Claude Code
- **Branch tested:** master
- **Commit SHA:** d72929033ea3c1a029b9f88a43c5779ebcc5aad4
- **Scope:** full regression (follow-up to the same-day baseline entry below, verifying `fix/export-v4-build-error` after merge)
- **Status:** PASS
- **Diff coverage:** 100% of the diff (2 lines changed in `ExportDrawer.tsx`, 1 new file `.eslintrc.json` — both exercised directly by the smoke tests below)
- **Critical path pass rate:** 100% (3/3)
- **Escape count:** 0
- **Notes:** Verifies the fix branch merged to master (`d1d0d39` fix + `d729290` chore, fast-forwarded `02a49c5..d729290`, pushed to origin).
  - Smoke test — production build: **PASS**. `npm run build` compiles and generates all 5 static pages cleanly — the `Set<string>` iteration TS error from the baseline entry is gone.
  - Smoke test — lint: **PASS**. `npm run lint` now runs non-interactively via the new `.eslintrc.json` (`next/core-web-vitals`) — "No ESLint warnings or errors."
  - Smoke test — core pages respond: **PASS** (`GET /` → 200, `GET /expenses` → 200).
  - Both follow-ups flagged in the prior baseline entry are resolved: (1) production build no longer broken, (2) lint is CI-runnable. No new issues introduced by the fix.
  - Still no automated unit/integration/e2e test suite in this project — diff coverage above is smoke-test-based, not unit-test-based, since none exists.

---

### Entry — 2026-08-07
- **Date:** 2026-08-07
- **Run by:** Claude Code
- **Branch tested:** master
- **Commit SHA:** 02a49c5f10ae2cd544f2c3fa107465bbf736502b (+ uncommitted CLAUDE.md edit, working tree)
- **Scope:** full regression (initial core baseline — no prior entry to diff against)
- **Status:** FAIL
- **Diff coverage:** 0% (no automated test framework configured in this project — see `CLAUDE.md`)
- **Critical path pass rate:** 67% (2/3 — see Notes)
- **Escape count:** 0
- **Notes:** This is the first-ever core regression entry, so it establishes the baseline rather than diffing against a prior run.
  - Smoke test — dev server start: **PASS** (`npm run dev` boots cleanly on port 3000).
  - Smoke test — core pages respond: **PASS** (`GET /` → 200, `GET /expenses` → 200).
  - Smoke test — production build: **FAIL**. `npm run build` fails type-checking with: `components/export/ExportDrawer.tsx:76:40 - Type 'Set<string>' can only be iterated through when using the '--downlevelIteration' flag or with a '--target' of 'es2015' or higher.` in `setConnected((prev) => new Set([...prev, id]))`. This code shipped in the `feature-data-export-v4` → `master` merge (commit `8be86a9`). It blocks `npm run build`/production deploy on current master — a critical-path break per Step 2 of this methodology, regardless of whether this run's scope was that feature. Flagged as a follow-up: fix the Set-spread iteration (either add `downlevelIteration`/bump `target` to ES2015+ in `tsconfig.json`, or rewrite as `new Set(prev).add(id)`) and re-run this check.
  - `npm run lint`: could not complete — no ESLint config exists yet in the repo, so `next lint` drops into an interactive "How would you like to configure ESLint?" prompt with no non-interactive flag path. Marked as skipped, not scored into pass rate. Follow-up: commit an `.eslintrc` so lint is runnable in CI/non-interactively.
  - No automated unit/integration/e2e test suite exists (confirmed via `CLAUDE.md`: "No test framework is configured in this project"), so diff coverage and golden/snapshot/contract tests (Step 3.2–3.5) were not applicable/executable this run.
  - CRUD/filter/sort core logic (`hooks/useExpenses.ts`) was not exercised beyond page load since there is no test harness; this is inherited risk for all future runs until a test framework is added.

---
