# Context Map

This repository uses three orthogonal contexts to describe agentic software development: **Work**, **Structural**, and **Engineering**. Together they distinguish what capability is being delivered, where that capability belongs in the software, and how engineering knowledge matures from evidence into implementation-ready decisions.

## Contexts

- [Work](./WORK-CONTEXT.md): defines the units of planned software capability and their decomposition from large outcomes into bounded deliverables.
- [Structural](./STRUCTURAL-CONTEXT.md): defines the logical hierarchy used to organize software functionality from platform scope down to cohesive modules.
- [Engineering](./ENGINEERING-CONTEXT.md): defines the engineering knowledge artifacts that progressively reduce uncertainty from research through implementation design.

## Relationships

- **Work → Structural**: Epics and Features describe *what must be delivered*; they map onto one or more Platforms, Solutions, Packages, and Modules that describe *where the capability lives*. This mapping is many-to-many and must not be treated as a fixed hierarchy.
- **Work → Engineering**: An Epic normally establishes the shared Research, Concept, and major Architecture for an initiative. Features consume that context and normally proceed to Feature-level Design; a Feature may trigger targeted Research or Conceptualization when it introduces unresolved conceptual uncertainty.
- **Structural → Engineering**: Architecture is documented at the structural scope where significant decisions belong. System, Package, and Module architecture artifacts describe progressively narrower structural boundaries.
- **Engineering → Work**: Research, Concept, and Architecture may refine, split, merge, or reorder candidate Features before implementation planning is finalized.
- **Engineering → Structural**: Design materializes architectural decisions into implementation-ready contracts, behavior, data structures, interactions, and constraints within the affected structural elements.

## Governing Model

The three contexts are independent axes, not one combined hierarchy:

```text
WORK                     STRUCTURAL                 ENGINEERING

EPIC                     PLATFORM                   RESEARCH
 └── FEATURE              └── SOLUTION                 ↓
                            └── PACKAGE              CONCEPT
                                 └── MODULE             ↓
                                                     ARCHITECTURE
                                                         ↓
                                                       DESIGN
```

A Feature is not a Module, an Epic is not a Solution, and an Architecture artifact is not a work item. Each context answers a different question:

- **Work** — What capability are we delivering?
- **Structural** — Where does that capability belong?
- **Engineering** — What do we know about how to realize it, and at what level of resolution?
