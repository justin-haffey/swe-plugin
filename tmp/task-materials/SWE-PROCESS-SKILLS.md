# SWE Process Skills

Each SWE Process Skill should represent a **well-defined engineering transformation**, not merely “write a document.”

The skills operate across the three contextual axes:

* **Work** — Epic → Feature
* **Structural** — Platform → Solution → Package → Module
* **Engineering** — Research → Concept → Architecture → Design → Implementation

The Portfolio repository owns **Platform-level intent, Epics, Features, Research, Conceptualization, Platform Architecture, and cross-repository implementation planning**.

Child repositories own **Solution/Package/Module Architecture, detailed Feature implementation Design, source code, and tests**.

| Skill                       | Reads                                                                                                       | Produces                                                              | Transformation                                                           | Approach |
| --------------------------- | ----------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------- | ------------------------------------------------------------------------ | -------- |
| `swe-new-epic`            | Human intent + Platform context                                                                             | `EPIC.md` + candidate Features + Epic workspace                     | Idea → structured Platform initiative                                   |          |
| `swe-research`            | `EPIC.md` + candidate Features + existing architecture/code + external evidence                           | `RESEARCH/`                                                         | Questions and unknowns → engineering evidence                           |          |
| swe-conceptualize           | `EPIC.md` + `RESEARCH/` + applicable Platform context                                                   | `CONCEPT.md`                                                        | Evidence + intent → coherent conceptual model                           |          |
| `swe-assess-architecture` | `CONCEPT.md` + current Platform/Solution/Package/Module Architecture                                      | `ARCHITECTURE-IMPACT.md`                                            | Concept → identified structural implications                            |          |
| `swe-architect`           | `CONCEPT.md` + `ARCHITECTURE-IMPACT.md` + current canonical Architecture                                | Updated canonical Architecture artifacts + ADRs/contracts as required | Structural implications → authoritative architecture                    |          |
| `swe-plan-features`       | `EPIC.md` + `CONCEPT.md` + canonical Architecture + candidate Features                                  | Finalized Feature directories containing`FEATURE.md`                | Epic + Architecture → bounded delivery capabilities                     |          |
| `swe-plan-implementation` | `FEATURE.md` + Platform Architecture + affected Solution boundaries                                       | `IMPLEMENTATION-PLAN.md`                                            | Platform Feature → repository/package/module implementation assignments |          |
| `swe-design`              | Feature assignment +`FEATURE.md` + `IMPLEMENTATION-PLAN.md` + applicable Architecture + repository code | Child-repo`DESIGN.md`                                               | Assigned capability → implementation-ready specification                |          |
| `swe-implement`           | `DESIGN.md` + applicable Architecture + repository source                                                 | Source code + tests + required local documentation updates            | Specification → executable software                                     |          |
| `swe-validate`            | `FEATURE.md` acceptance criteria + `DESIGN.md` + implementation + tests                                 | Validation results / completion evidence                              | Implemented software → demonstrated Feature correctness                 |          |

## Skill Flow

```text
                         PLATFORM / PORTFOLIO
                                  │
                                  ▼
                       swe-scaffold-epic
                                  │
                                  ▼
                              EPIC.md
                         + Candidate Features
                                  │
                                  ▼
                          swe-research
                                  │
                                  ▼
                             RESEARCH/
                                  │
                                  ▼
                       swe-conceptualize
                                  │
                                  ▼
                             CONCEPT.md
                                  │
                                  ▼
                    swe-assess-architecture
                                  │
                                  ▼
                     ARCHITECTURE-IMPACT.md
                                  │
                                  ▼
                         swe-architect
                                  │
                                  ▼
                  Canonical Architecture Updates
                                  │
                                  ▼
                       swe-plan-features
                                  │
                     ┌────────────┼────────────┐
                     ▼            ▼            ▼
                 FEATURE-001  FEATURE-002  FEATURE-003
                     │            │            │
                     ▼            ▼            ▼
                  FEATURE.md   FEATURE.md   FEATURE.md
                     │
                     ▼
               swe-plan-implementation
                     │
                     ▼
              IMPLEMENTATION-PLAN.md
                     │
          ┌──────────┼───────────┐
          │          │           │
          ▼          ▼           ▼
      Solution A  Solution B  Solution C
          │          │           │
──────────┼──────────┼───────────┼──────── Repository Boundary
          │          │           │
          ▼          ▼           ▼
      swe-design  swe-design  swe-design
          │          │           │
          ▼          ▼           ▼
      DESIGN.md   DESIGN.md   DESIGN.md
          │          │           │
          ▼          ▼           ▼
     swe-implement swe-implement swe-implement
          │          │           │
          ▼          ▼           ▼
      CODE/TESTS  CODE/TESTS  CODE/TESTS
          │          │           │
          └──────────┼───────────┘
                     ▼
                swe-validate
                     │
                     ▼
              FEATURE COMPLETE
```

## Artifact Ownership

The skills must respect artifact authority and repository scope.

| Artifact                     | Authority                       | Typical Location                                                |
| ---------------------------- | ------------------------------- | --------------------------------------------------------------- |
| `EPIC.md`                  | Platform / Portfolio            | `.swe/epics/{epic}/EPIC.md`                                   |
| `RESEARCH/`                | Platform / Epic                 | `.swe/epics/{epic}/RESEARCH/`                                 |
| `CONCEPT.md`               | Platform / Epic                 | `.swe/epics/{epic}/CONCEPT.md`                                |
| `ARCHITECTURE-IMPACT.md`   | Platform / Epic                 | `.swe/epics/{epic}/ARCHITECTURE-IMPACT.md`                    |
| `PLATFORM-ARCHITECTURE.md` | Platform                        | `architecture/PLATFORM-ARCHITECTURE.md`                       |
| `SOLUTION-ARCHITECTURE.md` | Child Solution repository       | `architecture/SOLUTION-ARCHITECTURE.md`                       |
| `PACKAGE-ARCHITECTURE.md`  | Child Solution repository       | `architecture/packages/{package}/PACKAGE-ARCHITECTURE.md`     |
| `MODULE-ARCHITECTURE.md`   | Child Solution repository       | `architecture/modules/{module}/MODULE-ARCHITECTURE.md`        |
| `FEATURE.md`               | Platform / Epic                 | `.swe/epics/{epic}/features/{feature}/FEATURE.md`             |
| `IMPLEMENTATION-PLAN.md`   | Platform / Feature              | `.swe/epics/{epic}/features/{feature}/IMPLEMENTATION-PLAN.md` |
| `DESIGN.md`                | Child repository implementation | `.swe/implementations/{epic}/{feature}/DESIGN.md`             |
| Source + tests               | Child repository                | `src/`, `tests/`                                            |

## Core Rules

### 1. Skills consume authoritative upstream artifacts

Skills should not repeatedly rediscover intent from conversation when an authoritative artifact already exists.

```text
Research reads Epic.
Concept reads Research.
Architecture reads Concept.
Feature planning reads Architecture.
Design reads Feature + Architecture.
Implementation reads Design.
Validation reads Feature acceptance criteria + implementation.
```

The repository becomes the engineering memory of the process.

### 2. Epics are Platform-level work constructs

Epics are owned by the Portfolio repository.

Child repositories do not recreate or duplicate Platform Epics.

```text
Portfolio
└── Epic
    └── Feature
```

A child repository receives an **implementation assignment** derived from a Platform Feature.

### 3. Features remain under their parent Epic

```text
.swe/
└── epics/
    └── {epic}/
        └── features/
            └── {feature}/
                ├── FEATURE.md
                └── IMPLEMENTATION-PLAN.md
```

A Feature is a bounded capability, not a Package or Module.

### 4. Conceptualization normally occurs at Epic scope

The Epic Concept establishes the shared conceptual model for its Features.

A Feature should not receive a separate Concept by default.

Feature-level Research or Conceptualization is an **escalation path** when the Feature introduces conceptual uncertainty not adequately resolved by the parent Epic.

### 5. Architecture is canonical structural knowledge

Architecture does not live under an Epic merely because the Epic caused it to change.

The Epic records the proposed impact:

```text
ARCHITECTURE-IMPACT.md
```

`swe-architect` then applies the accepted changes to the canonical Architecture owned by the affected structural scope.

```text
Platform Architecture    → Portfolio
Solution Architecture    → Child repo
Package Architecture     → Child repo
Module Architecture      → Child repo
```

### 6. Architecture is federated; authority follows structural scope

```text
PLATFORM ARCHITECTURE
        │
        ▼
SOLUTION ARCHITECTURE
        │
        ▼
PACKAGE ARCHITECTURE
        │
        ▼
MODULE ARCHITECTURE
        │
        ▼
FEATURE DESIGN
        │
        ▼
IMPLEMENTATION
```

A lower-level artifact may refine a higher-level architectural decision but must not silently contradict it.

### 7. Implementation planning is the Platform-to-repository handoff

`IMPLEMENTATION-PLAN.md` bridges Platform Feature planning and child-repository engineering.

It identifies:

* affected Solutions/repositories
* affected Packages
* affected Modules
* responsibility assigned to each repository
* cross-repository dependencies
* sequencing constraints
* applicable architecture
* required contracts or integration points

It deliberately does **not** specify detailed classes, methods, algorithms, or implementation mechanics.

Those belong to `DESIGN.md`.

### 8. Detailed Design belongs with the implementing repository

Each affected child repository independently produces the detailed implementation Design for its assigned portion of the Feature.

```text
Portfolio Feature
      │
      ▼
IMPLEMENTATION-PLAN.md
      │
      ├──────────► AgentRuntime
      │               └── DESIGN.md
      │
      ├──────────► System
      │               └── DESIGN.md
      │
      └──────────► Observability
                      └── DESIGN.md
```

This preserves a critical boundary:

> **The Platform determines what must change and where responsibility belongs. The child repository determines exactly how its responsibility will be implemented.**

## Transformation Principle

Each skill should resolve a specific category of uncertainty:

| Skill                       | Uncertainty Resolved                  | Approach |
| --------------------------- | ------------------------------------- | -------- |
| `swe-scaffold-epic`       | Initiative ambiguity                  |          |
| `swe-research`            | Evidence and knowledge uncertainty    |          |
| `swe-conceptualize`       | Conceptual uncertainty                |          |
| `swe-assess-architecture` | Architectural impact uncertainty      |          |
| `swe-architect`           | Structural uncertainty                |          |
| `swe-plan-features`       | Capability decomposition uncertainty  |          |
| `swe-plan-implementation` | Responsibility/allocation uncertainty |          |
| `swe-design`              | Implementation uncertainty            |          |
| `swe-implement`           | Construction                          |          |
| `swe-validate`            | Correctness uncertainty               |          |

The resulting SWE process is therefore not a document-generation pipeline. It is a **progressive uncertainty-reduction and responsibility-localization pipeline**:

```text
INTENT
  ↓
EVIDENCE
  ↓
CONCEPT
  ↓
STRUCTURE
  ↓
CAPABILITY
  ↓
RESPONSIBILITY
  ↓
DESIGN
  ↓
IMPLEMENTATION
  ↓
VALIDATION
```

As the process progresses, authority moves from broad Platform-level reasoning toward increasingly local implementation authority:

```text
Broad / Global                                      Local / Concrete

RESEARCH → CONCEPT → ARCHITECTURE → FEATURE → PLAN → DESIGN → CODE
   │          │            │           │       │       │       │
Platform   Platform    Platform +   Platform Platform  Child   Child
                         Child
```

This allows the Portfolio repository to function as the **Platform engineering and coordination authority**, while each child repository remains the **authoritative implementation boundary** for the software it owns.
