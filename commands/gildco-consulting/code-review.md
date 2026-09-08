# GILDCO Code Review

Perform a thorough code review of $ARGUMENTS.

## Brand & Design Standards
Before reviewing, read these reference files to understand GILDCO's standards:
- Brand colors: graphite warm (#1C1A17), deep purple accent (#5B4FD1), cream backgrounds (#F7F6F3), terracotta for lost capacity, teal for recoverable
- Typography: Inter Semibold 600 (h1, h2), DM Sans Medium 500 (subtitles), DM Sans Regular 400 (body)
- Stack: Next.js + Vercel + GitHub

## Review Process
1. **Read** the target files in $ARGUMENTS
2. **Check** against GILDCO's brand guidelines and coding patterns
3. **Analyze** for:
   - Consistent use of brand colors via CSS custom properties (never hardcoded hex values inline)
   - Typography hierarchy matches brand spec
   - Component structure and reusability
   - Mobile responsiveness (Colombia market is mobile-first)
   - Performance (Vercel deployment optimization)
   - Spanish content: proper accents, grammar, professional tone
   - Security: no exposed API keys, env variables properly handled
   - SEO basics: meta tags, semantic HTML, Open Graph tags

## Output
Save review to `reviews/{filename}-review.md` with:
- Issues found (Critical / Warning / Suggestion)
- Specific line references
- Concrete fix suggestions
- Overall quality rating: Ship / Needs Changes / Rewrite
