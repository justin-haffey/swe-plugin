---
name: swe-architect
description: Create, revise, or independently review canonical platform, solution, package, or module architecture plus governed ADRs and cross-solution contracts.
---
# Architect

Resolve architecture at the highest active-repository authority unless a narrower flag is supplied. Use `-review [ARTIFACT_PATH]` only for an independent architecture approval review.

Apply the canonical filenames, lifecycle, approval, and locator rules in [the artifact contract](../../references/ARTIFACT-CONTRACT.md).

## Scope

- Portfolio default: platform architecture, platform ADRs, contracts, and system views. Child changes require explicit repository targets and handoffs.
- Solution default: solution, package, and module architecture owned locally.
- Narrow with `-platform`, `-solution`, `-package [PACKAGE]`, or `-module [PACKAGE]/[MODULE]`.
- Create a named System view only when requested within the active Platform or Solution authority; it does not change the structural scope.

Authoring or revision requires an `Accepted` Concept and `Accepted` architecture-impact assessment. Reconciliation of existing accepted architecture instead requires the accepted governing change and its implementation evidence. Read the Epic concept, impact assessment, current canonical architecture, decisions, contracts, and affected code. Systems are views within platform or solution architecture, not a separate structural level.

## Gauging Complexity

Produce `Complex` **Outputs** when the `-in-depth` flag is specified, or when you intuitively determine the architecture will be: large in scope, critical, complex or highly specialized, or otherwise deservers special attention.

## Outputs

**Standard**. Use the matching template in `references/`:

**Complex**. Use the matching template in `references/in-depth-version/`:

- `architecture/PLATFORM-ARCHITECTURE.md`
- `architecture/SOLUTION-ARCHITECTURE.md`
- `architecture/packages/[PACKAGE]/PACKAGE-ARCHITECTURE.md`
- `architecture/packages/[PACKAGE]/modules/[MODULE]/MODULE-ARCHITECTURE.md`
- `architecture/views/systems/[SYSTEM_NAME].md`
- `architecture/decisions/ADR-NNN-[SHORT_NAME].md`
- `architecture/contracts/[CONTRACT_NAME].md`

Set changed architecture to `Target`. Record rationale, qualities, boundaries, contracts, deployment/runtime views, traceability, and known divergence. A lower scope may refine but never silently contradict its parent.

Populate the core Mermaid views in the selected template with actual architecture facts; do not leave sample nodes in a generated artifact. Keep one abstraction level per diagram, label relationship meaning, and keep prose or tables as the authority for details that do not improve visually. Add a conditional data, state, trust-boundary, deployment, or sequence view only when it answers a distinct architectural question. If a core view genuinely does not apply, replace its placeholder with a short rationale instead of inventing structure.

## Approval and lifecycle

Default to human approval. `-auto-approve` requires an independent approver: platform, solution, and System views use `architecture-reviewer`; package uses `solution-architect` or reviewer; module uses `package-architect` or reviewer; ADRs/contracts use an independent same- or parent-scope reviewer. The author cannot self-approve. Allow two repair/review cycles, then require a human. `-force` is an explicit human bypass and must be recorded. Repository policy applies unless an invocation flag overrides this workflow.

After implementation evidence and validation, promote `Target` to `Implemented`, then `Current`; record and review divergence. No flag expands filesystem, repository, or approval authority.

## Independent review mode

Before using `-review`, read [references/ARCHITECTURE-REVIEW.md](references/ARCHITECTURE-REVIEW.md). The reviewer must be independent from the artifact author and must not author, repair, or implement the architecture under review. Review the named Target architecture or proposed ADR/contract against its identity, scope, parent alignment, accepted inputs, quality attributes, security, operability, reversibility, and implementation feasibility. Edit only its Approval Record and review metadata. Record `Accepted`, `ChangesRequired`, or `Rejected` with durable evidence; allow no more than two author repair/review cycles before human escalation. Do not create a Feature `VALIDATION.md` for architecture approval.

Return changed paths, scope, decision IDs, approval state, handoffs, and divergence.
