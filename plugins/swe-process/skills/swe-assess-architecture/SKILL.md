---
name: swe-assess-architecture
description: Assess an Epic or change for architectural impact across platform, solution, package, and module scopes before architecture work begins.
---

# Assess Architecture

Produce a portfolio-owned impact decision, not the architecture itself.

Apply the lifecycle, approval, and locator rules in [the artifact contract](../../references/ARTIFACT-CONTRACT.md).

## Workflow

1. Resolve the Epic, Concept, affected solutions, architecture, ADRs, and contracts through stable IDs and repository-relative paths. Require Accepted Epic and Concept for ordinary assessment. In a shared Concept/Impact authoring packet, draft impact with the unaccepted Concept gate marked unresolved; do not approve Impact or dispatch architecture work until Concept acceptance is recorded.
2. Compare the proposed outcomes with current boundaries, qualities, integrations, data, operations, security, and ownership.
3. Classify each scope as `none`, `review`, or `change`; state why and identify the owning repository and required architect.
4. Write `.swe/epics/NNN-short-name/ARCHITECTURE-IMPACT.md` from [references/ARCHITECTURE-IMPACT-TEMPLATE.md](references/ARCHITECTURE-IMPACT-TEMPLATE.md). Generate metadata/locators through [artifact generation](../../references/ARTIFACT-GENERATION.md). Reuse verified research and Concept references rather than copied narratives; identify risk, trust/contract changes, required early proofs, and participant availability.
5. Do not mutate child architecture. Produce explicit handoffs for any child scope.

## Approval

Default to human approval unless owner-adopted risk policy or explicit run authorization applies; Major decisions retain named-human approval. `-auto-approve` requires an independent architecture reviewer; never self-approve. Co-review the immutable Concept/Impact packet with qualified decision owners, recording separate decisions in dependency order after checking fingerprints. Preserve the maximum two repair/review cycles and their history across resumes. `-force` records an explicit human bypass. Route execution checks through `$swe-test`.

Return the assessment path, approval state, impacted scopes, and handoffs.
