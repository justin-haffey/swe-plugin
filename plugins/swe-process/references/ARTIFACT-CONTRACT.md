# SWE Artifact Contract

Use these v2 conventions for every process artifact.

## Metadata

- Use `snake_case` for `artifact_type` values and `PascalCase` for lifecycle `status` values.
- Preserve stable IDs after creation. Paths are locators, not identities.
- Every `upstream` locator contains `repository`, `artifact_id`, `path`, and optional `revision`.
- Feature acceptance criteria use stable Feature-local IDs `AC-001`, `AC-002`, and so on. Never renumber an accepted criterion; mark it superseded and add a new ID.
- Downstream Implementation Plan, Design, Evidence, and Validation artifacts preserve the exact acceptance criterion IDs they cover.

## Legal lifecycle transitions

Decision-bearing work artifacts (`EPIC`, `CONCEPT`, `ARCHITECTURE-IMPACT`, `FEATURE`, `IMPLEMENTATION-PLAN`, and `DESIGN`) use:

`Draft -> InReview -> Accepted -> Superseded`

- `InReview -> Draft` is allowed after changes are required.
- `InReview -> Rejected` is allowed for a final rejection.
- `Rejected -> Draft` requires an explicit owner decision to reopen and a recorded reason.
- An `Accepted` artifact is immutable except for non-semantic corrections; replace semantic changes with a new revision or successor.

Canonical architecture uses `Target -> Implemented -> Current -> Superseded`. Approval accepts the Target without changing its lifecycle status. Promote to `Implemented` only with implementation evidence and to `Current` only with validation and reconciliation.

ADRs and contracts use `Proposed -> Accepted -> Superseded` or `Proposed -> Rejected`. Validation uses `Draft -> InReview -> Accepted`, `Rejected`, or `Blocked`; a blocked validation may return to `InReview` when its blocker changes. Research and Evidence use `Complete` only when their recorded work is complete. Fast paths use `Active -> Implemented -> Validated -> Closed`, or `Active -> Escalated`.

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
