---
name: swe-validate
description: Independently validate implemented Feature assignments against authoritative acceptance criteria, Design, architecture, tests, and evidence.
---

# Validate

Validation demonstrates correctness; it does not infer success from implementation claims.

Apply the lifecycle, approval, locator-chain, and acceptance-ID rules in [the artifact contract](../../references/ARTIFACT-CONTRACT.md).

## Workflow

1. Resolve the authoritative `FEATURE.md`, `IMPLEMENTATION-PLAN.md`, each child `DESIGN.md` and `EVIDENCE.md`, applicable architecture, code, and tests.
2. Build a criterion-to-assignment-to-evidence matrix keyed by the authoritative `AC-NNN` IDs. Re-run safe, relevant checks when the environment permits; label unavailable validation as blocked.
3. Test integration, contracts, qualities, security, migration, and operational behavior proportional to risk. Treat malformed inputs, unauthorized side effects, and failure paths as required when relevant.
4. Write `VALIDATION.md` beside the child Design for solution-local validation, or beside the portfolio Feature for integrated Feature validation, using [references/VALIDATION-TEMPLATE.md](references/VALIDATION-TEMPLATE.md).
5. Conclude `accepted`, `rejected`, or `blocked`; never call partial or unavailable evidence a pass.
6. On acceptance, authorize architecture lifecycle promotion from `target` to `implemented`, then `current` only when deployed/operational truth supports it. Record divergence.

## Approval

Default to human approval. `-auto-approve` requires an independent `feature-validator` or appropriate architecture reviewer; the author/implementer cannot self-approve. Permit two reject/repair cycles, then require a human. `-force` records an explicit human bypass, never a fabricated pass. Repository policy applies unless an invocation flag overrides this workflow.

Return the validation path, decision, coverage, blockers, lifecycle recommendations, and residual risk.
