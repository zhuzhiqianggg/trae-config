---
name: react-state-management
description: Modern React state management with Redux Toolkit, Zustand, Jotai, and React Query. From local state to global stores and server state sync.
tags: [react, state, redux, zustand, jotai, react-query]
---

# React State Management

## State Categories

| Type | Description | Solutions |
|------|-------------|-----------|
| Local State | Component-specific | useState, useReducer |
| Global State | Shared across components | Zustand, Redux Toolkit, Jotai |
| Server State | Remote data, caching | React Query, SWR, RTK Query |
| URL State | Route parameters | React Router |
| Form State | Input values | React Hook Form, Formik |

## Selection Criteria

- Small app, simple state → Zustand or Jotai
- Large app, complex state → Redux Toolkit
- Heavy server interaction → React Query + light client state
- Atomic/granular updates → Jotai

## Best Practices

### Do's
- Colocate state as close to usage as possible
- Use selectors to prevent unnecessary re-renders
- Normalize data for easier updates
- Separate server state (React Query) from client state (Zustand)

### Don'ts
- Don't over-globalize - not everything needs global state
- Don't duplicate server state - let React Query manage it
- Don't mutate directly - always use immutable updates
- Don't store derived data - compute it instead

## Combined Pattern

```typescript
// Zustand for client state
const useUIStore = create<UIState>((set) => ({
  sidebarOpen: true,
  toggleSidebar: () => set((s) => ({ sidebarOpen: !s.sidebarOpen })),
}))

// React Query for server state
function Dashboard() {
  const { data: users, isLoading } = useQuery({
    queryKey: ['users'],
    queryFn: fetchUsers,
  })
  // ...
}
```
