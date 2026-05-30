# Design-First AI Collaboration — CLAUDE.md Template & Workflow

A structured approach to AI-assisted development based on Rahul Garg's five patterns published on [martinfowler.com](https://martinfowler.com/articles/reduce-friction-ai/) (Feb–Apr 2026). These patterns shift the experience from correcting a tool to collaborating with a capable teammate.

**Source framework:** [design-first-ai](https://github.com/andresdiegolanda/design-first-ai) (MIT license)
**Pattern author:** Rahul Garg, Principal Engineer @ Thoughtworks

---

## The Problem

AI coding assistants are like junior developers with infinite energy but zero context. Without project-specific information, they default to generic patterns from training data — producing code that compiles but doesn't fit your project's conventions, architecture, or constraints.

The five patterns solve five failure modes:

| Pattern | Failure mode | Solution |
|---------|-------------|----------|
| **Knowledge Priming** | AI uses generic patterns | Load project context before each session |
| **Design-First Collaboration** | AI collapses design + implementation into one step | Separate design decisions from code |
| **Context Anchoring** | Decisions are lost when sessions end | Persist decisions in files, not conversations |
| **Encoding Team Standards** | Senior judgment lives in one head | Version team standards as executable instructions |
| **Feedback Flywheel** | Same mistakes repeat across sessions | Retrospective after every task improves context |

---

## 1. CLAUDE.md Template

Claude Code auto-loads `CLAUDE.md` from the project root at the start of every session. This is equivalent to Copilot's `.github/copilot-instructions.md` — the single most important file for AI-assisted development.

### Template

Create `CLAUDE.md` in your project root:

```markdown
# [Project Name] — Claude Code Instructions

> Auto-loaded at session start. Keep under 150 lines.
> Last reviewed: [date]

---

## Project Identity

[One sentence: what this app does.]

- **Type:** [API / web app / CLI / library / monorepo]
- **Stack:** [language, framework, key dependencies with versions]
- **Architecture:** [monolith / microservices / serverless / etc.]

---

## Non-Negotiables

- [Rule 1 — e.g., "No business logic in controllers"]
- [Rule 2 — e.g., "Constructor injection only — no field injection"]
- [Rule 3 — e.g., "All public service methods have Javadoc"]
- [Rule 4 — e.g., "UUID for all entity identifiers — never Long or int"]
- [Rule 5 — e.g., "Named domain exceptions only — never bare RuntimeException"]

---

## Anti-Patterns — Never Propose These

- [Anti-pattern 1 — e.g., "Do not add @Autowired on fields"]
- [Anti-pattern 2 — e.g., "Do not add Spring Data or JPA — this project uses in-memory storage"]
- [Anti-pattern 3 — e.g., "Do not add pagination or sorting unless explicitly asked"]
- [Anti-pattern 4 — e.g., "Do not wrap services in additional abstraction layers"]

---

## Architecture

[Component] → [Component] → [Storage]
No [layer that doesn't exist]. [Component] owns the [storage mechanism] directly.

---

## What This Project Is NOT

- Not [thing it's commonly confused with]
- Not [scope limitation]
- Not [technology it doesn't use]

---

## File Structure

| Folder | Contains | Rule |
|--------|----------|------|
| `src/controllers/` | HTTP handlers | No business logic — delegate to services |
| `src/services/` | Business logic | Own the data store directly |
| `src/models/` | Data types, DTOs | Records/value objects only |
| `tests/` | Unit + integration tests | Mirror src/ structure |

---

## Naming Conventions

- Files: `[kebab-case].ts` or `[PascalCase].java`
- Classes: `PascalCase` — `ProductService`, `OrderController`
- Methods: `camelCase` — `createProduct`, `findByCategory`
- Tests: `[ClassName]Test` — `ProductServiceTest`
- Test methods: `[method]_[scenario]_[expected]` — `create_validRequest_returnsProduct`

---

## Design Constraints

_This section grows over time through the retrospective technique (see Feedback Flywheel below)._

- [Constraint discovered through use — e.g., "ConcurrentHashMap iteration order is not guaranteed — never rely on insertion order for pagination"]
- [Constraint discovered through use — e.g., "Record constructors don't support @Valid on nested objects — validate manually"]
```

### How to generate this from an existing codebase

Instead of filling in the template manually, ask Claude Code to generate it:

```
Analyze this entire codebase and generate a CLAUDE.md file.
Be specific to THIS codebase — not generic best practices.
Include a "Design Constraints" section listing what you should NEVER propose.
Include an "Anti-Patterns" section with patterns that look valid but break in this project.
Flag anything non-standard or surprising.
```

Review the output, correct assumptions, and commit. This takes ~15 minutes.

---

## 2. The Retrospective Command

Create `.claude/commands/retrospective.md`:

```markdown
After completing this task, answer:

**What context were you missing that would have changed your approach?**

For each answer:
1. State what you assumed
2. State what is actually true
3. Propose the exact line to add to CLAUDE.md (either in Non-Negotiables, Anti-Patterns, or Design Constraints)

Format each as a ready-to-commit addition.
```

Run this after every completed task — not just when something goes wrong. A session that produced correct output still contains missing context; Claude just happened to guess right.

Each answer becomes a constraint in `CLAUDE.md`. The file compounds — each task makes the next one cheaper.

---

## 3. The Two-Document Workflow

Before writing any code, produce a design document. After writing code, produce a result document. One document captures intention, the other captures result.

### Implementation Guide (before code)

Create `.claude/commands/impl-guide.md`:

```markdown
Create an implementation guide for this feature as `docs/$ARGUMENTS-impl-guide.md`.

Structure it with these sections:

## Scope
What this feature does and what it explicitly does NOT do.

## Components
Each building block with a one-line responsibility. Reuse existing components — do not create unnecessary abstractions.

## Interactions
How data flows between components. Include error paths.

## Contracts
Method signatures, parameter types, return types, DTOs. No implementation code — just the interfaces.

Do NOT write any implementation code. This is a design document.
```

Usage: `/impl-guide SEARCH-ENDPOINT`

### Review checklist (Garg's five dimensions)

Before executing, review the impl-guide against these five questions:

1. **Scope** — Does it match the story? No extra capabilities added?
2. **Components** — Are existing components reused? No unnecessary abstractions?
3. **Interactions** — Are error paths documented? Data flow is clear?
4. **Contracts** — Are signatures complete? Types correct?
5. **Constraints** — Does it respect everything in CLAUDE.md?

Iterate until every section is correct. Then execute.

### Execution Report (after code)

Create `.claude/commands/execution-report.md`:

```markdown
Create an execution report as `docs/$ARGUMENTS-execution-report.md`.

Include:
- What was implemented and where (file paths)
- Deviations from the impl-guide and why
- How to run the application
- How to run the tests
- A compliant commit message
```

Usage: `/execution-report SEARCH-ENDPOINT`

### Why two documents

The impl-guide and execution-report together solve two patterns at once:

- **Design-First Collaboration:** The impl-guide forces design decisions before code. Corrections caught here cost a sentence to fix. The same correction after implementation costs a rewrite.
- **Context Anchoring:** Both documents persist on disk. They survive session boundaries, IDE restarts, and engineer changes. The next person reads the documents, not the chat history.

---

## 4. How It All Fits Together

```
ONBOARDING (once, ~15 minutes)
────────────────────────────────────────
Ask Claude Code to generate CLAUDE.md
from your existing codebase.
Review, correct, commit.

FOR EACH FEATURE
────────────────────────────────────────
CLAUDE.md ← auto-loaded every session

   /impl-guide FEATURE-NAME
          ↓
   Review against 5 dimensions
   Iterate until correct
          ↓
   Claude executes the guide
          ↓
   Code + /execution-report FEATURE-NAME

AFTER EVERY TASK
────────────────────────────────────────
   /retrospective
          ↓
   Add answers to CLAUDE.md
   (Design Constraints section grows)
   Commit the change.
```

---

## Example: What the retrospective produces

After building a search endpoint, running `/retrospective` might surface:

```
ASSUMED: Long for product IDs (Java default)
ACTUAL: This project uses UUID for all identifiers

→ Add to CLAUDE.md Non-Negotiables:
  "UUID for all entity identifiers — never Long or int"

ASSUMED: Spring Data Pageable for pagination
ACTUAL: This project doesn't use Spring Data — manual pagination with stream/skip/limit

→ Add to CLAUDE.md Anti-Patterns:
  "Do not add Spring Data or JPA dependencies"
```

Both additions prevent the same mistakes in every future session, for every developer on the team.

---

## References

- **Garg's articles:** [martinfowler.com/articles/reduce-friction-ai](https://martinfowler.com/articles/reduce-friction-ai/)
- **Framework repo:** [github.com/andresdiegolanda/design-first-ai](https://github.com/andresdiegolanda/design-first-ai) (MIT license, v1.5.0)
- **Patterns:** Knowledge Priming (Feb 24), Design-First Collaboration (Mar 3), Context Anchoring (Mar 17), Encoding Team Standards (Mar 24), Feedback Flywheel (Apr 8)
