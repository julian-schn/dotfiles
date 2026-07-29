---
name: ui-review
description: Audit UI changes for accessibility and responsive behavior. Use after any change to components, layout, or styling.
---

Run against the changed views:

1. keyboard only: tab order, visible focus, no traps, escape closes overlays
2. semantics: landmarks, heading order, labels on every input, alt text
3. contrast: 4.5:1 body, 3:1 large text and ui borders
4. motion and zoom: respects prefers-reduced-motion, usable at 200% zoom
5. viewports via playwright: 320, 375, 768, 1024, 1440. check for horizontal scroll,
   clipped text, tap targets under 44px, layout collapse
6. report findings as WCAG 2.2 AA pass/fail with the offending selector

Report what fails and where. Don't fix anything unless asked.
