---
name: orchestrate-max
description: Executes complex, high-value work through maximum practical specialist coverage, staged multi-agent fan-out, independent review, and integrated validation. Use when the user explicitly invokes `$orchestrate-max`, asks to use every relevant subagent, or requests maximum-depth parallel orchestration. Do not use for routine, tightly coupled, low-risk, or single-step tasks.
---
# Orchestrate Max

Execute a complex task with as many distinct, relevant subagents as practical while preserving clear ownership, bounded coordination, and one integrated result.

## Core Contract

- Create or update `/goal` with the exact user-visible outcome before delegation.
- Execute the task; do not return only a plan unless the user requested planning only.
- Maximize useful specialist coverage, not raw agent count. Use every available custom agent whose expertise maps to a material workstream, then fill genuine gaps with `@explorer`, `@worker`, or `@default`.
- Run independent work concurrently up to the runtime's current capacity. Schedule remaining relevant agents in later waves rather than dropping useful coverage.
- Give every subagent 1-3 concrete tasks, a bounded scope, required skills, an output contract, and a stop condition.
- Keep orchestration state in memory. Do not create scratch plans or orchestration manifests on disk.
- The parent owns task decomposition, wave scheduling, decisions, integration, final validation, and the user-facing response.

## Trigger and Non-Trigger Rules

Use this skill only when:

- the user invokes `$orchestrate-max` or `orchestrate max`;
- the user explicitly asks for all or as many relevant subagents as practical; or
- the task is broad enough to benefit from multiple specialist, implementation, and review waves and the user requests maximum-depth orchestration.

Do not use it when:

- one agent can complete the work reliably;
- write scopes cannot be separated safely;
- delegation would add no independent evidence or specialist judgment;
- the task is a small answer, edit, diagnosis, or lookup; or
- the user restricts delegation, tool use, time, or cost in a conflicting way.

If maximal orchestration is unnecessary, explain briefly and use `$orchestrate` or execute directly.

## Discovery and Coverage Map

Before spawning, perform a compact routing pass:

1. Read the applicable repository instructions and the minimum relevant task context.
2. Inspect the configured custom-agent registry when available. Treat names and descriptions as routing evidence, not permission to exceed the user's scope.
3. Decompose the request into material workstreams such as repository discovery, architecture, security, data, backend, frontend/UX, infrastructure, testing, documentation, current-source research, and independent review.
4. Build an in-memory coverage map with one primary owner per workstream and reviewers only where independent scrutiny adds value.
5. Select all relevant specialist agents. Add built-in agents only for uncovered work:
   - `@explorer` for specific read-only codebase questions;
   - `@worker` for bounded implementation or test ownership;
   - `@default` for synthesis or a gap without a specialist.
6. Omit agents whose expertise is unrelated, duplicative, or blocked by missing permissions. Record meaningful omissions in the final response only when they affect confidence.

## Execution Waves

Compose only the waves the task needs, but prefer full lifecycle coverage for build work.

### Wave 1: Parallel Evidence

- Fan out disjoint discovery, current-source research, repository mapping, and requirements checks.
- Use repository-mandated discovery tools first. Treat retrieval results as leads and verify material claims in current files or authoritative sources.
- Continue parent work that does not depend on the agents; wait only when results block the next wave.

### Wave 2: Specialist Decisions

- Assign relevant specialists to architecture, security, data, UX, infrastructure, API, or domain decisions.
- Require explicit assumptions, trade-offs, constraints, and actionable recommendations.
- Have the parent resolve conflicts before write-heavy work starts. Ask the user only when a missing decision materially changes scope, safety, or externally visible behavior.

### Wave 3: Fork-Join Implementation

- Split implementation into disjoint file, module, or artifact ownership.
- Tell every write-capable agent that others are editing concurrently, it must not revert others' work, and it must adapt to current files.
- Avoid concurrent edits to shared registries, lockfiles, broad configuration, or the same source file. Reserve integration-sensitive files for the parent or one named owner.
- Reuse a specialist for implementation only when its configured role permits changes; otherwise assign a worker with the specialist's handoff.

### Wave 4: Independent Verification

- Use agents not responsible for the implementation to inspect correctness, regressions, safety, maintainability, and task-specific quality.
- Run mapped tests and validation commands. Never claim a test, review, citation, visual inspection, or external check that did not occur.
- For high-risk or user-facing artifacts, include an adversarial or negative-path reviewer when a relevant agent exists.

### Wave 5: Repair and Integration

- Triage review findings by severity and evidence.
- Run at most one targeted repair wave by default. A second repair wave is allowed only for a remaining blocking defect with a clear, bounded fix.
- Re-run affected validation after any repair or integration edit.
- Integrate results into one coherent outcome; do not expose a pile of conflicting subagent handoffs.

## Concurrency and Capacity

- Determine the runtime's active-agent and depth limits before scheduling.
- Keep the parent slot free. Fill the remaining concurrent slots with independent relevant work.
- When relevant agents exceed available slots, use priority-ordered waves: blockers first, implementation owners next, then independent reviewers.
- Prefer reusing an agent when follow-up depends on its local context. Prefer a fresh independent agent for review.
- Do not spawn duplicate agents merely to vote. Parallel agents must contribute distinct evidence, ownership, or review dimensions.
- Stop spawning when every material workstream has an owner and additional agents would be redundant or unable to act within permissions.

## Subagent Prompt Contract

Every spawn prompt must include:

```text
@agent-name

Objective: [one delegated outcome]

Context: [minimum task facts, repository scope, dependencies, and constraints]

Use skills: Invoke [$skill-name] when required; otherwise state none.

Tasks:
1. [concrete task]
2. [optional concrete task]
3. [optional concrete task]

Boundaries:
- [read, edit, test, network, or connector permissions]
- Ownership: [exact files, modules, artifacts, or read-only question]
- Do not work outside this scope.
- If editing, do not revert others' work; adapt to concurrent changes.

Return:
- Outcome and evidence in 3-7 bullets.
- Changed paths or source references.
- Validation performed and exact failures.
- Remaining risks or blockers.

Stop when [clear completion or blocker condition].
```

Do not send the full parent transcript when a smaller context package is sufficient.

## Skill Routing

- Explicitly name an available `$skill-name` in a subagent prompt when that workflow applies.
- Use document, PDF, presentation, spreadsheet, image, website, OpenAI documentation, Gmail, Calendar, or repository-retrieval skills only for matching workstreams.
- Use repository-local authoring skills for skills, agents, plugins, and governed SWE artifacts.
- Do not invent skill or tool names. If a needed capability is unavailable, assign the nearest safe role and state the limitation.
- A skill may narrow permissions or prescribe validation; orchestration never overrides it.

## Tool, Retry, and Safety Rules

- Read-only discovery is allowed within the user's stated scope. Mutations require user authority and agent permissions.
- Do not deploy, publish, send messages, mutate external services or production data, expose secrets, delete user work, force-push, or perform destructive actions without explicit authorization.
- Parallelize tool calls only when independent and safe. Never run concurrent destructive or overlapping write operations.
- Validate tool arguments and outputs. Never assume a tool or subagent succeeded from its invocation alone.
- Retry a replay-safe transient failure once after changing or confirming the strategy. Do not automatically retry side-effecting operations without guaranteed idempotency.
- After repeated failure, narrow scope, use a safe fallback, or report the blocker. Never loop indefinitely.

## Stop Rules

Stop orchestration when:

- the `/goal` success criteria are met and affected validation passes;
- all material workstreams have been integrated and further delegation is redundant;
- a critical decision, permission, dependency, or fact is missing and cannot be safely inferred;
- repeated tool or agent failure prevents meaningful progress; or
- the next action would exceed the user's scope or require unapproved side effects.

When stopped short, preserve completed work and report the exact blocker, affected workstreams, validation not run, and next required decision.

## Validation

Before finalizing, confirm:

- `/goal` represents the user's actual outcome;
- every material workstream had a relevant owner or an explained omission;
- every subagent received 1-3 tasks, boundaries, skills, output, and stop conditions;
- parallel write ownership was disjoint;
- specialist findings were reconciled before integration;
- independent review and task-appropriate tests ran where available;
- repairs were followed by affected validation;
- no scratch orchestration files or unapproved side effects were created;
- completion claims match actual evidence.

## Output

Return:

- outcome first;
- the major agent waves and each meaningful contribution;
- files, artifacts, or external state changed;
- validation and review results;
- omitted relevant coverage, unresolved risks, or the next required action.

Keep the response concise. Do not include hidden reasoning, raw logs, or full subagent prompts unless requested.
