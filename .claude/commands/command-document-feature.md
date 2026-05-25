# Document Feature Command

Generate paired developer and user documentation for the feature: **$ARGUMENTS**.

## Inputs

- `$ARGUMENTS` is the feature name in any form (e.g. `csv-export`, `csv export`, `CSV Export`).
- Slugify it to kebab-case → `<slug>` (e.g. `csv-export`). Use `<slug>` for all filenames and cross-links.

## Process

Follow these steps in order. Do not skip the confirmation gate.

### 1. Discover the relevant code

- Grep `src/` for the slug and obvious variants (singular/plural, words split on `-`, common synonyms).
- Glob `src/components/**`, `src/hooks/**`, `src/utils/**`, `src/app/**` for filename matches.
- Read each candidate to confirm it actually implements the feature (don't include incidental matches).

### 2. Confirmation gate (REQUIRED)

Present the candidate file list to the user as a numbered list and stop. Wait for them to confirm, edit, add, or remove files before writing any docs. Do **not** proceed autonomously.

### 3. Classify scope

Inspect the confirmed files and tag the feature as one of:

- **frontend** — only `components/`, `hooks/`, client utilities, and `app/` pages with no network calls.
- **backend** — only `app/api/`, server actions, or utilities that make network/DB calls.
- **full-stack** — both.

This project is intentionally client-only (see `CLAUDE.md`), so most features will be **frontend**. Use the scope tag to choose dev-doc section templates (see §6).

### 4. Find cross-links

- Scan existing `docs/dev/*.md` and `docs/user/*.md` for files whose title or first heading overlaps the feature topic. Link them under "Related docs" in both generated files.
- Reference the relevant rules from the root `CLAUDE.md` (quality gates, data model location, formatters) in the dev doc.

### 5. Prepare output directories

Create these only if missing (use `mkdir -p`):

- `docs/dev/`
- `docs/user/`
- `docs/user/screenshots/`

Do not create a screenshots PNG. Placeholders only — the user captures real screenshots later.

### 6. Write the two files

#### `docs/dev/<slug>-implementation.md`

Use this skeleton. Omit sections that don't apply; never leave a section empty.

```markdown
# <Feature title> — Implementation

> **User-facing guide:** [How to <feature>](../user/how-to-<slug>.md)
> **Scope:** <frontend | backend | full-stack>

## Overview
One paragraph: what this feature does and where it lives in the app.

## Code map
| File | Role |
|---|---|
| `src/path/to/file.tsx:LINE` | … |
| … | … |

## Data model
Link `src/types/expense.ts` (or the relevant type file) and quote the exact types this feature reads or writes.

## <Frontend scope: State & rendering>
- Where state lives (hook / provider / local).
- How props flow.
- Key render decisions.

## <Backend scope: API contract>
- Route(s), method, request/response shape.
- Persistence target.
- Auth assumptions.

## <Full-stack scope: include both of the above>

## Error handling
What can fail, what the user sees, where it's caught.

## Quality gates
From `CLAUDE.md`:
- `npm run lint` — clean.
- `npx tsc --noEmit` — clean.
- `npm run build` — when touching routing/build-time code.
- Manual browser verification of the affected flow.

## Gotchas
Non-obvious constraints, invariants, or workarounds. One bullet each. Omit if none.

## Related docs
- [How to <feature>](../user/how-to-<slug>.md)
- <Other dev docs found in §4, if any>
```

#### `docs/user/how-to-<slug>.md`

Use this skeleton. Keep language plain — no jargon, no code unless the user is expected to type it.

```markdown
# How to <feature title>

> **Looking for technical details?** See [<slug> — Implementation](../dev/<slug>-implementation.md).

## What this lets you do
One or two sentences in user terms.

## Before you start
Prerequisites the user needs (e.g. "at least one expense saved").

## Steps

1. **<Action>**
   ![Step 1 — <short caption>](./screenshots/<slug>-step-1.png)
   <!-- TODO: capture screenshot -->

2. **<Action>**
   ![Step 2 — <short caption>](./screenshots/<slug>-step-2.png)
   <!-- TODO: capture screenshot -->

<add as many steps as the flow actually has — one screenshot placeholder per step>

## If something goes wrong
- **<Symptom>** — <what to check or do>.

## Related guides
- [<Other user doc found in §4>](./<other>.md)
- [<slug> — Implementation](../dev/<slug>-implementation.md)
```

### 7. Report

In your final message to the user, include:

- The two file paths written.
- The detected scope (frontend / backend / full-stack).
- Any cross-link candidates you found but were unsure about (so the user can confirm or reject).
- A reminder that screenshot placeholders are unresolved (`<!-- TODO: capture screenshot -->`).

## Hard rules

- **Do not** edit any file under `src/`.
- **Do not** install dependencies, run the dev server, or launch Playwright. Screenshots are placeholders only.
- **Do not** commit. The project rule (see `CLAUDE.md`) is: never commit unless the user explicitly asks.
- **Do not** invent file paths, exports, or line numbers — every reference in the dev doc must come from a file you actually read.
- **Do not** skip the confirmation gate in §2, even if the discovery looks unambiguous.
