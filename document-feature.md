# Document Feature Command

Generate comprehensive documentation for a new feature: $ARGUMENTS

## Overview
This command creates both technical developer documentation and user-friendly guides for the specified feature. It automatically detects the feature type (frontend/backend/full-stack) and adapts documentation accordingly.

## Process

### Phase 1: Discovery & Analysis

1. **Locate Feature Files**
   - Search codebase for files related to "$ARGUMENTS"
   - Use glob patterns: `**/*$ARGUMENTS*`, `**/*{kebab-case}*`, `**/*{camelCase}*`
   - Check common locations: `src/`, `api/`, `components/`, `services/`, `routes/`

2. **Classify Feature Type**
   - **Frontend**: Contains React/Vue components, UI elements, styling
   - **Backend**: Contains API routes, controllers, database models, services
   - **Full-stack**: Contains both frontend and backend elements
   - Document the classification for context

3. **Analyze Existing Documentation Patterns**
   - Read 2-3 existing files from `docs/dev/` to understand:
     - Structure and formatting conventions
     - Section organization
     - Code example patterns
     - Cross-reference style
   - Read 2-3 existing files from `docs/user/` to understand:
     - Tone and language level
     - Step-by-step instruction format
     - Screenshot placement and captioning
     - Troubleshooting patterns

### Phase 2: Generate Developer Documentation

Create file: `docs/dev/{feature-name}-implementation.md`

**Required Sections:**

```markdown
# {Feature Name} - Technical Implementation

## Overview
[Brief technical description of what the feature does and why it was built]

## Architecture
[High-level architecture diagram or description]

## Component Structure (if Frontend)
- Component hierarchy
- Key props and state
- Event handlers and callbacks
- Styling approach

## API Endpoints (if Backend)
### POST /api/{endpoint}
- **Purpose**: [Description]
- **Request Body**:
  ```json
  {
    "field": "value"
  }
  ```
- **Response**:
  ```json
  {
    "result": "data"
  }
  ```
- **Authentication**: [Requirements]
- **Authorization**: [Permissions needed]

## Data Models (if Backend)
[Database schema, relationships, indexes]

## Implementation Details
- Key algorithms or business logic
- Third-party integrations
- Configuration requirements
- Environment variables needed

## Code Examples
[Actual code snippets from implementation showing key patterns]

## Testing
- Unit test coverage
- Integration test approach
- E2E test scenarios
- How to run tests: `npm test {feature-tests}`

## Security Considerations
[Authentication, authorization, data validation, etc.]

## Performance Considerations
[Caching, optimization, scalability notes]

## Related Documentation
- User Guide: [Link to user documentation]
- Related Features: [Links to related dev docs]
- API Reference: [If applicable]

## Troubleshooting
Common developer issues and solutions

---
*Last Updated: {current-date}*
*Feature Type: {Frontend/Backend/Full-stack}*
```

### Phase 3: Generate User Documentation

Create file: `docs/user/how-to-{feature-name}.md`

**Required Sections:**

```markdown
# How to Use {Feature Name}

## What is {Feature Name}?
[Simple, jargon-free explanation of what the feature does and why users would want to use it]

## Before You Begin
- Prerequisites or requirements
- Permissions needed
- Any setup required

## Step-by-Step Guide

### Step 1: {First Action}
[Clear instruction in simple language]

**Screenshot Placeholder:**
![{Descriptive alt text}](screenshots/{feature-name}-step-1.png)
*Caption: {What the user should see at this step}*

### Step 2: {Second Action}
[Clear instruction]

**Screenshot Placeholder:**
![{Descriptive alt text}](screenshots/{feature-name}-step-2.png)
*Caption: {What the user should see at this step}*

[Continue for all major steps...]

## Tips and Best Practices
- Helpful hints for using the feature effectively
- Common workflows
- Time-saving shortcuts

## Frequently Asked Questions

### Q: {Common question}?
A: {Clear answer}

### Q: {Another common question}?
A: {Clear answer}

## Troubleshooting

### Issue: {Common problem}
**Solution:** {How to fix it}

### Issue: {Another problem}
**Solution:** {How to fix it}

## Related Features
- [{Related Feature 1}](link-to-related-feature.md)
- [{Related Feature 2}](link-to-related-feature.md)

## Need More Help?
- Technical Details: See [developer documentation](../dev/{feature-name}-implementation.md)
- Contact Support: [Support information]

---
*Last Updated: {current-date}*
```

### Phase 4: Cross-Reference Integration

1. **Add links from dev docs to user docs**
   - In the "Related Documentation" section
   
2. **Add links from user docs to dev docs**
   - In the "Need More Help?" section
   
3. **Update any index or table of contents files**
   - `docs/dev/README.md` or `docs/dev/index.md`
   - `docs/user/README.md` or `docs/user/index.md`

### Phase 5: Screenshot Integration (Bonus)

**If Claude in Chrome is available:**

1. **For Frontend Features:**
   - Launch the application in Chrome
   - Navigate to the feature
   - Capture screenshots for each major step
   - Save to `docs/user/screenshots/{feature-name}-step-{n}.png`
   - Update markdown to reference actual screenshot files

2. **Screenshot Quality Guidelines:**
   - Use consistent browser window size (1920x1080 recommended)
   - Highlight relevant UI elements with annotations
   - Crop to show only relevant portions
   - Use descriptive filenames

**If Chrome integration not available:**
- Keep placeholder format with descriptive captions
- Document in output that screenshots need manual capture

## Adaptive Documentation Rules

### For Frontend Features:
- Emphasize component structure and UI patterns
- Include more screenshots in user docs
- Detail state management approach
- Document styling conventions used

### For Backend Features:
- Focus on API contracts and data models
- Include request/response examples
- Detail authentication/authorization
- User docs may be lighter or focus on API consumers

### For Full-Stack Features:
- Document both frontend and backend thoroughly
- Show data flow between layers
- Include end-to-end examples
- Ensure user docs show complete workflows

## Output Requirements

**Summary Report:**
```
✅ Documentation Generated for: {feature-name}

📁 Files Created:
  - docs/dev/{feature-name}-implementation.md
  - docs/user/how-to-{feature-name}.md

📊 Feature Classification: {Frontend/Backend/Full-stack}

📝 Files Analyzed:
  - {list of source files found and analyzed}

📸 Screenshots:
  - {If captured: list of screenshot files}
  - {If not captured: number of placeholders that need manual screenshots}

🔗 Cross-References Added:
  - {list of cross-reference links inserted}

⚠️  Action Items:
  - {Any manual steps needed, like capturing screenshots}
  - {Any additional documentation that might be helpful}
```

## Quality Checklist

Before completing, verify:
- [ ] Both documentation files created successfully
- [ ] Documentation follows existing patterns from examples
- [ ] Feature type correctly identified and documented
- [ ] All required sections present in both docs
- [ ] Cross-references properly linked
- [ ] Code examples are accurate and from actual implementation
- [ ] User documentation is jargon-free and clear
- [ ] Screenshot placeholders have descriptive captions
- [ ] File naming follows project conventions
- [ ] Index/TOC files updated if they exist

## Error Handling

**If no files found for feature:**
- Search with more flexible patterns
- Ask user to specify file locations
- Suggest checking feature name spelling

**If existing docs directory structure missing:**
- Create `docs/dev/` and `docs/user/` directories
- Note this in output summary

**If unable to determine feature type:**
- Default to full-stack documentation
- Note uncertainty in output
- Ask user to clarify and regenerate if needed

## Examples of Excellent Documentation

**Developer Docs Reference:**
- Look for existing files in `docs/dev/` or `technical/`
- Match their tone, structure, and level of detail

**User Docs Reference:**
- Look for existing files in `docs/user/`, `guides/`, or `help/`
- Match their accessibility and instruction style

## Notes

- Use current date for "Last Updated" timestamps
- Convert feature names to appropriate case for filenames (kebab-case)
- Preserve any existing documentation structure conventions
- If unsure about specific project patterns, ask for clarification
- Documentation should be complete enough to onboard new team members
