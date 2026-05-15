---
name: eng-code-refactoring
model: 
- claude-3.7-sonnet
- gpt-4o
---

# Code Refactoring

Systematic code refactoring patterns to improve code quality without changing behavior.

## When to Use

- Code is working but hard to understand or maintain
- You encounter duplicated logic
- Functions are too long with multiple responsibilities
- Error handling is inconsistent or missing
- Tests exist and you need to safely improve code structure
- You need to pay down technical debt before adding features

## Core Principles

1. **Behavior Preserving** — refactoring never changes what the code does
2. **Test-Guarded** — always have tests before refactoring
3. **Small Steps** — one transformation at a time, commit after each
4. **Stopping Criterion** — stop if tests fail, revert to last green state

## Refactoring Patterns

### 1. Extract Function
When a block of code can be grouped together and named:
```
1. Identify coherent block of logic
2. Extract to new function with descriptive name
3. Pass required state as parameters
4. Return result if needed
5. Replace original block with function call
6. Run tests
```

### 2. Extract Class / Module
When related functions operate on the same data:
```
1. Group related functions
2. Move shared state into class/module fields
3. Define clear public interface
4. Depend on interface, not implementation
```

### 3. Consolidate Duplicate Logic (DRY)
When the same logic appears in multiple places:
```
1. Identify ALL duplicate instances
2. Extract common logic
3. Parameterize differences
4. Replace all instances
5. Verify no behavioral changes
```

### 4. Simplify Conditionals
When conditionals are nested or complex:
```
1. Extract condition to named boolean variable/function
2. Use early return to flatten nesting
3. Replace switch with object/record lookup or pattern matching
4. Replace if/else with polymorphism when type-based
```

### 5. Replace Magic Values
When code uses unexplained constants:
```
1. Find all magic numbers, strings, and booleans
2. Replace with named constants/enums
3. Verify all references updated
```

### 6. Improve Error Handling
When error handling is inconsistent:
```
1. Standardize on one error pattern (Result type vs exceptions)
2. Replace throw strings with typed errors
3. Remove empty catch blocks
4. Add error context (wrap/rethrow with additional info)
```

## Anti-Patterns to Avoid

| Anti-Pattern | Why | Better |
|-------------|-----|--------|
| Refactoring without tests | Can't verify behavior preserved | Write tests first |
| Big bang refactoring | Too risky, hard to debug | Small incremental steps |
| Mixing refactoring + features | Confuses what changed | Separate commits |
| Over-abstraction | Premature generalization | YAGNI — refactor when needed |
| Renaming in same commit | Hides other changes | Rename-only commits first |

## Workflow

```
1. Ensure test coverage exists (write tests if missing)
2. Create refactoring branch
3. Apply ONE pattern at a time
4. Run tests after each step
5. Commit after each green test run
6. Repeat until code quality is acceptable
7. Create PR with refactoring-* title
```

## Before/After Example

**Before:**
```python
def process(data):
    if data:
        if data.get("type") == "user":
            # validate user
            if len(data.get("name", "")) > 0:
                # save to db
                db.save(data)
                return True
            else:
                return False
    return False
```

**After:**
```python
def process(data):
    if not data:
        return False
    if data.get("type") == "user":
        return _process_user(data)
    return False

def _process_user(data):
    if not _valid_user(data):
        return False
    db.save(data)
    return True

def _valid_user(data):
    return bool(data.get("name"))
```
