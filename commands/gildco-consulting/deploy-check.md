# GILDCO Pre-Deploy Checklist

Run pre-deployment verification for the GILDCO website before pushing to Vercel.

## Checks to Run
1. **Build**: Run `npm run build` — must complete with zero errors
2. **TypeScript**: No type errors
3. **Links**: Check all internal links resolve correctly
4. **Images**: All images have alt text in Spanish, optimized for web
5. **Responsive**: Verify layout works at 375px (mobile), 768px (tablet), 1440px (desktop)
6. **Brand compliance**:
   - Colors match brand palette (no rogue hex values)
   - Typography uses Inter/DM Sans only
   - GILDCO always written as one word, never "Gild Co" or "GILD CO"
7. **SEO**: 
   - All pages have unique meta titles and descriptions in Spanish
   - Open Graph images set
   - Semantic HTML structure
8. **Performance**: 
   - No unoptimized images over 200KB
   - Lazy loading on below-fold images
   - No unused dependencies in bundle
9. **Environment**: 
   - No hardcoded API keys or secrets
   - .env.example is up to date
10. **Content**: All Spanish text checked for accent marks and grammar

## Output
Save checklist results to `deploy-reports/{date}-precheck.md`:
- ✅ Passed / ❌ Failed / ⚠️ Warning for each item
- Details on any failures
- Recommendation: SHIP / FIX FIRST / HOLD
