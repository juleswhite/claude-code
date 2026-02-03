# Contributing to Claude Code Community Patterns

First off, thank you for considering contributing! This repository is built on the belief that **sharing agentic workflows multiplies our collective productivity.**

Whether you're fixing a typo, adding a new slash command, or documenting a complex multi-agent workflow, your help is appreciated.

## 🌟 What We're Looking For

We specifically encourage contributions in these three areas:

### 1. Custom Commands (`/commands`)
Have you written a custom command that automates a tedious task?
* **Examples:** Automated test runners, documentation generators, code style fixers, or security scanners.
* **Requirement:** Commands must be generic enough to be useful to others (or easily adaptable).

### 2. Context Templates (`CLAUDE.md`)
Have you cracked the code on how to prompt Claude for a specific tech stack?
* **Examples:** A `CLAUDE.md` optimized for Next.js 14, a Python/Django context that prevents circular import errors, or a Unity C# setup.
* **Requirement:** Include comments explaining *why* certain rules are included.

### 3. Workflows & Guides
Have you found a reliable process for "pair programming" with Claude?
* **Examples:** "How to use Claude to refactor legacy code safely" or "A workflow for writing comprehensive unit tests."

---

## 🚀 How to Contribute

### Step 1: Fork & Branch
1.  Fork the repository to your own GitHub account.
2.  Create a new branch for your feature:
    ```bash
    git checkout -b feature/your-command-name
    ```

### Step 2: Add Your Content
Please follow our directory structure:

* **Commands** go in `commands/{category}/your-command.md`
* **Templates** go in `templates/{stack}/CLAUDE.md`
* **Workflows** go in `workflows/your-workflow-guide.md`

#### Style Guide for Commands
When adding a new command, please include a **metadata header** at the top of the file so users know what it does.

**Example Format:**
```markdown
(Your prompt content goes here...)

```

### Step 3: Submit a Pull Request

1. Push your branch to GitHub.
2. Open a Pull Request (PR) against the `main` branch of this repository.
3. **In your PR description, please answer:**
* What problem does this solve?
* How have you tested it? (e.g., "Used this on a React project for 2 weeks")



---

## 🧪 Testing Your Contributions

Before submitting, please **test your command or template** in a fresh environment if possible.

* **For Commands:** Does it work if the project structure is slightly different?
* **For Templates:** Does it consume too many tokens unnecessarily?

## 📜 License

By contributing, you agree that your contributions will be licensed under the MIT License defined in the `LICENSE` file of this repository.

Thank you for helping us build the ultimate manual for Claude Code!
