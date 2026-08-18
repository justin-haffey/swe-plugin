# ADR-003: Use Exact-Name Whole-Template Overrides

> **Status:** Approved— review candidate
>
> **Decision scope:** Artifact generation
>
> **Source:** [Process Design](DESIGN-scoped-swe-process-and-architecture-library.md)

## Context

The plugin needs portable defaults while repositories need safe local tailoring. Partial merging makes generated artifacts difficult to reason about and validate.

## Decision

Templates live with their owning skills. `docs/99-templates/` can override a template only when a whole file has the exact requested filename. The override replaces the default completely; no fragment merge occurs. Outputs record template identity.

## Consequences

Override behavior is predictable and auditable. Repositories must own complete compatible override files.

## Verification

Test exact-match override selection, no-match default fallback, provenance capture, and rejection of incomplete or invalid template metadata.
