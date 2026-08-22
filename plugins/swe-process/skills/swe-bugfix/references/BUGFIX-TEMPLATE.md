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
template_version: "2.0.0"
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

## Residual Risk

- [RISK_OR_NONE]
