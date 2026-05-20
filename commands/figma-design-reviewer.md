Perform a Figma-to-code design audit for: $ARGUMENTS

<!-- This setup part is not for AI but for the user -->
<!-- ## Setup (first time only) -->
<!-- You need two things from Figma: -->
<!-- 1. Your Figma API token: Go to Figma → Account Settings → Personal Access Tokens -->
<!-- 2. Your Figma file key: It's in your Figma URL → figma.com/file/THIS_PART/... -->
<!-- Store them in your .env.local file as: -->
<!-- FIGMA_API_TOKEN=your_token_here -->
<!-- FIGMA_FILE_KEY=your_file_key_here -->

## What to do

**Step 1 — Fetch Figma design tokens**
Make a GET request to:
https://api.figma.com/v1/files/$FIGMA_FILE_KEY/styles
with header: X-Figma-Token: $FIGMA_API_TOKEN

Extract all:

- Colors and their hex values
- Text styles (font family, size, weight, line height)
- Effect styles (shadows, blurs)
- Grid styles

**Step 2 — Fetch the specific component from Figma**
Search for a component named $ARGUMENTS in the Figma file and extract its exact visual properties.

**Step 3 — Audit the code**
Compare the extracted Figma values against the actual implementation in the codebase. Check:

- Every color matches a Figma color style
- Every font matches a Figma text style
- Spacing values are consistent with Figma layout
- Component structure mirrors the Figma component hierarchy

**Step 4 — Report**
Output:

- Figma design tokens found
- Exact mismatches between Figma and code with file, line number, Figma value vs actual value
- Missing tokens that should be added to your config
- Design system compliance score out of 100
- Save the full report as docs/design-audit-$ARGUMENTS.md in the project root.
