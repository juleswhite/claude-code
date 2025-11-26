# Setup Community Health Files

Set up GitHub community health files with good defaults for this project.

## Instructions

### Step 1: Analyze Current State

Check which community health files already exist:

```
.github/
├── ISSUE_TEMPLATE/
│   ├── bug_report.md
│   ├── feature_request.md
│   └── config.yml
├── PULL_REQUEST_TEMPLATE.md
├── FUNDING.yml
├── SECURITY.md
├── SUPPORT.md
└── CODEOWNERS
CODE_OF_CONDUCT.md
CONTRIBUTING.md
```

Also check the root for: `README.md`, `LICENSE`

### Step 2: Gather Project Context

Before generating files, determine:
1. **Project name** - from package.json, Cargo.toml, go.mod, or directory name
2. **Project description** - from package.json or README if exists
3. **Primary language** - from file extensions or config files
4. **License type** - from existing LICENSE file
5. **Repo URL** - from git remote or package.json

### Step 3: Ask User Preferences

Ask the user which files they want to create (only show missing ones):

**Required files:**
- [ ] CODE_OF_CONDUCT.md - Community behavior guidelines
- [ ] CONTRIBUTING.md - How to contribute to the project
- [ ] SECURITY.md - Security vulnerability reporting

**Recommended files:**
- [ ] .github/ISSUE_TEMPLATE/bug_report.md - Bug report template
- [ ] .github/ISSUE_TEMPLATE/feature_request.md - Feature request template
- [ ] .github/PULL_REQUEST_TEMPLATE.md - PR description template
- [ ] .github/SUPPORT.md - Where to get help

**Optional files:**
- [ ] .github/FUNDING.yml - Sponsorship links
- [ ] .github/CODEOWNERS - Auto-assign reviewers

### Step 4: Generate Selected Files

Use these templates, customized with project context:

---

#### CODE_OF_CONDUCT.md

Use the Contributor Covenant v2.1 (industry standard):
- Replace `[INSERT CONTACT METHOD]` with appropriate contact
- Keep at project root for visibility

---

#### CONTRIBUTING.md

Include sections:
1. **Welcome** - Brief intro encouraging contributions
2. **Getting Started** - Dev setup instructions (reference README)
3. **How to Contribute**
   - Reporting bugs (link to issue template)
   - Suggesting features (link to issue template)
   - Code contributions (fork, branch, PR workflow)
4. **Development Workflow**
   - Branch naming conventions
   - Commit message format
   - Testing requirements
5. **Code Style** - Linting/formatting standards
6. **Pull Request Process** - What to expect

---

#### SECURITY.md

Include:
1. **Supported Versions** - Table of versions receiving security updates
2. **Reporting a Vulnerability** - Private disclosure process
   - Email or GitHub private vulnerability reporting
   - What to include in report
   - Response timeline expectations
3. **Security Update Process** - How fixes are released

---

#### .github/ISSUE_TEMPLATE/bug_report.md

```yaml
---
name: Bug Report
about: Report a bug to help us improve
title: '[BUG] '
labels: bug
assignees: ''
---

## Description
A clear description of the bug.

## Steps to Reproduce
1. Go to '...'
2. Click on '...'
3. See error

## Expected Behavior
What you expected to happen.

## Actual Behavior
What actually happened.

## Environment
- OS: [e.g., macOS 14.0]
- Node version: [e.g., 20.10.0]
- Package version: [e.g., 1.0.0]

## Additional Context
Screenshots, logs, or other relevant information.
```

---

#### .github/ISSUE_TEMPLATE/feature_request.md

```yaml
---
name: Feature Request
about: Suggest an idea for this project
title: '[FEATURE] '
labels: enhancement
assignees: ''
---

## Problem Statement
Describe the problem this feature would solve.

## Proposed Solution
Describe your proposed solution.

## Alternatives Considered
Other solutions you've considered.

## Additional Context
Mockups, examples, or other relevant information.
```

---

#### .github/ISSUE_TEMPLATE/config.yml

```yaml
blank_issues_enabled: true
contact_links:
  - name: Documentation
    url: [DOCS_URL]
    about: Check the documentation before opening an issue
```

---

#### .github/PULL_REQUEST_TEMPLATE.md

```markdown
## Description
Brief description of changes.

## Type of Change
- [ ] Bug fix (non-breaking change fixing an issue)
- [ ] New feature (non-breaking change adding functionality)
- [ ] Breaking change (fix or feature causing existing functionality to change)
- [ ] Documentation update

## How Has This Been Tested?
Describe tests you ran to verify changes.

## Checklist
- [ ] My code follows the project's style guidelines
- [ ] I have performed a self-review of my code
- [ ] I have commented my code where necessary
- [ ] I have updated the documentation accordingly
- [ ] My changes generate no new warnings
- [ ] I have added tests that prove my fix/feature works
- [ ] New and existing tests pass locally
```

---

#### .github/SUPPORT.md

Include:
1. **Documentation** - Link to docs/wiki
2. **Questions** - Where to ask (Discussions, Discord, etc.)
3. **Bug Reports** - Link to issue templates
4. **Feature Requests** - Link to issue templates

---

#### .github/FUNDING.yml

```yaml
# Uncomment and fill in applicable platforms:
# github: [username]
# patreon: username
# open_collective: project-name
# ko_fi: username
# custom: ['https://example.com/donate']
```

---

#### .github/CODEOWNERS

```
# Default owners for everything
* @owner-username

# Examples:
# /docs/ @docs-team
# *.js @js-team
```

---

### Step 5: Create Files

1. Create `.github/` directory if needed
2. Create `.github/ISSUE_TEMPLATE/` directory if needed
3. Write each selected file with customized content
4. Use relative paths only - no absolute paths

### Step 6: Summary

After creating files, provide:
1. List of files created
2. Files that need manual customization (marked with TODO)
3. Reminder to review and customize before committing
4. Link to GitHub's community health documentation

## Notes

- Always use relative paths - never absolute paths with system information
- Customize templates with actual project name, URLs, and contact info
- Use project's existing conventions where applicable
- Mark placeholder values clearly with `[PLACEHOLDER]` format
- Don't overwrite existing files without asking
