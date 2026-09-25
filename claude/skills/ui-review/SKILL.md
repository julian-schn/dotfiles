---
name: ui-review
description: Audit UI changes for accessibility, responsive behavior, and calm UI. Use after any change to components, layout, or styling.
---

Run against the changed views:

1. keyboard only: tab order, visible focus, no traps, escape closes overlays
2. semantics: landmarks, heading order, labels on every input, alt text
3. contrast: 4.5:1 body, 3:1 large text and ui borders
4. motion and zoom: respects prefers-reduced-motion, usable at 200% zoom
5. viewports via playwright: 320, 375, 768, 1024, 1440. check for horizontal scroll,
   clipped text, tap targets under 44px, layout collapse
6. calm ui: the UI should feel quiet and stable, not jumpy or noisy. examples, not a full list
   (see https://maxschmitt.me/posts/calm):
   - one loading state per action. keep the spinner on the submit button until the
     refetched data is on screen, with no second loader appearing after it
   - no toasts. confirm success by showing the result (the new item appears). show errors
     next to the control that caused them, not in a toast that disappears
   - no layout shift. pin a modal whose height changes to the top so its buttons stay put
   - forms submit on Enter via `<form onSubmit>`. dialogs autofocus their first input
   flag anything else that makes the UI flicker, jump, or draw attention it doesn't need
7. report findings for 1-5 as WCAG 2.2 AA pass/fail with the offending selector. report
   calm ui findings separately as pass/fail with the selector

Report what fails and where. Don't fix anything unless asked.
