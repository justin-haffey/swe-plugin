---
name: swe-assess-architecture
description: Assess an Epic or change for architectural impact across platform, solution, package, and module scopes before architecture work begins.
---

# Assess Architecture

Produce a portfolio-owned impact decision, not the architecture itself.

Apply the lifecycle, approval, and locator rules in [the artifact contract](../../references/ARTIFACT-CONTRACT.md).

## Workflow

1. Resolve the Epic, concept, affected solutions, current architecture, ADRs, and contracts using both artifact IDs and repository-relative paths. Require both the Epic and Concept to be `Accepted`; stop before assessment when either gate is unmet.
2. Compare the proposed outcomes with current boundaries, qualities, integrations, data, operations, security, and ownership.
3. Classify each scope as `none`, `review`, or `change`; state why and identify the owning repository and required architect.
4. Write `.swe/epics/NNN-short-name/ARCHITECTURE-IMPACT.md` from [references/ARCHITECTURE-IMPACT-TEMPLATE.md](references/ARCHITECTURE-IMPACT-TEMPLATE.md).
5. Do not mutate child architecture. Produce explicit handoffs for any child scope.

## Approval

Default to human approval. `-auto-approve` requires an independent architecture reviewer; never self-approve. Allow two reject/repair cycles before human escalation. `-force` records an explicit human bypass. Repository policy applies unless an invocation flag overrides this workflow.

Return the assessment path, approval state, impacted scopes, and handoffs.
