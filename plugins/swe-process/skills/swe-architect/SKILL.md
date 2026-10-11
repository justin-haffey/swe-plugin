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

Authoring requires an approved governing outcome or a named human's explicit architecture brief. A first standalone Solution is a root with no Platform; draft Feature and architecture together and approve both before code. Read Concept/impact/parent architecture only when they govern the work. Create architecture for material decisions and actual boundaries; reuse existing accepted architecture. Systems are views.

## Outputs

Use Compact templates in `references/v1/` by default. Select Detailed in `references/v2/` per artifact when critical foundations, ownership/trust boundaries, changed shared contracts, complex state/concurrency/persistence, compatibility, failure, or operations require more explanation. An ordinary internal interface alone does not require Detailed. Record one sentence explaining the selection and load only that profile. Both profiles must satisfy the same artifact contract; add a focused missing concern or select Detailed when an independent reviewer finds a gap. Preserve accepted documents instead of rewriting them for brevity.

Use the selected profile's matching template for:

- `architecture/PLATFORM-ARCHITECTURE.md`
- `architecture/SOLUTION-ARCHITECTURE.md`
- `architecture/packages/[PACKAGE]/PACKAGE-ARCHITECTURE.md`
- `architecture/packages/[PACKAGE]/modules/[MODULE]/MODULE-ARCHITECTURE.md`
- `architecture/views/systems/[SYSTEM_NAME].md`
- `architecture/decisions/ADR-NNN-[SHORT_NAME].md`
- `architecture/contracts/[CONTRACT_NAME].md`

Set changed architecture to `Target`. Use [artifact generation](../../references/ARTIFACT-GENERATION.md) for metadata and locator/coverage structure; author rationale, alternatives, invariants, qualities, boundaries, contracts, feasibility, runtime/operations, traceability, and divergence. Verify actual participants, reachable limits, and proof obligations before freezing commitments. A lower scope may refine but never silently contradict its parent.

Use Mermaid views only when they clarify an actual boundary or interaction; do not leave sample nodes in a generated artifact. Keep one abstraction level per diagram, label relationship meaning, and keep prose or tables as the authority for details that do not improve visually. Add a conditional data, state, trust-boundary, deployment, or sequence view only when it answers a distinct architectural question. Omit unused example views instead of inventing structure.

## Approval and lifecycle

Default to human approval unless an owner-adopted standing policy or explicit run authorization applies. Major intent, contracts, and risk decisions require the named human under the delivery policy. `-auto-approve` requires an independent approver: platform, solution, and System views use `architecture-reviewer`; package uses `solution-architect` or reviewer; module uses `package-architect` or reviewer; ADRs/contracts use an independent same- or parent-scope reviewer. The author cannot self-approve. Allow two repair/review cycles across resumes, then require a human. `-force` is an explicit human bypass and must be recorded.

After implementation evidence and validation, promote `Target` to `Implemented`, then `Current`; record and review divergence. No flag expands filesystem, repository, or approval authority.

## Independent review mode

Before `-review`, load the selected profile's review procedure: [Compact](references/v1/ARCHITECTURE-REVIEW.md) or [Detailed](references/v2/ARCHITECTURE-REVIEW.md). The reviewer must be independent from the author, repairer, and implementer. Review the current decision and recorded input fingerprints against identity, scope, parent alignment, accepted inputs, qualities, security, operability, reversibility, and feasibility. Edit only its Approval Record and review metadata after fingerprint correspondence is verified. Record `Accepted`, `ChangesRequired`, or `Rejected` with durable evidence and preserved cycle history. Route any test/build/static/browser execution through `$swe-test`; independent judgment remains with the reviewer. Do not create a Feature `VALIDATION.md` for architecture approval.

Return changed paths, scope, decision IDs, approval state, handoffs, and divergence.
