---
artifact_type: "context-vocabulary"
id: "CONTEXT-WORK-[PLATFORM_ID]"
status: "draft"
owners: ["[OWNER]"]
schema_version: 4
links: []
---

# Work Context

The Work context defines the portfolio-owned units of delivery without treating them as software structure.

## Language

**Epic**: A substantial outcome too large to deliver as one bounded capability.
_Avoid_: Solution, System, Project

**Feature**: One bounded, independently understandable capability with observable acceptance criteria. Feature numbering is local to its Epic.
_Avoid_: Package, Module, Task

**Candidate Feature**: A provisional capability boundary that Research, Concept, or Architecture may still split, merge, or remove.
_Avoid_: Accepted Feature

**Implementation Plan**: An optional portfolio-owned handoff beside a canonical Feature for complex allocation. It allocates outcomes, constraints, evidence, and integration responsibilities to child Solution repositories.
_Avoid_: Solution Design, Task List, copied Feature

## Rules

- An Epic owns its Features; a Feature expresses capability rather than code structure.
- The portfolio keeps one canonical `FEATURE.md`; allocation lives there or in an adjacent `IMPLEMENTATION-PLAN.md` when complexity warrants it, never both.
- Child repositories link to those artifacts and refine only their assigned implementation.
