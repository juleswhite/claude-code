> A reusable template for defining project context and expectations when using Claude Code.


# CLAUDE.md

## Project Overview
This project exists to:
- Briefly describe what the project does
- Define the primary goal of the codebase
- Clarify the intended users or use cases

Keep this section short but explicit. Claude uses this as the mental model for all decisions.

---

## Tech Stack
- Language(s):
- Frameworks / Libraries:
- Runtime / Platform:
- Database / Storage:
- Tooling (build, lint, test, CI):

---

## Project Structure
High-level explanation of the repository layout.

Example:
- `/src` – Core application logic
- `/tests` – Unit and integration tests
- `/docs` – Project documentation
- `/scripts` – Automation and tooling scripts

---

## Coding Standards & Conventions
Claude should follow these rules when writing or modifying code:

- Preferred coding style (functional, OOP, etc.)
- Naming conventions
- Error handling approach
- Formatting or linting rules
- Patterns to prefer or avoid

If unsure, prioritize clarity and maintainability.

---

## Testing Philosophy
- Types of tests used (unit, integration, e2e)
- Testing framework(s)
- How new code should be tested
- When tests are optional vs mandatory

Claude should not skip tests unless explicitly instructed.

---

## Performance, Security & Reliability
Important non-functional requirements:

- Performance constraints
- Security considerations
- Data validation rules
- Logging and observability expectations

---

## How Claude Should Help
Explicit instructions for Claude Code behavior:

- Act as a senior engineer reviewing and improving code
- Ask clarifying questions when requirements are ambiguous
- Prefer minimal, incremental changes
- Explain reasoning when making non-obvious decisions
- Flag potential risks, edge cases, or technical debt

---

## How Claude Should NOT Help
Boundaries to avoid unhelpful output:

- Do not introduce unnecessary abstractions
- Do not rewrite large sections without justification
- Do not assume missing requirements
- Do not change public APIs unless requested

---

## Common Workflows
Typical tasks Claude will assist with:

- Code reviews
- Refactoring
- Bug fixing
- Writing tests
- Explaining existing code
- Generating documentation

Describe any preferred workflow steps if applicable.

---

## Context Sharing Guidelines
When context is large:

- Focus on the most relevant files
- Summarize rather than paste entire directories
- Ask Claude to confirm understanding before proceeding

---

## Notes for Future Contributors
Anything a new contributor (human or AI) should know:

- Known pain points
- Legacy decisions
- Upcoming refactors
- Things that commonly go wrong

---

## Final Instruction
If there is ever a conflict between being fast and being correct,
**prioritize correctness, clarity, and maintainability.**

Add reusable CLAUDE.md template for Claude Code projects
Provides a structured template to clearly define project context, coding standards, and expectations for Claude Code.
