---
name: prove-it-works
description: >
  Verify finished work against the real artifact before calling it done.
  Use after a task, or when another skill needs the rule that a real test run,
  a command and its output, or the real interface is the proof. Compiling is not proof.
disable-model-invocation: true
---

# Prove It Works

Do not call work done until you have checked the real artifact.

A clean compile is not proof. A guess, a cached result, or a claim that the work is done is not proof.

Proof is one of these:

- The tests ran, and that run is shown.
- The command ran, and its output is shown.
- The real interface was used, and what it did is shown.

Check the thing itself. Read the value, not a copy or a summary of the value. If a process must be up, look at the process.

When the check can be a command, run that command and keep the output. Someone else should be able to run it again.

If the check fails, question the check before you question the system.
