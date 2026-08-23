# Codebase Memory Evidence Workflow

Use codebase-memory-mcp as structural evidence for SWA analysis, not as a substitute for architectural judgment or direct artifact reading.

## Establish the graph

1. Resolve the exact repository and graph project. Use `list_projects` and `index_status` when callable; otherwise test the inferred project with `get_architecture` and disclose the limitation.
2. If the repository is missing or stale and indexing is authorized, call `index_repository` for the exact repository with persistence disabled so analysis does not add a graph artifact to the repository. Do not re-index reflexively when a current graph is available.
3. Use `get_graph_schema` before custom graph queries when the available labels, properties, or relationships are uncertain.

## Gather task-directed evidence

- `get_architecture`: establish languages, packages, boundaries, layers, entry points, hotspots, dependencies, and clusters relevant to the target.
- `search_graph`: locate candidate functions, classes, interfaces, routes, variables, packages, and modules. Prefer narrow queries or patterns and inspect `has_more`; paginate material result sets.
- `trace_path`: inspect inbound and outbound calls, data flow, or cross-service paths for the relationships relevant to the chosen strategy. Keep depth proportionate to the question.
- `get_code_snippet`: verify material definitions only after `search_graph` supplies the exact qualified name.
- `query_graph`: answer bounded multi-hop, aggregation, coupling, dependency-direction, complexity, or hotspot questions that simpler tools cannot answer. Use only the supported read-only query subset.
- `search_code`: find literals and code/config occurrences when available, then verify exact source. Do not treat a zero text-search result as proof of absence.
- `detect_changes`: use only when the requested analysis concerns current changes and the tool is available.

After candidate evidence paths are known, batch them through `check_index_coverage` when that tool is callable. A clean result means no recorded gap, not proof of completeness. For partial, skipped, excluded, stale, pending, unknown, or unavailable coverage, read the reported source ranges or bounded scope directly. Markdown, TOML, JSON, templates, and other non-code artifacts should normally be read directly even when represented in the graph.

## Strategy-specific emphasis

- Leverage, interface, pattern, and dialectic analysis benefit from dependency, call/data-flow, cluster, degree, and repeated-structure evidence.
- Boundary and perspective analysis benefit from packages, layers, routes, contracts, consumers, and cross-service relationships.
- Abstraction and first-principles analysis use graph evidence to test whether documented responsibilities match implementation, not to derive goals from code alone.
- Inversion, constraint, and scenario analysis use current paths and hotspots as feasibility evidence for counterfactuals.

Record the exact project, queries or tool purposes, pagination state, direct-source checks, and limitations in `ANALYSIS.md`. Never claim access to a Codebase Memory tool that was unavailable in the active runtime.
