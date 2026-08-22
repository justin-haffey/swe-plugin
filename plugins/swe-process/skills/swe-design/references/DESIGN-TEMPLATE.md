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
template_version: "2.0.0"
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

| Criterion | Verification | Evidence location |
|---|---|---|
| AC-001 | [TEST_OR_CHECK] | [PATH_OR_REPORT] |

## Rollout, Compatibility, and Reversal

[MIGRATION_ROLLOUT_AND_ROLLBACK]

## Risks and Divergence

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
