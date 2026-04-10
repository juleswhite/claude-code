# Incident Playbook

Generate a structured Incident Response (IR) runbook for a specific alert type
or security event. Outputs a step-by-step playbook calibrated to your stack,
severity, and compliance requirements.

## Usage

```
/incident-playbook <incident-type> [--severity P0|P1|P2|P3] [--stack <tech>]
```

## Examples

```
/incident-playbook active-breach
/incident-playbook credential-stuffing --severity P1
/incident-playbook data-exposure --severity P2
/incident-playbook api-abuse --stack python,postgres
/incident-playbook ransomware --severity P0
/incident-playbook anomalous-auth
```

**Common incident types:**
`active-breach` | `credential-stuffing` | `data-exposure` | `api-abuse` |
`ransomware` | `supply-chain-compromise` | `insider-threat` | `dos-attack` |
`anomalous-auth` | `secret-exposure` | `container-escape` | `phishing-campaign`

---

## Instructions for Claude

You are a senior incident responder. You've been paged. `$ARGUMENTS` is your
initial alert summary. Your job is to produce a runbook that an engineer
receiving this alert at 2 AM can execute without hesitation — clear, ordered,
no ambiguity.

Parse `$ARGUMENTS`:
- `incident_type`: what happened or is happening
- `--severity`: P0 (all-hands, active), P1 (critical, < 2h), P2 (significant, < 8h), P3 (low, < 24h)
  If not provided, infer from incident type (active-breach → P0, data-exposure → P2, etc.)
- `--stack`: technology hints for stack-specific commands (infer from CLAUDE.md if not provided)

### Step 0 — Read Context

Read `CLAUDE.md`:
- Stack, database, cloud provider, auth mechanism
- Compliance scope (HIPAA, PCI, SOC2 — these determine notification timelines)
- On-call contacts and war room location
- Any prior incidents from `.claude/security-log.md`

### Step 1 — Classify the Incident

Map the incident type to:
- **MITRE ATT&CK Initial Access tactic** (what likely triggered it)
- **NIST IR phase** (Preparation / Detection / Containment / Eradication / Recovery / Post-Incident)
- **Primary data risk**: PII / Financial / IP / Availability / Reputation
- **Regulatory notification requirement**: determine if breach notification laws apply
  - GDPR: 72 hours to supervisory authority if EU personal data involved
  - HIPAA: 60 days to HHS if PHI involved; immediate if > 500 individuals
  - PCI DSS: Immediately notify card brands and acquirer
  - State laws: Vary (CA CCPA, NY SHIELD, etc.)

### Step 2 — Determine Severity (if not provided)

```
P0 — CRITICAL (Immediate all-hands)
  - Active attacker in production systems with data access
  - Ransomware encrypting production data
  - Admin credential confirmed compromised
  - Active exfiltration of PII/financial data in progress

P1 — HIGH (< 2 hour response)
  - Confirmed unauthorized access, attacker possibly still present
  - Credential stuffing succeeding at scale (> 100 accounts/hour)
  - Critical vulnerability actively exploited in wild, unpatched in prod
  - Supply chain compromise confirmed

P2 — MEDIUM (< 8 hour response)
  - Data exposure confirmed, no evidence of access
  - Single account compromise, isolated
  - Anomalous access pattern, not yet confirmed malicious
  - Secret accidentally committed (revoke + rotate needed)

P3 — LOW (< 24 hour response)
  - Security scanner alert, likely false positive
  - Low-volume anomaly, no data access
  - Failed attacks only (brute force repelled)
```

### Step 3 — Generate the Runbook

Create `docs/security/playbooks/{incident-type-slug}.md`:

```markdown
# IR Playbook: {Incident Type}

**Severity:** {P0/P1/P2/P3} — {label}
**Last Updated:** {today}
**Owner:** {from CLAUDE.md or "Security Team"}
**MITRE Phase:** {tactic}

---

## ⚡ First 5 Minutes

{For P0/P1 only — the critical actions to take before reading the rest of this document}

- [ ] **Declare incident** in {Slack channel} with: `🚨 INCIDENT DECLARED: {type} | Severity: {P0/P1} | IC: @you`
- [ ] **Page on-call lead:** {method from CLAUDE.md}
- [ ] **Do NOT** {common mistake to avoid — e.g., "do NOT restart the affected service yet"}
- [ ] **Start** an incident timeline document (copy template below)
- [ ] **Screenshot / preserve** current state before any remediation

---

## Phase 1 — Detection & Initial Triage

**Goal:** Confirm the incident is real and establish blast radius.

### 1.1 Confirm the Alert

```bash
# Verify the triggering condition — stack-specific commands here

# Check auth logs for anomalous patterns
{stack-appropriate log query — e.g., for CloudWatch, Splunk, ELK, raw file}

# Check active sessions
{query for active sessions — e.g., SQL or Redis command}

# Identify affected accounts/IPs
{command}
```

**Decision gate:**
- If confirmed → continue to Phase 2
- If false positive → document in `.claude/security-log.md`, close incident

### 1.2 Establish Blast Radius

Answer these questions before containment:

- [ ] Which accounts/users are affected?
- [ ] Which systems/services are involved?
- [ ] What data could have been accessed? (Classify: PII / financial / IP)
- [ ] Is the attacker still present?
- [ ] How long has this been occurring? (Check logs back to: {timeframe})
- [ ] Is this isolated or part of a larger campaign?

```bash
# Determine time window of compromise
{log search command covering extended period}

# List all actions taken by affected account(s)
{audit log query}

# Check for lateral movement indicators
{command}
```

---

## Phase 2 — Containment

**Goal:** Stop the bleeding without destroying evidence.

**⚠️ Evidence first:** Before taking any action, capture:
- Full log output from triage commands above (save to incident folder)
- Screenshot of monitoring dashboards
- Network connection state if relevant: `ss -tulpn` or `netstat -an`

### 2.1 Immediate Containment

```bash
# Option A — Isolate specific account(s)
{disable user account command — stack specific}

# Option B — Block by IP
{firewall command or WAF rule}

# Option C — Rotate compromised credential
{key/token rotation command}

# Option D — Take service offline (P0 last resort)
{graceful shutdown command}
```

### 2.2 Preserve Evidence

```bash
# Export relevant logs to incident folder
mkdir -p incidents/{date}-{slug}

# Application logs
{log export command}

# System logs (if applicable)
sudo cp /var/log/auth.log incidents/{date}-{slug}/
sudo cp /var/log/syslog incidents/{date}-{slug}/

# Database audit log (if applicable)
{DB audit export command}

# Container state snapshot (if applicable)
docker inspect {container} > incidents/{date}-{slug}/container-state.json
```

---

## Phase 3 — Eradication

**Goal:** Remove attacker access and close the vulnerability.

### 3.1 Identify the Entry Point

```bash
# Trace back to initial access
{log analysis commands — look for first anomalous event before the alert}

# Check for persistence mechanisms
{commands to find backdoors, new users, scheduled tasks, SSH keys}
```

**Common entry points for {incident_type}:**
- {Entry point 1 specific to this incident type}
- {Entry point 2}
- {Entry point 3}

### 3.2 Remove Attacker Access

- [ ] Rotate ALL credentials that may have been exposed (not just the confirmed ones)
- [ ] Revoke all active sessions for affected accounts
- [ ] Remove any backdoor accounts, SSH keys, or API tokens created during compromise
- [ ] Update/patch the exploited vulnerability

```bash
# Force re-authentication for all users (if session compromise suspected)
{command to invalidate all sessions — e.g., flush Redis, rotate JWT secret}

# Rotate service account credentials
{credential rotation commands}

# Audit for new privileged accounts
{command}
```

### 3.3 Vulnerability Remediation

```bash
# Apply the patch/fix
{git or deployment command}

# Verify fix is deployed
{health check command}

# Run /pr-sentinel to confirm fix doesn't introduce new issues
```

---

## Phase 4 — Recovery

**Goal:** Restore service safely and validate clean state.

### 4.1 Validation Checks Before Restoring Service

- [ ] All attacker access removed (credentials rotated, sessions invalidated)
- [ ] Vulnerability patched and verified
- [ ] Monitoring/alerting in place for recurrence
- [ ] Logs showing clean state after remediation

### 4.2 Restore Service

```bash
# Re-enable service / accounts
{command}

# Monitor for recurrence (watch logs live)
{tail/stream log command}
```

### 4.3 Notification (Compliance-Triggered)

{Generate this section based on detected compliance scope from CLAUDE.md}

**If GDPR applies:**
- Notify supervisory authority within 72 hours of awareness
- Template: [EU Breach Notification](.claude/templates/gdpr-breach-notification.md)
- Notify affected individuals if high risk to their rights/freedoms

**If HIPAA applies:**
- Notify HHS via breach report portal within 60 days
- Notify affected individuals without unreasonable delay (≤ 60 days)
- If > 500 individuals: also notify prominent media outlets in affected states

**If PCI DSS applies:**
- Immediately notify payment card brands and acquiring bank
- Do NOT disable logging or alter systems until forensics is complete

**If none apply:**
- Document your notification decision and rationale

---

## Phase 5 — Post-Incident

**Goal:** Learn, document, and prevent recurrence.

### 5.1 Incident Timeline Template

Copy to incident folder and complete:

```markdown
# Incident Timeline: {type} — {date}

## Summary
- **What happened:** 
- **When detected:**
- **When contained:**
- **Data affected:**
- **Users affected:**

## Timeline (UTC)

| Time (UTC) | Event | Who |
|------------|-------|-----|
| {time} | Alert triggered | System |
| {time} | Incident declared | |
| {time} | Blast radius confirmed | |
| {time} | Containment action: {action} | |
| {time} | Eradication complete | |
| {time} | Service restored | |
| {time} | Incident closed | |

## Root Cause
{What the attacker exploited / what failed}

## What Went Well
- 

## What Went Poorly
- 

## Action Items
| Action | Owner | Due | Status |
|--------|-------|-----|--------|
| {fix} | {name} | {date} | Open |
```

### 5.2 Post-Incident Actions

- [ ] Schedule blameless post-mortem within 5 business days
- [ ] File tickets for all action items with owners and due dates
- [ ] Run `/threat-model` on affected component post-fix
- [ ] Run `/pr-sentinel` on all changes made during incident
- [ ] Update this playbook based on what was missing or incorrect
- [ ] Update `.claude/security-log.md` with incident summary

---

## Reference

### Useful Commands for {Stack}

```bash
{Stack-specific reference commands — log queries, DB commands, cloud CLI commands
based on the technology detected in CLAUDE.md}
```

### Key Contacts

{Populate from CLAUDE.md — security lead, legal, DPO, PR/comms, executive escalation}

### Related Playbooks

- {Link to related playbooks in docs/security/playbooks/}
```

### Step 4 — Print Activation Summary

```
INCIDENT PLAYBOOK GENERATED
════════════════════════════════════════

Incident:  {type}
Severity:  {P0/P1/P2/P3} — {label}
Stack:     {detected stack}
Compliance: {detected compliance scope}

Playbook:  docs/security/playbooks/{slug}.md

⚡ IMMEDIATE ACTIONS ({severity}):
{Top 3 first-5-minutes steps, numbered}

⏰ Time constraints:
{Notification timelines if compliance scope detected}

Run now:
  cat docs/security/playbooks/{slug}.md

Declare incident:
  {Slack/PagerDuty command from CLAUDE.md}
```
