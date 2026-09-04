---
description: Generate developer and user documentation for a feature branch, log a regression-check entry with content hashes for both docs, and flag drift against the last passing regression run.
argument-hint: "[feature-name] [--user-facing | --internal-only] (flag optional)"
allowed-tools: Read, Write, Edit, Glob, Grep, Bash(sha256sum:*), Bash(date:*)
---

# document-feature

**Feature name and override:** `$ARGUMENTS` is a single trailing string — parse it yourself. Treat the first whitespace-separated token as `{{FEATURE_NAME}}`. Look for `--user-facing` or `--internal-only` anywhere else in the string:
- `--user-facing` → skip judgment in Step 2 entirely; always regenerate `how-to-{{FEATURE_NAME}}.md`.
- `--internal-only` → skip judgment in Step 2 entirely; never regenerate `how-to-{{FEATURE_NAME}}.md`, regardless of what the diff looks like.
- Neither flag present → fall back to the diff-based judgment described in Step 2.

If both flags are present, or `{{FEATURE_NAME}}` is empty, ask the user to clarify before proceeding — do not guess.

**Naming convention check:** Per `CLAUDE.md`, feature names are PascalCase, single compressed word, no hyphens or underscores (e.g. `PayIns`, not `pay-ins` or `pay_ins` or `payins`). If `{{FEATURE_NAME}}` doesn't match this — contains a hyphen/underscore, or is all-lowercase/all-uppercase — stop and tell the user the name doesn't follow the project's convention, showing the corrected form, rather than silently proceeding or auto-correcting it yourself.

## SETUP - Directory Structure

All artifacts for a feature live under a per-feature directory: `{{FEATURE_NAME}}/`

```
{{FEATURE_NAME}}/
    {{FEATURE_NAME}}.DeveloperDocumentation.md
    {{FEATURE_NAME}}.DeveloperDocumentation_Old.md
    how-to-{{FEATURE_NAME}}.md
    how-to-{{FEATURE_NAME}}_Old.md
    {{FEATURE_NAME}}.RegressionCheckQA.md      <- feature sub-log, append-only
    {{FEATURE_NAME}}.RegressionCheckout.md
```

The root-level `RegressionCheckQA.md` is the **core log** for base/shared functionality. It is not feature-specific and is never overwritten by this command — only read from, to confirm which core entry a feature branched from.

====================================================================================================================================================================

## STEP 1 - CREATE DEVELOPER DOCUMENTATION ARTIFACT AND ARCHIVE OLD VERSION

**Create a Developer Documentation Artifact for feature `{{FEATURE_NAME}}`.**

**Create a detailed structure that includes:**
- Architecture Decision Records
- API References: endpoints, request formats, and responses
- Technical specs
- READMEs and Getting Started Guides
- Release Notes and Change Logs
- Read through `{{FEATURE_NAME}}.review.md` and include any vulnerabilities not addressed in the initial design.
- Read through `CLAUDE.md` to ensure any applied design follows global infrastructure conventions.
- Identify whether `{{FEATURE_NAME}}` is frontend/backend/full-stack and adjust documentation accordingly.

**Output:** `{{FEATURE_NAME}}/{{FEATURE_NAME}}.DeveloperDocumentation.md`

**Archiving:** If `{{FEATURE_NAME}}.DeveloperDocumentation.md` already exists, copy the existing version to `{{FEATURE_NAME}}.DeveloperDocumentation_Old.md` in the same folder, with a demarcated section outlining what changed from the prior version.

**Timestamp + hash:** After writing the file, use the Bash tool to run `sha256sum {{FEATURE_NAME}}/{{FEATURE_NAME}}.DeveloperDocumentation.md` and `date` to capture the current date/time. Do this as a live tool call against the file you just wrote — never fabricate or estimate a hash. Hold onto both values so you can mention them in your summary; the authoritative snapshot for comparison purposes is still the one captured by `/run-regression-check`, not by this command.

====================================================================================================================================================================

## STEP 2 - CREATE USER DOCUMENTATION ARTIFACT AND ARCHIVE OLD VERSION (IF THE CHANGE IS USER-FACING)

**First, check the override parsed above:**
- If `--internal-only` was passed AND `how-to-{{FEATURE_NAME}}.md` already exists, treat this as NOT user-facing — skip straight to the "If NOT user-facing" block below. (If no prior file exists, `--internal-only` is ignored — a feature can't ship with zero user documentation on its first pass; fall through to "If user-facing" instead.)
- If `--user-facing` was passed, treat this as user-facing — skip straight to the "If user-facing" block below. Do not read the diff or apply judgment.
- If neither flag was passed, fall back to judgment: read the diff/commit for `{{FEATURE_NAME}}` and compare it against the steps in the existing guide (if one exists). A change is user-facing if it alters what the user sees, clicks, enters, or the order/outcome of the steps. A bug fix, refactor, or internal change with no observable difference in the documented workflow is **not** user-facing, even if it's a meaningful code change.

**If NOT user-facing:**
- Do not regenerate or overwrite `how-to-{{FEATURE_NAME}}.md`. Leave the file byte-for-byte untouched — regenerating it even with equivalent content changes its hash and creates false drift signals later.
- Do not create a `how-to-{{FEATURE_NAME}}_Old.md` for this run.
- Note in your response to the user that user documentation was reviewed and found unaffected by this change, so it was left as-is.
- Skip the rest of this step and proceed to Step 3.

**If user-facing** (via `--user-facing`, judgment, or no prior `how-to-{{FEATURE_NAME}}.md` exists yet), create a User Documentation Artifact for feature `{{FEATURE_NAME}}`.

**Create a detailed structure that includes:**
- A simple guide with screenshot placeholders
- Step-by-step instructions for completing the new feature's workflow
- A flag recording when the document was created/updated

**Output:** `{{FEATURE_NAME}}/how-to-{{FEATURE_NAME}}.md`

**Archiving:** If `how-to-{{FEATURE_NAME}}.md` already exists, copy the existing version to `how-to-{{FEATURE_NAME}}_Old.md` in the same folder, with a demarcated section outlining what changed from the prior version.

**Timestamp + hash:** After writing the file, use the Bash tool to run `sha256sum {{FEATURE_NAME}}/how-to-{{FEATURE_NAME}}.md` and `date` to capture the current date/time. Do this as a live tool call against the file you just wrote — never fabricate or estimate a hash. Hold onto both values so you can mention them in your summary; the authoritative snapshot for comparison purposes is still the one captured by `/run-regression-check`, not by this command.

====================================================================================================================================================================

## STEP 3 - CHECK DOCS FOR DRIFT AGAINST THE LAST PASSING REGRESSION RUN

This command never writes to `{{FEATURE_NAME}}.RegressionCheckQA.md`. That log is written exclusively by `/run-regression-check` — this step only reads it.

1. Open `{{FEATURE_NAME}}/{{FEATURE_NAME}}.RegressionCheckQA.md` (if it doesn't exist yet, skip to step 4 — there is no regression history to compare against, and every doc is trivially "unverified").

2. Find the most recent entry where `Regression status = PASS`.

3. Generate `{{FEATURE_NAME}}.RegressionCheckout.md` that:
   - Uses the Bash tool to compute a fresh `sha256sum` of `{{FEATURE_NAME}}.DeveloperDocumentation.md` (written in Step 1) and compares it to the Developer Documentation Snapshot hash stored in that PASS entry.
   - Uses the Bash tool to compute a fresh `sha256sum` of `how-to-{{FEATURE_NAME}}.md` (written in Step 2) and compares it to the User Documentation Snapshot hash stored in that PASS entry.
   - Flags each independently — a hash mismatch in dev docs is a separate flag from a hash mismatch in user docs, since one doc can drift without the other.
   - Flags if the most recent PASS entry predates `{{FEATURE_NAME}}`'s feature creation date.

4. If any flag is raised, or if no `RegressionCheckQA.md` / no PASS entry exists at all, notify the developer that this feature (or the specific doc that drifted) has not been verified by a passing regression check, and recommend running `/run-regression-check {{FEATURE_NAME}}`.
