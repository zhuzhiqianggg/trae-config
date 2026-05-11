---
name: pattern-web-performance
description: Optimize website and web application performance including loading speed, Core Web Vitals, bundle size, caching strategies, and runtime performance.
tags: [performance, web, optimization, core-web-vitals, bundle]
---

# Web Performance Optimization

## Core Web Vitals

| Metric | Target | What It Reflects |
|--------|--------|-----------------|
| LCP | < 2.5s | Loading performance |
| INP | < 100ms | Interactivity |
| CLS | < 0.1 | Visual stability |
| TTFB | < 600ms | Server response |

## Step-by-Step Process

### Step 1: Measure
- Run Lighthouse audits
- Measure Core Web Vitals
- Check bundle sizes (webpack-bundle-analyzer)
- Analyze network waterfall

### Step 2: Identify Issues
- Large JavaScript bundles
- Unoptimized images
- Render-blocking resources
- Slow server response times
- Missing caching headers
- Layout shifts

### Step 3: Prioritize
Focus on high-impact improvements first:
1. Image optimization (largest gains)
2. Code splitting and lazy loading
3. Critical rendering path
4. Caching strategies
5. Third-party script optimization

## Image Optimization

- Use modern formats: WebP, AVIF
- Responsive images with srcset
- Lazy loading with `loading="lazy"`
- Always specify width and height
- Compress images < 200KB each
- Use CDN for delivery

## JavaScript Optimization

- Bundle size < 200KB (gzipped)
- Code splitting with dynamic imports
- Tree shaking to remove dead code
- Async/defer for non-critical scripts
- Remove unused dependencies

## Caching Strategy

- Set cache headers for static assets
- Implement service worker
- Use CDN caching
- Cache API responses
- Version static assets

## Performance Checklist

- [ ] LCP < 2.5s
- [ ] INP < 100ms
- [ ] CLS < 0.1
- [ ] Bundle size < 200KB gzipped
- [ ] Images in WebP/AVIF format
- [ ] Lazy loading implemented
- [ ] Code splitting active
- [ ] Cache headers set
- [ ] CDN configured
