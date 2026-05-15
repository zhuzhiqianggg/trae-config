---
name: eng-accessibility-review
model: 
- claude-3.7-sonnet
- gpt-4o
---

# Accessibility Review & Fix

WCAG 2.1 AA compliance audit and remediation for web applications.

## When to Use

- Reviewing UI components for accessibility compliance
- Fixing accessibility issues identified by audits or user feedback
- Before launching a public-facing web application
- Adding new interactive components that need to be accessible
- Ensuring keyboard navigation works correctly

## WCAG 2.1 AA Checklist

### 1. Perceivable

- [ ] **1.1.1 Non-text Content**: All images have meaningful alt text
- [ ] **1.2.x Time-based Media**: Captions for video, transcripts for audio
- [ ] **1.3.1 Info and Relationships**: Semantic HTML used correctly (nav, main, aside, etc.)
- [ ] **1.3.2 Meaningful Sequence**: Content order makes sense when linearized
- [ ] **1.4.1 Use of Color**: Information not conveyed by color alone
- [ ] **1.4.3 Contrast Minimum**: Text 4.5:1, large text 3:1
- [ ] **1.4.4 Resize Text**: Text can be zoomed 200% without loss
- [ ] **1.4.5 Images of Text**: Use real text, not images of text
- [ ] **1.4.10 Reflow**: Content works at 400% zoom without scrolling both axes
- [ ] **1.4.11 Non-text Contrast**: UI components meet 3:1 contrast
- [ ] **1.4.12 Text Spacing**: No loss of content with custom spacing
- [ ] **1.4.13 Content on Hover/Focus**: Tooltips are dismissible, hoverable, persistent

### 2. Operable

- [ ] **2.1.1 Keyboard**: All functionality available via keyboard
- [ ] **2.1.2 No Keyboard Trap**: Focus doesn't get stuck
- [ ] **2.4.1 Skip Links**: Skip navigation links present
- [ ] **2.4.3 Focus Order**: Logical tab order
- [ ] **2.4.4 Link Purpose**: Links are descriptive (not "click here")
- [ ] **2.4.6 Headings and Labels**: Descriptive headings and labels
- [ ] **2.4.7 Focus Visible**: Clear focus indicators on all interactive elements
- [ ] **2.5.3 Label in Name**: Accessible name matches visible label

### 3. Understandable

- [ ] **3.1.1 Language of Page**: html lang attribute set
- [ ] **3.2.1 On Focus**: No unexpected context changes on focus
- [ ] **3.2.2 On Input**: No unexpected changes when typing
- [ ] **3.3.1 Error Identification**: Error messages clearly identify issues
- [ ] **3.3.2 Labels or Instructions**: Form inputs have clear labels
- [ ] **3.3.3 Error Suggestion**: Suggestions for fixing errors

### 4. Robust

- [ ] **4.1.1 Parsing**: Valid HTML
- [ ] **4.1.2 Name, Role, Value**: ARIA attributes used correctly
- [ ] **4.1.3 Status Messages**: Dynamic updates announced by screen readers

## Common Fixes

### Add Alt Text
```html
<!-- Before -->
<img src="chart.png">
<!-- After -->
<img src="chart.png" alt="Monthly revenue chart showing 20% growth in Q3">
```

### Fix Color Contrast
```css
/* Before — fails 4.5:1 */
.light-text { color: #999; background: #fff; }
/* After — passes 4.5:1 */
.light-text { color: #595959; background: #fff; }
```

### Add Keyboard Support
```javascript
// Before — mouse only
button.addEventListener('click', handleClick);
// After — keyboard accessible
button.addEventListener('click', handleClick);
button.addEventListener('keydown', (e) => {
  if (e.key === 'Enter' || e.key === ' ') handleClick(e);
});
```

### Fix Focus Indicator
```css
/* Before — no focus visible */
*:focus { outline: none; }
/* After — clear focus ring */
*:focus-visible {
  outline: 2px solid #4A90D9;
  outline-offset: 2px;
}
```

## Tools

- **axe DevTools** — Browser extension for automated testing
- **Lighthouse** — Built-in Chrome audit tool
- **WAVE** — Web accessibility evaluation tool
- **NVDA / VoiceOver** — Screen reader testing
- **Colour Contrast Analyser** — Color contrast checking
- **Tab through** — Manual keyboard navigation test
- **Playwright MCP** — Automate a11y testing via axe-core integration
