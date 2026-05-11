---
name: core-skills-creator
description: Guide the creation, review, and optimization of Trae IDE skills (SKILL.md). Use when creating new skills, reviewing existing ones, optimizing skill descriptions, or publishing skills to the trae-config repository.
tags: [skill-creation, meta-skill, skilly.md, frontmatter, quality]
---

# Skills Creator

Guide the creation, review, and optimization of Trae IDE skills that trigger reliably and instruct LLMs clearly.

## Quick Reference

| User wants... | Do this |
|---------------|---------|
| Create a new skill | Gather requirements, determine complexity tier, write frontmatter + body |
| Review an existing skill | Run quality checklist, output findings as table |
| Fix poor triggering | Rewrite description with trigger phrases |
| Retrofit / optimize a skill | Audit → rewrite description → restructure content → re-audit |

## Rules

### Rule 1: Determine complexity tier first

| Tier | When to use | SKILL.md size |
|------|-------------|---------------|
| Simple | Pure instructions, no code examples | < 150 lines |
| Medium | Needs code examples or reference tables | 100–300 lines |
| Complex | Multiple workflows + cross-language examples | 200–650 lines |

### Rule 2: Description is the highest-leverage field

The `description` in frontmatter determines whether an LLM activates the skill. Spend disproportionate effort here. Follow the formula:

```
[Action verb] + [value proposition]. Use when [trigger 1], [trigger 2], ... or discusses [topic area].
```

Include 5+ trigger phrases so the LLM matches it against diverse user input.

### Rule 3: Write instructions for an LLM, not documentation for a human

SKILL.md is injected into an LLM's context. Write actionable directives ("Do X when Y"), not explanatory documentation ("This skill provides..."). The LLM needs to know **what to do**, not **what the skill is**.

### Rule 4: Use tables for decision logic, not prose

Tables are the LLM's fastest lookup structure. Any conditional logic ("if X then Y") should be a table row, not a paragraph.

## Create New Skill

1. Ask the user what the skill does (one sentence) and what should trigger it
2. Determine complexity tier (start Simple — easier to add complexity)
3. Write frontmatter with `name`, `description`, `tags`
4. Write SKILL.md body: Title → Quick Reference → Rules → Workflow → Verification
5. Run quality checklist before considering complete

## Quality Checklist

- [ ] Frontmatter has `name` (kebab-case), `description` (with triggers), `tags`
- [ ] Description includes 5+ trigger phrases
- [ ] Content uses tables for conditional logic (not paragraphs)
- [ ] Skill describes itself accurately (self-consistent)
- [ ] Actionable directives, not explanatory documentation
- [ ] Verification section with checkboxes at the end
- [ ] Follows project naming convention (category-prefix-name)
