---
name: design-effective-ui
description: Professional UI design guidelines for accessible, well-structured interfaces. Covers WCAG 2.1 AA, OKLCH color, 8pt grid, fluid typography, form patterns, SEO meta tags, and Core Web Vitals.
tags: [design, ui, ux, accessibility, css, frontend]
---

# Effective UI Design

Enforces professional UI design guidelines for accessible, well-structured interfaces.

## Core Principles

1. **Minimize Usability Risks** - Meet WCAG 2.1 AA, avoid thin grey text, icons without labels
2. **Every Detail Has a Reason** - Design with objective logic, not subjective opinion
3. **Minimize Interaction Cost** - Fitts's Law, Hick's Law, minimum 48pt targets
4. **Minimize Cognitive Load** - Clear hierarchy, consistent patterns, remove unnecessary elements
5. **Create a Design System** - 8pt spacing increments, predefined palette, typography scale

## Critical Rules

### Color
- Text contrast: minimum 4.5:1 ratio
- UI elements: minimum 3:1 ratio
- Never rely on color alone to convey meaning
- Use OKLCH for perceptually uniform palettes
- Use `light-dark()` for theme switching
- Avoid pure black (#000) - use dark grey instead

### Typography
- UI text: 14px base; Body text: 16px base
- Line height: minimum 1.5 for body text
- Line length: 40-80 characters per line
- Left-align text; 1-2 typefaces maximum

### Layout
- 8pt spacing grid: 8, 16, 24, 32, 48, 80pt
- Space based on relationship (closer = more related)
- Use container queries for component-level responsiveness
- Use subgrid for card alignment

### Buttons
- 3 weights: Primary, Secondary, Tertiary
- Single primary button per screen
- Minimum 48x48pt target size
- Button text: verb + noun

### Forms
- Single column layout
- Labels above inputs
- Field width matches expected input
- Use `:user-valid`/`:user-invalid` for validation

### SEO
- Unique title (50-60 chars) and meta description (150-160 chars)
- One H1 per page, logical hierarchy
- JSON-LD structured data
- Open Graph tags for social sharing
