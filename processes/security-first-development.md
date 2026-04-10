# The Security-First Development Process

A repeatable workflow that integrates threat modeling, automated security review,
and incident readiness into the normal development cycle — without slowing it down.

Built for teams using Claude Code. All steps invoke commands from this repository.

---

## Why This Process Exists

Security review typically happens too late (at the end of a sprint, or after a breach).
This process moves security left — into design, development, and review — using Claude Code
commands that make security analysis as fast as writing a commit message.

**The core idea:** Every feature has a threat model before it ships. Every PR has a
security review. Every alert type has a playbook before it fires.

---

## The Lifecycle

```
DESIGN          BUILD           REVIEW          OPERATE
  │               │               │               │
  ▼               ▼               ▼               ▼
/threat-model   /ctf-recon     /pr-sentinel    /incident-playbook
  │               │               │               │
  └───────────────┴───────────────┘               │
            /vuln-chain (any phase)                │
                                                   ▼
                                          /threat-model (post-incident)
```

---

## Phase 1: Design — Before You Write a Line of Code

**Trigger:** Any new feature, endpoint, or infrastructure change.

**Command:** `/threat-model <feature-name>`

**Who runs it:** The engineer designing the feature, or a security champion during design review.

**What it produces:** A STRIDE + MITRE threat model in `docs/security/threat-models/`.

**Decision gates:**
- CRITICAL or HIGH findings → must be addressed in the design before coding begins
- MEDIUM findings → must have a mitigation plan before the feature ships
- LOW findings → tracked, addressed in a future sprint

**Time investment:** 5–10 minutes to run, 15–30 minutes to review and act on findings.

**Example workflow:**
```bash
# You're about to build a file upload feature
/threat-model "user file upload to S3" --scope full

# Review docs/security/threat-models/user-file-upload-to-s3.md
# File tickets for HIGH findings before opening a coding sprint
```

**Tip:** The threat model becomes a living document. Re-run it when the design changes.

---

## Phase 2: Build — While Writing Code

**Trigger:** Anytime you're working on security-relevant code (auth, crypto, input handling, data access).

**Command:** `/ctf-recon <file-or-directory> --depth standard`

**Who runs it:** The engineer building the feature, as a self-review tool.

**What it produces:** A vulnerability scan report in `docs/security/recon/`.

**When to run it:**
- When you finish a function that handles user input
- When you add a new authentication or authorization check
- When you add a new dependency
- When you touch cryptographic operations

**Example workflow:**
```bash
# You just finished writing the file upload handler
/ctf-recon src/api/upload.py --category web --depth standard

# Review the findings
# Fix any MEDIUM+ issues before opening the PR
```

**Tip:** Run with `--depth quick` for a fast pattern scan during active development,
`--depth deep` when you want PoC sketches before a security review.

---

## Phase 3: Review — Before Merging

**Trigger:** Every PR that touches auth, crypto, input handling, data access, or infrastructure.

**Command:** `/pr-sentinel [--strict]`

**Who runs it:** The PR reviewer, or automatically in CI.

**What it produces:** A structured security review comment on the PR.

**How to integrate with CI (GitHub Actions example):**

```yaml
# .github/workflows/security-review.yml
name: PR Security Review

on:
  pull_request:
    paths:
      - 'src/**'
      - 'infrastructure/**'
      - '*.tf'

jobs:
  sentinel:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Run PR Sentinel
        uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          prompt: |
            Run /pr-sentinel --strict on the changes in this PR.
            Post the full review output as a PR comment.
          claude_args: "--max-turns 10"
```

**Decision gates:**
- MERGE BLOCK findings → PR cannot merge until resolved
- HIGH findings → require a second human reviewer sign-off
- MEDIUM findings → engineer's discretion, document rationale if accepting risk
- LOW findings → track, no merge block

**Tip:** Use `--strict` on PRs to `main` or `production` branches. Use without `--strict`
on feature branch PRs for faster iteration.

---

## Phase 4: Attack Graph Review — Periodic or Pre-Release

**Trigger:** Major releases, architecture changes, quarterly security reviews, or when
you want to understand the blast radius of a component.

**Command:** `/vuln-chain <entry-point> --goal any`

**Who runs it:** Security champion or the engineer responsible for the component.

**What it produces:** An attack graph in `docs/security/attack-graphs/`.

**When to run it:**
- Before a major release (run on every external-facing entry point)
- After a significant refactor
- As part of a quarterly security review
- When a threat model finds HIGH/CRITICAL findings (chain them to understand blast radius)

**Example workflow:**
```bash
# Quarterly review of your API's external attack surface
/vuln-chain "unauthenticated POST /api/register" --goal any
/vuln-chain "authenticated GET /api/files/:id" --goal data-exfil
/vuln-chain "webhook POST /api/webhooks/stripe" --goal rce
```

---

## Phase 5: Operate — Before an Alert Fires

**Trigger:** Any new alert type added to your monitoring, or after a post-incident review.

**Command:** `/incident-playbook <incident-type>`

**Who runs it:** Security engineer, SRE, or on-call engineer when setting up new alerts.

**What it produces:** A runbook in `docs/security/playbooks/`.

**Rule:** Every alert type must have a playbook BEFORE it fires in production.

**Example workflow:**
```bash
# You just added a "failed login spike" alert to your SIEM
/incident-playbook credential-stuffing --severity P1

# Review docs/security/playbooks/credential-stuffing.md
# Test the runbook: can someone on your team follow it at 2 AM?
```

**Quarterly runbook review:**
- Run each playbook against recent incidents: was anything missing?
- Update commands for stack changes (new log locations, new services)
- Add new playbooks for new alert types

---

## The Security Log — Shared Memory Across Sessions

All commands read and write `.claude/security-log.md` as a persistent threat register.
This means Claude remembers what was found in previous sessions and can connect dots
across features.

**Format:**
```markdown
## {date} — {brief description}
- Finding: {what was found}
- Status: [open | mitigated | accepted | false-positive]
- Owner: {who}
- Refs: {ticket / CVE / CWE}
```

**Maintain it:** Keep it updated after every sprint. Archive entries older than 6 months
to `.claude/security-log-archive.md`.

---

## Suggested Team Norms

| When | Who | Command | Time |
|------|-----|---------|------|
| New feature design | Engineer + security champion | `/threat-model` | 30 min |
| During coding (self-review) | Engineer | `/ctf-recon --depth quick` | 5 min |
| PR opened | Reviewer | `/pr-sentinel` | 10 min |
| Pre-release | Security champion | `/vuln-chain` | 60 min |
| New alert added | SRE / on-call | `/incident-playbook` | 20 min |
| Quarterly | Security lead | All commands | Half-day |
| Post-incident | Incident commander | `/threat-model` + `/incident-playbook` | 2 hours |

---

## Measuring Effectiveness

Track these metrics in your security log or issue tracker:

**Leading indicators (predict future incidents):**
- Threat models per feature (target: 100% of features with external attack surface)
- PR Sentinel coverage (target: 100% of PRs touching auth/crypto/input)
- Playbooks per alert type (target: 100%)
- Time from threat model finding to ticket filed

**Lagging indicators (measure impact):**
- Security bugs found in code review vs. production
- Mean time to contain an incident (MTTC)
- Repeat finding rate (same CWE appearing in multiple PRs)
- External CVEs / bug bounty reports

**Green target state:**
- > 80% of security bugs caught before merge
- < 30 min mean time to execute any IR playbook
- 0 CRITICAL findings reaching production unmitigated

---

## FAQ

**Q: This looks like a lot of overhead. How do we avoid slowing down shipping?**

The commands are fast — `/ctf-recon --depth quick` on a single file takes under
a minute. The overhead is front-loaded: a 30-minute threat model before coding
prevents a 30-hour incident response later. Most teams find that false-positive
rates drop and security debates become shorter once findings are concrete and
CVSS-scored rather than subjective.

**Q: Do we need all five commands?**

Start with `/pr-sentinel` — it requires zero setup and adds security review to every
PR immediately. Add `/threat-model` when you start a new feature. Add the others
as your security maturity grows.

**Q: What if Claude misses something?**

These commands are a floor, not a ceiling. Claude catches a large class of
well-known vulnerability patterns reliably. It won't catch zero-day logic flaws
specific to your business domain. Use these as automated first-pass review;
bring in human security engineers for high-risk components and compliance audits.

**Q: Can we run these in CI without human review?**

Yes, but with caution. `/pr-sentinel` with `--strict` and a MERGE BLOCK on CRITICAL
findings is a safe CI automation. Full `/threat-model` runs are better triggered
manually — they generate documents that need human review before acting on.

---

## Contributing to This Process

Found a gap? Add a new playbook, improve a command, or share a workflow that worked
for your team. See [CONTRIBUTING.md](../../CONTRIBUTING.md) for how to submit a PR.
