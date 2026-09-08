---
name: swe-validate
description: Independently validate implemented Feature assignments or governed fast paths against authoritative criteria, architecture, tests, and evidence.
---

# Validate

Validation demonstrates correctness; it does not infer success from implementation claims.

Apply the lifecycle, approval, locator-chain, and acceptance-ID rules in [the artifact contract](../../references/ARTIFACT-CONTRACT.md).

For a Feature assignment or integrated Feature, follow the workflow below. For a `BUGFIX.md` or `ENHANCEMENT.md` fast path, independently verify its eligibility, risk classification, implementation evidence, checks, and applicable architecture; update only its `Validation and Closure` record, do not create `VALIDATION.md`, and conclude `Accepted`, `Rejected`, or `Blocked`. Only an `Accepted` independent decision authorizes `Validated`; a low-risk owner waiver closes directly from `Implemented` without invoking this validation workflow or claiming `Validated`.

## Workflow

1. Resolve the authoritative `FEATURE.md`, `IMPLEMENTATION-PLAN.md`, each child `DESIGN.md` and `EVIDENCE.md`, applicable architecture, code, and tests. Expected entry states are `Accepted` for Feature, Implementation Plan, Design, and applicable architecture approval, and `Complete` for Evidence. Missing or contradictory preconditions produce a `Blocked` validation, never a successful conclusion.
2. Build a criterion-to-assignment-to-evidence matrix keyed by authoritative `AC-NNN` IDs. Inspect receipt attribution, source/test/fixture/configuration/runtime/dependency-output generations, participant/operation identity and realized fixtures. A green command, wrong participant, stale generation or a declared but unrealized fixture cannot prove conformance. Reuse only applicable current evidence; pending or unavailable required checks produce Blocked acceptance.
3. Independently assess integration, contracts, qualities, security, migration, operational and browser coverage, including relevant malformed inputs, unauthorized side effects and failure paths. Specify any additional or independently controlled verification through `$swe-test` -> `test-runner` (`gpt-5.6-luna`, `medium`); validators do not execute checks or repair source/tests themselves. Authors fix failures, then the validator requests affected reruns. A passing tester receipt never decides adequacy or acceptance.
4. Write `VALIDATION.md` beside the child Design for solution-local validation, or beside the portfolio Feature for integrated Feature validation, using [references/VALIDATION-TEMPLATE.md](references/VALIDATION-TEMPLATE.md).
5. Freeze substantive decision bytes or use an immutable review snapshot and record its fingerprint and durable cycle-history locator. Verify byte correspondence before recording the separate decision for each artifact; changed bytes invalidate stale acceptance and require review of changed decisions and affected dependents. Conclude `Accepted`, `Rejected`, or `Blocked`; never call partial, deferred or unavailable evidence a pass. Portfolio aggregate progress is read-only and cannot grant child acceptance.
6. On acceptance, authorize architecture lifecycle promotion from `Target` to `Implemented`, then `Current` only when deployed/operational truth supports it. Record divergence.

## Approval

Default to human approval absent effective standing policy or explicit run authorization. Preserve named approvers and applicable Major human intent/contract/risk decisions. `-auto-approve` requires an independent `feature-validator` for portfolio validation or `solution-validator` for solution-local validation; author, designer and implementer cannot validate their own delivery. Architecture approval uses `$swe-architect -review`. Permit at most two author-repair/independent-review cycles, initial review cycle zero, then require explicit human disposition. Resume, packet/executor changes and successors for the same unresolved decision never reset the count. `-force` records an explicit human bypass, never a fabricated pass. A batched review can share evidence and qualified reviewers, but each artifact retains its own decision and authority.

Return the validation path, decision, coverage, blockers, lifecycle recommendations, and residual risk.
