# [PLATFORM_NAME]

[ONE_PARAGRAPH_PLATFORM_PURPOSE_AND_PORTFOLIO_SCOPE]

This is the portfolio authority repository. It defines why the platform exists, what work is accepted, which cross-solution boundaries are durable, and where implementation is allocated. Child solution repositories own their local architecture and delivery.

## Start Here

- [Agent governance](./AGENTS.md)
- [Context map](./CONTEXT-MAP.md)
- [Platform architecture](./architecture/README.md)
- [Engineering work](./.swe/README.md)
- [Child solutions](./repos/README.md)
- [Version](./VERSION.md)

## Repository Model

```text
portfolio intent and architecture
  -> Epic and accepted Concept
  -> canonical Feature
  -> portfolio-owned Implementation Plan
  -> child Solution Design, implementation Evidence, and local Validation
  -> independent feature-validator makes the portfolio Feature acceptance decision
  -> architecture promotion
```

The portfolio owns the canonical Feature and its adjacent `IMPLEMENTATION-PLAN.md`. Solution repositories link to both using stable artifact IDs plus repository-relative paths and, when available, a revision; they do not copy either artifact. Systems are documented as architecture views, not as a separate hierarchy level.

## Goal Completion Wrap-Up

When an installed goal-completion hook requests `$repo-wrap-up`, the workflow assigns the repository's `repo-author` agent and falls back to a built-in `worker` subagent only when that role is unavailable. The wrap-up reviews completed-goal Git changes and relevant portfolio artifacts, reconciles this README, updates [AGENTS.md](./AGENTS.md) only when durable governance changed, runs repository checks, and pauses with exact paths for user review. It does not stage, commit, push, tag, release, deploy, change versions, rewrite history, or include ambiguous unrelated changes.

## Extending This Scaffold

Replace bracketed placeholders in the [context map](./CONTEXT-MAP.md) and repository documentation, register child solutions in [`repos/`](./repos/README.md), and create governed work through the `swe-process` skills. Preserve the layout and approval rules in [AGENTS.md](./AGENTS.md); add narrower `AGENTS.md` files only when a subtree needs durable additional governance.
