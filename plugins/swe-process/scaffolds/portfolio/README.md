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

## V3 Workflow

Start with `$swe-scaffold -portfolio`, then use `$swe-max` for an Epic: frame the outcome, reuse research, review Concept/Impact together, establish affected architecture, and allocate each Feature/Plan pair. Eligible assignments can advance while unrelated decisions wait. The coordinator keeps pre-code gates and validated prerequisites explicit.

Child developers implement and author tests; `$swe-test` dispatches bounded execution to `test-runner` (Luna, medium). Risky and prerequisite behavior is checked early. Accepted isolated reversible work may batch tests at the Epic implementation checkpoint. Child Evidence distinguishes implementation-complete, verification-pending, and independently accepted delivery. Local validation and the portfolio Feature decision remain separate.

Scaffolding creates missing files only. Existing customized governance is not upgraded by rerunning it. Review the installed `swe-process/references/V3-MIGRATION.md` instructions and migration diff helper, record a deliberate policy adoption boundary, and preserve prior decisions and packages for rollback. Fresh V3 governance retains human approval until an owner records a different permitted policy. Before first execution, verify the host resolves the configured tester and installed `$swe-test`; file presence alone is insufficient.

## Goal Completion Wrap-Up

When an installed goal-completion hook requests `$repo-wrap-up`, the workflow assigns the repository's `repo-author` agent and falls back to a built-in `worker` subagent only when that role is unavailable. The wrap-up reviews completed-goal Git changes and relevant portfolio artifacts, reconciles this README, updates [AGENTS.md](./AGENTS.md) only when durable governance changed, requests repository checks through `$swe-test`, and pauses with exact paths for user review. It does not stage, commit, push, tag, release, deploy, change versions, rewrite history, or include ambiguous unrelated changes.

## Extending This Scaffold

Replace bracketed placeholders in the [context map](./CONTEXT-MAP.md) and repository documentation, register child solutions in [`repos/`](./repos/README.md), and create governed work through the `swe-process` skills. Preserve the layout and approval rules in [AGENTS.md](./AGENTS.md); add narrower `AGENTS.md` files only when a subtree needs durable additional governance.
## V3.1 assistance

The installed `swe-process` package's `references/V31-HELPERS.md` describes read-only canonical packet preparation and consolidated adoption preflight. Use reviewed findings and actual host smoke evidence; generated output never grants acceptance or changes repository governance.
