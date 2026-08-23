---
name: swe-bugfix
description: Run a governed solution-local bug-fix fast path when the defect does not require a new portfolio Feature, cross-solution contract, or unaccepted architecture.
---

# Bugfix

Use the fast path only for behavior already owned and intended by the active solution repository.

Apply the fast-path lifecycle and locator rules in [the artifact contract](../../references/ARTIFACT-CONTRACT.md).

## Eligibility gate

Escalate to the full Epic/Feature workflow when the fix changes platform intent, adds a capability, affects multiple solutions, changes a cross-solution contract, or requires unaccepted architecture. Do not use `-force` to bypass this gate.

## Workflow

1. Reproduce or establish the defect with observable evidence; resolve ownership and relevant architecture.
2. Allocate the next local `BUG-NNN` and create `.swe/changes/bugs/BUG-NNN-short-name/BUGFIX.md` from [references/BUGFIX-TEMPLATE.md](references/BUGFIX-TEMPLATE.md).
3. Record expected versus actual behavior, root cause, impact assessment, design, change boundaries, verification plan, and whether independent validation is mandatory before editing code. It is mandatory for externally visible behavior; security, data, identity, integration, migration, concurrency, or operational risk; and whenever repository policy requires it.
4. Implement the smallest corrective change with regression tests, preserving unrelated work.
5. Run relevant repository-native checks, record exact evidence, record the implementation timestamp, and transition to `Implemented`. Report unavailable checks as blocked.
6. When independent validation is mandatory, hand off to an independent `solution-validator`, record its identity, independence, decision, evidence, and timestamp, and transition through `Validated` only on a passing decision. For a low-risk fix, the owner may transition directly from `Implemented` to `Closed` only with `Decision: Waived` and a concrete waiver rationale; never claim `Validated` when validation was waived. Record the closure owner and timestamp. Any architecture divergence transitions to `Escalated` and returns to the architecture workflow.

No invocation grants destructive commands, deployment, publishing, or unrelated external side effects. Return the artifact path, ID, changed files, validation, escalation decision, and residual risk.
