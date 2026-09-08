---
name: swe-plan-features
description: Decompose an approved Epic and canonical architecture into portfolio-owned, outcome-bounded Features without duplicating solution structure.
---

# Plan Features

Features define delivery capabilities, not packages, modules, tasks, or implementation mechanics.

Apply the lifecycle, approval, locator, and acceptance-ID rules in [the artifact contract](../../references/ARTIFACT-CONTRACT.md).

## Workflow

1. Resolve the `Accepted` `EPIC.md`, `Accepted` `CONCEPT.md`, and `Accepted` architecture-impact assessment. Require applicable canonical architecture to be `Target` with an `Accepted` Approval Record before decomposing Features.
2. Identify independently valuable capabilities with explicit scope, dependencies, quality needs, and observable acceptance criteria. Allocate stable Feature-local IDs `AC-001`, `AC-002`, and so on.
3. Under the Epic's `features/`, allocate the next local three-digit directory for each Feature: `NNN-short-name/`. Do not reuse IDs.
4. Create `FEATURE.md` from [references/FEATURE-TEMPLATE.md](references/FEATURE-TEMPLATE.md), using `FEATURE-NNN`; numbering is local to the Epic. Co-author its adjacent Plan through `$swe-plan-implementation` in the same packet, retaining distinct IDs, owners, and decisions. Generate shared metadata and criterion rows through [artifact generation](../../references/ARTIFACT-GENERATION.md), leaving decisions authored.
5. Maintain exactly one authoritative Feature in the portfolio. Child repositories receive locators and assignments, never copies.
6. Validate that the set covers the Epic outcomes without overlapping authority. Never renumber an accepted criterion. Record risk, exact dependency requirements (`ApprovedContractOrDesign` or `ValidatedBehavior`), early proofs, and integration ownership. Unknown dependencies remain gates; unrelated approved assignments can proceed independently.

## Approval

Default to human approval unless an explicitly adopted risk policy or run authorization applies; Major decisions retain named-human approval. `-auto-approve` uses an independent `feature-validator`; the author cannot self-approve. Co-review Feature/Plan in one immutable packet with qualified allocation review, distinct decisions, and upstream acceptance recorded first. Verify decision fingerprints before recording approval. Preserve consumed repair cycles across packets/resumes; two repair/review cycles require human disposition. `-force` records an explicit human bypass. Route agent-directed execution checks through `$swe-test`.

Return created/changed Feature paths, IDs, approval states, dependencies, and gaps.
