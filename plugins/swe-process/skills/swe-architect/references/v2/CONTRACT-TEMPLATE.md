---
title: "[CONTRACT_NAME]"
artifact_type: "architecture_contract"
id: "CONTRACT-[CONTRACT_ID]"
status: "Proposed"
authority: "portfolio"
scope: "[PRODUCER_SOLUTION_TO_CONSUMER_SCOPE]"
parent: "[PLATFORM_ARCHITECTURE_ID]"
upstream:
  repository: "[REPOSITORY_ID_OR_URL]"
  artifact_id: "[SOURCE_ARTIFACT_ID]"
  path: "[REPOSITORY_RELATIVE_PATH]"
  revision: "[OPTIONAL_COMMIT_OR_TAG]"
owners:
  - "[CONTRACT_OWNER]"
created: "[YYYY_MM_DD]"
updated: "[YYYY_MM_DD]"
template_version: "2.0.0"
---

# [CONTRACT_NAME]

## Purpose and Parties

[PRODUCER_CONSUMERS_AND_PURPOSE]

## Compatibility and Versioning

[VERSIONING_DEPRECATION_AND_CHANGE_POLICY]

## Messages or Operations

| Name | Direction | Semantics | Schema Reference |
|---|---|---|---|
| [NAME] | [DIRECTION] | [SEMANTICS] | [SCHEMA_LINK] |

## Errors, Security, and Service Qualities

- [GUARANTEE_OR_CONSTRAINT]

## Conformance

[PRODUCER_AND_CONSUMER_VALIDATION]

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
