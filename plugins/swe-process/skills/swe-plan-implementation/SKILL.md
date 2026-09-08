---
name: swe-plan-implementation
description: Allocate a portfolio Feature to responsible solution repositories, packages, and modules through a cross-repository implementation handoff.
---

# Plan Implementation

Create the formal portfolio-to-solution handoff without specifying classes, methods, algorithms, or local design.

Apply the lifecycle, approval, locator, and acceptance-ID rules in [the artifact contract](../../references/ARTIFACT-CONTRACT.md).

## Workflow

1. Resolve `FEATURE.md`, platform architecture, affected solution architecture locators, and contracts. Require Accepted inputs for ordinary allocation. A shared Feature/Plan authoring packet may draft allocation against the paired unaccepted Feature, explicitly marking that gate unresolved; the Feature must be Accepted before Plan approval or child dispatch. Applicable architecture still requires an Accepted Approval Record.
2. For each implementing repository, define a stable assignment ID, exact checkout/write scope, outcome, package/module hints, contract obligations, prerequisites, risk/rationale, required checks/timing, policy locator, and evidence expected back. Preserve every `AC-NNN` ID. Declare each dependency's entry phase and requirement `ApprovedContractOrDesign` or `ValidatedBehavior`; missing or cyclic dependencies block affected work. Verify real participant availability, authorized work, contract limits, and integration ownership before freezing allocation.
3. Write `IMPLEMENTATION-PLAN.md` beside the Feature using [references/IMPLEMENTATION-PLAN-TEMPLATE.md](references/IMPLEMENTATION-PLAN-TEMPLATE.md). Use [artifact generation](../../references/ARTIFACT-GENERATION.md) for metadata, shared criterion rows, and locator chains; author allocation choices and tradeoffs.
4. Use dual locators for every assignment: repository identifier or URL, artifact ID, repository-relative path, and optional revision. Add a Markdown link when the target is reachable.
5. In each child, the expected local workspace is `.swe/implementations/EPIC-NNN/FEATURE-NNN/`; do not create or copy the Feature there.
6. Validate that every criterion has an owner, concrete proof, and integration path. Minimal work may defer behavioral tests only when independently confirmed isolated/reversible, non-prerequisite, and allowed by policy. Mandatory checks still apply. Design dispatch needs its own approved inputs; coding additionally needs Accepted local Design and implementation prerequisites. An unrelated waiting Plan is no global barrier.

## Approval

Default to human approval unless adopted risk policy or explicit run authorization applies; Major decisions retain named-human approval. `-auto-approve` requires an independent `integration-engineer` or `architecture-reviewer`; no self-approval. Co-review the Feature/Plan immutable packet with a qualified Feature reviewer, recording two separate decisions in dependency order. Confirm deferral eligibility and verify reviewed fingerprints before acceptance. Preserve the maximum two repair/review cycles and their durable history across resumes. `-force` records an explicit human bypass. Route check execution through `$swe-test`.

Return the plan path, approval state, assignments, dependencies, and unresolved ownership.
