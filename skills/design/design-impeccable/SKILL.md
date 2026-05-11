---
name: design-impeccable
description: Impeccable frontend design skill with 17 commands and curated anti-patterns. Expanded design vocabulary with 7 domain-specific references for typography, color, space, motion, interaction, responsive, and UX writing.
tags: [design, frontend, ui, ux, typography, color, motion]
---

# Impeccable Frontend Design

Create distinctive, production-grade frontend interfaces that avoid generic "AI slop" aesthetics.

## Design Direction

Choose a BOLD aesthetic direction:
- **Purpose**: What problem does this interface solve?
- **Tone**: Minimalist, maximalist, retro-futuristic, organic, luxury, editorial, brutalist...
- **Differentiation**: What makes this UNFORGETTABLE?

## Frontend Aesthetics Guidelines

### Typography
- Use modular type scale with fluid sizing (clamp)
- Pair a distinctive display font with a refined body font
- **DON'T**: Inter, Roboto, Arial, Open Sans, system defaults

### Color
- Use OKLCH, color-mix, light-dark for maintainable palettes
- Tint neutrals toward brand hue
- Dominant colors with sharp accents
- **DON'T**: Pure black (#000), gray on colored backgrounds

### Layout
- Create visual rhythm through varied spacing
- Embrace asymmetry and unexpected compositions
- Break the grid intentionally for emphasis
- **DON'T**: Wrap everything in cards, nest cards in cards

### Motion
- Focus on high-impact moments (staggered reveals)
- Use exponential easing (ease-out-quart/quint/expo)
- Animate via transform and opacity only
- **DON'T**: Bounce/elastic easing, decorative micro-motion spam

### Interaction
- Use optimistic UI - update immediately, sync later
- Progressive disclosure - start simple, reveal sophistication
- Design empty states that teach the interface

## Commands

| Command | What It Does |
|---------|-------------|
| /audit | Technical quality checks (a11y, performance, responsive) |
| /critique | UX design review: hierarchy, clarity, emotional resonance |
| /polish | Final pass before shipping |
| /distill | Strip to essence |
| /animate | Add purposeful motion |
| /colorize | Introduce strategic color |
| /bolder | Amplify boring designs |
| /quieter | Tone down overly bold designs |
