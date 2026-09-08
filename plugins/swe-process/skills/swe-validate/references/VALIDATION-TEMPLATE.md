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
template_version: "3.0.0"
---

# [FEATURE_TITLE] Validation

## Decision

[ACCEPTED_REJECTED_BLOCKED]: [RATIONALE]

- Validator and independence from author, implementer, and material repairer: [IDENTITY_AND_FINDING]
- Authority: [SOLUTION_LOCAL_OR_PORTFOLIO_INTEGRATION]
- Reviewed source/test/dependency generation: [FINGERPRINTS_AND_RECEIPT_LOCATORS]
- Evidence completeness and remaining obligations: [COMPLETE_FINDING_OR_BLOCKER]
- Risk/deferral eligibility and required early gates: [INDEPENDENT_JUDGMENT]

A green tester receipt is an observation, not acceptance. Verify real fixture/participant/operation attribution and criterion adequacy. Accepted delivery requires all required checks passed for the relevant generation with no deferred, missing, blocked, failed, or stale obligations. The validator controls any independent `$swe-test` invocation and may require additional checks; the tester never approves delivery. Solution acceptance does not grant portfolio integration acceptance.

## Coverage

| Criterion | Assignment | Immutable receipt and evidence | Validator-controlled check or inspection | Independent result |
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
