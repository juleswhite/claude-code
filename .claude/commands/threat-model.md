# Threat Model

Generate a complete STRIDE + MITRE ATT&CK threat model for a component, feature,
or endpoint. Outputs an actionable security document and updates the project's
living threat register.

## Usage

```
/threat-model <component-or-feature> [--scope api|frontend|infra|full] [--export]
```

## Examples

```
/threat-model "password reset flow"
/threat-model src/api/payments.py --scope api
/threat-model "user authentication" --export
/threat-model infrastructure/vpc.tf --scope infra
```

---

## Instructions for Claude

You are a senior threat modeler. Your job is to systematically decompose
`$ARGUMENTS` using STRIDE, map findings to MITRE ATT&CK, score them with CVSS 3.1,
and produce a document that a developer can act on in the next sprint.

### Step 1 — Parse Arguments

Extract:
- `target`: the component/feature/file being modeled (required)
- `--scope`: `api` | `frontend` | `infra` | `full` (default: infer from target)
- `--export`: if present, also write the finding to `.claude/threat-register.md`

Slugify target for filenames.

### Step 2 — Gather Context

Read `.claude/security-log.md` if it exists (prior findings).
Read `CLAUDE.md` for project context: stack, compliance scope, secrets handling.

Then search the codebase for the target:
- Find all relevant source files (controllers, services, models, config, IaC)
- Map the data flow: what comes IN, what goes OUT, what is persisted, what is called
- Identify trust boundaries (user → API, API → DB, API → 3rd party, internal service → internal service)
- List all external inputs (HTTP params, headers, env vars, file uploads, webhooks, queue messages)
- List all privileged operations (DB writes, file system access, external API calls, spawning processes)
- Note authentication and authorization mechanisms in place

Produce a mental data-flow diagram of the component:
```
[Actor] → [Entry Point] → [Service] → [Data Store / External]
                                    ↗ [Auth Check]
```

### Step 3 — STRIDE Analysis

For each trust boundary and entry point, systematically work through all six STRIDE categories.

**For each finding, record:**
- STRIDE category
- Threat statement ("An attacker could...")
- Current mitigations in place (if any)
- Residual risk
- CVSS 3.1 base score and vector string
- CWE identifier
- MITRE ATT&CK technique (Tactic / Technique / Sub-technique)
- Recommended mitigation
- Effort estimate (S=hours, M=days, L=week+)

**STRIDE categories to cover:**

**S — Spoofing Identity**
Could an attacker impersonate a user, service, or system component?
- Weak or absent authentication
- Credential stuffing / brute force
- JWT algorithm confusion (alg:none, RS→HS confusion)
- Session fixation, token leakage

**T — Tampering with Data**
Could an attacker modify data in transit or at rest?
- Missing input validation
- Mass assignment vulnerabilities
- IDOR (insecure direct object reference)
- SQL / NoSQL / LDAP / command injection
- Race conditions on shared state
- Replay attacks on non-idempotent operations

**R — Repudiation**
Could an attacker deny performing an action?
- Missing or insufficient audit logging
- Log injection / tampering
- Unsigned/unauthenticated webhook events
- Missing correlation IDs

**I — Information Disclosure**
Could an attacker access data they shouldn't?
- Verbose error messages (stack traces, DB errors)
- Directory listing / path traversal
- Insecure direct object references
- Sensitive data in logs / URLs / headers
- Insecure TLS configuration
- Timing side-channels

**D — Denial of Service**
Could an attacker degrade availability?
- Missing rate limiting
- Resource exhaustion (no pagination, no file size limits)
- Algorithmic complexity attacks (ReDoS, zip bomb)
- Unauthenticated expensive operations
- Dependency on third-party availability without circuit breaker

**E — Elevation of Privilege**
Could an attacker gain more access than intended?
- Missing authorization checks (vertical priv esc)
- Broken access control (horizontal priv esc)
- Unsafe deserialization
- SSRF (server-side request forgery) enabling metadata access
- Template injection

### Step 4 — MITRE ATT&CK Mapping

For each finding, map to the most specific applicable MITRE technique:

Web application context — commonly applicable techniques:
- T1190 Exploit Public-Facing Application
- T1078 Valid Accounts (credential attacks)
- T1552 Unsecured Credentials
- T1059 Command and Scripting Interpreter (injection)
- T1005 Data from Local System (path traversal)
- T1041 Exfiltration Over C2 Channel
- T1498 Network Denial of Service
- T1134 Access Token Manipulation
- T1110 Brute Force
- T1566 Phishing (if frontend involved)

Infrastructure context:
- T1580 Cloud Infrastructure Discovery
- T1537 Transfer Data to Cloud Account
- T1525 Implant Internal Image (container escape)
- T1613 Container and Resource Discovery

### Step 5 — Risk Scoring

Score overall component risk:
- Count findings by CVSS severity: CRITICAL(9.0+), HIGH(7.0-8.9), MEDIUM(4.0-6.9), LOW(0.1-3.9)
- Identify the highest-severity unmitigated finding
- Assign component risk: CRITICAL / HIGH / MEDIUM / LOW / ACCEPTABLE

### Step 6 — Generate Threat Model Document

Create `docs/security/threat-models/{target-slug}.md`:

```markdown
# Threat Model: {Target}

**Date:** {today}
**Scope:** {scope}
**Modeler:** Claude (reviewed by: ___)
**Component risk:** [CRITICAL | HIGH | MEDIUM | LOW]
**Review status:** Draft — pending human review

---

## 1. Component Overview

{2-3 sentence description of what this component does and why it matters from a security perspective.}

### Data Flow

```
{ASCII data flow diagram}
```

### Trust Boundaries

| Boundary | From | To | Authentication |
|----------|------|----|----------------|
| {name} | {actor} | {system} | {mechanism} |

### External Inputs

| Input | Source | Validated? | Sanitized? |
|-------|--------|------------|------------|
| {param} | {source} | {yes/no} | {yes/no} |

---

## 2. STRIDE Findings

### Finding #{n} — {Short Title}

| Field | Value |
|-------|-------|
| **Category** | {STRIDE letter(s)} — {Category name} |
| **Severity** | {CRITICAL / HIGH / MEDIUM / LOW} |
| **CVSS 3.1** | {score} — `{vector}` |
| **CWE** | CWE-{n}: {name} |
| **MITRE ATT&CK** | {Tactic} / {T####.###} {Technique name} |
| **Status** | {Open / Mitigated / Accepted / False Positive} |
| **Effort** | {S / M / L} |

**Threat statement:**
An attacker could {action} by {method}, resulting in {impact}.

**Reproduction (proof of concept):**
```
{minimal curl / code snippet demonstrating the issue, or "theoretical — needs validation"}
```

**Current controls:**
{What, if anything, currently prevents or limits this threat. "None identified" if absent.}

**Recommended mitigation:**
{Concrete, actionable fix. Code example if applicable.}

---

{Repeat Finding section for each threat}

---

## 3. Risk Summary

| Severity | Count | Unmitigated |
|----------|-------|-------------|
| CRITICAL | {n} | {n} |
| HIGH | {n} | {n} |
| MEDIUM | {n} | {n} |
| LOW | {n} | {n} |

**Overall component risk:** {CRITICAL / HIGH / MEDIUM / LOW}

**Top priority actions (sprint-ready):**
1. {Highest-severity unmitigated finding — one-liner action}
2. {Second priority}
3. {Third priority}

---

## 4. Out of Scope

{What was NOT modeled and why — e.g., "Physical access controls", "Third-party SaaS internals"}

---

## 5. Assumptions

- {Assumption 1 — e.g., "TLS termination handled upstream by load balancer"}
- {Assumption 2}

---

## 6. References

- [OWASP ASVS](https://owasp.org/www-project-application-security-verification-standard/)
- [MITRE ATT&CK Web Matrix](https://attack.mitre.org/matrices/enterprise/web-based/)
- [CWE Top 25](https://cwe.mitre.org/top25/)
- {Project-specific: link to design doc, API spec, architecture diagram}
```

### Step 7 — Update Threat Register (if --export)

Append to `.claude/threat-register.md`:

```markdown
| {date} | {target} | {total findings} | {critical count} | {high count} | {overall risk} | [View](docs/security/threat-models/{slug}.md) |
```

If the file doesn't exist, create it with this header first:
```markdown
# Threat Register

| Date | Component | Findings | Critical | High | Risk | Document |
|------|-----------|----------|----------|------|------|----------|
```

### Step 8 — Print Summary

```
THREAT MODEL COMPLETE
════════════════════════════════════════

Target:   {target}
Scope:    {scope}
Risk:     {CRITICAL | HIGH | MEDIUM | LOW}

Findings by severity:
  CRITICAL  {n}  ██████░░░░
  HIGH      {n}  ████░░░░░░
  MEDIUM    {n}  ██░░░░░░░░
  LOW       {n}  █░░░░░░░░░

Top unmitigated threat:
  [{severity}] {short title} — {one-line description}
  CWE-{n} / CVSS {score} / {MITRE T####}

Output:
  docs/security/threat-models/{slug}.md
  .claude/threat-register.md  (if --export)

Next steps:
  1. Human review required before using in a security audit
  2. File tickets for CRITICAL and HIGH findings
  3. Re-run after implementing mitigations: /threat-model {target}
  4. Schedule re-review in 90 days or on next major change

⚠ This model was generated by AI. It is a starting point, not a substitute
  for a professional penetration test or formal threat modeling exercise.
```
