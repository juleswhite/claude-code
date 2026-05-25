# Code Review Command

Carefully perform a comprehensive code review of $ARGUMENTS.

## Review Standards
Examples of excellent code that you should match the design/style/conventions of:
- `src/components/dashboard/SummaryCards.tsx` (React components)
- `src/utils/formatters.ts` (utility functions)
- `src/hooks/useExpenses.ts` (custom hooks)

## Process
1. **First**: Read the example files above to understand our design patterns, naming conventions, and code style
2. **Second**: Analyze $ARGUMENTS against these standards
3. **Third**: Create detailed critique covering:
   - Code structure and organization
   - Adherence to established patterns
   - Performance considerations
   - Security implications
   - Maintainability concerns
   - Test coverage gaps

## Output Requirements
- Save review as `ai-code-reviews/{filename}.review.md` for each file reviewed
- Include specific line references for issues
- Provide concrete suggestions for improvements
- Rate overall quality: Excellent/Good/Needs Improvement/Poor
- Estimate refactoring effort: Low/Medium/High

## Review Checklist
- Follows project naming conventions
- Proper error handling implemented
- No hardcoded values, secrets, or magic numbers
- Appropriate comments and documentation
- Follows existing design principles and consistent with exemplars
- No obvious security vulnerabilities
- Performance optimizations considered
