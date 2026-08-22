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
3. Record the value, boundaries, impact assessment, design, stable `AC-NNN` acceptance criteria, change map, and validation plan.
4. Implement the smallest coherent refinement with tests and required local documentation.
5. Run repository-native checks and capture evidence. Report unavailable checks as blocked.
6. Obtain independent validation when risk warrants it; route architecture divergence back to architecture review.

No invocation grants destructive commands, deployment, publishing, or unrelated external side effects. Return the artifact path, ID, changed files, validation, escalation decision, and residual risk.
