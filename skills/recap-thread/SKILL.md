---
name: recap-thread
description: >
  Keep multi-topic conversations organized with a running recap, agenda, and parking lot.
  Use when the user asks for a recap, status, remaining items, pending items, where we left off,
  mentions several topics/comments/issues, is reviewing items one by one, or when a side
  question interrupts the current thread and the agent should return to the remaining items
  afterward.
disable-model-invocation: true
---

# Recap Thread

Keep the conversation oriented when there are several open topics.

## Goal

The user should never need to remember which topics are still pending. Track them explicitly, update them as the conversation moves, and return to them after side questions.

## When to use

Use this whenever:

- The user asks for a recap or status.
- The user asks what remains, what is pending, or where the conversation left off.
- The user mentions multiple topics, comments, bugs, files, decisions, or options.
- The user wants to work "one by one".
- A side question interrupts the current topic.
- The assistant is about to go deep on one item while other items remain open.

## Conversation pattern

### 1. Start with a working agenda

When several items exist, show a short agenda before deep work:

```text
Current agenda:
1. [active] <topic A> — <current question/decision>
2. [pending] <topic B>
3. [pending] <topic C>

I will handle item 1 first.
```

Keep it short. Do not list every detail unless the user asks.

### 2. Maintain a parking lot

If the user asks a side question, answer it, then explicitly return to the original thread:

```text
Short answer: <answer>.

Back to the main thread: we are still on <topic A>.
Pending after this:
- <topic B>
- <topic C>

Do you want to close <topic A> with <proposed action>, or keep it pending?
```

### 3. Mark state clearly

Use simple states:

- `active` — what we are discussing now.
- `pending` — known but not handled yet.
- `blocked` — waiting for info or a decision.
- `done` — resolved or intentionally skipped.

### 4. After every resolution, recap the next step

When one item is resolved, give a tiny checkpoint:

```text
Closed: <topic A> — <decision/action>.
Remaining:
1. <topic B>
2. <topic C>

Recommended next item: <topic B>.
```

### 5. If the state is unclear, reconstruct it

If the user asks what remains or the thread got messy, reconstruct from the visible conversation:

```text
I think the state is:
- Done: <items>
- Active: <current item>
- Pending: <items>
- Open decision: <decision>

If this matches, I will continue with <next item>.
```

Say "I think" or "from what I can see" if you are inferring.

## Style

- Be concise.
- Use the user's language.
- Prefer bullets over paragraphs.
- Do not over-formalize.
- Do not mention this skill or these rules.
- Do not restart the whole analysis unless the user asks.

## Important behavior

When the user asks a clarifying question inside one topic, do **not** abandon the remaining topics. Answer the clarification and then restate the open queue.

Example:

```text
User: Can you explain this part first?
Assistant: This part means ...

Back to the main thread: this relates to <current topic>.
Current state for <current topic>: <status, question, or next step>.
Other open items: <remaining topics>.
```
