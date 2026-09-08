---
title: "[FEATURE_TITLE] — [SOLUTION_NAME] Evidence"
artifact_type: "implementation_evidence"
id: "EVIDENCE-[EPIC_NNN]-[FEATURE_NNN]-[SOLUTION_ID]"
status: "Draft"
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
template_version: "3.0.0"
---

# Implementation Evidence

## Delivery Progress

```yaml
delivery_progress:
  implementation: NotStarted
  verification: Pending
  acceptance: Pending
  source_generation: unknown
  acceptance_locator: null
  pending_obligations:
    - check_id: "[CHECK_ID]"
      criteria: [AC-001]
      reason: "[PENDING_REASON_OR_APPROVED_DEFERRAL]"
      due: "[EARLY_GATE_OR_EPIC_IMPLEMENTATION_CHECKPOINT]"
      owner: test-runner
```

Evidence starts Draft. Implementation may be Complete while verification remains Pending and this record remains Draft. Mark Evidence Complete only when all required observations and coverage exist; truthful failures remain evidence but cannot support acceptance. Verification Complete requires all required checks passed for the relevant generation. Acceptance is a derived observation with the independent Validation locator/fingerprint, never an implementer decision. Preserve every pending or blocked obligation on interruption; no missing field implies completion.

## Scope and Generation

- Accepted Design/allocation and effective policy: [EXACT_LOCATORS_AND_FINGERPRINTS]
- Source, tests, fixtures, configuration, and runtime: [ACTUAL_GENERATION_IDENTITIES]
- Dependency outputs and shared build owner: [EXECUTED_GENERATION_AND_RELEASE_RECEIPT]
- Dirty baseline and changes during execution: [FINGERPRINTS_AND_FINDINGS]

## Change Summary

[IMPLEMENTED_BEHAVIOR]

## Changed Paths

- `[REPOSITORY_RELATIVE_PATH]`: [CHANGE]

## Verification

| Check | Actual execution ID | Result | Immutable receipt and logs |
|---|---|---|---|
| [CHECK_ID] | [EXECUTION_ID] | [PASSED_FAILED_BLOCKED_PENDING] | [RECEIPT_PATH_AND_DIGEST] |

Link actual `$swe-test` receipts; do not copy full logs. Preserve failed attempts separately. Reuse only when the affected source/test/fixture/configuration/runtime/dependency closure matches. Uncertain provenance, changed-during-run findings, missing browser/tools, or unavailable participants are pending evidence.

## Acceptance Coverage

| Criterion | Concrete fixture | Participant and operation | Expected versus observed | Result | Receipt |
|---|---|---|---|---|---|
| AC-001 | [REALIZED_FIXTURE] | [ACTUAL_PARTICIPANT_AND_OPERATION] | [EXPECTED_AND_ACTUAL] | [PASS_FAIL_BLOCKED_PENDING] | [REFERENCE] |

An unrealized fixture, wrong participant/operation, or successful process exit without the required observation cannot count as coverage. One execution may cover multiple Features while each criterion stays separately attributable.

## Design and Architecture Deviations

- [DEVIATION_OR_NONE]

## Residual Risk and Follow-up

- [RISK_OR_NONE]
