# Roles

A role is who does a step. The guide decides which step, and when. This file only says which model and effort that person runs on.

`/tero init` writes `~/.agents/tero-roles.md`. If that file is missing, create it:

- Check the available models and efforts (or thinking) in the model settings.
- Give each spawned role a chain of models, best first. Use the efforts in the table below.

## Format

One line per spawned role: `role: model effort > model effort > ...`. The lead takes the first model in the chain that this environment can spawn.

- `default:` is the chain for a role with no line, or whose chain has nothing available.
- `fallback:` is the last resort when `default:` has nothing available either.
- A single-model line still works. It is a chain of one.

```
---
description: tero role-model choices (overrides skill defaults)
alwaysApply: true
---
# tero model configuration. One chain per role, best first.
default: claude-opus-5-5 high > gpt-6.1-sol high
fallback: grok-4.7 medium
tech-lead: claude-opus-5-5 high > gpt-6.1-sol high
researcher: gpt-6.1-sol medium > claude-sonnet-5-5 medium
architect: claude-opus-5-5 high > gpt-6.1-sol high
developer: gpt-6.1-sol medium > claude-sonnet-5-5 medium
code-reviewer: claude-opus-5-5 medium > gpt-6.1-sol medium
code-reviewer-cross: gpt-6.1-sol medium
qa: claude-sonnet-5-5 low > grok-4.7 low
technical-writer: claude-haiku-5-5 low > grok-4.7 low
```

## How the lead picks

At spawn time, the lead does this. See [roles/lead.md](roles/lead.md).

1. List the models this environment can spawn. In T3 Code, read the orchestrator capabilities. In Cursor or pi, read their model list.
2. Walk the role's chain left to right. Take the first model that is available.
3. Match by model family name. Ignore provider prefixes: `cliproxyapi/claude-opus-5-5` is `claude-opus-5-5`.
4. If the environment puts the effort in the id, map it: `grok-4.7 medium` is `grok-4.7-medium`.
5. Nothing available: walk `default:`. Still nothing: use `fallback:`. Still nothing: use the lead's own model.
6. Say the pick in the `spawn-subagent:` note. Example: `spawn-subagent: researcher on grok-4.7-medium (fallback; gpt-6.1-sol not available here)`.

## Who exists

| Role | Effort | Why | File | Does |
| --- | --- | --- | --- | --- |
| lead | none | This chat. No model line. | [roles/lead.md](roles/lead.md) | Runs the guide. |
| tech-lead | high | Judges. The input is short. | [roles/tech-lead.md](roles/tech-lead.md) | Accepts or rejects the technical plan. |
| researcher | medium | Reads a lot, often in parallel. | [roles/researcher.md](roles/researcher.md) | Finds how it works, or why it failed, from evidence. |
| architect | high | One shot at the plan. | [roles/architect.md](roles/architect.md) | Names the change before anyone writes it. |
| developer | medium | The plan is already set. | [roles/developer.md](roles/developer.md) | Makes the change it was handed. |
| code-reviewer | medium | Compares a diff with a plan. | [roles/code-reviewer.md](roles/code-reviewer.md) | Says whether the change matches the plan. |
| code-reviewer-cross | medium | A second family catches other misses. | [roles/code-reviewer.md](roles/code-reviewer.md) | Same as code-reviewer. Only with `--cross`. |
| qa | low | Mechanical driving. | [roles/qa.md](roles/qa.md) | Runs it and says what happened. |
| technical-writer | low | Writes from results already found. | [roles/technical-writer.md](roles/technical-writer.md) | Writes up what the other roles already found. |

`lead` is the chat that received `/tero`. It is not spawned and it has no model line.

A role file says how that person behaves when a guide step names them. It does not list the steps. The steps stay in the guide.
