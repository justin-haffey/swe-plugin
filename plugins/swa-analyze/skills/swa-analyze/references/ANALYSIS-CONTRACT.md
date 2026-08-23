# SWA Analysis Contract

Use this contract for every SWA strategy and routed analysis.

## Purpose and authority

An SWA report is an advisory reading of existing software-engineering artifacts and code. It can recommend a different architecture, boundary, mental model, interface, or sequence, but it does not change the authority or lifecycle of the sources it analyzes.

Systems are runtime or operational views, not a separate architecture level. Respect the repository's actual hierarchy and ownership; in the SWE scaffolds that hierarchy is `Platform -> Solution -> Package -> Module`.

## Resolve the analysis context

1. Confirm the active repository and the exact target named or implied by the developer input.
2. Identify the target kind from evidence: platform, solution, package, module, system view, component, interface, feature slice, workflow, or another explicit architectural unit.
3. Read the narrowest governing chain that can support the analysis. Depending on scope, this can include `CONTEXT-MAP.md` or `CONTEXT.md`, `.swe/context/`, the active Epic and Concept, architecture-impact assessment, canonical architecture, ADRs, contracts, Features, Implementation Plans, Design, Evidence, Validation, and relevant code/tests.
4. Record the sources actually inspected. Do not imply that an artifact exists or was current when it could not be resolved.

Analyze the existing artifacts and their implemented relationships. Do not translate a strategy's source wording into a request to draw a new diagram. For example, systems mapping means reading the documented and implemented relationships, feedback, ownership, and delays, then explaining leverage points in prose.

## Evidence standard

- Use Codebase Memory for structural code discovery and direct source reads for Markdown, configuration, exact verification, and graph coverage gaps.
- Distinguish confirmed evidence, inference, assumptions, and counterfactual exploration.
- Cite repository-relative paths and qualified symbols close to material findings.
- Make negative or exhaustive claims only after checking the bounded scope, pagination, and available index coverage. State unresolved coverage plainly.
- Stop gathering evidence when the target, current architectural reading, and recommendation trade-offs are sufficiently supported.

## Output path and write boundary

Derive a stable lower-kebab `<scope-key>` from the existing artifact ID, canonical path, or established target name. Prefix the kind only when needed to avoid ambiguity, such as `module-auth-session`.

Write exactly:

```text
architecture/analysis/<scope-key>/ANALYSIS.md
```

The only permitted repository write is creating that missing directory and report. Do not edit any existing code, test, architecture, diagram, ADR, contract, Context, Epic, Concept, Feature, Plan, Design, Evidence, Validation, status, or approval record. Do not overwrite an existing `ANALYSIS.md` unless the user explicitly authorizes replacement or revision.

When a strategy runs as a contributor selected by `$swa-analyze`, return a structured contribution to the router and do not write. The router owns the single combined report. A direct or autonomous strategy invocation owns and writes its report, then returns its path to the calling agent.

## Required report shape

Render every placeholder and use this structure:

```markdown
---
artifact_type: software_architecture_analysis
analysis_status: Complete
scope_kind: <KIND>
scope_name: <NAME>
scope_path: <REPOSITORY_RELATIVE_PATH_OR_NA>
strategies:
  - <SWA_SKILL_NAME>
generated_at: <ISO_8601_TIMESTAMP>
---

# Architecture Analysis: <SCOPE_NAME>

## Executive Architectural Review

<Brief high-level review of the current architecture, strongest finding, and recommended direction.>

## Scope and Existing Evidence

<Target, boundaries, governing artifacts, relevant code, and exclusions.>

## Current Architectural Reading

<Responsibilities, relationships, constraints, qualities, tensions, and implementation reality.>

## Strategy Findings

### <STRATEGY_NAME>

<Findings, evidence, and interpretation. Repeat for each selected strategy.>

## Detailed Recommendations

| Priority | Recommendation | Architectural rationale | Affected authority/artifacts | Expected effect | Trade-offs and validation |
| --- | --- | --- | --- | --- | --- |
| 1 | ... | ... | ... | ... | ... |

## Sequencing and Decision Handoffs

<Recommended order and the owner/workflow that must decide or implement each change.>

## Risks, Assumptions, and Open Questions

<What remains uncertain and what could invalidate the recommendations.>

## Evidence and Coverage

<Repository paths, symbols, graph project/generation when available, direct-source fallback, and limitations.>

## Write Record

Created this advisory report only. No analyzed code or authoritative artifact was modified.
```

Recommendations must be detailed enough for an architect to evaluate: identify the conceptual change, why it matters, affected ownership or interfaces, expected improvement, trade-offs, migration implications, and evidence that would validate or falsify it.
