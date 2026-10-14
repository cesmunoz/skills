# Roles

A role is who does a step. The guide decides which step, and when. This file only says which model and effort that person runs on.

`/tero init` writes `~/.agents/tero-roles.md`. If that file is missing, create it:

- Check the available models and efforts (or thinking) in the model settings.
- Assign each spawned role below to one model and effort.

One line per spawned role. Delete a line to fall back to the Default column in the table.

```
---
description: tero role-model choices (overrides skill defaults)
alwaysApply: true
---
# tero model configuration. One line per role.
tech-lead: grok-4.7-xhigh-fast
researcher: grok-4.7-xhigh-fast
architect: grok-4.7-xhigh-fast
developer: grok-4.7-xhigh-fast
code-reviewer: grok-4.7-xhigh-fast
qa: grok-4.7-xhigh-fast
technical-writer: grok-4.7-xhigh-fast
```

## Who exists

| Role | Default | File | Does |
| --- | --- | --- | --- |
| lead | this chat | [roles/lead.md](roles/lead.md) | Runs the guide. No model line. |
| tech-lead | grok-4.7-xhigh-fast | [roles/tech-lead.md](roles/tech-lead.md) | Accepts or rejects the technical plan. |
| researcher | grok-4.7-xhigh-fast | [roles/researcher.md](roles/researcher.md) | Finds how it works, or why it failed, from evidence. |
| architect | grok-4.7-xhigh-fast | [roles/architect.md](roles/architect.md) | Names the change before anyone writes it. |
| developer | grok-4.7-xhigh-fast | [roles/developer.md](roles/developer.md) | Makes the change it was handed. |
| code-reviewer | grok-4.7-xhigh-fast | [roles/code-reviewer.md](roles/code-reviewer.md) | Says whether the change matches the plan. |
| qa | grok-4.7-xhigh-fast | [roles/qa.md](roles/qa.md) | Runs it and says what happened. |
| technical-writer | grok-4.7-xhigh-fast | [roles/technical-writer.md](roles/technical-writer.md) | Writes up what the other roles already found. |

`lead` is the chat that received `/tero`. It is not spawned and it has no model line.

A role file says how that person behaves when a guide step names them. It does not list the steps. The steps stay in the guide.
