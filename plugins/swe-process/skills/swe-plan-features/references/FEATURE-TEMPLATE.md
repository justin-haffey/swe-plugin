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
template_version: "2.0.0"
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
