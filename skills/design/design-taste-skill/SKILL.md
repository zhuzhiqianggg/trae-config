---
name: design-taste-skill
description: Senior UI/UX frontend design skill. Override default LLM biases with premium aesthetic rules. Enforces metric-based design, strict component architecture, and anti-slop patterns.
tags: [frontend, design, ui, ux, taste, anti-slop, css, tailwind]
---

# Taste Skill - High-Agency Frontend Design

## 1. Active Baseline Configuration

- DESIGN_VARIANCE: 8 (1=Perfect Symmetry, 10=Artsy Chaos)
- MOTION_INTENSITY: 6 (1=Static, 10=Cinematic)
- VISUAL_DENSITY: 4 (1=Art Gallery, 10=Pilot Cockpit)

## 2. Default Architecture & Conventions

- **Dependency Verification:** Check `package.json` before importing any 3rd party library
- **Framework:** React or Next.js. Default to Server Components (RSC)
- **State Management:** Local useState/useReducer for UI; global state only for deep prop-drilling
- **Styling:** Tailwind CSS for 90% of styling
- **Anti-Emoji Policy:** Never use emojis in code or markup. Use Radix/Phosphor icons
- **Viewport Stability:** Use `min-h-[100dvh]` never `h-screen`
- **Grid over Flex-Math:** Use CSS Grid, never complex flexbox percentage math

## 3. Design Engineering Directives

### Typography
- Display: `text-4xl md:text-6xl tracking-tighter leading-none`
- Body: `text-base text-gray-600 leading-relaxed max-w-[65ch]`
- Banned: Inter, Arial, system fonts for premium work
- Preferred: Geist, Outfit, Cabinet Grotesk, Satoshi

### Color Calibration
- Max 1 Accent Color, Saturation < 80%
- Banned: Purple/Blue "AI aesthetic"
- Use neutral bases (Zinc/Slate) with high-contrast singular accents

### Layout Diversification
- Centered Hero/H1 sections banned when LAYOUT_VARIANCE > 4
- Force split-screen, left-aligned, or asymmetric structures

### Interactive UI States
- Loading: Skeletal loaders matching layout
- Empty States: Beautiful composition with guidance
- Error States: Clear inline reporting
- Tactile Feedback: translateY or scale on :active

## 4. Anti-Slop Patterns

- No neon/outer glows
- No pure black (#000000)
- No oversaturated accents
- No Inter font
- No 3-column card layouts
- No "John Doe" generic data
- No Unsplash broken links

## 5. Performance Guardrails

- Animate exclusively via `transform` and `opacity`
- Never animate `top`, `left`, `width`, `height`
- Isolate CPU-heavy animations in separate Client Components
- Memoize perpetual motion components with React.memo

## 6. The Creative Arsenal

- Bento Grid layouts
- Parallax Tilt Cards
- Glassmorphism with inner refraction borders
- Magnetic buttons with useMotionValue
- Staggered orchestration for list reveals
- Kinetic typography and marquees
