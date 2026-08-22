# Work

The Work context defines how agentic software-development initiatives are decomposed into planned units of capability. It exists to separate delivery intent from software structure and engineering documentation.

## Language

### Planning Hierarchy

**Epic**:
A substantial software-development objective representing a coherent outcome or capability area that is too large to implement as a single bounded unit of work.
_Avoid_: Project, Solution, System

**Feature**:
A bounded, independently understandable software capability that contributes to an Epic and can be designed, implemented, and validated as a delivery unit.
_Avoid_: Module, Component, Package

**Candidate Feature**:
A provisional Feature identified during Epic scoping before Research, Conceptualization, and Architecture have sufficiently validated its boundary.
_Avoid_: Final Feature, Requirement

**Planned Feature**:
A Feature whose scope and boundary have been validated against the Epic Concept and applicable Architecture and is ready to enter detailed Design and implementation planning.
_Avoid_: Candidate Feature, Module

## Context Rules

- An **Epic** owns the overall delivery objective and provides the primary planning boundary for a major initiative.
- A **Feature** expresses capability, not code structure; one Feature may affect multiple Packages or Modules, and one Module may support multiple Features.
- Epic scaffolding may create **Candidate Features**, but Research and Conceptualization are allowed to split, merge, remove, or redefine them.
- **Planned Features** should normally be finalized after the Epic Concept and applicable Architecture are sufficiently stable.
- Epic-level Conceptualization is the default. Feature-level Conceptualization is an escalation path for a Feature that introduces unresolved conceptual or architectural uncertainty.
