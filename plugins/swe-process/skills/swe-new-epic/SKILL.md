---
name: swe-new-epic
description: Create the next governed Epic workspace in a portfolio repository when a durable cross-solution outcome needs definition.
---

# New Epic

Create one portfolio-owned Epic without designing or implementing its solution.

Apply the lifecycle, approval, locator, and stable-ID rules in [the artifact contract](../../references/ARTIFACT-CONTRACT.md).

## Inputs

Require an outcome or problem statement. Infer the repository role from `AGENTS.md` and `.swe/`; stop if the active repository is not a portfolio authority.

## Workflow

1. Inspect `.swe/epics/` and allocate the next three-digit number. Never reuse a retired number.
2. Normalize the short name to lowercase hyphenated text.
3. Create `.swe/epics/NNN-short-name/EPIC.md` from [references/EPIC-TEMPLATE.md](references/EPIC-TEMPLATE.md).
4. Set `id: EPIC-NNN`, portfolio authority, stable parent/upstream locators, stable Epic-local `EO-NNN` acceptance outcomes, constraints, and affected solutions. Reserve `AC-NNN` for Feature-local acceptance criteria.
5. Create empty `RESEARCH/`, `features/`, and `decisions/` directories only when the repository preserves empty directories; otherwise let later skills create them.
6. Validate links, identifiers, and placeholders. Do not create feature or architecture artifacts.

## Approval

Default to human approval. `-auto-approve` delegates review to an independent appropriate agent; the author cannot self-approve. Allow at most two reject/repair/review cycles before requiring a human. `-force` records an explicit human bypass; an agent must never infer it. Repository defaults in `AGENTS.md` apply unless an invocation flag overrides this workflow.

Return the Epic path, assigned ID, approval state, and any unresolved inputs.
