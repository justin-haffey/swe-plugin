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
2. Build a criterion-to-assignment-to-evidence matrix keyed by the authoritative `AC-NNN` IDs. Re-run safe, relevant checks when the environment permits; label unavailable validation as blocked.
3. Test integration, contracts, qualities, security, migration, and operational behavior proportional to risk. Treat malformed inputs, unauthorized side effects, and failure paths as required when relevant.
4. Write `VALIDATION.md` beside the child Design for solution-local validation, or beside the portfolio Feature for integrated Feature validation, using [references/VALIDATION-TEMPLATE.md](references/VALIDATION-TEMPLATE.md).
5. Conclude `Accepted`, `Rejected`, or `Blocked`; never call partial or unavailable evidence a pass.
6. On acceptance, authorize architecture lifecycle promotion from `Target` to `Implemented`, then `Current` only when deployed/operational truth supports it. Record divergence.

## Approval

Default to human approval. `-auto-approve` requires an independent `feature-validator` for portfolio validation or `solution-validator` for solution-local validation; the author, designer, and implementer cannot validate their own delivery. Architecture approval uses `$swe-architect -review`, not this Feature-validation workflow. Permit two reject/repair cycles, then require a human. `-force` records an explicit human bypass, never a fabricated pass. Repository policy applies unless an invocation flag overrides this workflow.

Return the validation path, decision, coverage, blockers, lifecycle recommendations, and residual risk.
