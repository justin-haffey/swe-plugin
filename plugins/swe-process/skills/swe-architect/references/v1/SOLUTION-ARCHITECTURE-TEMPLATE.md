---
artifact_type: "solution_architecture"
id: "ARCH-SOLUTION-[SOLUTION_ID]"
status: "Target"
owners: ["[OWNER]"]
schema_version: 4
links: []
---

# [SOLUTION_NAME] Solution Architecture

## Responsibilities and Boundaries

[RESPONSIBILITIES_AND_NON_RESPONSIBILITIES]

## Package Decomposition

| Package | Responsibility | Dependencies |
|---|---|---|
| [PACKAGE] | [RESPONSIBILITY] | [DEPENDENCIES] |

### Optional view

Add a diagram only when it clarifies a real boundary or interaction. Keep prose/tables authoritative; omit unused example views.

## Runtime and Integration Views

[COMPONENTS_FLOWS_AND_CONTRACTS]

### Optional view

Add a diagram only when it clarifies a real boundary or interaction. Keep prose/tables authoritative; omit unused example views.

## Data, Security, Qualities, and Operations

- [CONSTRAINT_OR_DECISION]

## Traceability and Divergence

- [UPSTREAM_OR_ADR_LINK]
- [DIVERGENCE_OR_NONE]

## Profile and Decision Basis

- Profile: [COMPACT_OR_DETAILED]; rationale: [ONE_SENTENCE_PROFILE_RATIONALE]
- Parent alignment and exclusions: [GOVERNING_CONSTRAINTS_AND_BOUNDARY]
- Invariants: [MUST_HOLD_BEHAVIOR_AND_OWNERSHIP_RULES]
- Alternatives and consequences: [CHOICE_REJECTED_ALTERNATIVE_AND_TRADEOFF]
- Feasibility and verification: [PROOF_OBLIGATIONS_AND_REQUIRED_CHECKS]
- Applicability: [OMITTED_CONCERN_AND_REASON_OR_NONE]

## Failure, Security, and Operational Readiness

- Failure and recovery: [ERROR_RETRY_RESOURCE_LIMIT_AND_RECOVERY_BEHAVIOR]
- Security and trust: [THREAT_BOUNDARY_AND_CONTROL]
- Operations and compatibility: [OBSERVABILITY_DEPLOYMENT_MIGRATION_AND_REVERSAL]

## Approval Record

| Field | Value |
|---|---|
| Mode | [HUMAN_OR_AUTO_APPROVE_OR_FORCE] |
| Author | [AUTHOR] |
| Approver | [INDEPENDENT_APPROVER_OR_FORCE_AUTHORIZING_HUMAN] |
| Decision | [PENDING_OR_ACCEPTED_OR_CHANGES_REQUIRED_OR_REJECTED_OR_BYPASSED] |
| Recorded | [ISO_8601_TIMESTAMP_OR_PENDING] |
| Evidence | [REVIEW_REFERENCE_OR_NONE] |
| Bypass reason | [REQUIRED_FOR_FORCE_OR_NONE] |

Review history: [REVIEWED_INPUT_AND_DECISION_FINGERPRINTS]; repair cycles consumed: [COUNT]. Record actual decisions and unresolved findings here; preserve history across resumes.
