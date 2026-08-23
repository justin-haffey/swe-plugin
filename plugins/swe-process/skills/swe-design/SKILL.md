---
name: swe-design
description: Create an implementation-ready DESIGN.md in a solution repository for that repository's assigned portion of a portfolio Feature.
---

# Design

Design only the active solution repository's assignment. Do not redefine the portfolio Feature or parent architecture.

Apply the lifecycle, approval, locator-chain, and acceptance-ID rules in [the artifact contract](../../references/ARTIFACT-CONTRACT.md).

## Workflow

1. Resolve the implementation assignment through dual locators to the authoritative `EPIC.md`, `FEATURE.md`, and `IMPLEMENTATION-PLAN.md`. Require both the Feature and Implementation Plan to be `Accepted`.
2. Read applicable solution, package, and module architecture plus current code and tests. Require applicable architecture to have an `Accepted` Approval Record before designing.
3. Write `.swe/implementations/EPIC-NNN/FEATURE-NNN/DESIGN.md` from [references/DESIGN-TEMPLATE.md](references/DESIGN-TEMPLATE.md).
4. Specify behavior, components, data, interfaces, failure handling, security, migration, observability, tests, rollout, and file-level change boundaries.
5. If implementation requires contradicting architecture or a cross-solution contract, record the divergence and stop for architecture review.
6. Validate traceability from every assigned `AC-NNN` criterion to design and planned evidence. Preserve criterion IDs verbatim.

## Approval

Default to human approval. `-auto-approve` uses an independent architecture reviewer or the appropriate solution/package/module architect; the author cannot self-approve. Permit two reject/repair cycles, then require a human. `-force` records an explicit human bypass. Repository policy applies unless an invocation flag overrides this workflow.

Return the design path, approval state, traceability, risks, and blockers.
