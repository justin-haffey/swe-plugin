---
title: "[PLATFORM_NAME] Platform Architecture"
artifact_type: "platform_architecture"
id: "ARCH-PLATFORM-[PLATFORM_ID]"
status: "Target"
authority: "portfolio"
scope: "[PLATFORM_ID]"
parent: "[PORTFOLIO_ID_OR_NONE]"
upstream:
  repository: "[REPOSITORY_ID_OR_URL]"
  artifact_id: "[SOURCE_ARTIFACT_ID]"
  path: "[REPOSITORY_RELATIVE_PATH]"
  revision: "[OPTIONAL_COMMIT_OR_TAG]"
owners:
  - "[PLATFORM_ARCHITECT]"
created: "[YYYY_MM_DD]"
updated: "[YYYY_MM_DD]"
template_version: "2.0.0"
---

# [PLATFORM_NAME] Platform Architecture

## Purpose and Outcomes

[PURPOSE_AND_QUALITY_OUTCOMES]

## Context and Boundaries

[PLATFORM_BOUNDARY_AND_EXTERNAL_CONTEXT]

## Solution Decomposition

| Solution | Responsibility | Owned Data | Interfaces |
|---|---|---|---|
| [SOLUTION] | [RESPONSIBILITY] | [DATA] | [CONTRACT_LINK] |

## System and Runtime Views

[IMPORTANT_RUNTIME_INTERACTIONS]

## Qualities, Security, and Operations

- [QUALITY_OR_CONSTRAINT]

## Decisions, Contracts, and Traceability

- [ADR_OR_CONTRACT_LINK]
- [EPIC_FEATURE_OR_IMPACT_LINK]

## Divergence and Lifecycle

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
