# Security Engineering Command Suite

A complete, production-grade security workflow for Claude Code — five commands
and a master CLAUDE.md template that bring threat modeling, vulnerability recon,
automated PR security review, attack graph analysis, and incident response
playbook generation into your development cycle.

Built for engineers who take security seriously and want tools that work like
they think: adversarially, systematically, and without ceremony.

---

## What's Included

```
CLAUDE.md                                    ← Security engineering baseline template
.claude/commands/
  threat-model.md                            ← STRIDE + MITRE ATT&CK threat models
  ctf-recon.md                               ← CTF-style vulnerability reconnaissance
  pr-sentinel.md                             ← Security-first PR review with merge blocking
  vuln-chain.md                              ← Attack graph traversal from entry point
  incident-playbook.md                       ← IR runbook generation
processes/
  security-first-development.md             ← End-to-end process tying it all together
```

---

## Quick Start

```bash
# 1. Copy CLAUDE.md to your project root and fill in the project context section
cp CLAUDE.md /your/project/CLAUDE.md

# 2. Copy the commands to your project
mkdir -p /your/project/.claude/commands
cp .claude/commands/*.md /your/project/.claude/commands/

# 3. Create the output directories
mkdir -p /your/project/docs/security/{threat-models,recon,attack-graphs,playbooks}

# 4. Run your first threat model
cd /your/project && claude
> /threat-model "your most critical component"
```

---

## The Five Commands

### `/threat-model <component>` — Before You Build

Run STRIDE threat analysis + MITRE ATT&CK mapping on any feature, endpoint,
or infrastructure component before coding begins.

```
/threat-model "password reset flow"
/threat-model src/api/payments.py --scope api
/threat-model infrastructure/vpc.tf --scope infra --export
```

**Output:** `docs/security/threat-models/{slug}.md` with CVSS-scored findings,
CWE identifiers, MITRE technique mappings, and sprint-ready remediation tasks.

---

### `/ctf-recon <target>` — While You Build

Apply competitive CTF methodology to your own code. Hunts for secrets,
injection vectors, auth bypasses, crypto weaknesses, hidden values, and
attack chains — using the same systematic approach top CTF players use.

```
/ctf-recon src/api/auth.py
/ctf-recon . --category web --depth deep
/ctf-recon src/utils/crypto.py --category crypto
```

**Output:** `docs/security/recon/{slug}-{date}.md` with all findings categorized,
a best attack chain analysis, and stack-specific reproduction steps.

---

### `/pr-sentinel` — Before You Merge

Security-first PR review that checks invariants, hunts for regressions,
scores dependencies for CVEs, and can block merges on CRITICAL findings.
Drop into CI or run manually as a reviewer.

```
/pr-sentinel
/pr-sentinel --strict          # merge block on any HIGH+
/pr-sentinel --files "src/api/**"
```

**Output:** Structured review with APPROVE / MERGE BLOCK verdict, per-finding
CWE references, and corrected code snippets.

---

### `/vuln-chain <entry-point>` — Map the Blast Radius

Given an entry point (a route, function, or attacker capability), traverse the
codebase and build a directed attack graph — every path from that point to a
high-value goal (RCE, data exfil, privilege escalation).

```
/vuln-chain "unauthenticated POST /api/upload" --goal rce
/vuln-chain "guest session" --goal any --hops 4
```

**Output:** `docs/security/attack-graphs/{slug}.md` with each chain scored,
exploitability rated, detectability assessed, and prioritized remediation.

---

### `/incident-playbook <type>` — Before the Alert Fires

Generate a complete IR runbook for any incident type, calibrated to your
stack and compliance scope. Phase-by-phase: triage → containment → eradication
→ recovery → post-incident. Includes evidence preservation, compliance notification
timelines, and stack-specific commands.

```
/incident-playbook credential-stuffing --severity P1
/incident-playbook active-breach
/incident-playbook secret-exposure --stack python,aws
```

**Output:** `docs/security/playbooks/{slug}.md` — a runbook an on-call engineer
can execute at 2 AM without needing to think.

---

## The CLAUDE.md Template

The included `CLAUDE.md` template establishes a security engineering baseline
for any project:

- **Security invariants** Claude checks before any task (no secrets in source, parameterized queries, etc.)
- **Stack-specific conventions** for Python, PowerShell, and common web patterns
- **Vulnerability disclosure format** so Claude produces structured findings, not prose
- **Git commit format** for security fixes (includes CWE, CVSS, CVE)
- **PR checklist** Claude runs automatically on every review
- **Persistent security log** that gives Claude memory across sessions

Fill in the project context section (3 fields) and you're operational.

---

## The Process

The five commands map to the five phases of secure development:

| Phase | Trigger | Command | Time |
|-------|---------|---------|------|
| Design | New feature | `/threat-model` | 30 min |
| Build | Self-review | `/ctf-recon --depth quick` | 5 min |
| Review | PR opened | `/pr-sentinel` | 10 min |
| Pre-release | Architecture review | `/vuln-chain` | 60 min |
| Operate | New alert added | `/incident-playbook` | 20 min |

Full workflow documentation: [`processes/security-first-development.md`](processes/security-first-development.md)

---

## Design Philosophy

**Adversarial by default.** Every command assumes a motivated attacker will
read what Claude produces and try to exploit what was missed. The goal is to
find it first.

**Actionable, not theoretical.** Every finding includes a CVSS score, CWE
identifier, MITRE ATT&CK mapping, and a concrete remediation. No vague
"consider adding input validation" — specific file, line, and corrected code.

**Composable.** Commands share a common security log (`.claude/security-log.md`)
so Claude builds knowledge across sessions. The output of `/threat-model` feeds
into `/pr-sentinel`. The output of `/incident-playbook` feeds back into
`/threat-model` after an incident.

**Honest about limits.** Every output includes a disclaimer: this is a
floor for security review, not a substitute for a professional penetration test
or compliance audit. The commands catch a broad class of known vulnerability
patterns reliably — they don't catch novel zero-days or business-logic flaws
specific to your domain.

---

## Contributing

Improvements welcome:
- New incident types for `/incident-playbook`
- Stack-specific command variations (Rails, Spring Boot, Go, Rust)
- CI integration examples for other platforms (GitLab CI, Jenkins, CircleCI)
- CLAUDE.md templates for specific compliance frameworks (PCI-DSS, FedRAMP)

See [CONTRIBUTING.md](../../CONTRIBUTING.md) for PR guidelines.

---

*Contributed by a network/security engineer who got tired of finding the same
bugs in code review that a systematic methodology would have caught in design.*
