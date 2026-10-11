---
name: swe-design
description: Prepare or independently review a Feature approach or separate local Design when complexity warrants it.
---
# swe-design

Apply [the delivery contract](../../references/ARTIFACT-CONTRACT.md). Human approval is default; preserve named Major human decisions, independence and the two-cycle limit.

Author with `$swe-design <feature-or-design-path>`; `-review <path>` is independent technical review. Resolve mode first.

- Standalone: develop Approach, Change scope, Risk/prerequisites and Checks in local FEATURE.md; no separate Design by default.
- Federated: link approved upstream Feature/allocation (Feature section or separate Plan), write local DESIGN.md at `.swe/implementations/EPIC-NNN/FEATURE-NNN/`.
- Separate [DESIGN-TEMPLATE.md](references/DESIGN-TEMPLATE.md) is justified by substantial interface/state/security/migration or independent review needs. Link it from Feature; never duplicate intent.

Read applicable architecture and code. Address behavior, data/interfaces, failure/security/operations, boundaries, tests and reversal proportionately. Unknown dependencies stay unknown; approved contract/design and validated behavior are distinct prerequisites. Standalone has no required parent Platform. Material architecture divergence returns to swe-architect.

Independent review uses a qualified architect or architecture-reviewer explicitly allocated this procedure. Assess actual outcome/approach, criteria and risk; edit only decision/review record, verifying current fingerprints and preserving reviewer identity/history. Never review your authored/repaired work. Major decisions retain a named human. Any execution checks use swe-test.

Only approved outcome and approach plus applicable architecture/prerequisites permit code. Return the exact design input locator (Feature or separate Design) and decision. Do not edit source/tests/Evidence here.
