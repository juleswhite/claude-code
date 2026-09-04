# {{FEATURE_NAME}} — Regression Check QA (Feature Log)

> Sub-log scoped to the `{{FEATURE_NAME}}` feature/branch. Entries here are written exclusively by `/run-regression-check {{FEATURE_NAME}}`. This file is append-only — newest entry on top. `document-feature.md` (via `RegressionCheckout.md`) only **reads** from this log — it never appends an entry or fabricates a status.

- **Feature directory:** `{{FEATURE_NAME}}/`
- **Feature branch created:** {{FEATURE_CREATION_DATE}}
- **Branched from core log entry dated:** {{CORE_LOG_ENTRY_DATE}} <!-- points back to the base RegressionCheckQA.md entry this feature branched from -->

---

## Entries

<!-- Written by /run-regression-check. Newest entry on top. Date format is ISO 8601 (YYYY-MM-DD) throughout. -->

### Entry — {{DATE_RUN}}
- **Date:** {{DATE_RUN}}
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

---
