---
title: "[SOLUTION_NAME] Solution Architecture"
artifact_type: "solution_architecture"
id: "ARCH-SOLUTION-[SOLUTION_ID]"
status: "Target"
authority: "solution"
scope: "[SOLUTION_ID]"
parent: "[PLATFORM_ARCHITECTURE_ID]"
upstream:
  repository: "[PORTFOLIO_REPOSITORY_ID_OR_URL]"
  artifact_id: "[PLATFORM_ARCHITECTURE_ID]"
  path: "architecture/PLATFORM-ARCHITECTURE.md"
  revision: "[OPTIONAL_COMMIT_OR_TAG]"
owners:
  - "[SOLUTION_ARCHITECT]"
created: "[YYYY_MM_DD]"
updated: "[YYYY_MM_DD]"
template_version: "2.0.0"
---

# [SOLUTION_NAME] Solution Architecture

## Responsibilities and Boundaries

[RESPONSIBILITIES_AND_NON_RESPONSIBILITIES]

## Package Decomposition

| Package | Responsibility | Dependencies |
|---|---|---|
| [PACKAGE] | [RESPONSIBILITY] | [DEPENDENCIES] |

## Runtime and Integration Views

[COMPONENTS_FLOWS_AND_CONTRACTS]

## Data, Security, Qualities, and Operations

- [CONSTRAINT_OR_DECISION]

## Traceability and Divergence

- [UPSTREAM_OR_ADR_LINK]
- [DIVERGENCE_OR_NONE]

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
