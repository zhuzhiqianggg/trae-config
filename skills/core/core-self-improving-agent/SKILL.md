---
name: core-self-improving-agent
description: Log learnings, errors, and corrections to enable continuous improvement. Use when a command fails, the user corrects you, the user requests a capability that doesn't exist, an external API or tool fails, or you discover a better approach.
tags: [self-improvement, learning, memory, continuous-improvement, logging]
---

# Self-Improvement Agent

Log learnings and errors to markdown files for continuous improvement. Promotes recurring patterns to project memory.

## Quick Reference

| Situation | Action |
|-----------|--------|
| Command/operation fails | Log to `.learnings/ERRORS.md` |
| User corrects you | Log to `.learnings/LEARNINGS.md` with category `correction` |
| User requests missing feature | Log to `.learnings/FEATURE_REQUESTS.md` |
| API/external tool fails | Log to `.learnings/ERRORS.md` with integration details |
| Knowledge was outdated | Log to `.learnings/LEARNINGS.md` with category `knowledge_gap` |
| Found better approach | Log to `.learnings/LEARNINGS.md` with category `best_practice` |
| Broadly applicable learning | Promote to `AGENTS.md` or `CLAUDE.md` |
| Recurring pattern (3+ times) | Promote to project memory files |

## Initialization

Ensure `.learnings/` directory exists in the project root. If not, create it:

```bash
mkdir -p .learnings
```

## Logging Format

### Learning Entry (`.learnings/LEARNINGS.md`)

```markdown
## [LRN-YYYYMMDD-XXX] category

**Priority**: low | medium | high | critical
**Status**: pending
**Area**: frontend | backend | infra | tests | docs | config

### Summary
What was learned in one line

### Details
What happened, what was wrong, what's correct

### Suggested Action
Specific fix or improvement

### Metadata
- Source: conversation | error | user_feedback
- Tags: tag1, tag2

---
```

### Error Entry (`.learnings/ERRORS.md`)

```markdown
## [ERR-YYYYMMDD-XXX] command_name

**Priority**: high
**Status**: pending

### Summary
What failed

### Error
Error message

### Context
Command attempted, input used, environment details

### Suggested Fix
How to resolve

---
```

## Promotion Rules

Promote to `AGENTS.md` (project-wide) or `CLAUDE.md` when:
- Same issue recurred 3+ times
- Applies across multiple files/features
- Any team member (human or AI) should know it

## Priority Guidelines

| Priority | When |
|----------|------|
| critical | Blocks core functionality, data loss, security issue |
| high | Significant impact, affects common workflows |
| medium | Moderate impact, workaround exists |
| low | Minor inconvenience, edge case |

## Periodic Review

- Before starting a new major task
- After completing a feature
- When working in an area with past learnings

Count pending items: `grep -c "Status\*\*: pending" .learnings/*.md`
