---
name: tech-concept
description: >
  Write or review an implementation-ready technical concept for a software change.
  Use when the user asks for a technical concept, engineering concept, implementation concept,
  architecture proposal, feature breakdown, estimates, or asks to turn requirements into a
  technical plan. This is design-only unless the user explicitly asks to implement.
disable-model-invocation: true
---

# Tech Concept

A tech concept is an **implementation handoff for a software change**. It connects desired behavior to concrete code paths, code-shaped contracts, migration/runtime concerns, release strategy, estimates, and tests.

This skill is design-only. Do **not** implement code changes while using this skill unless the user explicitly asks for implementation after the concept is complete.

## Core principle

Write the concept from the repository outward:

1. user, maintainer, or business intent;
2. current code and data model;
3. affected entrypoints and boundaries;
4. proposed contracts and call stacks;
5. rollout, testing, risks, and estimate.

Do not invent architecture. Unknowns remain open questions.

## Branch selection

### Path A: Convert available context to a concept

Use this when the conversation, issue, docs, or repository contain enough context to draft an implementation-ready concept.

### Path B: Grill first

Use this when the user wants a concept but the problem, desired behavior, constraints, affected systems, or acceptance criteria are unclear.

Ask one question at a time. If the answer can be found by inspecting the repository, inspect the repository instead of asking.

### Path C: Review an existing concept

Use this when the user already has a technical concept, design doc, spec, architecture proposal, or implementation plan and wants feedback, validation, gaps, risks, or a readiness review.

Completion criterion: choose the path from actual available context, not from assumptions.

## Path A: Convert available context to a concept

### 1. Load repository standards and local context

Inspect only the relevant local context:

- root contribution or agent guide files;
- nearest guide files in affected subtrees;
- package scripts and test commands;
- existing implementations of similar features;
- existing endpoint, command handler, service, storage, component, state, event, migration, and test patterns;
- existing docs or concepts for related features.

Prefer current code over prose when they disagree.

Completion criterion: the concept uses project vocabulary, module boundaries, validation style, test style, and runtime patterns already present in the repo.

### 2. Extract the user and engineering problem

Capture:

- current state;
- problem;
- users/callers;
- goals;
- non-goals;
- constraints;
- invariants;
- affected systems;
- likely entrypoints;
- operational/runtime concerns;
- risks;
- open questions.

Mark uncertain requirements as open questions. Do not silently choose desired behavior.

Completion criterion: every requirement is grounded in user-provided context, repository evidence, or an explicit open question.

### 3. Find current code seams

For every affected area, identify current seams before proposing new ones. Adapt the names to the repository's architecture:

```txt
user/system entrypoint
  -> UI state, CLI handler, API client, or message consumer
  -> network/process boundary, if any
  -> boundary parser / validation
  -> authorization / capability check, if any
  -> application/domain module
  -> persistence, platform, or external adapter
  -> transaction/runtime side effect
  -> response/projection
  -> realtime notification, email, job, metrics, or audit side effect, if any
```

If the repo uses different names or does not have one of these layers, use the repo's names and omit layers that do not exist.

Completion criterion: proposed changes are attached to real files/modules or called out as new modules.

### 4. Split scope before designing details

Large concepts must be split into independently reviewable and releasable slices. Prefer vertical slices over horizontal layers.

For each slice, define:

- user-visible behavior;
- server/API/worker changes, if any;
- client/UI changes, if any;
- data/migration changes;
- runtime or async processing;
- feature flag, beta flag, config switch, or rollout strategy;
- tests;
- estimate;
- dependencies and blockers.

Completion criterion: no slice should require the entire feature to be finished before it can be reviewed, tested, or released unless that is explicitly unavoidable.

### 5. Explore alternatives

Produce materially different alternatives before choosing the recommendation. Alternatives should differ by API shape, data model, ownership boundary, runtime topology, or rollout strategy.

For each alternative, sketch:

- domain/state model;
- public or module interfaces;
- request/response shape;
- persistence projection;
- call stack;
- failure and authorization handling;
- testing strategy;
- tradeoffs.

Compare on:

- caller burden;
- locality of invariants;
- migration risk;
- compatibility with current code;
- testability;
- operational fit;
- implementation complexity;
- incremental delivery.

Completion criterion: recommendation is chosen after comparison, not before.

### 6. Specify code-shaped contracts

Use the repository's implementation language and contract style. Inspect the codebase first, then match its conventions:

- TypeScript repos: types, interfaces, discriminated unions, runtime codecs where used.
- JavaScript repos: JSDoc typedefs, validation schemas, object-shape examples, or the local schema library.
- Python repos: dataclasses, Pydantic models, TypedDicts, or protocol-style signatures.
- Go/Rust/Java/C# repos: native structs/enums/interfaces and error/result types.
- Config or API-only changes: JSON Schema, OpenAPI, protobuf, GraphQL SDL, or documented payload examples.

Specify every new or changed:

- domain value;
- enum / state machine;
- request body;
- response body;
- endpoint, command, or message-handler signature;
- function signature;
- hook/component props, CLI options, or SDK parameters;
- repository/storage DTO;
- persistence document/projection;
- realtime/event payload;
- background job/message payload;
- metrics/audit/telemetry event;
- expected error.

Prefer precise contracts over boolean bags and loosely shaped objects.

Example shapes, adapted to the repository style:

```js
// JavaScript + runtime schema example
const OperationTargetSchema = z.discriminatedUnion("kind", [
  z.object({ kind: z.literal("single"), id: EntityIdSchema }),
  z.object({ kind: z.literal("filtered-query"), filter: z.record(z.unknown()) }),
  z.object({ kind: z.literal("explicit-list"), ids: z.array(EntityIdSchema) }),
]);

const ExpectedFailureSchema = z.discriminatedUnion("kind", [
  z.object({ kind: z.literal("not-authorized") }),
  z.object({ kind: z.literal("not-found"), resource: z.string(), id: EntityIdSchema }),
  z.object({ kind: z.literal("invalid-state"), reason: z.string() }),
]);
```

```go
// Go example
type OperationTarget struct {
    Kind   string
    ID     EntityID
    Filter map[string]any
    IDs    []EntityID
}
```

Completion criterion: every changed boundary has a concrete contract or an explicit reason no new contract is needed.

### 7. Specify call stacks and data flow

For each behavior, show current and proposed flow from entrypoint to side effects and response.

Use this shape:

```txt
raw input
  -> boundary DTO / unknown
  -> parser / validation
  -> canonical application input
  -> authorization
  -> service/module call
  -> storage/adapter call
  -> transaction / runtime side effect
  -> domain result or expected failure
  -> projection / event / response
```

Include when relevant:

- validation rejection;
- authorization rejection;
- not-found and invalid-state failures;
- transactions;
- idempotency;
- retry/cancellation;
- background jobs;
- realtime/email/metrics/audit events;
- observability and safe logging.

Completion criterion: every new or changed behavior has an end-to-end flow.

### 8. Define release and rollout

Include:

- feature flag / beta flag / config switch;
- migration order;
- backwards compatibility;
- mixed-version behavior;
- rollback plan;
- data backfill or cleanup;
- telemetry to verify rollout;
- removal plan for temporary flags or compatibility code.

Completion criterion: the concept can be shipped safely and incrementally.

### 9. Estimate by deliverable slices

Estimate after the design is clear. Use ranges and name assumptions.

For each slice include:

- implementation estimate;
- test/QA estimate;
- uncertainty/risk buffer;
- dependencies;
- what could reduce or increase the estimate.

Avoid one large estimate for a multi-feature concept.

Completion criterion: estimates map to scoped, testable deliverables.

### 10. Write the test plan using RGR TDD slices

Plan vertical Red-Green-Refactor slices. Do not write a horizontal “all tests first, all code later” plan.

Cover proportionately:

- public behavior;
- parser acceptance/rejection;
- permission failures;
- domain invariants;
- persistence changes;
- event/job/email/metrics/audit payloads;
- client/UI state transitions;
- accessibility and responsive behavior where relevant;
- e2e high-value flows;
- rollback or compatibility behavior.

Favor tests through public interfaces and real seams over implementation-coupled mocks.

Completion criterion: each important behavior and failure mode has a test slice or a reason it is not tested.

## Path B: Grill first

If context is insufficient, do not write the full concept yet.

Ask one question at a time and include a recommended/default answer. Continue until you know:

- target users and problem;
- exact behavior and acceptance criteria;
- affected surfaces;
- data and permission rules;
- external systems;
- rollout constraints;
- non-goals;
- expected tests;
- rough deadline or desired slice size.

Then run Path A.

## Path C: Review an existing concept

Do not rewrite the concept by default. Review it against this skill's standard and return actionable feedback.

### Review steps

1. Inspect the concept and the relevant repository context.
2. Check whether the concept is grounded in current code, docs, and conventions.
3. Identify missing or weak sections:
   - problem, goals, non-goals, invariants, and constraints;
   - alternatives and recommendation tradeoffs;
   - code-shaped contracts and expected failures;
   - current and proposed call stacks;
   - file/module map;
   - release, rollout, rollback, and compatibility;
   - RGR TDD test slices;
   - estimates and risk buffers;
   - open questions.
4. Flag mismatches between the concept and current source code.
5. Separate blockers from improvements.
6. Suggest concrete additions, preferably as copy-ready snippets or section outlines.

### Review output shape

```md
## Verdict

## What Works Well

## Blockers Before Implementation

## Important Improvements

## Source-Code Mismatches

## Missing Contracts / Call Stacks

## Missing RGR TDD Slices

## Rollout / Estimate Gaps

## Suggested Additions
```

Completion criterion: the review tells the user whether the concept is implementation-ready, what is missing, and exactly what to add next.

## Required concept outline

Use this outline unless the task is small enough to compress without losing contracts, flows, rollout, or tests.

```md
# <Feature Name> Technical Concept

## Summary

## Context / Current State

## User / Maintainer Goals

## Non-Goals

## Invariants and Constraints

## Affected Systems

## Current Code Paths

## Scope Split / Delivery Plan

### Slice 1: <name>
### Slice 2: <name>
### Slice 3: <name>

## Alternatives Considered

### Option 1: <name>
### Option 2: <name>
### Option 3: <name>

## Recommendation

## Proposed Design

## Domain Model and Contracts

## API / Boundary Contracts

## Client / UI Contracts

## Persistence, Migrations, and Backfills

## Events, Jobs, Emails, Metrics, Audit, and Observability

## Authorization and Failure Handling

## Call Stacks and Data Flow

### Current Flow
### Proposed Flow
### Failure Flow
### Async / Retry / Idempotency Flow

## Files to Add / Change / Delete

## Release, Rollout, and Rollback

## RGR TDD Test Plan

## Estimate

## Risks and Open Questions
```

Omit sections that truly do not apply, but do not omit code-shaped contracts, call stacks, release plan, tests, or risks merely because they are hard.

## Writing rules

- Code first: contracts, interfaces, payloads, and call stacks define the change.
- Prose explains why.
- Use repository vocabulary and module names.
- Keep seams real: only add adapters for framework, persistence, network, time, randomness, telemetry, runtime, or platform boundaries.
- Prefer vertical slices over large all-or-nothing plans.
- Keep a single source of truth for rules; point to it from other sections.
- State assumptions explicitly.
- Keep open questions visible.
- Do not use confidential company-specific names, links, credentials, or customer data in an open-source skill. If adapting private repository patterns, generalize them.
