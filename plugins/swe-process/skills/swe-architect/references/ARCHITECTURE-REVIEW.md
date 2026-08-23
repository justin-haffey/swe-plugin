# Architecture Review Procedure

Use this procedure only with `$swe-architect -review [ARTIFACT_PATH]`. Architecture review is an approval decision over an existing Target architecture, ADR, or contract; it is not Feature validation and does not create `VALIDATION.md`.

## Preconditions

- Resolve the exact artifact by stable ID and repository-relative path.
- Confirm the artifact is eligible for review and its required Concept, impact assessment, parent architecture, ADRs, and contracts are `Accepted`.
- Confirm the reviewer did not author, repair, or implement the artifact and has no unresolved conflict of interest.
- Stop with a blocked review summary when identity, authority, eligibility, or independence cannot be established.

## Review dimensions

Evaluate and cite evidence for:

- scope, ownership, responsibilities, boundaries, and dependency direction;
- alignment with accepted parent architecture, Concept, impact assessment, ADRs, and contracts;
- required qualities, security and trust boundaries, data and migration consequences;
- failure behavior, observability, operability, deployment, rollback, and reversibility;
- implementation feasibility, testability, known divergence, and unresolved decisions;
- whether diagrams and prose agree at the declared abstraction level.

## Decision

Edit only the artifact's Approval Record and review metadata. Record the independent reviewer, ISO 8601 timestamp, durable evidence locator, and exactly one decision:

- `Accepted`: the Target or proposal is fit to govern downstream work.
- `ChangesRequired`: bounded repairs are required before another review.
- `Rejected`: the proposal is not acceptable under the governing intent or constraints.

The author performs repairs. Review at most two repair cycles, then escalate to a human. Never rewrite substantive architecture during review, infer acceptance from silence, or use `-force` without explicit recorded human authorization.
