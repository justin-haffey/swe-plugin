# SWE Artifact Contract

Use these v2 conventions for every process artifact.

## Metadata

- Use `snake_case` for `artifact_type` values and `PascalCase` for lifecycle `status` values.
- Preserve stable IDs after creation. Paths are locators, not identities.
- Every `upstream` locator contains `repository`, `artifact_id`, `path`, and optional `revision`.
- Epic acceptance outcomes use stable Epic-local IDs `EO-001`, `EO-002`, and so on.
- Feature acceptance criteria use stable Feature-local IDs `AC-001`, `AC-002`, and so on. Never renumber an accepted criterion; mark it superseded and add a new ID.
- Downstream Implementation Plan, Design, Evidence, and Validation artifacts preserve the exact acceptance criterion IDs they cover.
- A fast-path Enhancement may use local `AC-NNN` criteria inside its `ENHANCEMENT.md`; those IDs do not enter Feature traceability and must not be presented as Feature acceptance criteria.

## Legal lifecycle transitions

Decision-bearing work artifacts (`EPIC`, `CONCEPT`, `ARCHITECTURE-IMPACT`, `FEATURE`, `IMPLEMENTATION-PLAN`, and `DESIGN`) use:

`Draft -> InReview -> Accepted -> Superseded`

- `InReview -> Draft` is allowed after changes are required.
- `InReview -> Rejected` is allowed for a final rejection.
- `Rejected -> Draft` requires an explicit owner decision to reopen and a recorded reason.
- An `Accepted` artifact is immutable except for non-semantic corrections; replace semantic changes with a new revision or successor.

Canonical architecture uses `Target -> Implemented -> Current -> Superseded`. Approval accepts the Target without changing its lifecycle status. Promote to `Implemented` only with implementation evidence and to `Current` only with validation and reconciliation.

ADRs and contracts use `Proposed -> Accepted -> Superseded` or `Proposed -> Rejected`. Validation uses `Draft -> InReview -> Accepted`, `Rejected`, or `Blocked`; a blocked validation may return to `InReview` when its blocker changes. Research and Evidence use `Complete` only when their recorded work is complete.

Fast paths normally use `Active -> Implemented -> Validated -> Closed`, or `Active -> Escalated`. `Validated` requires a named independent validator and durable decision evidence. Independent validation is mandatory for externally visible behavior and for security, data, identity, integration, migration, concurrency, or operational risk, as well as whenever repository policy requires it. A low-risk fast path may instead use `Active -> Implemented -> Closed` only when its owner records `Decision: Waived` and a concrete waiver rationale; it must never claim `Validated`. The fast-path record must identify the validator, independence, decision, evidence, transition timestamps, closure owner, and waiver rationale when applicable.

## Approval record

Decision-bearing artifacts include an Approval Record with:

- `Mode`: `human`, `auto-approve`, or `force`.
- `Author`: the artifact author.
- `Approver`: the independent human or agent; for `force`, the human who explicitly authorized the bypass.
- `Decision`: `Pending`, `Accepted`, `ChangesRequired`, `Rejected`, or `Bypassed`.
- `Recorded`: an ISO 8601 timestamp, or `Pending` before review.
- `Evidence`: a review artifact, message, or other durable locator.
- `Bypass reason`: required only when the decision is `Bypassed`.

Human approval is the default. Under `auto-approve`, author and approver must differ and no more than two reject/repair cycles are allowed before human escalation. `force` records a human-authorized bypass; it never fabricates acceptance, validation, or evidence.

## Prototype-first reconciliation

Prototype Mode is a workflow-sequencing exception, not an approval mode. An explicit developer instruction may allow repository-local prototype implementation to begin before ordinary lifecycle artifacts exist or meet their acceptance entry gates. Repository ownership, filesystem scope, destructive-action controls, external-side-effect authority, deployment controls, credentials, Git safety, and tool approvals remain unchanged.

Each prototype run records its exact developer instruction, repository scope, changed paths, observed behavior, checks, decisions, assumptions, and limitations under `.swe/prototype/runs/`. After implementation, agents backtrack from that evidence into the smallest truthful governed route:

- a solution-local bugfix or enhancement fast path when Feature intent, contracts, and accepted architecture are unchanged; or
- the full Epic, Concept, architecture-impact, Target architecture, Feature, Implementation Plan, Design, Evidence, and Validation chain when the implemented capability requires it.

Reconstructed decision-bearing work starts as `Draft`; reconstructed architecture starts as `Target`; ADRs and contracts start as `Proposed`. Approval Records remain `Pending` until ordinary governance supplies a real decision. Prototype Mode never retroactively makes an artifact `Accepted`, treats implementation as approval, edits accepted history to appear forward-governed, or fabricates validation. The mode may return to `Off` only after all open runs are reconciled or explicitly cancelled by the developer.
