---
name: swe-design
description: Create an implementation-ready DESIGN.md in a solution repository for that repository's assigned portion of a portfolio Feature.
---

# Design

Design only the active solution repository's assignment. Do not redefine the portfolio Feature or parent architecture.

The portfolio `IMPLEMENTATION-PLAN.md` is an allocation and handoff input, not the coding phase. This skill produces the local Design only; `$swe-implement` is the following coding phase after Design acceptance.

Apply the lifecycle, approval, locator-chain, and acceptance-ID rules in [the artifact contract](../../references/ARTIFACT-CONTRACT.md).

## Workflow

1. Resolve the active repository's assignment through dual locators to the authoritative `EPIC.md`, `FEATURE.md`, and `IMPLEMENTATION-PLAN.md`. Verify that the Plan assigns work to this repository. Require both the Feature and Implementation Plan to be `Accepted`.
2. Read applicable solution, package, and module architecture plus current code and tests. Require applicable architecture to have an `Accepted` Approval Record before designing.
3. Write `.swe/implementations/EPIC-NNN/FEATURE-NNN/DESIGN.md` from [references/DESIGN-TEMPLATE.md](references/DESIGN-TEMPLATE.md). Generate mechanical metadata/locators using [artifact generation](../../references/ARTIFACT-GENERATION.md); reference approved upstream intent and author only local choices, alternatives, risks, and concrete proof obligations.
4. Specify behavior, components, data, interfaces, failure handling, security, migration, observability, tests, rollout, and file-level change boundaries.
5. If implementation requires contradicting architecture or a cross-solution contract, record the divergence and stop for architecture review.
6. Validate traceability from every assigned `AC-NNN` to concrete tests, fixtures, expected observations, actual participant/operation, and receipt locations. Preserve IDs. Record risk, dependencies by entry phase and `ApprovedContractOrDesign`/`ValidatedBehavior`, required checks/timing, and the policy locator. Verify real participants and jointly reachable limits. Missing dependency/risk information blocks eligibility. An independent reviewer must confirm Minimal isolation/reversibility and deferral; public contracts, security, persistence, concurrency, operations, and prerequisite behavior require early checks. Revoke deferral when scope or consumers change.

Do not change product source, tests, or `EVIDENCE.md` as part of this workflow.

## Approval

Default to human approval unless an owner-adopted risk policy or explicit run authorization applies; Major decisions retain named-human approval. `-auto-approve` uses an independent architecture reviewer or appropriate architect; no self-approval. Review an immutable packet and verify correspondence before acceptance. Preserve the maximum two repair/review cycles across resumes, then require human disposition. `-force` records an explicit human bypass. Any agent-directed test, build, static, or browser execution goes through `$swe-test`; the Design reviewer still judges adequacy.

Only an `Accepted` Design is ready for the ordinary `$swe-implement` handoff. Return the design path, approval state, traceability, risks, and blockers.
