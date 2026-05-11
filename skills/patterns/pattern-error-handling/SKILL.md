---
name: pattern-error-handling
description: Master error handling patterns across languages including exceptions, Result types, error propagation, and graceful degradation for resilient applications.
tags: [error-handling, programming, patterns, reliability]
---

# Error Handling Patterns

## Core Strategies

| Pattern | Use Case | Languages |
|---------|----------|-----------|
| Exceptions | Unexpected errors | Java, Python, C#, Ruby |
| Result Types | Expected failures | Rust, Go, TypeScript |
| Either/Monad | Functional error handling | Haskell, Scala, FP-TS |
| Error Codes | Low-level systems | C, Zig |

## Exception Patterns

### Checked vs Unchecked
- Checked: Recoverable (file not found, network timeout)
- Unchecked: Programming bugs (null pointer, index out of bounds)

### Best Practices
- Catch specific exceptions, not base types
- Never swallow exceptions silently
- Preserve stack traces when wrapping
- Log with context, not just messages

## Result Type Pattern (Functional)

```typescript
type Result<T, E> = { ok: true; value: T } | { ok: false; error: E }

function divide(a: number, b: number): Result<number, string> {
  if (b === 0) return { ok: false, error: "Division by zero" }
  return { ok: true, value: a / b }
}
```

## Recovery Strategies

- Retry with exponential backoff
- Circuit breaker pattern
- Graceful degradation (degraded but working)
- Fallback defaults
- Bulkhead isolation

## Anti-Patterns

- Empty catch blocks
- Exception for control flow
- Catching Throwable/Exception base types
- Log and re-throw without context
- Excessive try-catch nesting
