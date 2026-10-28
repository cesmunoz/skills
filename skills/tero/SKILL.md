---
name: tero
description: >
  Tero is the working mode. Enter it with /tero.
  A guide is the ordered steps for one kind of task. A role is who does a step.
  The guide names the role on each step. The role does not repeat the steps.
  The lead is this chat and runs the guide. Every other role is spawned with the first available model in its chain in ~/.agents/tero-roles.md.
  Use for tero, /tero, or when a new task matches a guide and needs that rigor.
disable-model-invocation: true
mode: true
icon: crown
color: yellow
reminder: New task that matches a guide, or real rigor needed -> /tero. Casual turn or an opt-out -> don't.
---

# Tero

Tero is the working mode. `/tero` enters it.

## Requirement

- A guide holds the steps. A role holds the person who does one of those steps.
- Read this skill before using tero.

## Commands

| Command | Description | File |
| --- | --- | --- |
| /tero | Enters tero mode. |
| /tero init | Initializes the roles. | roles.md |
| /tero ... --cross | Review step runs two reviewers on different model families. Off by default. Also "cross review". | roles/code-reviewer.md |

## Rules

1. You type `/tero` and say what you need, in a few words.
2. Tero reads that message and picks the guide that fits the task.
3. Tero is the lead. Read `roles/lead.md`. Copy the guide's steps into a list and work down that list.
4. Do not start a step before the one above it is done or skipped.
5. Do the step. Do not ask "should I?" first. Spawn the named role without asking. A reversible choice is made and reported. Mark `need-input:` and wait only when the user is the only one who can act: a login the role cannot pass, an irreversible write (force-push, deleting data, a message to a customer), or a product choice no run can settle. Do not drop that step quietly.
6. If a step is skipped, it will leave it on the list with `skip:` and the reason.
7. If a step is finished, it will leave it on the list with `done:` and the reason.
8. A step marked `lead` stays in this chat. A step that names another role is spawned immediately: the first available model in that role's chain in `~/.agents/tero-roles.md` (see `roles.md`), instructions from `roles/<role>.md`, the step text, and the earlier results that step needs. When the step says one per slice, spawn that many of the role in the same turn, and wait until every one has replied. Mark it `spawn-subagent:` with the model picked and the reason. Do not wait for approval to spawn.
9. It will close when the work is done.

## Guides

A guide is the order of work for one kind of task. It does not choose the model.

| Guide | For |
| --- | --- |
| [bug-fix](guides/bug-fix.md) | A reported defect to reproduce, root-cause, and fix with runtime evidence. |
| [investigation](guides/investigation.md) | A read-only question about how something works, whether a claim holds, or which option to pick. |
