# Night shift

This is a guide. It is the order of work for an unattended overnight run on a backlog. Each step names the role that does it. The role files do not repeat this list. Models for spawned roles are in `~/.agents/tero-roles.md`.

Nobody is awake to answer. Do not wait on the user. An item that needs the user is marked and skipped. A failed role is retried as [roles/lead.md](../roles/lead.md) says, then marked `blocked:`.

The backlog is `backlog.md` in the repo root, one `- [ ]` line per item, or the issues the user named.

| Step | Role | What to do |
| --- | --- | --- |
| 1. Pick | lead | Read the backlog. Take the items in order. Write the list. |
| 2. Work each item | per item | A defect runs the [bug-fix](bug-fix.md) steps. A change runs architect -> tech-lead -> developer -> code-reviewer -> qa, with the same rules as bug-fix steps 3 to 7. One draft pull request per item. |
| 3. Tick and move on | lead | After each item, tick it in `backlog.md` with the PR link, or add `blocked:` and the reason. An item that needs user input gets `need-input:` and the question, and is skipped. Do not stop while an unticked item is not blocked or need-input. |
| 4. Safe merge | lead | Before integrating, update each PR onto current main. Resolve conflicts. Run the full test suite. Confirm no other merged change was lost. Never force-push main. Never merge without a green suite. |
| 5. Handoff | technical-writer | Write `handoff-YYYY-MM-DD.md`: done items with PR links, blocked items with the reason, need-input questions, and every qa `Verified` block. |
