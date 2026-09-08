---
name: swe-conceptualize
description: Turn Epic research into a portfolio-owned conceptual model, vocabulary, boundaries, and candidate capabilities without prescribing implementation.
---

# Conceptualize

Create or revise only the Epic-local conceptual artifact.

This phase is upstream of architecture impact, Feature planning, the portfolio Implementation Plan, local Design, and coding. It models intent and domain meaning without allocating repositories or producing delivery artifacts.

Apply the lifecycle, approval, and locator rules in [the artifact contract](../../references/ARTIFACT-CONTRACT.md).

## Workflow

1. Resolve the portfolio Epic and require its `EPIC.md` to be `Accepted`; then read relevant `RESEARCH/` artifacts. Stop before authoring when the Epic is not accepted.
2. Create `.swe/epics/NNN-short-name/CONCEPT.md` from [references/CONCEPT-TEMPLATE.md](references/CONCEPT-TEMPLATE.md). Share its discovery/authoring packet with `$swe-assess-architecture`, retaining two canonical outputs and explicit decisions. Generate metadata/locators through [artifact generation](../../references/ARTIFACT-GENERATION.md).
3. Define shared language, actors, domain boundaries, capabilities, relationships, invariants, scenarios, and open questions.
4. Link material claims to the Epic or verified research; record source freshness/applicability without copying narratives. Keep technology and implementation choices out unless explicit constraints. Mark paired impact drafting's Concept gate unresolved until Concept acceptance.
5. Validate that the model supports Epic outcomes and does not duplicate architecture.

## Approval

Default to human approval unless owner-adopted risk policy or explicit run authorization applies; Major decisions retain named-human approval. With `-auto-approve`, an independent platform architect or architecture reviewer reviews the immutable Concept/Impact packet. One reviewer may cover both only when qualified and authorized; record distinct decisions, Concept first, after verifying fingerprints. No self-approval; preserve the maximum two repair cycles and durable history across resumes. `-force` requires recorded human authorization. Route execution checks through `$swe-test`.

Return the path, approval state, changed vocabulary, and unresolved modeling questions.
