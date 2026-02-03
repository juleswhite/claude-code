# Claude Code: Community Patterns, Commands & Context

[![Contributions Welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg)](CONTRIBUTING.md)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

**A curated library of efficient slash commands, `CLAUDE.md` templates, and agentic workflows for software engineering with Claude Code.**

## 📖 About This Repository

Claude Code is a powerful agentic interface that acts as an AI development team member. However, its true power "multiplies when we share proven patterns."

This repository serves as a centralized knowledge base for:
* **Custom Commands (`/commands`):** Reusable prompts that automate complex tasks like testing, documentation, or refactoring.
* **Context Templates (`CLAUDE.md`):** Best-practice structures for teaching Claude about your project's architecture and rules.
* **Process Documentation:** Guides on how to "pair program" effectively with AI agents to solve specific engineering challenges.

The goal is to help developers skip the trial-and-error phase and jump straight to productive, AI-assisted development.

---

## 📂 Repository Structure

The repository is organized by resource type:

```text
.
├── commands/           # Custom slash commands (e.g., /test, /doc, /refactor)
│   ├── testing/        # Commands for running and fixing tests
│   ├── docs/           # Commands for generating documentation
│   └── architecture/   # Commands for analyzing code structure
├── templates/          # CLAUDE.md templates for different project types
│   ├── react/          # Context templates for React apps
│   ├── python/         # Context templates for Python/Django/Flask
│   └── generic/        # Universal project context structures
└── workflows/          # Guides on multi-step agentic processes

```

---

## 🚀 How to Use These Resources

### 1. Using Custom Commands

Claude Code allows you to create custom "slash commands" by placing markdown files in a `.claude/commands` directory in your project.

1. Navigate to the `commands/` directory in this repo.
2. Choose a command (e.g., `document-feature.md`).
3. Copy the file into your local project: `.claude/commands/document-feature.md`.
4. Run it in Claude Code by typing `/document-feature`.

### 2. Adopting a `CLAUDE.md` Template

The `CLAUDE.md` file is the "brain" of your project's context.

1. Navigate to `templates/` and find a stack that matches yours.
2. Copy the content into a file named `CLAUDE.md` at the root of your project.
3. **Customize it:** Fill in your specific build commands, linting rules, and architectural constraints.

---

## 🤝 How to Contribute

We welcome contributions! If you have developed a workflow that saves you time or improves code quality, please share it.

### What we're looking for:

* **High-Leverage Commands:** Scripts that turn 30 minutes of work into 30 seconds.
* **Robust Contexts:** `CLAUDE.md` files that effectively prevent hallucinations or style errors.
* **Novel Workflows:** Creative ways to use Claude for design, debugging, or planning.

### Submission Guidelines

1. **Fork** this repository.
2. **Create a branch** for your contribution (`git checkout -b feature/amazing-test-command`).
3. **Add your file** to the appropriate directory.
* *Naming:* Use clear, descriptive filenames (e.g., `generate-unit-tests.md` rather than `tests.md`).


4. **Add Metadata:** If possible, include a short comment block at the top of your file describing what it does and any prerequisites.
5. **Submit a Pull Request** with a description of the problem your contribution solves.

---

## ⚖️ License

This project is licensed under the MIT License - see the [LICENSE](https://www.google.com/search?q=LICENSE) file for details.

> **Note:** This is a community-driven resource. Always review commands and prompts to ensure they align with your specific project requirements and security standards before running them.
