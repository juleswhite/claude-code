# Document Feature Command

Generate comprehensive documentation for a new feature, creating both developer and user-facing guides.

## Usage
```bash
claude document-feature [feature-name] [options]
```

## Options
- `--type`: Specify feature type (frontend|backend|fullstack) - auto-detected if not provided
- `--user-role`: Target user role for user docs (admin|user|developer) - defaults to 'user'
- `--include-api`: Include API documentation (default: true for backend/fullstack)
- `--screenshot-mode`: How to handle screenshots (placeholder|capture|skip) - defaults to 'placeholder'

## Command Implementation

You are an expert technical writer and documentation specialist. Your task is to analyze a feature implementation and generate comprehensive, dual-purpose documentation.

### Step 1: Feature Analysis
First, analyze the codebase to understand the feature:

1. **Identify feature scope and type:**
   - Search for files related to `{{feature-name}}`
   - Determine if it's frontend, backend, or full-stack
   - Identify key components, APIs, database changes, and UI elements
   - Find related configuration files, tests, and dependencies

2. **Analyze existing documentation patterns:**
   - Check `docs/` directory structure and naming conventions
   - Review existing documentation files for style and format
   - Identify common sections and templates used in the project

3. **Map user interactions:**
   - Identify user-facing features and workflows
   - Determine required user permissions or roles
   - Map the complete user journey for this feature

### Step 2: Generate Developer Documentation

Create `docs/dev/{{feature-name}}-implementation.md` with:

```markdown
# {{Feature Name}} - Developer Documentation

## Overview
Brief technical overview of what this feature does and why it was implemented.

## Architecture
- **Type**: [Frontend/Backend/Full-stack]
- **Components**: List key components/modules
- **Dependencies**: New dependencies added
- **Database Changes**: Schema modifications if any

## Implementation Details

### Backend Implementation
[If applicable]
- API endpoints and methods
- Database models and relationships
- Business logic and services
- Authentication/authorization requirements

### Frontend Implementation  
[If applicable]
- Components and their hierarchy
- State management approach
- Routing changes
- UI/UX considerations

### Configuration
- Environment variables
- Feature flags
- Configuration files modified

## API Reference
[If applicable]
### Endpoints
- `GET /api/{{feature-name}}` - Description
- `POST /api/{{feature-name}}` - Description
[Include request/response examples]

## Testing
- Unit tests: `{{test-file-paths}}`
- Integration tests: `{{test-file-paths}}`
- E2E tests: `{{test-file-paths}}`

## Security Considerations
- Authentication requirements
- Authorization levels
- Data validation
- Potential security implications

## Performance Impact
- Database query impact
- Caching considerations
- Resource usage

## Deployment Notes
- Migration requirements
- Environment-specific configurations
- Rollback procedures

## Related Documentation
- [User Guide](../user/{{feature-name}}-guide.md)
- [API Documentation](./api-reference.md)
- [Related Feature Docs]

## Troubleshooting
Common issues and their solutions.

---
*Generated on {{current-date}} | Last updated: {{current-date}}*
```

### Step 3: Generate User Documentation

Create `docs/user/{{feature-name}}-guide.md` with:

```markdown
# How to Use {{Feature Name}}

## What is {{Feature Name}}?
Simple explanation of what the feature does and why users would want to use it.

## Who Can Use This Feature?
- User roles that have access
- Required permissions

## Getting Started

### Prerequisites
What users need before they can use this feature.

### Quick Start
1. **Access the feature**
   ![Screenshot: Navigation to feature](screenshots/{{feature-name}}-navigation.png)
   
2. **Basic setup** (if required)
   ![Screenshot: Initial setup](screenshots/{{feature-name}}-setup.png)

## Step-by-Step Guide

### Task 1: [Primary Use Case]
1. **Step 1 description**
   ![Screenshot: Step 1](screenshots/{{feature-name}}-step1.png)
   
2. **Step 2 description**
   ![Screenshot: Step 2](screenshots/{{feature-name}}-step2.png)

### Task 2: [Secondary Use Case]
[Similar structure]

## Tips and Best Practices
- Helpful tips for effective use
- Common workflows
- Time-saving shortcuts

## Troubleshooting

### Common Issues
**Problem**: Issue description
**Solution**: How to fix it

**Problem**: Another issue
**Solution**: How to fix it

### Getting Help
- Where to find additional support
- How to report bugs or request features

## Related Features
- Links to related user guides
- Features that work well together

---
*Need help? Contact [support link] | [Developer docs](../dev/{{feature-name}}-implementation.md)*
```

### Step 4: Screenshot Management

Based on `--screenshot-mode`:

**Placeholder mode (default):**
- Create placeholder references with descriptive names
- Generate a `docs/screenshots/{{feature-name}}/README.md` file listing all required screenshots

**Capture mode (bonus):**
- Use automated screenshot capture tools
- Generate actual screenshot files in `docs/screenshots/{{feature-name}}/`

**Skip mode:**
- Remove all screenshot references from user documentation

### Step 5: Cross-Reference Generation

1. **Update main documentation index:**
   - Add entries to `docs/README.md` or main index
   - Update feature matrix or capability table

2. **Create cross-references:**
   - Link user docs to developer docs and vice versa
   - Update related feature documentation with references
   - Add to search index if one exists

3. **Generate navigation updates:**
   - Update documentation sidebars/menus
   - Add breadcrumb navigation

### Step 6: Quality Assurance

1. **Validate documentation:**
   - Check for broken internal links
   - Verify code examples compile/run
   - Ensure consistent formatting and style

2. **Generate documentation manifest:**
   ```json
   {
     "feature": "{{feature-name}}",
     "type": "{{detected-type}}",
     "generated": "{{timestamp}}",
     "files": [
       "docs/dev/{{feature-name}}-implementation.md",
       "docs/user/{{feature-name}}-guide.md"
     ],
     "screenshots": ["list-of-screenshot-files"],
     "cross_references": ["list-of-updated-files"]
   }
   ```

## Output Format

After generation, provide a summary:

```
✅ Documentation generated for: {{feature-name}}

📋 Files created:
• docs/dev/{{feature-name}}-implementation.md ({{word-count}} words)
• docs/user/{{feature-name}}-guide.md ({{word-count}} words)

📸 Screenshots needed:
• {{count}} placeholder screenshots created
• See docs/screenshots/{{feature-name}}/README.md for details

🔗 Cross-references updated:
• {{count}} related documents updated
• Navigation menus updated

⚡ Next steps:
1. Review and edit the generated documentation
2. Capture required screenshots
3. Test all links and code examples
4. Publish to documentation site
```

## Advanced Features

### Feature Type Detection
Analyze the codebase to determine feature type:
- **Frontend**: Look for component files, stylesheets, client-side routing
- **Backend**: Look for API routes, database models, server-side logic  
- **Full-stack**: Combination of both

### Related Documentation Discovery
- Scan existing docs for related features
- Identify integration points
- Suggest additional cross-references

### Template Customization
- Detect project-specific documentation templates
- Adapt generated docs to match existing style
- Include project-specific sections (e.g., accessibility notes, localization)

### Continuous Integration
- Generate docs that can be validated in CI/CD
- Include metadata for automated testing
- Create documentation diff reports for reviews