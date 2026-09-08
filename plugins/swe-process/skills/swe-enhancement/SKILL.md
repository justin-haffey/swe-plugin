---
name: swe-enhancement
description: Run a governed solution-local enhancement fast path for a bounded refinement that preserves portfolio intent, contracts, and accepted architecture.
---

# Enhancement

Use this fast path for a local refinement of an existing capability, not a new portfolio capability.

Apply the fast-path lifecycle, locator, and stable acceptance-ID rules in [the artifact contract](../../references/ARTIFACT-CONTRACT.md).

## Eligibility gate

Escalate to an Epic/Feature when the change introduces new platform value, spans solutions, changes a cross-solution contract, reallocates ownership, or needs unaccepted architecture. Do not use `-force` to bypass the gate.

## Workflow

1. Resolve the existing capability, owner, architecture, code, and observable desired outcome.
2. Allocate the next local `ENH-NNN` and create `.swe/changes/enhancements/ENH-NNN-short-name/ENHANCEMENT.md` from [references/ENHANCEMENT-TEMPLATE.md](references/ENHANCEMENT-TEMPLATE.md).
3. Record the value, boundaries, impact assessment, design, stable Enhancement-local `AC-NNN` acceptance criteria, change map, validation plan, and whether independent validation is mandatory before editing code. These local criteria never enter Feature traceability. Independent validation is mandatory for externally visible behavior; security, data, identity, integration, migration, concurrency, or operational risk; and whenever repository policy requires it.
4. Implement the smallest coherent refinement with tests and required local documentation.
5. Request repository-native build, lint, test, security, integration and browser checks through `$swe-test` -> `test-runner` (`gpt-5.6-luna`, `medium`). Authors fix source/tests; the tester returns attributable immutable receipts. Coordinate shared build outputs and capture actual generations, evidence and the implementation timestamp before `Implemented`. Unavailable checks remain blocked. Standalone work cannot defer to a nonexistent Epic checkpoint; finish required checks before closure.
6. When independent validation is mandatory, hand off to an independent `solution-validator`, record its identity, independence, decision, evidence, and timestamp, and transition through `Validated` only on a passing decision. For a low-risk enhancement, the owner may transition directly from `Implemented` to `Closed` only with `Decision: Waived` and a concrete waiver rationale; never claim `Validated` when validation was waived. Record the closure owner and timestamp. Architecture divergence transitions to `Escalated` and returns to architecture review.

No invocation grants destructive commands, deployment, publishing, or unrelated external side effects. Return the artifact path, ID, changed files, validation, escalation decision, and residual risk.

Freeze decision bytes during independent review and verify their fingerprint before recording acceptance. Preserve the durable initial-review/cycle-history locator and at most two author-repair/independent-review cycles. Resume, renamed packets, executor changes or successors for the same unresolved decision never reset the count; exhaustion requires explicit human disposition. A waiver cannot turn missing required checks into passing evidence.
