---
name: swe-max
description: Coordinate explicitly requested standalone Feature or related portfolio/Epic delivery with minimal paperwork and independent acceptance.
---
# SWE Max

Invoke explicitly with `$swe-max "<outcome>"`, `-feature <path-or-ID>` or `-epic <path-or-ID>`. Resolve mode from AGENTS.md; an idea in a standalone solution starts a local Feature, not a portfolio. Do not activate implicitly.

## Bootstrap

Resolve exact repository, ownership, existing work and effective approval policy. Explicit invocation authorizes bounded reversible repository work and qualified subagent delegation; dedicated child tasks and worktrees still require host/user authorization. Deployment, publication, external changes and Git history are separate.

Use the host's formal Goal when supported. The primary coordinator owns one Goal; if a user already established the matching active Goal, continue it rather than creating a duplicate. Never adopt an unrelated Goal. Children use bounded tasks, not Goals. If formal Goals are unavailable, ordinary local work may use the user's explicit task and durable canonical artifacts; report the capability boundary without inventing a host Goal.

## Execute

Read [the delivery contract](../../references/ARTIFACT-CONTRACT.md), then [orchestration](references/ORCHESTRATION.md). Read applicable context once, refresh changed inputs, expand only when needed. Maintain the next eligible action, not a new paperwork subsystem.

1. Standalone: define local Feature/outcome/approach; use relevant accepted architecture or establish the new Solution baseline. Obtain required pre-code decisions, implement, collect checks/Evidence, and request independent Validation. Optional Epic only for related Features.
2. Portfolio: define shared outcome/Features, actual participants/contracts and allocation. Create research/Concept/impact/separate Plans only for real decision needs. Bridge eligible assignments to exact child contexts; retain child-owned records. Local decisions feed portfolio integration acceptance.
3. Select only needed roles, with explicit file ownership and independence. Parallel work is useful only for disjoint ownership and actual dependency readiness. Review existing decisions rather than creating a new chain for each agent.
4. Developers implement and repair; configured test-runner executes swe-test; validators assess adequacy. Reuse current evidence and rerun affected checks. Resolve material architectural findings, not a mandatory new analysis report for every task.
5. Verify Implementation complete, Verification complete, then Delivery accepted (or all required local/integration decisions for Epic acceptance). Apply [completion](references/COMPLETION-CONTRACT.md) before reporting success or updating the Goal.

Human approval remains default; explicit auto-approve or adopted policy preserves named independent reviewers, Major human decisions and the two-cycle limit. Never infer force or skip missing evidence to finish. Return concise progress and canonical locators.
