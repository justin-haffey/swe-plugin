---
title: "[PLATFORM_NAME] Work Context"
artifact_type: "context-vocabulary"
id: "CONTEXT-WORK-[PLATFORM_ID]"
status: "draft"
authority: "portfolio"
scope: "[PLATFORM_ID]"
parent: "CONTEXT-MAP-[PLATFORM_ID]"
upstream:
  repository: "[REPOSITORY_ID_OR_URL]"
  artifact_id: "CONTEXT-MAP-[PLATFORM_ID]"
  path: "CONTEXT-MAP.md"
  revision: "[OPTIONAL_COMMIT_OR_TAG]"
owners:
  - "[CONTEXT_OWNER]"
created: "[YYYY-MM-DD]"
updated: "[YYYY-MM-DD]"
template_version: "2.0.0"
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

**Implementation Plan**: The portfolio-owned handoff beside a canonical Feature that allocates outcomes, constraints, evidence, and integration responsibilities to child Solution repositories.
_Avoid_: Solution Design, Task List, copied Feature

## Rules

- An Epic owns its Features; a Feature expresses capability rather than code structure.
- The portfolio keeps exactly one `FEATURE.md` and one adjacent `IMPLEMENTATION-PLAN.md`.
- Child repositories link to those artifacts and refine only their assigned implementation.
