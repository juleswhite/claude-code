# Governed Workflow — a hook-enforced safety harness for Claude Code

Most `CLAUDE.md` templates are *advice*: "be careful, write tests, don't force-push." A
model can read that and still choose to ignore it. This bundle is different — it pairs the
prose with **hooks that actually enforce the rules**, so the dangerous actions are blocked
at the harness level, not left to the model's good intentions.

The design principle is **supervised acceleration**: Claude can do almost anything *except*
a short list of irreversible or outward-facing actions, which require an explicit, typed
human sentinel phrase to unlock — per session.

> ⚠️ **Platform:** the hooks are written in **PowerShell for Windows**. The *model* (the
> `CLAUDE.md` prose, the permission deny-list, the design) is cross-platform; only the four
> `.ps1` enforcement scripts are Windows-specific. See [Porting to macOS / Linux](#porting-to-macos--linux).

---

## What's in the bundle

| File | Role |
|------|------|
| `CLAUDE.md` | Standing instructions — the *intent* layer (operating model, hard stops, prompt-injection defence, commit workflow). |
| `settings.json` | Permission **deny-list** (irreversible/destructive commands) + wiring for the four hooks. |
| `hooks/sentinel-watch.ps1` | `UserPromptSubmit` — detects the typed sentinel phrases and unlocks pushing for the session. |
| `hooks/push-guard.ps1` | `PreToolUse` (Bash/PowerShell) — blocks `git push` unless unlocked; blocks force-push and protected-branch push unconditionally / behind a stronger phrase; catches shell-wrapper evasion. |
| `hooks/secrets-guard.ps1` | `PreToolUse` (Read/Edit/Write) — blocks access to secret/key file patterns (`.env`, `*.pem`, `id_rsa`, `**/secrets/**`, cloud creds…). |
| `hooks/session-audit.ps1` | `Stop` — appends a session-end audit line and clears this session's push unlock flags so the next session starts locked down again. |

---

## The two-tier push gate

This is the centrepiece. `git push` is blocked by default and unlocks only when the human
types an exact phrase **in the chat**, which a hook detects:

| Phrase typed by human | Effect (this session only) |
|-----------------------|----------------------------|
| *(nothing)* | **All pushes blocked.** |
| `push this branch now` | Tier 1 — push to **non-protected** branches allowed. |
| `override protected push now` | Tier 2 — push to **protected** branches (`main`, `master`, `prod`, `release`, `staging`, `develop`) also allowed. Implies tier 1. |
| *(any)* + `--force` / `-f` / `--force-with-lease` | **Force-push blocked unconditionally** — no phrase unlocks it. |

Because the model can't type the phrase *as the human*, it can't unlock itself. Unlock
flags are per-session files under `~/.claude/session-env/` and are cleared on session end,
so authorization never silently carries into the next session.

**Evasion-resistant:** `push-guard.ps1` regex-matches `git push` even when wrapped in
`bash -c`, `sh -c`, `eval`, or `iex`, and the deny-list in `settings.json` blocks those
wrappers outright. The hook also *fails closed* — if it errors while inspecting a `git push`,
it blocks rather than allows.

---

## Install (Windows)

1. Copy `CLAUDE.md` to `~/.claude/CLAUDE.md` (global) **or** a repo root (per-project).
2. Copy the four scripts into `~/.claude/hooks/`.
3. Merge `settings.json` into your `~/.claude/settings.json`. If you already have a
   `settings.json`, merge the `permissions.deny` array and the `hooks` block rather than
   overwriting — and keep your own `theme`, plugins, and other prefs.
4. The hook commands use `%USERPROFILE%\.claude\hooks\…`. If your shell doesn't expand
   `%USERPROFILE%`, replace it with your absolute home path.
5. Start a new Claude Code session and verify:
   - Ask it to `git push` → should be **blocked**.
   - Type `push this branch now`, ask again → push to a feature branch **allowed**, but a
     push to `main` still **blocked** until you type `override protected push now`.
   - Ask it to read a `.env` file → **blocked**.

---

## Tuning before you rely on it

- **Protected branches:** edit the regex in `push-guard.ps1` and the phrase wording in
  `CLAUDE.md` to match your team's protected set.
- **Deny-list:** the `permissions.deny` list in `settings.json` is opinionated (cloud IAM,
  IaC apply/destroy, package publish, `curl|sh`). Add/remove for your stack.
- **Secret patterns:** extend the `$patterns` array in `secrets-guard.ps1` for your
  org's conventions (e.g. `*.kdbx`, `*vault*`).

These hooks are a **speed-bump and a backstop, not a sandbox.** They block the obvious and
the accidental; they are not a security boundary against a determined adversary. Pair them
with real controls (branch protection on the server, scoped tokens, least-privilege creds).

---

## Porting to macOS / Linux

The logic is simple enough to re-implement as POSIX shell. Each hook reads a JSON payload
on stdin (`session_id`, `tool_input.command`, `prompt`, `file_path`) and signals a block by
writing to **stderr and exiting with code 2**. To port:

- Parse stdin JSON with `jq`.
- Replace `%USERPROFILE%\.claude` with `$HOME/.claude` and the `powershell -File …` command
  strings in `settings.json` with `bash …/hook.sh`.
- Keep the same flag-file convention under `~/.claude/session-env/`.

PRs adding a `hooks-bash/` variant are welcome.

---

*Derived from a personal global `CLAUDE.md` + hook setup, genericized for reuse. Treat every
list here as a starting point to adapt, not a finished policy.*
