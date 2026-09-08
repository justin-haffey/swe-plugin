---
title: "[FEATURE_TITLE] — [SOLUTION_NAME] Design"
artifact_type: "design"
id: "DESIGN-[EPIC_NNN]-[FEATURE_NNN]-[SOLUTION_ID]"
status: "Draft"
authority: "solution"
scope: "[SOLUTION_ID]"
parent: "[IMPLEMENTATION_PLAN_ID]"
upstream:
  repository: "[PORTFOLIO_REPOSITORY_ID_OR_URL]"
  artifact_id: "[IMPLEMENTATION_PLAN_ID]"
  path: ".swe/epics/[EPIC_DIR]/features/[FEATURE_DIR]/IMPLEMENTATION-PLAN.md"
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
  implementation_plan:
    repository: "[PORTFOLIO_REPOSITORY_ID_OR_URL]"
    artifact_id: "[IMPLEMENTATION_PLAN_ID]"
    path: ".swe/epics/[EPIC_DIR]/features/[FEATURE_DIR]/IMPLEMENTATION-PLAN.md"
    revision: "[OPTIONAL_COMMIT_OR_TAG]"
owners:
  - "[DESIGN_OWNER]"
created: "[YYYY_MM_DD]"
updated: "[YYYY_MM_DD]"
template_version: "3.0.0"
---

# [FEATURE_TITLE] — [SOLUTION_NAME] Design

## Assignment and Boundaries

[ASSIGNED_OUTCOME_AND_EXCLUSIONS]

## Current State

[RELEVANT_CODE_ARCHITECTURE_AND_CONSTRAINTS]

## Proposed Design

[COMPONENTS_RESPONSIBILITIES_AND_INTERACTIONS]

## Interfaces, Data, and Contracts

- [INTERFACE_OR_DATA_CHANGE]

## Failure, Security, Observability, and Operations

- [DESIGN_DECISION]

## Change Map

| Area or path | Change | Owner |
|---|---|---|
| [REPOSITORY_RELATIVE_PATH] | [CHANGE] | [OWNER] |

## Test and Evidence Plan

| Criterion | Check and concrete fixture | Participant and actual operation | Expected observation | Timing | Receipt location |
|---|---|---|---|---|---|
| AC-001 | [CHECK_ID_AND_REAL_FIXTURE] | [PARTICIPANT_AND_OPERATION] | [EXPECTED_BEHAVIOR] | [EARLY_OR_EPIC_CHECKPOINT] | [PATH_OR_REPORT] |

Test authors own assertions and fixes. `$swe-test` dispatches check execution to Luna/medium `test-runner`; an independent validator judges adequacy. Record shared build-output ownership and dependency generations where checks can rebuild dependencies.

## Rollout, Compatibility, and Reversal

[MIGRATION_ROLLOUT_AND_ROLLBACK]

## Risks and Divergence

- [RISK_OR_NONE]

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
