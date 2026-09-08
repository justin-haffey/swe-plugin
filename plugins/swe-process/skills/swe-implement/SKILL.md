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
3. Verify every Implementation-entry prerequisite from the Plan and Design: `ApprovedContractOrDesign` requires current accepted bytes; `ValidatedBehavior` requires independently Accepted Validation and passing attributable evidence for the behavior/generation consumed. Missing risk/dependency information blocks coding. Inventory dirty worktree state, preserve unrelated changes, and confirm planned files and permissions before side effects.
4. Implement the smallest coherent change, including tests and necessary local documentation. Do not mutate portfolio-owned artifacts.
5. Request all repository-native format, lint, build, test, security, integration and browser execution through `$swe-test` to `test-runner` (`gpt-5.6-luna`, `medium`). The developer authors tests and fixes failures; the tester executes bounded checks and returns immutable receipts. Acquire a single builder slot over shared output/dependency closure, including upstream outputs rebuilt by consumers; release with the actual receipt/generation. Reuse only applicable current receipts; invalidate affected checks after source/test/fixture/configuration/runtime/dependency changes.
6. Write or update `.swe/implementations/EPIC-NNN/FEATURE-NNN/EVIDENCE.md` from [references/EVIDENCE-TEMPLATE.md](references/EVIDENCE-TEMPLATE.md), preserving covered `AC-NNN` IDs verbatim and recording receipt locators, actual generation, implementation progress, pending obligations and deviations. Evidence is `Draft` while required observations are missing; `Complete` requires all observations/results/coverage, and required failures still prevent accepted delivery. Derive acceptance only from independent Validation.
7. Record deviations from Design. If a deviation changes accepted architecture or a cross-solution contract, stop for review before continuing.

No invocation grants destructive commands, credential access, publishing, deployment, dependency upgrades, or external mutations unless those actions are separately authorized. Do not retry non-idempotent side effects automatically.

## Timing and handoff

Apply the effective recorded adoption/run policy, preserving existing in-flight policy. Only independently confirmed isolated, reversible `Minimal` work with no prerequisite consumer may defer eligible behavioral checks to the actual Epic implementation checkpoint. Record each obligation's criteria, rationale, owner and due checkpoint; mandatory structural/build checks remain. `Standard` required checks precede Feature completion. Public contracts, security, persistence/migration, concurrency, operational/irreversible effects and foundational prerequisites require early tests regardless of a Minimal label. Unknown risk favors earlier checks. Revoke deferral and reconcile affected approvals if scope or consumers change. Standalone work must finish required checks before closure.

Implementation-complete may coexist with Draft Evidence and pending verification; it never satisfies `ValidatedBehavior` or accepted delivery. Return changed paths, receipts, generation, Evidence progress, pending obligations, deviations and residual risk. Independent `$swe-validate` controls acceptance; a green tester receipt cannot self-approve it.
