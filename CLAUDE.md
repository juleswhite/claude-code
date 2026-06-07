# AI Chat as a Knowledge Base — Standard

## Why this matters

Every productive AI-assisted session generates knowledge that currently vanishes when the window closes. When Claude traces a subtle bug, explains why your middleware needs a specific ordering, or uncovers an undocumented SDK quirk — that is institutional knowledge. Right now it lives nowhere.

This standard captures it.

---

## Directory layout

Add a `.claude/knowledge/` folder to your project:

```
.claude/
  knowledge/
    index.md          ← searchable index of every entry (auto-maintained)
    decisions/        ← architectural choices made with AI help
    patterns/         ← reusable solutions discovered in AI sessions
    gotchas/          ← bugs, edge cases, and non-obvious constraints
    integrations/     ← third-party API / SDK knowledge
    processes/        ← AI-refined workflows
```

Commit it. It travels with the repo, onboards new developers, and gives Claude context it would otherwise spend tokens rediscovering.

---

## Entry format

Each entry is a single Markdown file:

```markdown
---
id: kb-YYYY-MM-DD-NNN
type: decision | pattern | gotcha | integration | process
title: Short descriptive title
tags: [tag1, tag2]
date: YYYY-MM-DD
related: []
---

## Context
What problem was being explored and why it mattered.

## Chat extract
> **Developer:** [the question that produced the insight]
>
> **Claude:** [the key response — summarized or verbatim]

## Distilled insight
One paragraph. The core knowledge, stripped of conversation noise.
Written so a new team member (or Claude in a future session) can act on it immediately.

## Code example
```language
// Minimal, self-contained example if applicable
```

## References
- Source file: `src/path/to/file.ts`
- Related entry: [Title](../category/other-entry.md)
```

---

## Add this block to your project CLAUDE.md

```markdown
## Knowledge base

Project insights from AI-assisted sessions live in `.claude/knowledge/`.
Read `.claude/knowledge/index.md` at session start to avoid re-solving known problems.

- Search: `/search-kb <query>`
- Save new insight: `/save-insight <title>`

When you solve something non-obvious or make a significant design decision,
offer to run `/save-insight` to capture it.
```

---

## Slash commands

### `/save-insight`

`.claude/commands/save-insight.md`

```markdown
# Save Insight

Capture the key insight from this session into the project knowledge base.

## Instructions

Feature name / title: **$ARGUMENTS**

1. Review the current conversation and identify the single most valuable insight —
   the thing a future developer (or Claude) most needs to know.

2. Determine the entry type:
   - `decision` — a choice made between alternatives
   - `pattern` — a reusable solution
   - `gotcha` — a non-obvious bug or constraint
   - `integration` — knowledge about an external service
   - `process` — a refined workflow

3. Create the file at `.claude/knowledge/<type>/<slug>.md` using the standard entry
   format (frontmatter + Context + Chat extract + Distilled insight + Code example + References).

4. Update `.claude/knowledge/index.md` — add one line:
   `| kb-YYYY-MM-DD-NNN | <type> | <title> | <tags> | <relative path> |`

5. Report: "Saved to `.claude/knowledge/<type>/<slug>.md` and index updated."
```

### `/search-kb`

`.claude/commands/search-kb.md`

```markdown
# Search Knowledge Base

Search the project knowledge base for relevant insights.

## Instructions

Query: **$ARGUMENTS**

1. Read `.claude/knowledge/index.md`.
2. Find entries whose title, tags, or type match the query.
3. Read each matching entry file.
4. Return a ranked list:

   **<Title>** (`<type>`) — <one-sentence summary>
   Path: `.claude/knowledge/<type>/<slug>.md`
   Tags: <tags>

5. If no matches: "No entries found for '<query>'. Run `/save-insight` after solving it."
```

---

## Design principles

- **Zero-friction capture.** One command, one title. Everything else is inferred.
- **Version-controlled.** Lives in the repo, not a cloud service or personal notes app.
- **Claude-readable.** Plain Markdown — Claude can read, cite, and update entries natively.
- **Team-shareable.** Any developer who clones the repo gets the accumulated knowledge immediately.
- **Self-reinforcing.** The CLAUDE.md section tells Claude to check the index, and to offer `/save-insight` when something new is solved — so the base grows automatically.
