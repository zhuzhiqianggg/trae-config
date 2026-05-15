# Code Quality Reviewer Prompt Template

Use this template when dispatching a code quality reviewer subagent.

**Purpose:** Verify implementation is well-built (clean, tested, maintainable, secure)

**Only dispatch after spec compliance review passes.**

```
Task tool (superpowers:code-reviewer):
  WHAT_WAS_IMPLEMENTED: [from implementer's report]
  PLAN_OR_REQUIREMENTS: Task N from [plan-file]
  BASE_SHA: [commit before task]
  HEAD_SHA: [current commit]
  DESCRIPTION: [task summary]
```

## Quality Dimensions to Check

### 1. Structure & Architecture
- Does each file have one clear responsibility?
- Are interfaces well-defined at module boundaries?
- Is the code following the file structure from the plan?
- Did this implementation create large files or significantly grow existing ones?
- Is there proper separation of concerns?

### 2. Readability & Maintainability
- Are names descriptive and accurate (function names say what they do)?
- Is the code self-documenting (comments explain WHY, not WHAT)?
- No duplicated code (DRY)
- No deeply nested conditionals (extract functions instead)
- Functions do one thing (single responsibility at function level)
- No magic numbers or strings (use constants/enums)

### 3. Reliability & Error Handling
- Are all error paths handled (not just happy path)?
- Are async operations properly awaited with error handling?
- Are external calls wrapped in try/catch with meaningful recovery?
- No silent failures (empty catch blocks)
- Input validation at all API/function boundaries

### 4. Security Hygiene
- No hardcoded secrets, tokens, or credentials
- No eval() or dynamic code execution
- SQL queries use parameterized statements (no string concatenation)
- All file paths validated (no path traversal vulnerabilities)
- No overly permissive CORS or security headers

### 5. Performance
- No N+1 queries or unnecessary database calls
- No synchronous operations in async context where they block
- No unnecessary re-renders or computations (React useEffect deps, useMemo)
- Bundle/import size considerations (no importing entire libraries for one function)

### 6. Testing
- Tests exist for new/modified code
- Tests verify behavior, not implementation details
- Edge cases and error conditions covered
- Tests are deterministic (no flaky tests)
- Setup/teardown is clean

## Code reviewer returns
```
## Strengths
What was done well

## Issues
### Critical (must fix)
- file:line — description with recommendation

### Important (should fix)
- file:line — description with recommendation

### Minor (nice to have)
- file:line — description with recommendation

## Summary Assessment
PASS / PASS_WITH_CONCERNS / FAIL
```
