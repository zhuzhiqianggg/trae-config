---
name: design-frontend
description: Create distinctive, production-grade frontend interfaces with intentional aesthetics, high craft, and non-generic visual identity. Use when building or styling web UIs, components, pages, dashboards, or frontend applications.
tags: [frontend, design, ui, visual, css, react]
---

# Frontend Design (Distinctive, Production-Grade)

## 1. Core Design Mandate

Every output must satisfy all four:
1. **Intentional Aesthetic Direction** - A named, explicit design stance
2. **Technical Correctness** - Real, working code
3. **Visual Memorability** - At least one memorable element
4. **Cohesive Restraint** - No random decoration

## 2. Design Feasibility & Impact Index (DFII)

Score each dimension 1-5:
- Aesthetic Impact: How visually distinctive?
- Context Fit: Suits product/audience?
- Implementation Feasibility: Buildable with available tech?
- Performance Safety: Fast and accessible?
- Consistency Risk: Maintainable across screens?

Formula: DFII = (Impact + Fit + Feasibility + Performance) - Consistency Risk
- 12-15: Excellent
- 8-11: Strong
- 4-7: Risky
- <=3: Weak

## 3. Aesthetic Execution Rules

### Typography
- Avoid system fonts and AI-defaults (Inter, Roboto, Arial)
- Choose 1 expressive display font + 1 restrained body font

### Color & Theme
- Commit to a dominant color story
- CSS variables exclusively
- One dominant tone + one accent + one neutral system

### Spatial Composition
- Break the grid intentionally
- Use asymmetry, overlap, negative space
- White space is a design element

### Motion
- Purposeful, sparse, high-impact
- One strong entrance sequence
- A few meaningful hover states

## 4. Anti-Patterns (Immediate Failure)

- Inter/Roboto/system fonts
- Purple-on-white SaaS gradients
- Default Tailwind/ShadCN layouts
- Symmetrical predictable sections
- Overused AI design tropes

## 5. Required Output Structure

1. Design Direction Summary (aesthetic name, DFII score, key inspiration)
2. Design System Snapshot (fonts, color variables, spacing rhythm, motion philosophy)
3. Implementation (full working code)
4. Differentiation Callout ("This avoids generic UI by doing X instead of Y")
