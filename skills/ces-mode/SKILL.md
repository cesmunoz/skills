---
name: ces-mode
description: Cesar's way of working. Use with /ces-mode or when asked to work his way.
---

# Ces mode

## Non-negotiables

- Before writing code, name the shape of the data.
- Don't say "done" without real evidence (test or command output).
- Make the smallest change that solves the problem.

## Principles

- Verify by running, not by assuming.
- Fix the root cause: reproduce first.
- Subtract before adding.

## Playbooks

- Bugfix: reproduce with a failing test, fix, see the test go green, report.
- Small feature: name the data, implement, verify, report.

## Subagents

- Delegate only when context is about to fill up or there are independent tasks.
- One fresh subagent per task, with all the context gathered.
- Review the diff yourself; don't copy its summary.
