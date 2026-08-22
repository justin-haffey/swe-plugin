---
title: "[FEATURE_TITLE] Validation"
artifact_type: "validation"
id: "VALIDATION-[EPIC_NNN]-[FEATURE_NNN]-[SCOPE_ID]"
status: "Draft"
authority: "[PORTFOLIO_OR_SOLUTION]"
scope: "[FEATURE_OR_SOLUTION_SCOPE]"
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
  implementation_plan:
    repository: "[PORTFOLIO_REPOSITORY_ID_OR_URL]"
    artifact_id: "[IMPLEMENTATION_PLAN_ID]"
    path: ".swe/epics/[EPIC_DIR]/features/[FEATURE_DIR]/IMPLEMENTATION-PLAN.md"
    revision: "[OPTIONAL_COMMIT_OR_TAG]"
  design:
    repository: "[SOLUTION_REPOSITORY_ID_OR_URL]"
    artifact_id: "[DESIGN_ID]"
    path: ".swe/implementations/[EPIC_ID]/[FEATURE_ID]/DESIGN.md"
    revision: "[OPTIONAL_COMMIT_OR_TAG]"
  evidence:
    repository: "[SOLUTION_REPOSITORY_ID_OR_URL]"
    artifact_id: "[EVIDENCE_ID]"
    path: ".swe/implementations/[EPIC_ID]/[FEATURE_ID]/EVIDENCE.md"
    revision: "[OPTIONAL_COMMIT_OR_TAG]"
owners:
  - "[VALIDATOR]"
created: "[YYYY_MM_DD]"
updated: "[YYYY_MM_DD]"
template_version: "2.0.0"
---

# [FEATURE_TITLE] Validation

## Decision

[ACCEPTED_REJECTED_BLOCKED]: [RATIONALE]

## Coverage

| Criterion | Assignment | Evidence | Independent check | Result |
|---|---|---|---|---|
| AC-001 | [OWNER] | [REFERENCE] | [CHECK] | [PASS_FAIL_BLOCKED] |

## Quality, Contract, and Integration Results

- [RESULT]

## Deviations and Defects

- [DEVIATION_OR_NONE]

## Architecture Lifecycle Recommendation

- [ARTIFACT]: [KEEP_TARGET_PROMOTE_IMPLEMENTED_PROMOTE_CURRENT]

## Residual Risk

- [RISK_OR_NONE]

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
