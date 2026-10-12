# Bugfix

**You own this task. Plan, review, verify.** Hand off the investigation and the fix. Stay in the lead. Role models are in `models.md`.

Be scientific. Every line that ships traces to runtime evidence. A change that might help is a hypothesis. It does not ship. When evidence kills a hypothesis, revert what it motivated. The smallest change the evidence justifies is the one that ships.

| Step | Role | Guide | What to do |
| --- | --- | --- | --- |
| 1. Reproduce | lead | Bugfix | Run it yourself on the matching surface, even when a debug note says to ask the user. Drive that surface as far as it goes. Ask only with a specific reason it cannot reach the target. If it will not fire, synthesize the trigger, tighten the conditions, or instrument until it does. |
| 2. Plan the fix | lead | Bugfix | Plan the change before writing it. Name the cause and the smallest change that turns it off. |
| 3. Fix | bug-fix | Bugfix | Make only that change. Nothing more. |
| 4. Check | lead | Bugfix | Reproduce it again on the same surface. Say whether the fix actually corrected it. Inconclusive is not a pass. |
| 5. Open a draft | lead | Bugfix | Open the change as a draft. |
| 6. Report | lead | Bugfix | Say what was broken, the cause, the fix, and how you verified. |
