# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

- `npm run dev`: dev server on http://localhost:3000 (also defined in `.claude/launch.json` as `dev`)
- `npm run build`: production build (also runs lint and type checks)
- `npm test`: Vitest unit tests. Run a single file with `npx vitest run lib/analytics.test.ts`, or a single test with `-t "<name>"`
- `npm run lint` / `npm run typecheck`
- `npm run docs:screenshots -- <shots.json>`: capture documentation screenshots from a shot list (see the header of `scripts/capture-screenshots.mjs`). It needs the dev server running and uses the installed Edge/Chrome. The `/document-feature <name>` command (`.claude/commands/document-feature.md`) generates `docs/dev/` and `docs/user/` docs with these screenshots.

Don't run `npm run build` while the dev server is running, because both write to `.next/`.

## Architecture

Next.js 14 App Router with client-side state only and no backend. Pages are prerendered as static shells, then hydrate and read `localStorage`.

**Layers**

- `lib/` holds pure, framework-free logic, which is where the unit tests live (`lib/*.test.ts`): validation, analytics (filter, sort, summaries, chart series), CSV, storage parsing, and formatting. Put new business logic here so it stays testable.
- `components/*Provider.tsx` holds React context state, mounted in `components/Providers.tsx` in the order `ToastProvider` → `ExpensesProvider` → `ExpenseFormProvider`. Each provider may use the ones outside it.
  - `ExpensesProvider` is the single source of truth. It loads from storage on mount (`isLoaded` gates rendering, so show skeletons until it's true), auto-saves on every change, and syncs across tabs via the `storage` event. `deleteExpense` shows an Undo toast itself.
  - `ExpenseFormProvider` owns the one add/edit modal. Any component opens it with `useExpenseForm().openAdd()` or `openEdit(expense)`.
- `app/page.tsx` (dashboard) and `app/expenses/page.tsx` are client components that compose `components/dashboard/*` and `components/expenses/*`.

**Data conventions (important)**

- Money is stored as integer `amountCents`. Never use floats; parse user input with `parseAmountToCents` and display it with `formatCurrency`.
- Dates are local `YYYY-MM-DD` strings. Compare them as strings, build them with `toISODate` (never `toISOString`, which is UTC), and parse them with `parseISODate`.
- `CATEGORIES` in `lib/types.ts` is the canonical list. Each category also needs an entry in `CATEGORY_STYLES` (`lib/categories.ts`), whose Tailwind classes are written out in full so the content scanner keeps them.
- The storage key is `expense-tracker:expenses:v1`. If the `Expense` shape changes, bump the key or migrate in `lib/storage.ts`. Invalid records are dropped on load, and the raw data is backed up to `<key>:backup`.

**Gotchas**

- Text that depends on the current date (e.g. the month name) must render only after `isLoaded`. Otherwise the build-time prerender causes a hydration mismatch.
- Charts are hand-built with SVG and CSS (no chart library). The donut uses r=15.9155 so the circumference is 100 and dash lengths equal percentages.
- Shared styles are component classes in `app/globals.css`: `.btn-primary`, `.btn-secondary`, `.card`, `.field`.
