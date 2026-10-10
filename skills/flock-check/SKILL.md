---
name: flock-check
description: Check what the other Pi agents in Herdr are doing, their live status, recent progress, blockers, and whether they need input. Use whenever the user says “flock check”, “check the flock”, asks what other agents are doing, who is active or idle, or whether another agent needs attention. This is a read-only status check and must not interact with agents or change the Herdr layout.
license: MIT
compatibility: Requires Pi running inside Herdr with the herdr CLI available.
metadata:
  author: cesmunoz
  adapted-for: Pi and Herdr
---

# Flock Check

Inspect the live Herdr session and give a concise, evidence-based summary of the other Pi agents: what they are doing, what they completed, what blocks them, and what they need next.

This workflow is strictly read-only. Never focus or create a pane, move focus, send keys, submit a prompt, start or stop an agent, restart Herdr, or close anything during a flock check.

## Scope

Default to the local Herdr server and every recognized agent except the Pi pane running this check. Identify the current pane using `HERDR_PANE_ID`; do not guess from the agent name, workspace label, focus state, or terminal title.

Include the current pane only when the user explicitly asks for every agent. Use a remote machine only when the user names one.

## Workflow

### 1. Verify the environment

Confirm this Pi is running inside Herdr:

```bash
test "${HERDR_ENV:-}" = 1
```

If not, report that flock check requires a Herdr-managed Pi session and stop.

Run:

```bash
herdr status
```

Report compatibility or an exact availability blocker. Distinguish a stale server binary from `restart_needed`; do not claim a restart is required unless Herdr says so. Never start, stop, update, or restart Herdr automatically.

### 2. Inventory agents and workspaces

Run these read-only commands, preferably in parallel:

```bash
herdr agent list
herdr workspace list
```

Parse the returned JSON. For each recognized agent capture:

```text
agent
agent_status
pane_id
workspace_id
cwd / foreground_cwd
terminal_title_stripped
focused
```

Map each `workspace_id` to its workspace label. Record unknown workspaces separately without inventing an agent identity.

Exclude the entry whose `pane_id` equals `HERDR_PANE_ID`, unless the user requested every agent. Several entries may all be named `pi`; use pane IDs as identity and workspace labels for human-readable names.

### 3. Read recent evidence

For every selected recognized agent, read its recent output, in parallel when possible:

```bash
herdr agent read <pane_id> \
  --source recent-unwrapped \
  --lines 80 \
  --format text
```

Increase to at most 200 lines only when the task or blocker is unclear.

Look for:

- the latest instruction or task;
- completed commands, files, tests, or decisions;
- the latest explicit success or failure;
- questions, approval requests, errors, quota warnings, or restart notices;
- text staged at the prompt but not submitted.

Summarize rather than quoting terminal dumps. Redact credentials, tokens, private messages, and unrelated personal information.

### 4. Classify conservatively

Herdr's `agent_status` is authoritative for live state. Terminal history explains the work but does not override that state.

- **working** — Herdr reports `working`. Describe only the operation supported by recent output. If it is not visible, say so.
- **idle** — Herdr reports `idle`. Distinguish completed work, waiting for a user answer, and a blank agent needing a task.
- **done** — Herdr reports `done`. Summarize the finished result and say it is ready for review or a new instruction.
- **blocked** — Herdr reports `blocked`, or recent output clearly shows an approval/question UI. State the exact decision or approval needed.
- **unknown** — Herdr cannot identify or classify the process. Report only observable workspace and pane information.

If text appears at a prompt but no subsequent execution is visible and Herdr remains idle, say it is staged and not running. Never infer current work from a terminal title alone.

Treat errors or missing dependencies as blockers only when they prevent progress. A suggested next step is not automatically a blocker.

### 5. Summarize progress and needs

For each agent, derive:

```text
Status: working | idle | done | blocked | unknown
Task: one short sentence
Progress: latest concrete observable milestone
Needs: none | user decision | approval | restart | dependency | quota attention | review | new task
```

Do not say `Needs: none` when the agent asked a question. If context is insufficient, say that explicitly rather than guessing.

## Response format

Lead with one compact Herdr summary, then keep each agent to two or three short lines:

```text
Herdr: running and compatible · 1 working · 1 idle · 1 done · 2 unknown workspaces

- ci-runner-decision — working
  Comparing CI runner options; completed the repository constraints audit.
  Needs: none.

- feat-reviewer-in-sections — done
  Finished the implementation and verification; ready for review.
  Needs: review or a new task.

Unknown: 2 workspaces have no recognized agent.
```

When the user only asks who is active, return one compact line per agent and omit history.

## Optional diagnostics

Use only when ordinary output is insufficient:

```bash
herdr agent explain <pane_id>
herdr tab list
herdr api snapshot
```

`api snapshot` is a noisy fallback; extract only relevant fields.

## Safety checklist

Before responding, verify:

- The current pane was excluded by `HERDR_PANE_ID` unless explicitly requested.
- Every other recognized agent was checked using its pane ID.
- Live Herdr status was not confused with terminal history.
- Staged input was not reported as running.
- Unknown workspaces were counted without invented identities.
- No focus, pane, prompt, key, restart, update, start, stop, or close command was used.
- Sensitive terminal content was not reproduced.
- The final answer is concise and operational.
