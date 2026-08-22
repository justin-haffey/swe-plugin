---
name: swe-plan-features
description: Decompose an approved Epic and canonical architecture into portfolio-owned, outcome-bounded Features without duplicating solution structure.
---

# Plan Features

Features define delivery capabilities, not packages, modules, tasks, or implementation mechanics.

Apply the lifecycle, approval, locator, and acceptance-ID rules in [the artifact contract](../../references/ARTIFACT-CONTRACT.md).

## Workflow

1. Resolve the approved `EPIC.md`, `CONCEPT.md`, architecture-impact assessment, and applicable canonical architecture.
2. Identify independently valuable capabilities with explicit scope, dependencies, quality needs, and observable acceptance criteria. Allocate stable Feature-local IDs `AC-001`, `AC-002`, and so on.
3. Under the Epic's `features/`, allocate the next local three-digit directory for each Feature: `NNN-short-name/`. Do not reuse IDs.
4. Create `FEATURE.md` from [references/FEATURE-TEMPLATE.md](references/FEATURE-TEMPLATE.md), using `FEATURE-NNN`; numbering is local to the Epic.
5. Maintain exactly one authoritative Feature in the portfolio. Child repositories receive locators and assignments, never copies.
6. Validate that the set covers the Epic outcomes without overlapping authority. Never renumber an accepted criterion.

## Approval

Default to human approval. `-auto-approve` uses an independent `feature-validator`; the author cannot self-approve. Permit two reject/repair cycles, then require a human. `-force` records an explicit human bypass. Repository policy applies unless an invocation flag overrides this workflow.

Return created/changed Feature paths, IDs, approval states, dependencies, and gaps.
