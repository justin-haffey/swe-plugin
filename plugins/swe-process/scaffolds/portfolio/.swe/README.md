# Portfolio Engineering Work

`.swe/context/` contains durable portfolio vocabularies routed by the root `CONTEXT-MAP.md`. `.swe/epics/` contains lifecycle-bound portfolio work records. Each Epic directory uses `###-short-name` and owns its `RESEARCH`, Concept, architecture-impact assessment, and locally numbered Features.

```text
context/
  WORK-CONTEXT.md
  STRUCTURAL-CONTEXT.md
  ENGINEERING-CONTEXT.md
epics/
  001-short-name/
    EPIC.md
    RESEARCH/
    CONCEPT.md
    ARCHITECTURE-IMPACT.md
    features/
      001-short-name/
        FEATURE.md
        IMPLEMENTATION-PLAN.md
```

The canonical IDs are `EPIC-001` and `FEATURE-001`; paths are locators, not identities. The portfolio owns each `FEATURE.md` and its adjacent `IMPLEMENTATION-PLAN.md`. Allocated child solution repositories link to those artifacts and own `DESIGN.md`, source, tests, `EVIDENCE.md`, and solution-local `VALIDATION.md`.
