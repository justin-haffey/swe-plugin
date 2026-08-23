---
name: swe-implement
description: Implement an accepted solution-local DESIGN.md with scoped source, tests, documentation, and repository evidence.
---
# Implement

Transform an accepted Design into executable software within the active repository's authority.

This is the coding phase after Design. The portfolio `IMPLEMENTATION-PLAN.md` remains the upstream allocation and handoff; it is not the implementation output.

Apply the locator-chain and acceptance-ID rules in [the artifact contract](../../references/ARTIFACT-CONTRACT.md). Evidence is non-decision-bearing.

## Workflow

1. Resolve the accepted local `DESIGN.md` as the immediate input to the coding phase. Follow its parent, upstream, and traceability locators to the authoritative `EPIC.md`, accepted portfolio `IMPLEMENTATION-PLAN.md`, and accepted `FEATURE.md`; verify that the Design covers this repository's assignment, then read applicable architecture with an `Accepted` Approval Record, ADRs, contracts, and local `AGENTS.md` instructions.
2. If the Design is missing, not `Accepted`, `Superseded`, or inconsistent with its upstream assignment, stop and return to `$swe-design` or the owning upstream workflow. Do not create or revise `DESIGN.md` in this implementation workflow.
3. Inventory dirty worktree state and preserve unrelated changes. Confirm the planned files and permissions before side effects.
4. Implement the smallest coherent change, including tests and necessary local documentation. Do not mutate portfolio-owned artifacts.
5. Validate incrementally with repository-native format, lint, build, test, security, and integration checks proportional to risk.
6. Write or update `.swe/implementations/EPIC-NNN/FEATURE-NNN/EVIDENCE.md` from [references/EVIDENCE-TEMPLATE.md](references/EVIDENCE-TEMPLATE.md), preserving covered `AC-NNN` IDs verbatim.
7. Record deviations from Design. If a deviation changes accepted architecture or a cross-solution contract, stop for review before continuing.

No invocation grants destructive commands, credential access, publishing, deployment, dependency upgrades, or external mutations unless those actions are separately authorized. Do not retry non-idempotent side effects automatically.

Evidence does not self-approve. Return changed paths, tests, evidence path, deviations, and residual risk.
