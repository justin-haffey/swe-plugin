---
title: "[PLATFORM_NAME] Engineering Context"
artifact_type: "context-vocabulary"
id: "CONTEXT-ENGINEERING-[PLATFORM_ID]"
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

# Engineering Context

The Engineering context defines artifacts that progressively reduce uncertainty from evidence to independently validated delivery.

## Language

**Research**: Traceable evidence that resolves a material question or records bounded uncertainty.
_Avoid_: Opinion, Architecture

**Concept**: The shared language, capabilities, boundaries, invariants, and intended behavior of an Epic without implementation prescription.
_Avoid_: Architecture, Design

**Architecture**: Significant structural decisions about responsibilities, relationships, interfaces, runtime topology, dependencies, and qualities at the owning scope.
_Avoid_: Concept, detailed Design

**Design**: A solution-local, implementation-ready specification for one assigned Feature portion.
_Avoid_: canonical Feature, Implementation Plan

**Evidence**: Reproducible records of implementation changes and checks; Evidence does not approve itself.
_Avoid_: Validation decision

**Validation**: Independent evaluation of delivered behavior against authoritative acceptance criteria, architecture, Design, contracts, and Evidence.
_Avoid_: implementation claim

## Rules

- The normal progression is `Research -> Concept -> Architecture -> Design -> Evidence -> Validation`.
- Architecture begins as Target, becomes Implemented with evidence, and becomes Current only after validation and operational reconciliation.
- Portfolio artifacts define intent and allocation; solution artifacts refine and prove local implementation.
