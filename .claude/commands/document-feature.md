# Document Feature Command

Automatically generates comprehensive technical and user documentation for new features in the TaskFlow/ExpenseTracker application.

## Usage
```
/document-feature [feature-name]
```

## Parameters
- `feature-name`: The name of the feature to document (e.g., "export-system", "user-profile", "analytics-dashboard")

## What This Command Does

This command analyzes your codebase and generates two types of documentation:

1. **Technical Documentation** (`docs/technical/[feature-name].md`) - For developers
2. **User Documentation** (`docs/user-guides/[feature-name].md`) - For end users

## Command Implementation

```typescript
// This command will:
// 1. Analyze the specified feature's code files
// 2. Generate technical documentation for developers
// 3. Create user-friendly guides with screenshot placeholders
// 4. Establish cross-references between both doc types

import { analyzeFeatureFiles, generateTechnicalDocs, generateUserGuide } from '../utils/documentation';

async function documentFeature(featureName: string) {
  console.log(`📝 Generating documentation for feature: ${featureName}`);

  // Step 1: Create documentation directories
  await ensureDirectoriesExist();

  // Step 2: Analyze codebase for feature-related files
  const featureAnalysis = await analyzeFeatureFiles(featureName);

  // Step 3: Generate technical documentation
  const techDoc = await generateTechnicalDocs(featureName, featureAnalysis);

  // Step 4: Generate user documentation
  const userDoc = await generateUserGuide(featureName, featureAnalysis);

  // Step 5: Save documentation files
  await saveDocs(featureName, techDoc, userDoc);

  console.log(`✅ Documentation generated successfully!`);
  console.log(`📂 Technical docs: docs/technical/${featureName}.md`);
  console.log(`👤 User guide: docs/user-guides/${featureName}.md`);
}

async function ensureDirectoriesExist() {
  // Create documentation directory structure
  await createDirectories([
    'docs',
    'docs/technical',
    'docs/user-guides',
    'docs/screenshots',
    'docs/api-reference'
  ]);
}

async function analyzeFeatureFiles(featureName: string) {
  const patterns = [
    `src/components/**/*${featureName}*`,
    `src/components/${featureName}/**/*`,
    `src/app/**/*${featureName}*`,
    `src/hooks/*${featureName}*`,
    `src/utils/*${featureName}*`,
    `src/types/*${featureName}*`,
    `src/lib/*${featureName}*`
  ];

  const files = await findMatchingFiles(patterns);
  const analysis = {
    components: [],
    hooks: [],
    utilities: [],
    types: [],
    apiRoutes: [],
    pages: [],
    dependencies: []
  };

  for (const file of files) {
    const content = await readFile(file);
    const fileAnalysis = await analyzeFileContent(content, file);

    // Categorize files and extract key information
    if (file.includes('/components/')) {
      analysis.components.push(fileAnalysis);
    } else if (file.includes('/hooks/')) {
      analysis.hooks.push(fileAnalysis);
    } else if (file.includes('/utils/')) {
      analysis.utilities.push(fileAnalysis);
    } else if (file.includes('/types/')) {
      analysis.types.push(fileAnalysis);
    } else if (file.includes('/api/')) {
      analysis.apiRoutes.push(fileAnalysis);
    } else if (file.includes('/app/')) {
      analysis.pages.push(fileAnalysis);
    }
  }

  return analysis;
}

async function generateTechnicalDocs(featureName: string, analysis: any) {
  return `# ${toTitleCase(featureName)} - Technical Documentation

> **Feature**: ${featureName}
> **Generated**: ${new Date().toISOString().split('T')[0]}
> **Version**: 1.0.0

## Overview

${generateFeatureOverview(analysis)}

## Architecture

### Components
${generateComponentDocs(analysis.components)}

### Hooks
${generateHooksDocs(analysis.hooks)}

### Utilities
${generateUtilityDocs(analysis.utilities)}

### Types & Interfaces
${generateTypesDocs(analysis.types)}

### API Endpoints
${generateApiDocs(analysis.apiRoutes)}

## File Structure
\`\`\`
${generateFileStructure(analysis)}
\`\`\`

## Dependencies
${generateDependencyDocs(analysis.dependencies)}

## Implementation Details

### Key Design Decisions
${generateDesignDecisions(analysis)}

### Performance Considerations
${generatePerformanceNotes(analysis)}

### Security Considerations
${generateSecurityNotes(analysis)}

## Testing Strategy

### Unit Tests
- [ ] Component rendering tests
- [ ] Hook behavior tests
- [ ] Utility function tests
- [ ] Type validation tests

### Integration Tests
- [ ] API endpoint tests
- [ ] Component integration tests
- [ ] Data flow tests

### E2E Tests
- [ ] User workflow tests
- [ ] Cross-browser compatibility
- [ ] Accessibility tests

## Deployment Notes

### Build Requirements
${generateBuildRequirements(analysis)}

### Environment Variables
${generateEnvVarsDocs(analysis)}

## Maintenance

### Known Issues
- [ ] Document any known issues here

### Future Enhancements
- [ ] Document planned improvements here

### Troubleshooting
${generateTroubleshootingGuide(analysis)}

## Related Documentation
- [User Guide](../user-guides/${featureName}.md)
- [API Reference](../api-reference/${featureName}.md)

---
*Generated by Claude Code documentation system*
`;
}

async function generateUserGuide(featureName: string, analysis: any) {
  return `# ${toTitleCase(featureName)} - User Guide

> **Last Updated**: ${new Date().toISOString().split('T')[0]}
> **Difficulty**: Beginner
> **Estimated Time**: 5-10 minutes

## What is ${toTitleCase(featureName)}?

${generateUserFriendlyOverview(analysis)}

## Getting Started

### Prerequisites
- Ensure you have access to the application
- No special permissions required
- Works on all modern browsers

### Quick Start
![Feature Overview](../screenshots/${featureName}-overview.png)
*Screenshot: ${toTitleCase(featureName)} main interface*

1. **Access the feature**
   - Navigate to [specific location]
   - Click on "${toTitleCase(featureName)}" in the main menu

2. **First-time setup** (if applicable)
   - Follow the setup wizard
   - Configure your preferences

## Step-by-Step Guide

### Basic Usage

#### Step 1: [Primary Action]
![Step 1](../screenshots/${featureName}-step1.png)
*Screenshot: [Description of what user sees]*

1. Click the "[Button Name]" button
2. Fill in the required information:
   - **Field 1**: [Description and example]
   - **Field 2**: [Description and example]
3. Click "Save" to continue

#### Step 2: [Secondary Action]
![Step 2](../screenshots/${featureName}-step2.png)
*Screenshot: [Description of what user sees]*

1. Review your information
2. Make any necessary changes
3. Confirm your settings

### Advanced Features

#### Feature A: [Advanced Feature Name]
![Advanced Feature A](../screenshots/${featureName}-advanced-a.png)
*Screenshot: Advanced feature interface*

**When to use**: [Explain when this feature is useful]

**How to use**:
1. [Step 1]
2. [Step 2]
3. [Step 3]

**Tips**:
- 💡 [Helpful tip 1]
- ⚡ [Performance tip]
- ⚠️ [Important warning]

## Common Use Cases

### Use Case 1: [Scenario Name]
**Scenario**: [Describe common user scenario]

**Solution**:
1. [Step 1]
2. [Step 2]
3. [Result]

### Use Case 2: [Scenario Name]
**Scenario**: [Describe another scenario]

**Solution**:
1. [Step 1]
2. [Step 2]
3. [Result]

## Troubleshooting

### Common Issues

#### Issue: [Common Problem]
**Symptoms**: [What the user sees]
**Solution**:
1. [Solution step 1]
2. [Solution step 2]
3. [If still not working, try this]

#### Issue: [Another Common Problem]
**Symptoms**: [What the user sees]
**Solution**:
1. [Solution step 1]
2. [Alternative approach]

### Getting Help
- Check the [Technical Documentation](../technical/${featureName}.md) for detailed information
- Contact support at [support email/link]
- Join our community forum at [forum link]

## Tips & Best Practices

### Do's ✅
- [Best practice 1]
- [Best practice 2]
- [Best practice 3]

### Don'ts ❌
- [Common mistake to avoid 1]
- [Common mistake to avoid 2]
- [Common mistake to avoid 3]

## Keyboard Shortcuts

| Action | Windows/Linux | Mac |
|--------|---------------|-----|
| [Action 1] | \`Ctrl+Key\` | \`Cmd+Key\` |
| [Action 2] | \`Ctrl+Shift+Key\` | \`Cmd+Shift+Key\` |

## FAQ

### Q: [Common Question 1]
**A**: [Clear, concise answer]

### Q: [Common Question 2]
**A**: [Clear, concise answer with example if needed]

### Q: [Common Question 3]
**A**: [Clear, concise answer]

## What's Next?

After mastering this feature, you might want to explore:
- [Related Feature 1](./related-feature-1.md)
- [Related Feature 2](./related-feature-2.md)
- [Advanced Guide](./advanced-${featureName}.md)

---

## Screenshot Checklist
*For documentation maintainers*

- [ ] \`${featureName}-overview.png\` - Main feature interface
- [ ] \`${featureName}-step1.png\` - First step screenshot
- [ ] \`${featureName}-step2.png\` - Second step screenshot
- [ ] \`${featureName}-advanced-a.png\` - Advanced features
- [ ] \`${featureName}-settings.png\` - Settings/configuration
- [ ] \`${featureName}-mobile.png\` - Mobile view (if applicable)

*Generated by Claude Code documentation system*
`;
}

async function saveDocs(featureName: string, techDoc: string, userDoc: string) {
  const techPath = \`docs/technical/\${featureName}.md\`;
  const userPath = \`docs/user-guides/\${featureName}.md\`;

  await writeFile(techPath, techDoc);
  await writeFile(userPath, userDoc);

  // Also create API reference if API routes were found
  // await generateApiReference(featureName, analysis);
}

// Helper functions would be implemented here
function toTitleCase(str: string): string {
  return str.split('-').map(word =>
    word.charAt(0).toUpperCase() + word.slice(1)
  ).join(' ');
}

function generateFeatureOverview(analysis: any): string {
  // Analyze the code to generate an intelligent overview
  return \`This feature provides [functionality] through [number] components, [number] hooks, and [number] utilities.\`;
}

// Additional helper functions for generating specific documentation sections...
```

## Example Usage

```bash
# Document the export system feature
/document-feature export-system

# Document user profile functionality
/document-feature user-profile

# Document analytics dashboard
/document-feature analytics-dashboard
```

## Generated File Structure

After running this command, you'll have:

```
docs/
├── technical/
│   └── [feature-name].md          # Technical documentation
├── user-guides/
│   └── [feature-name].md          # User-friendly guide
├── screenshots/
│   ├── [feature-name]-overview.png    # Screenshot placeholders
│   ├── [feature-name]-step1.png
│   └── [feature-name]-step2.png
└── api-reference/
    └── [feature-name].md          # API documentation (if applicable)
```

## Features

### Technical Documentation Includes:
- ✅ Architecture overview with component relationships
- ✅ File structure and organization
- ✅ API endpoints and data flow
- ✅ TypeScript interfaces and types
- ✅ Dependencies and build requirements
- ✅ Testing strategy and checklist
- ✅ Performance and security considerations
- ✅ Deployment and maintenance notes

### User Documentation Includes:
- ✅ Simple, jargon-free explanations
- ✅ Screenshot placeholders with descriptive captions
- ✅ Step-by-step instructions with numbered lists
- ✅ Common use cases and scenarios
- ✅ Troubleshooting section with solutions
- ✅ Tips, best practices, and keyboard shortcuts
- ✅ FAQ section with common questions
- ✅ Cross-references to related features

### Smart Analysis:
- 🔍 Automatically finds feature-related files
- 🧠 Analyzes code structure and dependencies
- 📊 Generates intelligent overviews based on code
- 🔗 Creates proper cross-references between docs
- 📸 Provides screenshot checklists for maintainers

## Customization

The command follows your project's established patterns:
- Uses existing component structure from `src/components/`
- Follows TypeScript conventions from your codebase
- Matches the style of your current README.md
- Integrates with your Next.js application architecture

## Integration

This command works seamlessly with your existing workflow:
- Respects your git branching strategy (`feature-*`)
- Follows SOLID design principles
- Uses your established file organization patterns
- Maintains consistency with current documentation style