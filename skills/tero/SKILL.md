---
name: tero
description: >
  Tero is the working mode. Enter it with /tero.
  A guide is the ordered steps for one kind of task. A role is who does a step.
  The guide names the role on each step. The role does not repeat the steps.
  The lead is this chat and runs the guide. Every other role is spawned with the model in ~/.agents/tero-roles.md.
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

## Rules

1. You type `/tero` and say what you need, in a few words.
2. Tero reads that message and picks the guide that fits the task.
3. Tero is the lead. Read `roles/lead.md`. Copy the guide's steps into a list and work down that list.
4. Do not start a step before the one above it is done, skipped, or waiting on the user.
5. If a step needs input from the user, it will leave it on the list with `need-input:` and the reason, and waits. It does not drop the step quietly.
6. If a step is skipped, it will leave it on the list with `skip:` and the reason.
7. If a step is finished, it will leave it on the list with `done:` and the reason.
8. A step marked `lead` stays in this chat. A step that names another role spawns that role: model from `~/.agents/tero-roles.md`, instructions from `roles/<role>.md`, the step text, and the earlier results that step needs. Mark it `spawn-subagent:` and the reason.
9. It will close when the work is done.

## Guides

A guide is the order of work for one kind of task. It does not choose the model.

| Guide | For |
| --- | --- |
| [bug-fix](guides/bug-fix.md) | A reported defect to reproduce, root-cause, and fix with runtime evidence. |
