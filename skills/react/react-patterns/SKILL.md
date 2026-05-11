---
name: react-patterns
description: Modern React patterns and principles covering hooks, composition, performance, TypeScript best practices, and state management.
tags: [react, frontend, javascript, typescript, hooks]
---

# React Patterns

## 1. Component Design Principles

| Type | Use | State |
|------|-----|-------|
| Server | Data fetching, static | None |
| Client | Interactivity | useState, effects |
| Presentational | UI display | Props only |
| Container | Logic/state | Heavy state |

- One responsibility per component
- Props down, events up
- Composition over inheritance

## 2. Hook Patterns

- Hooks at top level only, same order every render
- Custom hooks start with "use"
- Clean up effects on unmount

## 3. State Management Selection

| Complexity | Solution |
|------------|----------|
| Simple | useState, useReducer |
| Shared local | Context |
| Server state | React Query, SWR |
| Complex global | Zustand, Redux Toolkit |

## 4. React 19 Patterns

| Hook | Purpose |
|------|---------|
| useActionState | Form submission state |
| useOptimistic | Optimistic UI updates |
| use | Read resources in render |

## 5. Performance Principles

- Profile first before optimizing
- Virtualize large lists
- useMemo for expensive calculations
- useCallback for stable callbacks

## 6. Anti-Patterns

| Don't | Do |
|-------|-----|
| Prop drilling deep | Use context |
| Giant components | Split smaller |
| useEffect for everything | Server components |
| Premature optimization | Profile first |
| Index as key | Stable unique ID |
