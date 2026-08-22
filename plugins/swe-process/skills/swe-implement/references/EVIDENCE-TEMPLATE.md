---
title: "[FEATURE_TITLE] — [SOLUTION_NAME] Evidence"
artifact_type: "implementation_evidence"
id: "EVIDENCE-[EPIC_NNN]-[FEATURE_NNN]-[SOLUTION_ID]"
status: "Complete"
authority: "solution"
scope: "[SOLUTION_ID]"
parent: "[DESIGN_ID]"
upstream:
  repository: "[SOLUTION_REPOSITORY_ID_OR_URL]"
  artifact_id: "[DESIGN_ID]"
  path: ".swe/implementations/[EPIC_ID]/[FEATURE_ID]/DESIGN.md"
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
owners:
  - "[IMPLEMENTER]"
created: "[YYYY_MM_DD]"
updated: "[YYYY_MM_DD]"
template_version: "2.0.0"
---

# Implementation Evidence

## Change Summary

[IMPLEMENTED_BEHAVIOR]

## Changed Paths

- `[REPOSITORY_RELATIVE_PATH]`: [CHANGE]

## Verification

| Check | Command or method | Result | Evidence |
|---|---|---|---|
| [CHECK] | [COMMAND_OR_METHOD] | [PASS_FAIL_BLOCKED] | [OUTPUT_OR_PATH] |

## Acceptance Coverage

| Criterion | Result | Evidence |
|---|---|---|
| AC-001 | [PASS_FAIL_BLOCKED] | [REFERENCE] |

## Design and Architecture Deviations

- [DEVIATION_OR_NONE]

## Residual Risk and Follow-up

- [RISK_OR_NONE]
