# [SOLUTION_NAME]

[ONE_PARAGRAPH_SOLUTION_PURPOSE_AND_BOUNDARY]

This repository implements one Solution within a portfolio. The upstream portfolio defines Epics, Concepts, platform contracts, and canonical Features. This repository owns Solution, Package, and Module architecture plus Design, code, tests, and delivery evidence.

## Start Here

- [Agent governance](./AGENTS.md)
- [Solution architecture](./architecture/README.md)
- [Implementation work](./.swe/README.md)
- [Context vocabulary](./CONTEXT.md) (replace with a root `CONTEXT-MAP.md` only when the Solution expands to multiple bounded contexts)
- [Version](./VERSION.md)

## Delivery Model

```text
upstream canonical Feature
  -> upstream portfolio Implementation Plan
  -> accepted local architecture and Design
  -> code, tests, and EVIDENCE
  -> independent solution-validator produces local VALIDATION
  -> architecture reconciliation and upstream handoff
```

Every implementation scope retains dual locators for the upstream Feature and its portfolio-owned Implementation Plan. A local artifact may refine implementation, but it does not copy or redefine upstream intent or allocation. Developers author tests and request `$swe-test` execution through Luna/medium `test-runner`, then produce Evidence; an independent `solution-validator` makes the formal local validation decision.

## V3 Workflow

Start with `$swe-scaffold -solution`. Resolve the upstream Feature and Plan, prepare local Design from approved intent, and begin coding only after Design, applicable architecture, and required prerequisite gates permit it. Use a suitable developer for the affected scope; use `$swe-bugfix` or `$swe-enhancement` for eligible bounded local work.

Developers own source and tests. Run `$swe-test <Feature, Design, or local-change scope>` for bounded execution by `test-runner` (Luna, medium). High-risk and prerequisite behavior is checked early. Accepted isolated reversible work can defer checks to the Epic implementation checkpoint. Keep incomplete Evidence Draft, record pending checks, and distinguish implementation-complete from acceptance. An independent solution-validator assesses complete relevant evidence, controls any additional tester invocation, and hands the local decision upstream.

Scaffolding creates missing files only. Existing governance and custom agents remain unchanged until an explicitly scoped migration applies reviewed differences. Use the installed `swe-process/references/V3-MIGRATION.md` guide and diff helper; preserve IDs, accepted history, local MCP/settings, and prior packages. Fresh V3 governance keeps human approval until an owner records another permitted policy. Verify actual host tester resolution and `$swe-test` availability before relying on execution.

## Goal Completion Wrap-Up

When an installed goal-completion hook requests `$repo-wrap-up`, the workflow assigns the repository's `repo-author` agent and falls back to a built-in `worker` subagent only when that role is unavailable. The wrap-up reviews completed-goal Git changes and relevant solution artifacts, reconciles this README, updates [AGENTS.md](./AGENTS.md) only when durable governance changed, requests repository checks through `$swe-test`, and pauses with exact paths for user review. It does not stage, commit, push, tag, release, deploy, change versions, rewrite history, or include ambiguous unrelated changes.

## Extending This Scaffold

Replace bracketed placeholders in [CONTEXT.md](./CONTEXT.md) and repository documentation, then register the upstream portfolio Feature and Plan in implementation artifacts. If the Solution later expands to multiple bounded contexts, follow the migration contract in `CONTEXT.md`: preserve its stable ID under `.swe/context/`, create a distinct root `CONTEXT-MAP.md`, and use the map as the sole root entry point. Preserve the layout and approval rules in [AGENTS.md](./AGENTS.md); add narrower `AGENTS.md` files only when a subtree needs durable additional governance.
## V3.1 assistance

The installed `swe-process` package's `references/V31-HELPERS.md` describes read-only canonical packet preparation and consolidated adoption preflight. Use reviewed findings and actual host smoke evidence; generated output never grants acceptance or changes repository governance.
