---
name: swe-plan-implementation
description: Allocate a portfolio Feature to responsible solution repositories, packages, and modules through a cross-repository implementation handoff.
---

# Plan Implementation

Create the formal portfolio-to-solution handoff without specifying classes, methods, algorithms, or local design.

Apply the lifecycle, approval, locator, and acceptance-ID rules in [the artifact contract](../../references/ARTIFACT-CONTRACT.md).

## Workflow

1. Resolve the `Accepted` `FEATURE.md`, platform architecture, affected solution architecture locators, and contracts. Require every applicable architecture artifact to have an `Accepted` Approval Record before allocating implementation.
2. For each implementing repository, define the assigned outcome, boundaries, package/module hints, dependencies, contract obligations, sequencing, and evidence expected back. Preserve every covered `AC-NNN` ID verbatim.
3. Write `IMPLEMENTATION-PLAN.md` beside the Feature using [references/IMPLEMENTATION-PLAN-TEMPLATE.md](references/IMPLEMENTATION-PLAN-TEMPLATE.md).
4. Use dual locators for every assignment: repository identifier or URL, artifact ID, repository-relative path, and optional revision. Add a Markdown link when the target is reachable.
5. In each child, the expected local workspace is `.swe/implementations/EPIC-NNN/FEATURE-NNN/`; do not create or copy the Feature there.
6. Validate that every acceptance criterion has an owner and integration path.

## Approval

Default to human approval. `-auto-approve` requires an independent `integration-engineer` or `architecture-reviewer`; no self-approval. Permit two reject/repair cycles, then require a human. `-force` records an explicit human bypass. Repository policy applies unless an invocation flag overrides this workflow.

Return the plan path, approval state, assignments, dependencies, and unresolved ownership.
