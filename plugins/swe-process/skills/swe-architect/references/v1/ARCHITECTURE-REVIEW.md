# Architecture Review Procedure

Use with `$swe-architect -review [ARTIFACT_PATH]` for an independent approval decision over existing Target architecture, Proposed ADRs, or contracts. This does not create Feature `VALIDATION.md` or authorize implementation.

## Preconditions and packet

Resolve stable IDs, exact repository-relative paths/revisions, the effective policy and named approver, accepted governing Concept/Impact and parent decisions. Canonical architecture approval is an Accepted Approval Record while lifecycle remains Target. Preserve V2 records unchanged; a missing V3 field is unknown, not assumed acceptance.

Require independence from the author, material repairer, and implementer. Freeze decision bytes or use an immutable snapshot. The packet identifies changed decisions, input/decision fingerprints, affected invariants, evidence, decision owners, and durable repair-cycle history. One qualified reviewer may cover multiple decisions only with authority for each; otherwise use the smallest distinct reviewer set. Stop with a concrete blocker when scope, identity, eligibility, independence, or required human approval cannot be established.

## Concerns and profile

Compact V1 is the default per artifact. Detailed V2 is appropriate for critical foundations, trust/ownership boundaries, changed shared contracts, or state/concurrency/persistence, compatibility, failure, and operational complexity that needs depth. An ordinary internal interface alone is not a trigger. Assess the recorded one-sentence rationale. A missing material concern requires a focused section or Detailed, never an approval/evidence waiver. Do not expand unrelated artifacts or shorten existing accepted documents.

Evaluate evidence for responsibilities/exclusions, boundaries and dependency direction, parent alignment, invariants, alternatives/tradeoffs, quality attributes, security/trust, state/data/migration, failure and observability, deployment/operations/reversal, traceability/divergence, and feasibility/testing. Confirm participant availability, actual operation ownership, concrete conformance cases, and jointly reachable limits before commitments freeze. Diagrams must agree with prose and use one abstraction level; irrelevant placeholders need a concise applicability finding.

Confirm risk and proposed deferral independently. Public/cross-solution contracts, security, persistence, concurrency, operational effects, and prerequisite behavior require early proofs; missing risk/dependencies block eligibility. Minimal deferral preserves allocation/Design approval before code. Major decisions retain named-human approval under adopted V3 policy.

## Decision and bounded repair

Inspect the full evidence needed for judgment. Request test/build/static/browser execution through `$swe-test`; Luna executes bounded checks, while this reviewer controls the request and assesses adequacy. A green receipt cannot approve architecture or replace judgment.

Immediately before recording a decision, verify correspondence with reviewed input and substantive decision bytes. Changed bytes invalidate stale acceptance; review the changed decision set and affected dependents. Cosmetic preferences alone do not reopen accepted semantics.

Edit only Approval Records and review metadata. Record the independent reviewer, policy/mode, timestamp, evidence locator, fingerprints, and one decision: Accepted, ChangesRequired, or Rejected. Paired Concept/Impact and Feature/Plan retain separate decisions recorded in dependency order. Never approve a dependent artifact before its upstream gate is accepted.

Authors own repairs. At most two repair/review cycles are permitted for the same unresolved decision across resumes, packet renames, successor attempts, and executor changes. Preserve consumed counts and history; exhaustion requires human disposition. Never rewrite substantive architecture while reviewing or infer acceptance from silence. Explicit human `-force` records a bypass, not acceptance. Approval of a Target never promotes it to Implemented or Current without real implementation evidence, validation, and reconciliation.
