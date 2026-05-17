# Document Feature Command

Generate complete developer and user documentation for: $ARGUMENTS

---

## Step 1 — Detect feature scope

Before writing anything, run these searches to understand what you're documenting:

```bash
# Find all files related to the feature name
grep -r "$ARGUMENTS" --include="*.ts" --include="*.tsx" -l .

# Check for existing related docs
find docs/ -name "*.md" | xargs grep -l "$ARGUMENTS" 2>/dev/null

# Understand the component tree
grep -r "$ARGUMENTS" --include="*.tsx" -l components/ app/
```

From the results, classify the feature as one of:
- **frontend-only** — touches only `components/`, `app/`, no `lib/` logic
- **logic-only** — touches only `lib/`, no UI components  
- **full-stack** — touches both UI components and `lib/` modules

This classification determines which documentation sections to include (see Step 3 and Step 4).

---

## Step 2 — Read the relevant source files

Read every file surfaced in Step 1. For each file, note:

- **What it exports** (functions, components, hooks, types)
- **Its dependencies** (what it imports)
- **Its contract** (props, parameters, return values)
- **Any invariants** (e.g. amounts always in cents, isLoaded pattern)
- **Edge cases** (empty states, loading states, error paths)

Also read `CLAUDE.md` to pick up project-wide conventions (amounts-as-cents, useClient rules, testing patterns, design system colors).

---

## Step 3 — Generate developer documentation

Save to: `docs/dev/$ARGUMENTS-implementation.md`

Use this exact structure, scaling each section to its actual complexity:

```markdown
# [Feature Name] — Developer Reference

> **Feature type:** [frontend-only | logic-only | full-stack]  
> **Last updated:** [today's date YYYY-MM-DD]  
> **Related user guide:** [../user/how-to-$ARGUMENTS.md]

## Overview

One paragraph: what problem this feature solves and how it fits into the overall architecture.

## Architecture

[Include this section for full-stack and logic-only features]

Describe the data flow end to end:
- Entry point (user action or route)
- Through which modules/hooks/context
- To persistence (localStorage) or output (download, render)

Include a plain-text diagram if the flow has more than 2 hops:

```
UserAction → ComponentX → useHookY → lib/module → localStorage
```

## Key Files

| File | Responsibility |
|------|---------------|
| `path/to/file.tsx` | What this file does in the context of this feature |

## Types & Interfaces

[Include for logic-only and full-stack features]

Document every type that is specific to or heavily used by this feature:

```typescript
// Paste the actual type definition from source
type ExampleType = { ... }
```

Note any invariants (e.g. "amount is always integer cents — never a float").

## Components

[Include for frontend-only and full-stack features]

### `ComponentName`

- **File:** `components/path/ComponentName.tsx`
- **Type:** Server component | Client component (`'use client'`)
- **Props:**

| Prop | Type | Required | Description |
|------|------|----------|-------------|
| `propName` | `string` | Yes | What it does |

- **State:** List any `useState` / context dependencies
- **Side effects:** List any `useEffect` calls and what triggers them

## Hook / Context API

[Include if the feature exposes or relies on a custom hook]

### `useHookName()`

```typescript
// Actual signature
function useHookName(): ReturnType
```

- **Must be used inside:** `<ProviderName>` (throws otherwise)
- **Returns:**

| Key | Type | Description |
|-----|------|-------------|
| `field` | `type` | What it represents |

## Utility Functions

[Include for logic-only and full-stack features]

### `functionName(input: Type): ReturnType`

- **File:** `lib/module.ts`
- **Purpose:** One sentence
- **Parameters:** List with types and constraints
- **Returns:** What it returns and when
- **Edge cases:** Empty input, zero values, boundary conditions

## Data Flow Diagram

[Include for full-stack features only]

```
[User fills form]
       ↓
[ExpenseForm validates via Zod schema]
       ↓
[onSubmit calls useExpenseMutations().addExpense()]
       ↓
[expense-context.tsx converts dollars → cents via dollarsToCents()]
       ↓
[Sorted array written to localStorage]
       ↓
[React state updates → UI re-renders]
```

## Error Handling

List every error path and how it is handled:

| Scenario | Handling | User-visible feedback |
|----------|----------|-----------------------|
| Validation fails | Zod blocks submit | Inline field error |
| localStorage full | try/catch in persist() | Silent fail (log only) |

## Testing

- **Test file:** `__tests__/[feature].test.ts`
- **Coverage:** What is tested, what is not
- **How to run:** `npx vitest run __tests__/[feature].test.ts`

Note any test gaps worth addressing.

## Known Limitations

List constraints that are intentional or deferred:
- e.g. "No pagination — assumes < 500 expenses in localStorage"
- e.g. "PDF export uses window.print(); no headless support"

## Related Documentation

- [User guide → how-to-$ARGUMENTS.md](../user/how-to-$ARGUMENTS.md)
- [Architecture overview → CLAUDE.md](../../CLAUDE.md)
- Link to any other dev docs that overlap
```

---

## Step 4 — Generate user documentation

Save to: `docs/user/how-to-$ARGUMENTS.md`

Use this exact structure:

```markdown
# How to [Feature Name]

> **Related developer reference:** [../dev/$ARGUMENTS-implementation.md]

## What this does

One sentence plain-language description. No technical jargon.

## Before you start

List any prerequisites (e.g. "You need at least one expense added").  
Omit this section if there are none.

## Step-by-step guide

### Step 1 — [Action]

Plain English instruction.

<!-- SCREENSHOT: [describe exactly what should be visible]
     Capture: npm run dev → navigate to /[route] → [action to take]
     Suggested filename: docs/user/screenshots/$ARGUMENTS-step-1.png -->

---

### Step 2 — [Action]

Plain English instruction.

<!-- SCREENSHOT: [describe exactly what should be visible]
     Suggested filename: docs/user/screenshots/$ARGUMENTS-step-2.png -->

---

[Continue for each meaningful step. Keep steps atomic — one action each.]

## What you'll see

Describe the result after completing all steps. What changed? What confirmation appears?

<!-- SCREENSHOT: [final result state]
     Suggested filename: docs/user/screenshots/$ARGUMENTS-result.png -->

## Tips

- Tip 1 (practical, not obvious)
- Tip 2

Omit this section if there are no non-obvious tips.

## Troubleshooting

[Include only if the feature has known gotchas]

| Problem | Likely cause | Fix |
|---------|-------------|-----|
| Nothing happens when I click X | Y condition | Do Z |

## Related guides

- Link to other user docs that are logically adjacent
```

---

## Step 5 — Screenshot automation

[Include this step for frontend-only and full-stack features]

After writing both docs, check if Playwright MCP is available. If it is:

1. Start the dev server: `npm run dev`
2. Navigate to the relevant page for each `<!-- SCREENSHOT: ... -->` placeholder
3. Perform the described action
4. Capture with `browser_take_screenshot`
5. Save to `docs/user/screenshots/` with the suggested filename
6. Replace each `<!-- SCREENSHOT: ... -->` comment with the actual markdown image tag:
   ```markdown
   ![Step description](./screenshots/filename.png)
   ```

If Playwright MCP is not available, leave the `<!-- SCREENSHOT: ... -->` comments in place as instructions for a human.

---

## Step 6 — Cross-reference audit

After both files are written, verify:

1. The developer doc links to the user doc
2. The user doc links to the developer doc
3. Both link back to `CLAUDE.md`
4. Scan `docs/` for any existing docs that mention this feature — add a "See also" link in those files pointing to the new docs

---

## Step 7 — Output summary

Report back with:

```
Documentation generated for: [feature name]
Feature type detected: [frontend-only | logic-only | full-stack]

Files created:
  docs/dev/$ARGUMENTS-implementation.md    ([line count] lines)
  docs/user/how-to-$ARGUMENTS.md           ([line count] lines)

Screenshots:
  [captured N screenshots automatically] OR [N screenshot placeholders left for manual capture]

Cross-references added to:
  [list any existing docs that were updated]

Key decisions made:
  [note anything non-obvious about how you interpreted the feature]
```
