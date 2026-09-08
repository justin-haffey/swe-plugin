---
title: "[FEATURE_TITLE] Implementation Plan"
artifact_type: "implementation_plan"
id: "IMPL-PLAN-[EPIC_NNN]-[FEATURE_NNN]"
status: "Draft"
authority: "portfolio"
scope: "[FEATURE_ID]"
parent: "[FEATURE_ID]"
upstream:
  repository: "[PORTFOLIO_REPOSITORY_ID_OR_URL]"
  artifact_id: "[FEATURE_ID]"
  path: ".swe/epics/[EPIC_DIR]/features/[FEATURE_DIR]/FEATURE.md"
  revision: "[OPTIONAL_COMMIT_OR_TAG]"
traceability:
  epic:
    repository: "[PORTFOLIO_REPOSITORY_ID_OR_URL]"
    artifact_id: "[EPIC_ID]"
    path: ".swe/epics/[EPIC_DIR]/EPIC.md"
    revision: "[OPTIONAL_COMMIT_OR_TAG]"
  feature:
    repository: "[PORTFOLIO_REPOSITORY_ID_OR_URL]"
    artifact_id: "[FEATURE_ID]"
    path: ".swe/epics/[EPIC_DIR]/features/[FEATURE_DIR]/FEATURE.md"
    revision: "[OPTIONAL_COMMIT_OR_TAG]"
owners:
  - "[PLAN_OWNER]"
created: "[YYYY_MM_DD]"
updated: "[YYYY_MM_DD]"
template_version: "3.0.0"
---

# [FEATURE_TITLE] Implementation Plan

## Delivery Strategy

[ALLOCATION_AND_SEQUENCE_SUMMARY]

## Assignments

### [SOLUTION_NAME]

```yaml
assignment_id: "[STABLE_ASSIGNMENT_ID]"
repository: "[REPOSITORY_ID_OR_URL]"
checkout: "[EXACT_CHECKOUT_IDENTITY]"
artifact_id: "[SOLUTION_ARCHITECTURE_ID]"
path: "architecture/SOLUTION-ARCHITECTURE.md"
revision: "[OPTIONAL_COMMIT_OR_TAG]"
local_workspace: ".swe/implementations/[EPIC_ID]/[FEATURE_ID]/"
```

- Outcome: [ASSIGNED_OUTCOME]
- Packages/modules: [OWNED_SCOPES]
- Contracts: [CONTRACT_LINKS]
- Depends on: [DEPENDENCIES]
- Evidence required: [TEST_OR_ARTIFACT_EVIDENCE]
- Allowed write scope: [REPOSITORY_RELATIVE_PATHS]
- Participant readiness: [REAL_PARTICIPANTS_AUTHORIZED_WORK_AND_REACHABLE_LIMITS]
- Expected Design, Evidence, Validation, and check receipt paths: [LOCAL_WORKSPACE_LOCATORS]

## Integration and Sequencing

1. [ORDERED_HANDOFF_OR_INTEGRATION_STEP]

## Acceptance Coverage

| Feature criterion | Owner | Evidence |
|---|---|---|
| AC-001 | [SOLUTION_NAME] | [EXPECTED_EVIDENCE] |

## Risk and Prerequisites

```yaml
risk:
  class: "[MINIMAL_STANDARD_MAJOR]"
  rationale: "[RATIONALE_AND_AFFECTED_CRITERIA]"
  policy_locator: "[ADOPTED_POLICY_OR_RUN_AUTHORIZATION_LOCATOR]"
  deferral_eligible: false
  confirmed_by: "[INDEPENDENT_REVIEWER_OR_PENDING]"
dependencies: [] # Explicit reviewed independence, or replace with entries below.
```

When dependencies exist, each entry records `assignment_id`, an artifact dual locator, `criteria`, `entry_phase` (Design or Implementation), and `requirement` (ApprovedContractOrDesign or ValidatedBehavior). Unknown dependencies block eligibility. ValidatedBehavior requires independent Accepted Validation and real passing behavior for the consumed generation. Reclassify when scope or consumers change.

| Required check | Criteria | Timing | Prerequisite consumer | Expected receipt |
|---|---|---|---|---|
| [CHECK_ID] | AC-001 | [EARLY_OR_EPIC_CHECKPOINT] | [CONSUMER_OR_REVIEWED_NONE] | [RECEIPT_PATH] |

Deferral applies only to independently confirmed isolated, reversible Minimal work under adopted policy. Mandatory checks, public/cross-solution contracts, security, persistence, concurrency, operations, and prerequisite behavior require early verification. Accepted allocation and Design still precede code.

## Review Packet

- Decision bytes or immutable snapshot: [INPUT_AND_DECISION_FINGERPRINT_LOCATORS]
- Effective policy and named approver: [POLICY_LOCATOR_AND_APPROVER]
- Paired decisions and order: [PAIRED_ARTIFACT_LOCATORS_OR_NONE]
- Review cycle history: [DURABLE_HISTORY_LOCATOR]; repair cycles consumed: [COUNT]
- Correspondence at decision time: [VERIFIED_MATCH_OR_BLOCKER]

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
