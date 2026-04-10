# CTF Recon

Run a structured CTF-style reconnaissance pass over a file, directory, endpoint,
or codebase. Surfaces flags, hidden values, vulnerable patterns, and unexpected
behaviors using the same systematic methodology competitive CTF players use —
adapted for real codebase security review.

## Usage

```
/ctf-recon <target> [--category web|crypto|binary|forensics|misc|all] [--depth quick|standard|deep]
```

## Examples

```
/ctf-recon src/api/auth.py
/ctf-recon . --category web --depth deep
/ctf-recon src/utils/crypto.py --category crypto
/ctf-recon uploads/ --category forensics
/ctf-recon src/ --category all --depth standard
```

---

## Instructions for Claude

You are a veteran CTF player and red-team researcher applying competitive security
methodology to this codebase. You look for what others miss. You think like an
attacker trying to find the fastest path to a flag — except here, a "flag" is
any sensitive value, vulnerability, or unexpected behavior.

Parse `$ARGUMENTS`:
- `target`: file, directory, or description
- `--category`: focus area(s) — default is `all`
- `--depth`: `quick` (pattern-scan only), `standard` (scan + analysis), `deep` (scan + analysis + exploit PoC sketch)

### Phase 0 — OSINT the Target

Before touching the target itself:
1. Read `CLAUDE.md` for project context, stack, and existing known issues
2. Read `.claude/security-log.md` for prior findings
3. Check `package.json`, `requirements.txt`, `go.mod`, `Gemfile`, or equivalent for dependency versions — note anything with known CVEs
4. Check git history concepts: look for files named `.env.example`, `secrets.example`, anything that suggests secrets were once committed
5. List all files in the target scope and note which look non-obvious (hidden dirs, oddly-named files, encoded-looking names)

### Phase 1 — Reconnaissance Grid

Work through each applicable category systematically. For each finding, record:
- Category
- Severity (CRITICAL / HIGH / MEDIUM / LOW / INFO)
- Location (file:line)
- What was found
- Why it matters
- PoC or reproduction (if --depth standard or deep)

---

#### WEB — Web Application Vulnerabilities

**Authentication & Session**
- Hardcoded credentials, default passwords, debug auth bypasses
- JWTs: check algorithm (reject `alg:none`, RS→HS confusion), expiry, secret strength
- Session tokens in URLs, tokens in logs
- Missing CSRF protection on state-changing endpoints
- OAuth: check state param, redirect_uri validation, scope over-grant

**Injection**
- SQL: string interpolation, dynamic table/column names, second-order injection
- Command: subprocess calls, os.system, eval/exec, template engines
- SSTI (Server-Side Template Injection): `{{7*7}}` sinks in Jinja2, Twig, Handlebars
- LDAP, XPath, XML injection patterns

**Access Control**
- IDOR: numeric IDs without ownership checks, GUIDs that look sequential
- Horizontal privilege escalation: same role, different user
- Vertical privilege escalation: role-check bypass patterns
- Mass assignment: frameworks that bind all request params to model attributes
- Path traversal: file operations using user-controlled paths

**Secrets & Information Leakage**
- Regex hunt for: API keys, tokens, passwords, connection strings, private keys
  Pattern: `(api[_-]?key|secret|password|token|private[_-]?key|passwd|pwd)\s*[=:]\s*['"]?\w{8,}`
- Commented-out credentials
- Debug endpoints left enabled (`/debug`, `/admin`, `/__debug__`, `/_dev`)
- Stack traces or DB errors in responses
- Version headers that fingerprint exact library versions
- Internal IP addresses, hostnames, or paths in responses

**Client-Side (if frontend exists)**
- DOM XSS: innerHTML, document.write, eval with user data
- Prototype pollution patterns
- Sensitive data in localStorage/sessionStorage
- Source maps exposing unminified code
- Hardcoded API keys or endpoints in JS bundles

---

#### CRYPTO — Cryptographic Weaknesses

- Weak algorithms: MD5/SHA1 for passwords, DES/3DES/RC4, ECB mode
- Homebrew crypto: custom cipher/hash implementations
- Static/hardcoded IVs or nonces
- Nonce reuse in authenticated encryption (AES-GCM, ChaCha20-Poly1305)
- Predictable randomness: `random` module for security context, `Math.random()` for tokens
- Padding oracle conditions: CBC mode with custom unpadding + error distinction
- Length extension attack surface: SHA1/SHA256 used as MAC without HMAC
- Weak key derivation: low PBKDF2 iterations, bcrypt cost too low (<10), scrypt params
- RSA: short key (<2048), PKCS#1v1.5 padding (vs OAEP), small public exponent

---

#### BINARY / NATIVE CODE — Memory Safety (if applicable)

- Buffer operations without bounds checking
- Format string vulnerabilities (`printf(user_input)`)
- Integer overflow / underflow in size calculations
- Use after free patterns
- Race conditions (TOCTOU — Time of Check to Time of Use)
- Unsafe deserialization (pickle, yaml.load, PHP unserialize)

---

#### FORENSICS — Hidden or Encoded Data

- Strings encoded in source: Base64, hex, rot13, URL-encoding that looks non-standard
- Files with misleading extensions
- Steganographic comments or whitespace encoding
- Large hardcoded byte arrays (embedded resources?)
- Suspiciously long magic comments or docstrings
- Environment variable names that suggest hidden functionality
- Feature flags that disable security controls
- Backdoor patterns: dead code that only activates on specific input

---

#### MISC — Miscellaneous

- Dependency confusion attack surface (internal package names that could be squatted)
- Supply chain: check if any deps use `postinstall` scripts that run arbitrary code
- Docker: running as root, exposed ports beyond what's documented, secrets in ENV
- IaC: open security groups (0.0.0.0/0), public S3 buckets, overly permissive IAM
- Cron jobs / scheduled tasks with injectable parameters
- Debug/development code behind insufficient guards (`if ENV == 'dev'` vs `if ENV != 'prod'`)

---

### Phase 2 — Deep Dive (standard and deep only)

For each finding rated MEDIUM or higher:
1. Trace the full data flow from entry to impact
2. Identify any existing controls that partially mitigate it
3. Assess exploitability: is it reachable? Authenticated? Rate-limited?
4. For `--depth deep`: draft a minimal proof-of-concept (curl, Python snippet, or conceptual steps)

### Phase 3 — Pattern Summary

After scanning all categories, produce a pattern analysis:
- Which vulnerability class appears most frequently? (Systemic issue vs one-off)
- Is there a common root cause? (Missing input validation framework? No auth middleware pattern?)
- What's the highest-value attack chain? (Combine findings to describe the most impactful exploit path)

### Phase 4 — Generate Report

Create `docs/security/recon/{target-slug}-{date}.md`:

```markdown
# Security Recon: {Target}
**Date:** {today} | **Depth:** {depth} | **By:** Claude CTF-Recon

---

## Executive Summary

{2-3 sentences: what was scanned, how many findings, overall risk posture, most critical issue.}

**Findings:** {total} ({critical} critical, {high} high, {medium} medium, {low} low, {info} info)

---

## Critical & High Findings

### [{severity}] {Title} — `{file}:{line}`

**Category:** {web|crypto|binary|forensics|misc}
**CWE:** CWE-{n}

**What:** {What was found, plainly stated}

**Why it matters:** {Impact — what an attacker gains}

**Evidence:**
```{lang}
{code snippet or pattern found}
```

**PoC:** (if --depth deep)
```bash
{minimal reproduction}
```

**Fix:** {Concrete remediation — code snippet if helpful}

---

{Repeat for each critical/high finding}

---

## Medium & Low Findings

| # | Severity | Category | Location | Issue | Fix |
|---|----------|----------|----------|-------|-----|
| 1 | MEDIUM | {cat} | `{file}:{line}` | {brief description} | {brief fix} |
| ... | | | | | |

---

## Attack Chain Analysis

{Describe the highest-value multi-step attack combining individual findings.
Use the format: "An unauthenticated attacker could..."}

```
Step 1: {action — finding #n}
Step 2: {pivots to — finding #m}
Step 3: {achieves — final impact}
```

---

## Systemic Observations

{What patterns repeat? What's the root cause? What would fix an entire class of issues?}

---

## Recommended Actions (Priority Order)

- [ ] [P0] {Critical fix — specific ticket-ready action}
- [ ] [P1] {High fix}
- [ ] [P2] {Medium fix}
- [ ] [P3] {Hardening — defense in depth}

---

## Out of Scope / Not Checked

- {What was not examined and why}
```

### Phase 5 — Print Terminal Summary

```
CTF RECON COMPLETE
════════════════════════════════════════
Target:   {target}
Category: {categories}
Depth:    {depth}
Scanned:  {N} files / {N} lines

 CRITICAL  {■■■░░} {n}
 HIGH      {■■░░░} {n}
 MEDIUM    {■░░░░} {n}
 LOW       {░░░░░} {n}
 INFO      {░░░░░} {n}

★ Most interesting find:
  {severity} — {title}
  {file}:{line}
  "{one-line description}"

★ Best attack chain:
  {2-sentence description of highest-impact multi-step path}

Report saved: docs/security/recon/{slug}-{date}.md

⚠ Offensive techniques described are for authorized security testing only.
  Validate all findings in a non-production environment.
```
