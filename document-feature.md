# Document Feature Command

Generate comprehensive documentation for a feature - both technical docs for developers and user-friendly guides for end users.

## Arguments
- `$ARGUMENTS` - The feature name to document (e.g., "export-data", "user-authentication", "expense-filtering")

## Instructions

You are a documentation specialist. When this command is invoked, you will generate two types of documentation for the feature specified in `$ARGUMENTS`.

### Step 1: Feature Analysis

First, analyze the codebase to understand the feature:

1. **Search for relevant files** using the feature name and related keywords:
   - Search in `src/components/` for UI components
   - Search in `src/lib/` for utilities and services
   - Search in `src/hooks/` for custom hooks
   - Search in `src/app/` for pages and API routes

2. **Determine feature type** based on what you find:
   - **Frontend-only**: Components, hooks, client-side utilities only
   - **Backend-only**: API routes, server actions, database operations only
   - **Full-stack**: Both frontend components AND backend/API logic

3. **Identify key elements**:
   - Main components and their props
   - Exported functions and their signatures
   - State management patterns used
   - API endpoints (if any)
   - Data types and interfaces
   - Dependencies on other features
   - Error handling patterns

### Step 2: Generate Developer Documentation

Create a file at `docs/dev/{feature-name}-implementation.md` with this structure:

```markdown
# {Feature Name} - Technical Documentation

> **Feature Type:** {Frontend | Backend | Full-stack}
> **Last Updated:** {current date}
> **Related User Guide:** [How to {Feature Action}](../user/how-to-{feature-name}.md)

## Overview

{Brief technical description of what this feature does and why it exists}

## Architecture

### Component Structure
{For frontend features - component hierarchy diagram using ASCII or markdown}

### Data Flow
{Describe how data moves through the feature}

```
{ASCII diagram showing data flow}
```

## File Reference

| File | Type | Purpose |
|------|------|---------|
| `path/to/file.tsx` | Component | {description} |
| ... | ... | ... |

## API Reference

### Components

#### `{ComponentName}`

**Props:**
| Prop | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| ... | ... | ... | ... | ... |

**Usage:**
```tsx
{code example}
```

### Functions

#### `{functionName}()`

**Signature:**
```typescript
{function signature}
```

**Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| ... | ... | ... |

**Returns:** `{return type}` - {description}

**Example:**
```typescript
{usage example}
```

### Types

```typescript
{relevant type definitions}
```

## State Management

{Describe state patterns used - useState, useContext, localStorage, etc.}

## Error Handling

{Document error scenarios and how they're handled}

| Error Scenario | Handling | User Feedback |
|----------------|----------|---------------|
| ... | ... | ... |

## Dependencies

### Internal Dependencies
- `{module}` - {why it's needed}

### External Dependencies
- `{package}` - {why it's needed}

## Testing

### Unit Tests
{Location and description of unit tests}

### Integration Tests
{Location and description of integration tests}

### Manual Testing Checklist
- [ ] {test case 1}
- [ ] {test case 2}

## Performance Considerations

{Any performance notes, optimizations, or concerns}

## Security Considerations

{Security-relevant information}

## Future Improvements

{Potential enhancements or known limitations}

## Changelog

| Date | Change | Author |
|------|--------|--------|
| {date} | Initial implementation | - |
```

### Step 3: Generate User Documentation

Create a file at `docs/user/how-to-{feature-name}.md` with this structure:

```markdown
# How to {Feature Action}

> **Difficulty:** {Beginner | Intermediate | Advanced}
> **Time Required:** {estimated time}
> **Prerequisites:** {any required setup or knowledge}

## What You'll Learn

{Brief description of what the user will accomplish}

## Overview

{Simple explanation of what this feature does and why it's useful, written for non-technical users}

## Before You Begin

{Any prerequisites, like being logged in, having data, etc.}

- {prerequisite 1}
- {prerequisite 2}

## Step-by-Step Guide

### Step 1: {Action Title}

{Clear instruction for what to do}

![{Alt text describing the screenshot}](./images/{feature-name}-step-1.png)
<!-- Screenshot placeholder: Capture the {specific UI element} showing {what state} -->

{Additional explanation if needed}

### Step 2: {Action Title}

{Clear instruction}

![{Alt text}](./images/{feature-name}-step-2.png)
<!-- Screenshot placeholder: Capture {description} -->

{Continue for all steps...}

## Options and Settings

{If the feature has configurable options}

### {Option Name}

| Setting | Description | Default |
|---------|-------------|---------|
| ... | ... | ... |

## Tips and Best Practices

- **Tip:** {helpful tip}
- **Best Practice:** {recommendation}

## Common Issues

### {Issue Title}

**Problem:** {description of the issue}

**Solution:** {how to fix it}

### {Another Issue}

**Problem:** {description}

**Solution:** {fix}

## Frequently Asked Questions

**Q: {Common question}?**

A: {Answer}

**Q: {Another question}?**

A: {Answer}

## Related Guides

- [{Related feature guide}](./how-to-{related-feature}.md)
- [{Another related guide}](./how-to-{another-feature}.md)

## Need Help?

If you're still having trouble, try:
1. Refreshing the page
2. Clearing your browser cache
3. {Other troubleshooting steps}

---

*For technical details, see the [Developer Documentation](../dev/{feature-name}-implementation.md)*
```

### Step 4: Screenshot Capture Instructions

After generating the documentation, provide a list of screenshots needed:

```
## Screenshots Needed

To complete the user documentation, capture the following screenshots:

1. **{feature-name}-step-1.png**
   - Location: {where in the app}
   - Show: {what should be visible}
   - State: {any specific state needed}

2. **{feature-name}-step-2.png**
   - Location: {where}
   - Show: {what}
   - State: {state}

{Continue for all screenshots...}

Save screenshots to: `docs/user/images/`
Recommended size: 800px width, PNG format
```

### Step 5: Auto-link Related Documentation

Search for existing documentation that should be cross-referenced:
1. Check `docs/dev/` for related technical docs
2. Check `docs/user/` for related user guides
3. Add appropriate links in both new documents

### Step 6: Update Documentation Index

If a `docs/README.md` or `docs/index.md` exists, add entries for the new documentation.

## Output

After completion, summarize:

1. **Files Created:**
   - Developer doc path and brief description
   - User doc path and brief description

2. **Feature Classification:**
   - Type (Frontend/Backend/Full-stack)
   - Complexity level
   - Files analyzed

3. **Cross-references Added:**
   - Links to related existing docs
   - Links added to existing docs pointing to new docs

4. **Action Items:**
   - Screenshots needed (with specific instructions)
   - Any manual review needed
   - Suggested improvements to the feature itself (if found during analysis)

## Notes

- Use clear, jargon-free language in user documentation
- Include code examples in developer documentation
- Always add the cross-reference link between dev and user docs
- If the feature doesn't exist or can't be found, report this and suggest similar features
- For complex features, consider breaking into multiple user guides
