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

1. Establish the defect from observable evidence; request reproduction checks through `$swe-test` and resolve ownership and relevant architecture.
2. Allocate the next local `BUG-NNN` and create `.swe/changes/bugs/BUG-NNN-short-name/BUGFIX.md` from [references/BUGFIX-TEMPLATE.md](references/BUGFIX-TEMPLATE.md).
3. Record expected versus actual behavior, root cause, impact assessment, design, change boundaries, verification plan, and whether independent validation is mandatory before editing code. It is mandatory for externally visible behavior; security, data, identity, integration, migration, concurrency, or operational risk; and whenever repository policy requires it.
4. Implement the smallest corrective change with regression tests, preserving unrelated work.
5. Request relevant repository-native build, lint, regression, security, integration and browser checks through `$swe-test` -> `test-runner` (`gpt-5.6-luna`, `medium`). Authors fix source/tests; the tester returns attributable immutable receipts. Coordinate shared build outputs and record the actual generation, evidence and implementation timestamp before `Implemented`. Unavailable checks remain blocked. Standalone work cannot defer to a nonexistent Epic checkpoint; finish required checks before closure.
6. When independent validation is mandatory, hand off to an independent `solution-validator`, record its identity, independence, decision, evidence, and timestamp, and transition through `Validated` only on a passing decision. For a low-risk fix, the owner may transition directly from `Implemented` to `Closed` only with `Decision: Waived` and a concrete waiver rationale; never claim `Validated` when validation was waived. Record the closure owner and timestamp. Any architecture divergence transitions to `Escalated` and returns to the architecture workflow.

No invocation grants destructive commands, deployment, publishing, or unrelated external side effects. Return the artifact path, ID, changed files, validation, escalation decision, and residual risk.

Freeze decision bytes during independent review and verify their fingerprint before recording acceptance. Preserve the durable initial-review/cycle-history locator and at most two author-repair/independent-review cycles. Resume, renamed packets, executor changes or successors for the same unresolved decision never reset the count; exhaustion requires explicit human disposition. A waiver cannot turn missing required checks into passing evidence.
