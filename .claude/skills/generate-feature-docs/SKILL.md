---
name: generate-feature-docs
description: Generate feature documentation under user-docs/<featureName>, auto-detecting whether the feature is backend/frontend/full-stack, auto-capturing screenshots when missing, and auto-linking related existing docs.
argument-hint: "[featureName]"
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Skill
---

Generate documentation for feature `$1`.

## Step 1 — Classify the feature (backend / frontend / full-stack)

Before touching screenshots, search the repository for files relevant to `$1` (by feature name, route/URL fragments, and obvious keyword variants — kebab-case, camelCase, PascalCase). Use Glob/Grep across the whole repo, not just `user-docs/`.

Bucket what you find:

- **Backend evidence**: controllers/route handlers, services, repositories/DAOs, models/entities, DTOs, API/OpenAPI specs, migrations.
- **Frontend evidence**: templates/views, components (`.tsx`/`.jsx`/`.vue`/`.svelte`/etc.), client-side JS/TS driving the feature, feature-specific CSS.

Classify as:

- **Backend-only** — backend evidence found, no dedicated frontend surface for this feature.
- **Frontend-only** — frontend evidence found, no dedicated backend/API code for this feature (e.g. it's purely client-side, or it consumes a generic existing endpoint).
- **Full-stack** — both.

This classification drives the structure of both output docs (see Step 3) and whether screenshot capture is even applicable (Step 2).

## Step 2 — Screenshots

Screenshots live in:

`${CLAUDE_PROJECT_DIR}/user-docs/$1/screenshots`

The directory may contain screenshot1.png, screenshot2.png, ... screenshotN.png — never assume a fixed count. If it already exists and has image files, use those as-is; do not move, rename, or modify them, and skip straight to Step 3.

If it's missing or empty:

- **Backend-only feature**: there is nothing to screenshot. Don't attempt capture and don't treat this as an error — proceed to Step 3 and produce an API-usage guide instead of a screenshot walkthrough.
- **Frontend-only or full-stack feature**: attempt to auto-capture screenshots before giving up:
  1. Check whether a `run` skill is available for this project (or a documented dev-server command in README/CLAUDE.md/package.json). Use it to start the app locally.
  2. Use the claude-in-chrome tools to navigate to the page(s)/route(s) identified in Step 1, drive the feature through its main states (e.g. initial view, an interactive/opened state, a filled-in or filtered state), and capture one screenshot per meaningful state.
  3. Save each capture into `${CLAUDE_PROJECT_DIR}/user-docs/$1/screenshots/` as `screenshot1.png`, `screenshot2.png`, etc., in the order a user would encounter them.
  4. If the app can't be started, the relevant route can't be found, or browser automation isn't available, stop capture attempts — don't fabricate what the UI looks like from code alone.

  If auto-capture wasn't possible, stop and report this clearly to the user instead of guessing at the feature's UI. Suggest checking for a typo in the feature name, confirming the app can run locally, or adding screenshots manually.

## Step 3 — Generate the docs

Inside `${CLAUDE_PROJECT_DIR}/user-docs/$1/` folder create exactly:

1. `implementation-details.md`
2. `user-guide.md`

### implementation-details.md

- State the feature's classification (Backend-only / Frontend-only / Full-stack) up top with a one-line rationale (what evidence led to it).
- Explain what the feature does.
- Explain its main workflow — end-to-end for full-stack (UI → API → service → data), request/response-centric for backend-only, or UI/state-centric for frontend-only.
- Find all files in the repository that are relevant to this feature and list them with a brief description of their purpose.
- Analyze code style, patterns, and conventions used in the relevant files.
- Explain any relevant implementation details that can be inferred from the repository code.
- If backend-only (or full-stack with a non-trivial API surface), include an **API Reference** section: endpoints, HTTP methods, request/response shapes, inferred from the controller/route and DTO code — not invented.
- Add a link to the detailed guide:

  `[See the user guide](./user-guide.md)`

### user-guide.md

- **Frontend-only / full-stack, with screenshots**: provide step-by-step instructions based on the screenshots (existing or freshly captured in Step 2). Use all relevant screenshots, but don't force every screenshot into the document if one is redundant.
- **Backend-only (no UI, no screenshots)**: provide a usage guide instead — example requests (curl or equivalent) and example responses for each relevant endpoint, derived from the controller/DTO code.
- Add a link back to the implementation details:

  `[For more info, check out implementation-details](./implementation-details.md)`

When embedding screenshots, calculate the correct relative path from the generated Markdown file to the original screenshot.

Do not invent UI behavior that cannot be inferred from the screenshots or repository code.

## Step 4 — Auto-link related documentation

Look for existing documentation that overlaps with this feature:

- Other folders under `user-docs/*/` whose `implementation-details.md` references any of the same files you listed in Step 1 (shared controller, service, model, component, etc.), or whose feature name/keywords clearly overlap.
- Repo-level docs (`README.md`, `CLAUDE.md`, `docs/**`) that mention this feature or the same relevant files.

If you find genuine overlap (shared files or explicit textual reference — not a guessed/topical relationship), add a **Related Documentation** section near the end of `implementation-details.md` listing each with a relative link and a one-line reason (e.g. "shares `ExportService` with the CSV export feature"). Skip the section entirely if nothing genuinely overlaps — don't invent relationships.

Only edit the files you are generating in `user-docs/$1/`. Do not modify other features' existing docs to add backlinks.