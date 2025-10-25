# Document Feature Command

Generate comprehensive documentation for: $ARGUMENTS

## Documentation Strategy

Analyze the feature and create two types of documentation:
1. **Developer Documentation** - Technical implementation details
2. **User Documentation** - Simple, accessible guides for end users

## Analysis Phase

Before generating documentation, analyze:

1. **Feature Scope Detection**:
   - Is this frontend-only, backend-only, or full-stack?
   - What files/components are involved?
   - What external dependencies or APIs are used?

2. **Code Analysis**:
   - Examine all relevant source files
   - Identify key functions, components, or endpoints
   - Document data flows and state management
   - Note any security or performance considerations

3. **User Journey Mapping**:
   - What problem does this solve for users?
   - What are the step-by-step interactions?
   - What are common pain points or edge cases?

## Developer Documentation Structure

Create file: `docs/dev/{feature-name}-implementation.md`

### Required Sections:

```markdown
# {Feature Name} - Developer Documentation

## Overview
Brief description of what this feature does and why it exists.

## Architecture

### Component Overview
- List all files/components involved
- Describe relationships between components
- Include architecture diagram (if complex)

### Technology Stack
- Frontend technologies used (if applicable)
- Backend technologies used (if applicable)
- External services or APIs
- Key libraries or dependencies

### Data Flow
1. Describe how data moves through the system
2. Include state management details
3. Document API contracts (if applicable)

## Implementation Details

### Frontend Implementation (if applicable)
- Component structure
- State management approach
- Key React hooks or lifecycle methods
- Styling approach

### Backend Implementation (if applicable)
- API endpoints
- Request/response formats
- Database schema changes
- Business logic details

### Full-Stack Integration (if both)
- How frontend and backend communicate
- Authentication/authorization flow
- Error handling strategy

## API Reference (if applicable)

### Endpoints
For each endpoint:
- Method and URL
- Request parameters
- Request body schema
- Response schema
- Error codes and meanings
- Example requests/responses

### Functions/Methods
For key functions:
- Function signature
- Parameters and types
- Return values
- Side effects
- Example usage

## Security Considerations
- Authentication requirements
- Authorization checks
- Input validation
- Data sanitization
- Privacy implications

## Performance Considerations
- Expected load/usage patterns
- Performance benchmarks
- Optimization opportunities
- Scalability concerns

## Testing
- Unit test coverage
- Integration test scenarios
- E2E test coverage
- Manual testing checklist

## Configuration
- Environment variables needed
- Feature flags
- Configuration options

## Dependencies
- Required packages/libraries
- Version constraints
- Breaking changes to watch for

## Deployment Notes
- Database migrations needed
- Feature flag rollout strategy
- Monitoring/observability setup
- Rollback procedure

## Known Issues & Limitations
- Current limitations
- Known bugs
- Future improvements planned

## Related Documentation
- Link to user documentation
- Link to related features
- Link to design docs (if any)

## Changelog
- Version history
- Notable changes

## Maintainer Notes
- Who to contact for questions
- Code review checklist
- Common gotchas

---
*Generated: {DATE}*
*Last Updated: {DATE}*
```

## User Documentation Structure

Create file: `docs/user/how-to-{feature-name}.md`

### Required Sections:

```markdown
# How to {Feature Action}

## What This Feature Does
A simple, jargon-free explanation of what the feature is and why users would want to use it.

**Quick Answer:** One sentence describing the main benefit.

## When to Use This
- Scenario 1: When you need to...
- Scenario 2: If you want to...
- Scenario 3: To help with...

## Prerequisites
What users need before they can use this feature:
- [ ] Requirement 1
- [ ] Requirement 2
- [ ] Requirement 3

## Step-by-Step Guide

### Step 1: {First Action}
Clear instructions for the first step.

📷 **Screenshot Placeholder:** `screenshots/{feature-name}-step-1.png`
*Show: {Description of what the screenshot should capture}*

**What you'll see:**
- Describe what users should expect

**Tips:**
- Helpful hint 1
- Helpful hint 2

---

### Step 2: {Second Action}
Clear instructions for the second step.

📷 **Screenshot Placeholder:** `screenshots/{feature-name}-step-2.png`
*Show: {Description of what the screenshot should capture}*

**What you'll see:**
- Describe what users should expect

---

### Step 3: {Third Action}
Continue for all necessary steps...

📷 **Screenshot Placeholder:** `screenshots/{feature-name}-step-3.png`

---

## Verification
How users can confirm the feature worked:
1. Check that...
2. Verify that...
3. You should see...

## Common Questions

### Q: {Common question 1}?
**A:** Clear, helpful answer.

### Q: {Common question 2}?
**A:** Clear, helpful answer.

### Q: {Common question 3}?
**A:** Clear, helpful answer.

## Troubleshooting

### Problem: {Common Issue 1}
**Symptoms:** What the user experiences
**Solution:** How to fix it
**Prevention:** How to avoid it in the future

### Problem: {Common Issue 2}
**Symptoms:** What the user experiences
**Solution:** How to fix it
**Prevention:** How to avoid it in the future

## Tips & Best Practices
- 💡 Tip 1: ...
- 💡 Tip 2: ...
- 💡 Tip 3: ...

## Privacy & Security Notes
- What data is used/stored
- Who can access this feature
- Privacy controls available
- Security best practices

## Related Features
- [Link to Related Feature 1](./related-feature-1.md)
- [Link to Related Feature 2](./related-feature-2.md)

## Need More Help?
- 📖 [Developer Documentation](../dev/{feature-name}-implementation.md) - For technical details
- 💬 [Contact Support](#) - If you're still stuck
- 🐛 [Report a Bug](#) - If something isn't working

---
*Last Updated: {DATE}*
*Feedback? Let us know!*
```

## Cross-Reference Requirements

Ensure both documents link to each other:
- Developer docs should link to user docs (to understand user perspective)
- User docs should link to developer docs (for advanced users who want details)

## Screenshot Guidelines

For user documentation screenshots:
1. Use consistent browser/window size
2. Highlight important UI elements with colored boxes/arrows
3. Keep screenshots up-to-date with UI changes
4. Name files descriptively: `{feature-name}-{step-number}-{description}.png`
5. Store in: `docs/user/screenshots/`

## Documentation Quality Checklist

Before finalizing, verify:
- [ ] All code examples are tested and working
- [ ] All links are valid
- [ ] Screenshot placeholders clearly describe what's needed
- [ ] Technical jargon is explained in user docs
- [ ] Security implications are documented
- [ ] Both docs cross-reference each other
- [ ] Code is analyzed from actual implementation files
- [ ] User workflow is logical and complete
- [ ] Troubleshooting covers common issues
- [ ] Related features are linked

## Feature Type Detection

Based on code analysis, automatically determine and adjust documentation:

**Frontend-Only Features:**
- Focus on component usage and UI interactions
- Include state management details
- Emphasize user experience and accessibility
- Screenshot every UI state

**Backend-Only Features:**
- Focus on API endpoints and data models
- Include request/response examples
- Document authentication/authorization
- Provide curl/Postman examples

**Full-Stack Features:**
- Document both frontend and backend separately
- Show the integration points
- Include end-to-end flow diagrams
- Document data contracts clearly

## Bonus Enhancements

### Auto-Detection Logic
Scan for these patterns to determine feature type:
- `.tsx`, `.jsx`, `components/` → Frontend
- `api/`, `server/`, `.route.ts` → Backend  
- Both of the above → Full-stack

### Related Documentation Auto-Linking
Search existing docs for:
- Features that share components
- Related API endpoints
- Common user workflows
- Related troubleshooting sections

### Documentation Quality Metrics
After generation, report:
- Number of screenshot placeholders created
- Number of cross-references added
- Code coverage (% of relevant files documented)
- Completeness score (% of required sections filled)

## Example Output

For input: `password-reset`

Should generate:
1. `docs/dev/password-reset-implementation.md` - Complete technical documentation
2. `docs/user/how-to-reset-password.md` - Simple user guide with screenshot placeholders

Both files should:
- Cross-reference each other
- Follow the project's existing doc patterns
- Include all required sections
- Be immediately useful and maintainable

---

## Notes for Claude Code

When executing this command:
1. First analyze the codebase to find relevant files
2. Determine feature type (frontend/backend/full-stack)
3. Extract key technical details from actual code
4. Map out the user journey through the feature
5. Generate both documentation files simultaneously
6. Ensure cross-references are accurate
7. Create screenshot placeholders with clear descriptions
8. Provide a summary of what was documented

**Remember:** Good documentation is:
- ✅ Accurate (based on actual code)
- ✅ Complete (covers all use cases)
- ✅ Clear (no unexplained jargon)
- ✅ Current (reflects latest implementation)
- ✅ Helpful (answers real questions)
- ✅ Respectful (of user's time and intelligence)
