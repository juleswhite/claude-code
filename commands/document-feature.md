# Documentation Generator Command

Generate comprehensive documentation for feature: $ARGUMENTS

## Documentation Strategy
Create dual-layer documentation based on $ARGUMENTS analysis:

1. **Developer Documentation**:
   - Technical specifications and architecture
   - API endpoints and data models
   - Implementation details and code examples
   - Configuration and environment setup
   - Testing strategies and debugging notes

2. **User Documentation**:
   - Step-by-step user guides
   - Visual walkthrough with screenshot placeholders
   - Common use cases and scenarios
   - Troubleshooting and FAQ sections
   - Quick reference guides

3. **Feature Detection**:
   - Analyze codebase to determine feature type (frontend/backend/full-stack)
   - Identify related components, services, and dependencies
   - Map feature integration points and data flow
   - Detect existing documentation patterns to follow

## File Analysis Process
1. **Code Discovery**: Search for files related to $ARGUMENTS in:
   - `/src/components/` (React/Vue components)
   - `/src/pages/` (Route handlers/pages)
   - `/src/api/` or `/routes/` (API endpoints)
   - `/src/services/` (Business logic)
   - `/src/utils/` (Helper functions)
   - `/src/hooks/` (Custom hooks)
   - `/src/types/` (TypeScript definitions)

2. **Documentation Structure Detection**:
   - Scan existing `/docs/` structure
   - Identify naming conventions and organization patterns
   - Check for existing cross-references and linking patterns

## Developer Documentation Template
Create in `/docs/dev/{feature-name}-implementation.md`:

```markdown
# {Feature Name} - Technical Implementation

## Overview
Brief technical description of the feature and its purpose.

## Architecture
- **Type**: [Frontend/Backend/Full-Stack]
- **Primary Components**: List of main files and their roles
- **Dependencies**: External libraries and internal modules used
- **Data Flow**: How data moves through the system

## API Specifications
### Endpoints
- `METHOD /api/endpoint` - Description
  - **Request**: Request format and parameters
  - **Response**: Response structure and status codes
  - **Authentication**: Required permissions/roles

### Data Models
```typescript
interface FeatureModel {
  // Type definitions
}
```

## Implementation Details
### Key Components
- **Component Name** (`path/to/file.ts`): Purpose and functionality
- **Service Layer** (`path/to/service.ts`): Business logic implementation
- **Database Layer** (`path/to/model.ts`): Data persistence details

### Configuration
Environment variables and configuration options required.

### Security Considerations
Authentication, authorization, and data validation requirements.

## Testing
- **Unit Tests**: `tests/unit/{feature}.test.ts`
- **Integration Tests**: `tests/integration/{feature}.test.ts`
- **API Tests**: `tests/api/{feature}.test.ts`

## Debugging Guide
Common issues and debugging strategies for developers.

## Related Documentation
- [Link to user documentation](../user/how-to-{feature}.md)
- [Related feature documentation](./related-feature.md)
```

## User Documentation Template
Create in `/docs/user/how-to-{feature-name}.md`:

```markdown
# How to Use {Feature Name}

## Overview
Simple explanation of what this feature does and why users would want to use it.

## Quick Start
1. **Step 1**: Basic action description
   ![Screenshot placeholder: Initial state]
   
2. **Step 2**: Next action with visual guide
   ![Screenshot placeholder: Action in progress]
   
3. **Step 3**: Final result
   ![Screenshot placeholder: Completed state]

## Detailed Guide

### Getting Started
Prerequisites and initial setup instructions.

### Step-by-Step Instructions

#### Task 1: {Primary Use Case}
1. Navigate to [specific location]
   ![Screenshot placeholder: Navigation step]
   
2. Click [specific button/element]
   ![Screenshot placeholder: Button/element highlighted]
   
3. Fill in the required information:
   - **Field 1**: What to enter and why
   - **Field 2**: Expected format or options
   ![Screenshot placeholder: Form completion]
   
4. Confirm your action
   ![Screenshot placeholder: Confirmation dialog]

#### Task 2: {Secondary Use Case}
[Additional scenarios and use cases]

## Common Scenarios

### Scenario 1: {Common Use Case}
When you want to [goal], follow these steps:
1. [Step with visual cue]
2. [Step with expected outcome]

### Scenario 2: {Edge Case Handling}
If you encounter [situation], here's how to handle it:
1. [Troubleshooting step]
2. [Alternative approach]

## Troubleshooting

### Problem: {Common Issue}
**Symptoms**: What the user sees
**Solution**: Step-by-step fix
**Prevention**: How to avoid in future

### Problem: {Another Issue}
**Symptoms**: Error messages or behavior
**Solution**: Resolution steps
**When to contact support**: Escalation criteria

## FAQ

**Q: {Common Question}**
A: Clear, concise answer with links to relevant sections.

**Q: {Technical Question}**
A: User-friendly explanation avoiding technical jargon.

## Quick Reference
- **Keyboard Shortcuts**: List of useful shortcuts
- **Important Links**: Quick access to key features
- **Related Features**: Links to complementary functionality

## Need Help?
- [Developer Documentation](../dev/{feature-name}-implementation.md) (for technical details)
- [Support Contact Information]
- [Community Forums/Resources]
```

## Cross-Reference Generation
Automatically create bidirectional links between:
- Developer docs ↔ User docs
- Feature docs ↔ Related feature docs
- API docs ↔ Implementation examples
- Troubleshooting guides ↔ Technical solutions

## Screenshot Automation Strategy
For user documentation:
1. **Placeholder Format**: `![Screenshot placeholder: {descriptive-action}]`
2. **Naming Convention**: `screenshots/{feature-name}/{step-number}-{action-description}.png`
3. **Auto-capture Instructions**: Include comments for future screenshot automation
4. **Alternative Text**: Provide descriptive alt text for accessibility

## Documentation Quality Checklist
- [ ] Both dev and user docs created
- [ ] Cross-references properly linked
- [ ] Screenshots placeholders positioned appropriately
- [ ] Code examples are functional and tested
- [ ] API documentation matches actual implementation
- [ ] User instructions tested by non-technical reviewer
- [ ] Troubleshooting section covers common issues
- [ ] Related documentation updated with new feature references

## Output Structure
```
docs/
├── dev/
│   └── {feature-name}-implementation.md
├── user/
│   └── how-to-{feature-name}.md
└── screenshots/
    └── {feature-name}/
        ├── step-1-navigation.png (placeholder)
        ├── step-2-action.png (placeholder)
        └── step-3-result.png (placeholder)
```

## Feature Type Detection Guide
- **Frontend Only**: Components, hooks, UI logic
- **Backend Only**: APIs, services, database models
- **Full-Stack**: Both frontend and backend components with data flow

Adjust documentation depth and technical detail based on detected feature type.
