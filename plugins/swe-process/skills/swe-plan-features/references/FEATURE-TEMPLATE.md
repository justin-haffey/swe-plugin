---
title: "[FEATURE_TITLE]"
artifact_type: "feature"
id: "FEATURE-[NNN]"
status: "Draft"
authority: "portfolio"
scope: "[EPIC_ID]"
parent: "[EPIC_ID]"
upstream:
  repository: "[REPOSITORY_ID_OR_URL]"
  artifact_id: "[EPIC_ID]"
  path: ".swe/epics/[EPIC_DIRECTORY]/EPIC.md"
  revision: "[OPTIONAL_COMMIT_OR_TAG]"
traceability:
  epic:
    repository: "[REPOSITORY_ID_OR_URL]"
    artifact_id: "[EPIC_ID]"
    path: ".swe/epics/[EPIC_DIRECTORY]/EPIC.md"
    revision: "[OPTIONAL_COMMIT_OR_TAG]"
owners:
  - "[FEATURE_OWNER]"
created: "[YYYY_MM_DD]"
updated: "[YYYY_MM_DD]"
template_version: "3.0.0"
---

# [FEATURE_TITLE]

## Capability and Value

[CAPABILITY_AND_USER_OR_PLATFORM_VALUE]

## Scope

### In

- [IN_SCOPE_BEHAVIOR]

### Out

- [OUT_OF_SCOPE_BEHAVIOR]

## Requirements

- [REQUIREMENT]

## Quality and Contract Constraints

- [QUALITY_OR_CONTRACT_LINK]

## Dependencies

- [FEATURE_ARCHITECTURE_OR_EXTERNAL_DEPENDENCY]

## Acceptance Criteria

- [ ] AC-001: [OBSERVABLE_CRITERION]

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
