---
title: "[CONCEPT_TITLE]"
artifact_type: "concept"
id: "CONCEPT-[EPIC_NNN]"
status: "Draft"
authority: "portfolio"
scope: "[EPIC_ID]"
parent: "[EPIC_ID]"
upstream:
  repository: "[REPOSITORY_ID_OR_URL]"
  artifact_id: "[EPIC_ID]"
  path: ".swe/epics/[EPIC_DIRECTORY]/EPIC.md"
  revision: "[OPTIONAL_COMMIT_OR_TAG]"
owners:
  - "[OWNER]"
created: "[YYYY_MM_DD]"
updated: "[YYYY_MM_DD]"
template_version: "3.0.0"
---

# [CONCEPT_TITLE]

## Purpose

[CONCEPTUAL_PURPOSE]

## Ubiquitous Language

| Term | Meaning | Excludes |
|---|---|---|
| [TERM] | [MEANING] | [NON_MEANING] |

## Actors and Goals

- [ACTOR]: [GOAL]

## Boundaries and Capabilities

- [BOUNDARY]
  - [CAPABILITY]

## Relationships and Invariants

- [RELATIONSHIP_OR_INVARIANT]

## Scenarios

1. [SCENARIO]

## Constraints and Open Questions

- [CONSTRAINT_OR_QUESTION]

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
