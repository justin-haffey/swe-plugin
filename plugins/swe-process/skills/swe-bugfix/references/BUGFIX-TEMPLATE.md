---
title: "[BUG_TITLE]"
artifact_type: "bugfix"
id: "BUG-[NNN]"
status: "Active"
authority: "solution"
scope: "[SOLUTION_PACKAGE_OR_MODULE_ID]"
parent: "[ARCHITECTURE_OR_REQUIREMENT_ID]"
upstream:
  repository: "[REPOSITORY_ID_OR_URL]"
  artifact_id: "[SOURCE_ARTIFACT_ID]"
  path: "[REPOSITORY_RELATIVE_PATH]"
  revision: "[OPTIONAL_COMMIT_OR_TAG]"
owners:
  - "[OWNER]"
created: "[YYYY_MM_DD]"
updated: "[YYYY_MM_DD]"
template_version: "3.0.0"
---

# [BUG_TITLE]

## Expected and Actual Behavior

- Expected: [EXPECTED]
- Actual: [ACTUAL]
- Reproduction: [STEPS_OR_EVIDENCE]

## Eligibility and Impact

- Fast-path eligible: [YES_OR_NO]
- Architecture/contracts affected: [NONE_OR_DETAILS]
- Escalation: [NONE_OR_HANDOFF]

## Root Cause

[EVIDENCE_BACKED_ROOT_CAUSE]

## Fix Design and Change Map

- `[PATH]`: [CHANGE]

## Verification

| Check | Result | Evidence |
|---|---|---|
| [REGRESSION_OR_REPOSITORY_CHECK] | [PASS_FAIL_BLOCKED] | [REFERENCE] |

- Execution route: `$swe-test` -> `test-runner` (`gpt-5.6-luna`, `medium`).
- Immutable receipt and actual source/dependency generation: [RECEIPT_LOCATOR_AND_GENERATION]
- Remaining required checks and closure gate: [NONE_OR_PENDING_OBLIGATIONS]
- Standalone closure requires all required checks; no deferral to an absent Epic checkpoint.

## Validation and Closure

| Field | Value |
|---|---|
| Independent validation required | [YES_OR_NO_WITH_RISK_BASIS] |
| Implemented recorded | [ISO_8601_TIMESTAMP_OR_PENDING] |
| Validator | [INDEPENDENT_VALIDATOR_OR_NONE] |
| Independence | [CONFIRMED_OR_NOT_APPLICABLE_OR_BLOCKED] |
| Decision | [PENDING_OR_ACCEPTED_OR_REJECTED_OR_BLOCKED_OR_WAIVED] |
| Validation recorded | [ISO_8601_TIMESTAMP_OR_PENDING] |
| Evidence | [VALIDATION_EVIDENCE_OR_NONE] |
| Closure owner | [OWNER_OR_PENDING] |
| Closure recorded | [ISO_8601_TIMESTAMP_OR_PENDING] |
| Waiver rationale | [REQUIRED_WHEN_WAIVED_OR_NONE] |
| Reviewed substantive fingerprint | [FINGERPRINT_OR_PENDING] |
| Cycle history and count | [DURABLE_LOCATOR_AND_CONSUMED_CYCLES] |

## Residual Risk

- [RISK_OR_NONE]
