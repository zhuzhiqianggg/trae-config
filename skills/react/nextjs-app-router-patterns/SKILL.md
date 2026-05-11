---
name: nextjs-app-router-patterns
description: Master Next.js 14+ App Router with Server Components, streaming, parallel routes, and advanced data fetching patterns.
tags: [nextjs, react, frontend, ssr, app-router]
---

# Next.js App Router Patterns

## Core Concepts

### Server Components (Default)
- Zero client-side JavaScript
- Direct database access
- Automatic code splitting

### Client Components
- Add `"use client"` directive
- For interactivity, browser APIs, event handlers
- Minimize client component boundaries

## Data Fetching Patterns

```typescript
// Server Component - direct fetch
async function Page() {
  const data = await fetch('https://api.example.com/data')
  const json = await data.json()
  return <div>{json.title}</div>
}
```

### Caching Strategies
- `cache: 'force-cache'` (default) - Static data
- `cache: 'no-store'` - Dynamic data
- `next: { revalidate: 60 }` - ISR pattern

## Route Patterns

### Parallel Routes
```typescript
// app/@analytics/page.tsx
// app/@team/page.tsx
export default function Layout({ analytics, team }: { analytics: ReactNode, team: ReactNode }) {
  return <>{analytics}{team}</>
}
```

### Intercepting Routes
- `(..)` - Intercept sibling
- `(...)` - Intercept root
- Useful for modals with shared URLs
