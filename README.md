# claude-code

A small collection of custom slash commands for [Claude Code](https://claude.com/claude-code).

## Commands

Drop the files in `.claude/commands/` into your own project's `.claude/commands/` directory to use them.

| Command | What it does |
|---|---|
| [`/command-code-review`](./.claude/commands/command-code-review.md) | Reviews a file against named exemplar files in your project. Writes the review to `ai-code-reviews/<file>.review.md`, with line-referenced findings, an overall quality rating, and a refactoring effort estimate. |
| [`/command-document-feature`](./.claude/commands/command-document-feature.md) | Given a feature name, discovers the relevant source files (with a confirmation gate), detects whether the feature is frontend / backend / full-stack, and generates paired developer and user documentation under `docs/dev/` and `docs/user/`. User docs include per-step screenshot placeholders. |

## Usage

1. Copy the desired `.md` file into `.claude/commands/` at the root of your project.
2. Invoke it in Claude Code as `/<filename-without-extension>`. For example, `command-document-feature.md` is invoked as `/command-document-feature csv-export`.

Each command file contains instructions that Claude Code follows — you can edit the exemplar paths, doc skeletons, and rules to match your codebase before using.
