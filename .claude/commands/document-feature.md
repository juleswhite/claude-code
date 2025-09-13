# Document Feature Command

## Purpose

Automatically generates comprehensive documentation for new features, including both technical documentation for developers and user-friendly guides for end users.

## Usage

```bash
document-feature <feature-name> [options]
```

### Examples

- `document-feature password-reset`
- `document-feature expense-categories --type=frontend`
- `document-feature api-export --type=backend`
- `document-feature user-dashboard --screenshots`

### Options

- `--type=<frontend|backend|fullstack>` - Force feature type detection
- `--screenshots` - Include automated screenshot placeholders in user docs
- `--no-cross-refs` - Skip automatic cross-referencing
- `--template=<custom-template>` - Use custom documentation template

## Command Implementation

When you run this command, I will:

1. **Analyze the Feature**
   - Search the codebase for files related to the feature name
   - Analyze component structure, hooks, utilities, and types
   - Determine if the feature is frontend, backend, or full-stack
   - Identify related existing features and documentation

2. **Set Up Documentation Structure**
   - Create `docs/dev/` and `docs/user/` directories if they don't exist
   - Set up proper documentation organization with clear naming conventions

3. **Generate Developer Documentation**
   - Technical specifications and architecture overview
   - API endpoints and data models (if backend involved)
   - Component hierarchy and props interfaces (if frontend involved)
   - Implementation details and code examples
   - Testing guidelines and edge cases
   - Performance considerations
   - Security implications

4. **Generate User Documentation**
   - Clear, step-by-step user guide
   - Feature benefits and use cases
   - Screenshot placeholders with descriptive captions
   - Troubleshooting section
   - FAQ for common questions
   - Accessibility features

5. **Add Cross-References**
   - Link technical and user documentation
   - Reference related existing documentation
   - Add navigation between documentation sections
   - Create documentation index if needed

6. **Feature Type Detection Logic**
   - **Frontend**: Components in `src/components/`, hooks in `src/hooks/`, pages in `src/app/`
   - **Backend**: API routes in `src/app/api/`, server utilities, database schemas
   - **Full-stack**: Combination of frontend and backend elements
   - **Utility**: Helper functions in `src/lib/`, type definitions in `src/types/`

## Documentation Templates

### Developer Documentation Structure

```markdown
# [Feature Name] - Technical Documentation

## Overview
- Feature description and purpose
- Architecture overview
- Technical requirements

## Implementation Details
- Component structure (if frontend)
- API specification (if backend)
- Data models and types
- Key algorithms or logic

## Code Examples
- Usage examples
- Integration patterns
- Testing examples

## Performance & Security
- Performance considerations
- Security implications
- Best practices

## Testing
- Unit test examples
- Integration test guidelines
- Edge cases to consider

## Maintenance
- Monitoring and debugging
- Common issues and solutions
- Extension points
```

### User Documentation Structure

```markdown
# How to Use [Feature Name]

## What is [Feature Name]?
- Clear explanation of what the feature does
- Benefits and use cases
- When to use this feature

## Getting Started
- Prerequisites
- Step-by-step setup (if needed)

## Using the Feature
- Detailed step-by-step instructions
- Screenshots and visual guides
- Common workflows

## Tips and Best Practices
- Pro tips for effective usage
- Common mistakes to avoid
- Optimization suggestions

## Troubleshooting
- Common issues and solutions
- Error messages and their meanings
- When to contact support

## FAQ
- Frequently asked questions
- Additional resources
```

## Execution Process

When you run `document-feature <feature-name>`, I will:

1. **Pre-Analysis Phase**
   - Validate the feature name format
   - Check if documentation already exists
   - Scan the codebase for related files

2. **Analysis Phase**
   - Identify all files related to the feature
   - Analyze component dependencies and relationships
   - Extract types, interfaces, and function signatures
   - Determine feature complexity and scope

3. **Generation Phase**
   - Create documentation directories if needed
   - Generate technical documentation with code analysis
   - Generate user documentation with clear instructions
   - Add screenshot placeholders where appropriate

4. **Cross-Reference Phase**
   - Link between technical and user docs
   - Reference related existing documentation
   - Update documentation index/navigation

5. **Validation Phase**
   - Check for missing information
   - Validate documentation completeness
   - Suggest improvements or additions

## Smart Features

### Automatic Code Analysis

- Extract component props and state management
- Identify hooks and their dependencies
- Document API endpoints and their parameters
- Analyze data flow and side effects

### Screenshot Integration

- Automatically insert screenshot placeholders
- Generate descriptive captions based on feature analysis
- Suggest optimal screenshot locations for maximum clarity

### Cross-Reference Intelligence

- Link to related components and utilities
- Reference similar patterns in existing code
- Connect to relevant sections of existing documentation

### Template Customization

- Adapt templates based on feature type and complexity
- Include technology-specific sections (React hooks, Next.js pages, etc.)
- Adjust depth and detail based on feature scope

## Output Examples

For `document-feature expense-export`:

**Generated Files:**

- `docs/dev/expense-export-implementation.md` - Technical specs
- `docs/user/how-to-export-expenses.md` - User guide

**Content Includes:**

- Component analysis (`ExportButton`, `ExportModal`)
- Utility function documentation (`exportToCSV`, `downloadCSV`)
- Type definitions (`ExportFormat`, `ExportOptions`)
- User workflow with screenshot placeholders
- Cross-references to related expense management docs

## Integration with Project

This command understands your Next.js project structure:

- Analyzes TypeScript components and their props
- Documents React hooks and their usage patterns
- Identifies Tailwind CSS styling patterns
- Understands the project's type system and interfaces
- Recognizes the localStorage-based data persistence approach

## Benefits

1. **Consistency** - Standardized documentation format across all features
2. **Completeness** - Ensures both technical and user perspectives are covered
3. **Efficiency** - Automates tedious documentation tasks
4. **Accuracy** - Based on actual code analysis rather than assumptions
5. **Maintenance** - Creates living documentation that can be updated as features evolve

---

**Ready to use!** Just run `document-feature <your-feature-name>` and I'll generate comprehensive documentation for any feature in your codebase.