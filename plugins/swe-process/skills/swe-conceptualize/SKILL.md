---
name: swe-conceptualize
description: Turn Epic research into a portfolio-owned conceptual model, vocabulary, boundaries, and candidate capabilities without prescribing implementation.
---

# Conceptualize

Create or revise only the Epic-local conceptual artifact.

Apply the lifecycle, approval, and locator rules in [the artifact contract](../../references/ARTIFACT-CONTRACT.md).

## Workflow

1. Resolve the portfolio Epic and read its `EPIC.md` plus relevant `RESEARCH/` artifacts.
2. Create `.swe/epics/NNN-short-name/CONCEPT.md` from [references/CONCEPT-TEMPLATE.md](references/CONCEPT-TEMPLATE.md).
3. Define shared language, actors, domain boundaries, capabilities, relationships, invariants, scenarios, and open questions.
4. Link every material claim to its Epic or research source. Keep technology and implementation choices out unless they are explicit constraints.
5. Validate that the model supports Epic outcomes and does not duplicate architecture.

## Approval

Default to human approval. With `-auto-approve`, an independent platform architect or architecture reviewer must review; the author cannot self-approve. Cap rejection repair at two cycles, then require a human. `-force` is an explicit human bypass and must be recorded. Repository policy applies unless an invocation flag overrides this workflow.

Return the path, approval state, changed vocabulary, and unresolved modeling questions.
