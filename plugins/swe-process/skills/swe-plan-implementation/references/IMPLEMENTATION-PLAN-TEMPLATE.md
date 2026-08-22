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
template_version: "2.0.0"
---

# [FEATURE_TITLE] Implementation Plan

## Delivery Strategy

[ALLOCATION_AND_SEQUENCE_SUMMARY]

## Assignments

### [SOLUTION_NAME]

```yaml
repository: "[REPOSITORY_ID_OR_URL]"
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

## Integration and Sequencing

1. [ORDERED_HANDOFF_OR_INTEGRATION_STEP]

## Acceptance Coverage

| Feature criterion | Owner | Evidence |
|---|---|---|
| AC-001 | [SOLUTION_NAME] | [EXPECTED_EVIDENCE] |

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
