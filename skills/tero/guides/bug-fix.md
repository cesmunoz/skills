# Bugfix

This is a guide. It is the order of work for a reported defect. Each step names the role that does it. The role files do not repeat this list. Models for spawned roles are in `~/.agents/tero-roles.md`.

Be scientific. Before the fix is called done, apply [Prove It Works](../../prove-it-works/SKILL.md). A change that might help is a hypothesis. It does not ship. When evidence kills a hypothesis, revert what it motivated. The smallest change the evidence justifies is the one that ships.

| Step | Role | What to do |
| --- | --- | --- |
| 1. Reproduce | qa | Run it yourself on the matching surface, even when a debug note says to ask the user. Drive that surface as far as it goes. Ask only with a specific reason it cannot reach the target. If it will not fire, synthesize the trigger, tighten the conditions, or instrument until it does. |
| 2. Narrow | researcher | Seed the candidate causes with `how` on the affected subsystem, then rule them out until one survives. Each pass, take the split that removes the most remaining space, get runtime evidence, and eliminate. When state is unclear, log it and read it as the code runs. Do not guess. On a long hunt, keep going until the surviving mechanism is confirmed with runtime evidence, before anyone plans the fix. |
| 3. Plan the fix | architect | Name the cause and the smallest change that turns it off. |
| 4. Accept the plan | tech-lead | Read the cause and the change from step 3. Accept it, or say what is wrong. Do not write a different plan. |
| 5. Fix | developer | Make only the change the tech-lead accepted. |
| 6. Review | code-reviewer | Read the change against the accepted plan. Say whether it matches. If it does not, name the mismatch. |
| 7. Check | qa | Reproduce it again on the same surface. Say whether the fix actually corrected it. Inconclusive is not a pass. |
| 8. Sequence | developer | Put the failing repro in history before the fix when a cheap local test can carry the bug. Skip that when the test would be expensive, integration-heavy, or unclear. |
| 9. Open a draft | lead | Open the change as a draft. |
| 10. Report | technical-writer | Say what was broken, the cause, the fix, and how it was verified. Paste the failing output and the passing output from that same repro, verbatim. |
