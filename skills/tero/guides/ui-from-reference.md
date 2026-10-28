# UI from reference

This is a guide. It is the order of work for making a UI look like a reference the user named. Each step names the role that does it. The role files do not repeat this list. Models for spawned roles are in `~/.agents/tero-roles.md`.

The reference is a product, screens, or URLs the user named. Copy the system, not the brand.

| Step | Role | What to do |
| --- | --- | --- |
| 1. Study | researcher | Study the reference. Extract layout, spacing, type scale, colors, and components. Cite the screenshot or URL for each. |
| 2. Plan | architect | Turn that into design tokens and the list of components to change. Name what stays as is. |
| 3. Accept the plan | tech-lead | Read the tokens and the component list. Accept them, or say what is wrong. Do not write a different plan. |
| 4. Apply | developer | Apply only the accepted tokens and component changes. |
| 5. Review | code-reviewer | Read the change against the accepted plan. Say whether it matches. |
| 6. Check | qa | Run it at the three viewports. Check text contrast meets WCAG AA (4.5:1). Take before and after screenshots. End with the `Verified` blocks. |
| 7. Open a draft | lead | Open the change as a draft. |
| 8. Report | technical-writer | Say what changed and why. Put before and after screenshots side by side. Paste the `Verified` blocks. |
