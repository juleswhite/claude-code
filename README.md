# claude-code

A small collection of custom slash commands for Claude Code.

## Commands

| Command | Description |
|---|---|
| `/document-feature <nome-da-funcionalidade>` | Finds the source files for an existing feature, then generates two Markdown docs from them: a technical write-up in `docs/dev/<slug>-implementation.md` (overview, files involved, data flow, API/interfaces, data models, implementation notes, dependencies, tests) and a plain-language user guide in `docs/user/how-to-<slug>.md` (what it does, step-by-step instructions with screenshot placeholders, troubleshooting). If the feature can't be located in the codebase, it stops and asks instead of inventing content. |

## Usage

1. Copy the command file(s) you want into your project's `.claude/commands/` directory.
2. In Claude Code, invoke the command with `/document-feature <nome-da-funcionalidade>` (or the equivalent slash command for other files in this repo), e.g. `/document-feature exportação de dados`.
3. Each command file contains editable instructions — adjust section templates, file-naming conventions, or search patterns to fit your project's conventions.
