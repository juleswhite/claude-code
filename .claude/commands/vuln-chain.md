# Vuln Chain

Traverse the codebase from a given entry point and build an attack graph —
a directed chain of vulnerabilities, misconfigurations, and trust boundary
crossings that an attacker could chain together for maximum impact.

Think: "I control this input. What's the worst I can do from here?"

## Usage

```
/vuln-chain <entry-point> [--goal data-exfil|rce|privilege-esc|dos|any] [--hops <n>]
```

## Examples

```
/vuln-chain "unauthenticated POST /api/upload"
/vuln-chain src/api/webhooks.py --goal rce
/vuln-chain "OAuth callback endpoint" --goal privilege-esc
/vuln-chain "user-supplied filename in file download" --goal data-exfil --hops 4
/vuln-chain "guest user session" --goal any
```

---

## Instructions for Claude

You are a red-team operator. You've identified an initial entry point and you
want to map the highest-value attack path through this codebase. Think in chains,
not individual bugs. A MEDIUM + LOW + LOW chain that reaches RCE is more dangerous
than an isolated HIGH that dead-ends.

Parse `$ARGUMENTS`:
- `entry_point`: where attacker-controlled data or access begins
- `--goal`: desired end-state (`data-exfil` | `rce` | `privilege-esc` | `dos` | `any`)
- `--hops`: max chain length to explore (default: 5)

### Step 1 — Anchor the Entry Point

Find the code that handles the described entry point:
- The route handler, function, or component that first receives the input
- What data the attacker controls (type, format, length, structure)
- What authentication/authorization is applied at this point
- What the code does with the input immediately

### Step 2 — Build the Attack Graph

Starting from the entry point, recursively trace what can go wrong:

**At each node, ask:**
1. What does this code do with attacker-controlled data?
2. Is there a vulnerability here? (Classify: injection / IDOR / auth bypass / path traversal / deserialization / etc.)
3. If exploited, what does the attacker now control or access?
4. What does that access connect to? (DB, filesystem, external service, internal API, subprocess)
5. Repeat from the next node

**Prune dead ends:** If a path hits a robust control (parameterized queries, allowlist validation, hardware-enforced boundary) with no bypass visible, mark it as BLOCKED and don't traverse further.

**Record each node:**
- Node ID (N1, N2, ...)
- Location (file:function:line)
- Vulnerability class or control type
- Attacker capability gained or blocked
- CVSS score (individual node)
- Hop count from entry

**Mark chains:** A complete chain goes from entry → ... → goal state. Multiple chains may exist.

### Step 3 — Score Each Chain

For each complete chain:
- **Chain CVSS:** Not an average — use the highest node score (a single critical hop dominates)
- **Exploitability:** HIGH (trivial, no auth), MEDIUM (requires one condition), LOW (requires multiple conditions)
- **Reliability:** Does each hop reliably succeed, or are there probabilistic elements?
- **Detectability:** Would a standard SIEM/WAF/IDS catch this chain? (SILENT / NOISY / VARIES)
- **Prerequisites:** What does the attacker need to start?

### Step 4 — Generate Attack Graph Document

Create `docs/security/attack-graphs/{entry-slug}-{date}.md`:

```markdown
# Attack Graph: {Entry Point}

**Date:** {today}
**Goal:** {goal}
**Entry requires:** {auth level — Unauthenticated / User / Admin}
**Chains found:** {n}
**Highest-impact chain:** Chain {id} → {goal achieved}

---

## Entry Point

**Where:** `{file}:{function}:{line}`
**Attacker controls:** {what they control — e.g., "filename parameter, arbitrary string, up to 255 chars"}
**Auth at entry:** {None / Session required / API key / Admin}

---

## Attack Graph

```
ENTRY: {entry point description}
  │
  ├─[N1]─ {vulnerability at node 1}
  │        {file:function} | CWE-{n} | attacker gains: {capability}
  │        │
  │        ├─[N2a]─ {next vulnerability - path A}
  │        │         └─[N3a]─ {goal reached} ← CHAIN 1
  │        │
  │        └─[N2b]─ {blocked by: parameterized query}
  │                  └─ DEAD END
  │
  └─[N1b]─ {alternative first hop}
            {file:function} | CWE-{n}
            └─[N2c]─ {continues}
                      └─[N3b]─ {goal reached} ← CHAIN 2
```

---

## Chain Analysis

### Chain 1 — {Short Title} [{severity} | {exploitability}]

**Attack summary:**
{2-3 sentences: what an attacker does, step by step, and what they achieve at the end.
Write this as if briefing a defender who needs to understand the real-world impact.}

**Step-by-step:**

**Hop 1/N: {Vulnerability name}**
- Location: `{file}:{line}`
- CWE: CWE-{n}: {name}
- CVSS: {score}
- What attacker does: {action}
- What attacker gains: {capability}

```{lang}
// Vulnerable code
{snippet showing the vulnerability}
```

```bash
# Attacker action (PoC sketch)
{minimal reproduction or conceptual command}
```

**Hop 2/N: {Vulnerability name}**
{Repeat structure}

**Final hop → {goal achieved}**
- Impact: {What the attacker achieves — data accessed, command executed, etc.}
- Blast radius: {Scope of compromise — one user, all users, full system, etc.}

**Chain CVSS:** {score}
**Exploitability:** {HIGH / MEDIUM / LOW}
**Detectability:** {SILENT / NOISY / VARIES} — {why}
**Prerequisites:** {What attacker needs before starting}

---

### Chain 2 — {Short Title}

{Repeat chain structure}

---

## Blocked Paths

| Entry | Blocked At | Control That Blocks It |
|-------|-----------|----------------------|
| {entry} | `{file}:{function}` | {what stops it — parameterized query, allowlist, etc.} |

---

## Recommendations

Ranked by chain impact × exploitability:

| Priority | Chain | Fix | Effort |
|----------|-------|-----|--------|
| P0 | Chain {n} | {specific fix} | {S/M/L} |
| P1 | Chain {n} | {fix} | {S/M/L} |

**Systemic fix (if applicable):**
{If multiple chains share a root cause, describe the single architectural change
that would block all of them — e.g., "move to a centralized input validation framework"}

---

*Next: run `/threat-model` for the full component threat model, or `/pr-sentinel` on the fix PR.*
```

### Step 5 — Terminal Summary

```
ATTACK GRAPH COMPLETE
════════════════════════════════════════

Entry:   {entry point}
Goal:    {goal}
Hops:    up to {n}

Chains found:  {n}
Dead ends:     {n}
Blocked paths: {n}

Best chain:
  {Chain title}
  {entry} → {hop1} → {hop2} → {goal}
  CVSS: {score} | Exploitability: {HIGH/MED/LOW} | {SILENT/NOISY}

  PoC summary:
  "{One sentence describing the attack an attacker would execute}"

Output: docs/security/attack-graphs/{slug}-{date}.md

Suggested next steps:
  /threat-model {component}   → full threat model of this area
  /pr-sentinel --strict       → review any fix PRs
  /incident-playbook {type}   → prepare IR for this scenario
```
