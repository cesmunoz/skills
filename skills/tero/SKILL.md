---
name: tero
description: >
  Tero is the working mode. Enter it with /tero.
  Everything lives in the guides. A guide holds the steps, and each step names the role that does the work.
  Use for tero, /tero, or when a new task matches a guide and needs that rigor.
disable-model-invocation: true
mode: true
icon: crown
color: yellow
reminder: New task that matches a guide, or real rigor needed -> /tero. Casual turn or an opt-out -> don't.
---

# tero

Tero is the working mode. `/tero` enters it. Everything lives in the guides.

## Install

Add the `skills/tero` folder where Cursor loads skills.

## Get started

1. You type `/tero` and say what you need, in a few words.
2. Tero reads that message and picks the guide that fits.
3. Tero makes a task list. The guide's steps go on it first, copied as written, before any other task.
4. Tero works that list. It loops a step when the step is not finished yet.
5. If a step needs you, Tero leaves it on the list with `skip:` and a short reason, and waits. It does not drop the step quietly.
6. Tero closes when the work is done. The reply says which rule changed a choice, and it includes what the guide asked to report.

## Usage

```
/tero the save button does nothing after the form is valid. reproduce it, then fix it.
```

## Rules

These are the rules you follow. The guides hold the work.

- In the reply, name each rule that changed a decision and the choice it changed.
- Match the message to a guide in the table. Do not invent a guide.
- Put that guide's steps on the list first, copied as written.
- A step you do not do stays on the list with `skip:` and the reason.
- If you can see the answer by running it, do not ask. Ask when the step needs the user.

## Roles

Setup writes [`models.md`](models.md). One line per role. `inherit-parent` means that role runs on the parent chat model.

| Role | Model |
| --- | --- |
| lead | inherit-parent |
| bug-fix | inherit-parent |

## Guides

| Guide | For |
| --- | --- |
| [Bugfix](guides/bugfix.md) | A reported defect to reproduce, root-cause, and fix with runtime evidence. |
