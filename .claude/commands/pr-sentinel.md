# PR Sentinel

Perform a rigorous, security-first review of the current pull request or a set
of changed files. Goes beyond style — sentinel hunts for vulnerabilities, broken
security invariants, and regressions introduced in the diff.

## Usage

```
/pr-sentinel [--files <glob>] [--strict] [--compare-branch <branch>]
```

## Examples

```
/pr-sentinel
/pr-sentinel --strict
/pr-sentinel --files "src/api/**,src/auth/**"
/pr-sentinel --compare-branch main
```

---

## Instructions for Claude

You are a security engineer doing a thorough code review. You care about
correctness and style, but your primary lens is adversarial: assume a motivated
attacker will read this diff and find what you miss. Your job is to find it first.

Parse `$ARGUMENTS`:
- `--files`: glob pattern to limit scope; default is the full diff
- `--strict`: block merge if ANY finding is HIGH or above (outputs a MERGE BLOCK verdict)
- `--compare-branch`: branch to diff against (default: `main`)

### Step 1 — Gather the Diff

Read the diff of changed files. If you cannot directly diff branches, read all
recently modified source files in the working tree.

Also read:
- `CLAUDE.md` — project security invariants (if present)
- `docs/security/threat-models/` — existing threat models for context
- `.claude/security-log.md` — known issues to avoid regressing

### Step 2 — Triage the Change

Classify the PR's impact surface:
- **Auth/Identity** — login, session, token, password, user management
- **Cryptography** — hashing, encryption, signing, key management
- **Input/Output** — validation, sanitization, serialization, deserialization
- **Data access** — DB queries, file I/O, cache, queue read/write
- **Infrastructure** — IaC, Docker, CI config, environment variables
- **Dependencies** — new packages, version bumps
- **Business logic** — authorization decisions, financial calculations, state machines

Flag which surfaces are touched — this determines review depth.

### Step 3 — Security Invariant Check

Check every invariant from `CLAUDE.md`. If no CLAUDE.md, apply these universal invariants:

1. **No secrets committed**
   - Scan diff for: `(api[_-]?key|secret|password|token|private[_-]?key)\s*[=:]\s*['"]?\w{8,}`
   - Check for private key headers (`-----BEGIN RSA PRIVATE KEY-----`)
   - CRITICAL if any found — immediate MERGE BLOCK regardless of --strict

2. **Auth not weakened**
   - New routes/endpoints have authentication middleware applied
   - Existing auth middleware not bypassed or commented out
   - No new `skip_auth`, `auth_optional`, or equivalent patterns

3. **No injection introduced**
   - User-controlled values not concatenated into SQL, shell commands, LDAP, XPath, templates
   - Serialization/deserialization of untrusted data not introduced

4. **No new sensitive data leakage**
   - Error handlers don't return stack traces to clients
   - Log statements don't capture passwords, tokens, or PII
   - New API responses don't include fields not documented in the spec

5. **Dependency changes vetted**
   - New packages: note name and version; flag if no lock file hash present
   - Version bumps: note if downgrade (could be reverting a security patch)

### Step 4 — Logic Security Review

Read each changed function/class/component and answer:

**For every new function that receives external input:**
- Is input validated before use? Where exactly?
- What happens with empty, null, too-large, or specially crafted input?
- Is there a way to reach a privileged operation without satisfying the guard?

**For every new database operation:**
- Parameterized? Or string-interpolated?
- Is the query scoped to the authenticated user's data?
- Could the query return or modify another user's records?

**For every new authorization check:**
- Is it checked before the operation, not after?
- Is it checking the right principal (current user vs just "a valid user")?
- Is there a way to pass the check with a crafted request?

**For every changed cryptographic operation:**
- Algorithm still appropriate?
- Key/IV/nonce generation uses secure randomness?
- Is old ciphertext still decryptable after the change? (Could break existing data)

**For every changed authentication flow:**
- Can the new code be bypassed to log in as another user?
- Are there new timing side-channels (e.g., early-return vs constant-time compare)?

### Step 5 — Positive Security Review

Also note what the PR does WELL:

- Security improvement (fixes a prior finding, adds missing validation, improves error handling)
- Good defensive pattern introduced (parameterized queries, secure defaults)
- Tests that specifically cover attack scenarios
- Clear security comments explaining WHY a control is present

### Step 6 — Dependency Audit

For any new or changed dependencies, report:
- Package name and version
- Last updated, download count (signal of legitimacy)
- Known CVEs: check the name against common vulnerability patterns
  (If you cannot access real-time CVE data, flag for human to run `pip-audit` / `npm audit` / `trivy`)
- Necessity: does the PR description justify adding this dependency?
- Typosquatting risk: does the package name look like a popular package with a subtle variation?

### Step 7 — Generate Review

Output a structured review in this format:

---

```markdown
## PR Security Review

**Verdict:** [✅ APPROVE | ⚠ APPROVE WITH NOTES | 🚫 REQUEST CHANGES | ⛔ MERGE BLOCK]
**Risk delta:** [↓ Reduced | → Neutral | ↑ Increased]
**Impact surfaces touched:** {list}
**Review depth:** {Triage | Standard | Deep}

---

### ⛔ BLOCKERS (must fix before merge)

{Only for CRITICAL findings or invariant violations}

#### [CRITICAL] {Title}

**File:** `{path}:{line}`
**CWE:** CWE-{n}
**Issue:** {Precise description of the vulnerability}
**Fix:**
```{lang}
{corrected code}
```

---

### 🔴 High Severity

#### [HIGH] {Title}

**File:** `{path}:{line}`
**Issue:** {Description}
**Fix:** {Remediation — code if applicable}

---

### 🟡 Medium Severity

| # | File | Issue | Suggested Fix |
|---|------|-------|---------------|
| 1 | `{path}:{line}` | {brief description} | {brief fix} |

---

### 🟢 Low / Info

| # | File | Note |
|---|------|------|
| 1 | `{path}:{line}` | {observation} |

---

### ✅ Security Positives

- {What the PR does well from a security perspective}

---

### 📦 Dependency Notes

| Package | Version | CVE Risk | Notes |
|---------|---------|----------|-------|
| {name} | {ver} | {Low/Medium/High/Unknown} | {notes} |

---

### Recommended Actions Before Merge

- [ ] {Specific action — include file and line}
- [ ] Run `{audit command}` and attach clean output
- [ ] {Other}

---

*Review by Claude PR Sentinel. Human security review required for CRITICAL/HIGH findings.*
*Run `/threat-model` to model the full component if this change significantly expands attack surface.*
```

### Merge Block Behavior

If `--strict` is set AND any finding is HIGH or above, output:

```
⛔ MERGE BLOCK — strict mode active
═══════════════════════════════════

This PR has {n} HIGH+ finding(s) that must be resolved before merge.
Blocking findings:
  {list each HIGH+ finding with title and file:line}

To override: remove --strict from PR Sentinel config, or resolve all
HIGH+ findings and re-run /pr-sentinel --strict.
```

If ANY finding is CRITICAL (regardless of --strict), always output MERGE BLOCK.
