---
name: swe-architect
description: Create or revise canonical platform, solution, package, or module architecture plus governed ADRs and cross-solution contracts.
---

# Architect

Resolve architecture at the highest active-repository authority unless a narrower flag is supplied.

Apply the canonical filenames, lifecycle, approval, and locator rules in [the artifact contract](../../references/ARTIFACT-CONTRACT.md).

## Scope

- Portfolio default: platform architecture, platform ADRs, contracts, and system views. Child changes require explicit repository targets and handoffs.
- Solution default: solution, package, and module architecture owned locally.
- Narrow with `-platform`, `-solution`, `-package [PACKAGE]`, or `-module [PACKAGE]/[MODULE]`.

Read the Epic concept, impact assessment, current canonical architecture, decisions, contracts, and affected code. Systems are views within platform or solution architecture, not a separate structural level.

## Outputs

Use the matching template in `references/`:

- `architecture/PLATFORM-ARCHITECTURE.md`
- `architecture/SOLUTION-ARCHITECTURE.md`
- `architecture/packages/[PACKAGE]/PACKAGE-ARCHITECTURE.md`
- `architecture/packages/[PACKAGE]/modules/[MODULE]/MODULE-ARCHITECTURE.md`
- `architecture/decisions/ADR-NNN-[SHORT_NAME].md`
- `architecture/contracts/[CONTRACT_NAME].md`

Set changed architecture to `target`. Record rationale, qualities, boundaries, contracts, deployment/runtime views, traceability, and known divergence. A lower scope may refine but never silently contradict its parent.

## Approval and lifecycle

Default to human approval. `-auto-approve` requires an independent approver: platform and solution architecture use `architecture-reviewer`; package uses `solution-architect` or reviewer; module uses `package-architect` or reviewer; ADRs/contracts use an independent same- or parent-scope reviewer. The author cannot self-approve. Allow two repair/review cycles, then require a human. `-force` is an explicit human bypass and must be recorded. Repository policy applies unless an invocation flag overrides this workflow.

After implementation evidence and validation, promote `target` to `implemented`, then `current`; record and review divergence. No flag expands filesystem, repository, or approval authority.

Return changed paths, scope, decision IDs, approval state, handoffs, and divergence.
