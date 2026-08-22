I would structure the Codex agents as **durable engineering roles**, with SWE skills acting as the repeatable procedures those roles invoke. I would not create one agent per skill. Several agents should invoke the same skill at different structural scopes.

The key split is:

> **Platform agents reason about intent, capability, coordination, and cross-repository architecture. Solution agents reason about local architecture, detailed design, implementation, and verification.**

### Recommended Codex Agent Model

| Codex Agent                 | Level                                         | Primary Responsibility                                                                                                                                                                                                                                       | SWE Process Skills Called                                                                                                          | Required Knowledge — Artifact Level                                                                                                                                                                                                                                                                                                    | Primary Artifacts Affected                                                                                  |
| --------------------------- | --------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------- |
| **`platform-engineer`**     | **Portfolio / Platform**                      | Owns the end-to-end engineering initiative and Work-axis decomposition. Converts human intent into Epics, coordinates downstream specialists, finalizes Features, and ensures work remains aligned with Platform intent.                                     | `swe-new-epic`, `swe-plan-features`, `swe-plan-implementation`; may orchestrate `swe-validate`                                     | **Required:** `CONTEXT-MAP.md`, `WORK-CONTEXT.md`, `STRUCTURAL-CONTEXT.md`, `ENGINEERING-CONTEXT.md`, `PLATFORM-ARCHITECTURE.md`. **Per Epic:** `EPIC.md`, `RESEARCH/`, `CONCEPT.md`, `ARCHITECTURE-IMPACT.md`. **Per Feature:** `FEATURE.md`, relevant Platform contracts and architecture.                                           | `EPIC.md`, candidate Features, `FEATURE.md`, `IMPLEMENTATION-PLAN.md`                                       |
| **`research-engineer`**     | **Portfolio / Platform**                      | Resolves evidence and knowledge uncertainty before conceptual or architectural commitments are made. Performs technical research, codebase investigation, standards review, comparative analysis, and experiments.                                           | `swe-research`                                                                                                                     | **Required:** `EPIC.md`, candidate Features, relevant existing `RESEARCH/`, applicable Platform/Solution/Package/Module Architecture, relevant source code. **Context:** `ENGINEERING-CONTEXT.md`, `STRUCTURAL-CONTEXT.md`.                                                                                                            | `RESEARCH/{topic}.md`                                                                                       |
| **`platform-architect`**    | **Portfolio / Platform**                      | Owns the conceptual coherence and architecture of the Platform. Determines how new capabilities affect Solutions, contracts, dependencies, and Platform topology.                                                                                            | `swe-conceptualize`, `swe-assess-architecture`, `swe-architect`; participates in `swe-plan-features` and `swe-plan-implementation` | **Required:** `EPIC.md`, complete relevant `RESEARCH/`, existing `CONCEPT.md`, `PLATFORM-ARCHITECTURE.md`, `architecture/contracts/`, Platform ADRs, Solution architecture summaries, `SOLUTION-MAP.md`, `DEPENDENCY-MAP.md`, `RUNTIME-TOPOLOGY.md`.                                                                                   | `CONCEPT.md`, `ARCHITECTURE-IMPACT.md`, `PLATFORM-ARCHITECTURE.md`, Platform ADRs, cross-Solution contracts |
| **`solution-architect`**    | **Solution**                                  | Owns architecture inside one Solution boundary. Interprets Platform architecture and implementation assignments and determines how the Solution must evolve without violating upstream constraints.                                                          | `swe-architect`; may participate in `swe-design` for cross-Package or structurally significant implementations                     | **Required upstream:** `PLATFORM-ARCHITECTURE.md`, relevant Platform contracts, `FEATURE.md`, `IMPLEMENTATION-PLAN.md`, `ARCHITECTURE-IMPACT.md`. **Required local:** `CONTEXT.md`, `SOLUTION-ARCHITECTURE.md`, local ADRs, all affected `PACKAGE-ARCHITECTURE.md` and significant `MODULE-ARCHITECTURE.md`, relevant source topology. | `SOLUTION-ARCHITECTURE.md`, Solution ADRs, affected Package/Module architecture                             |
| **`package-architect`**     | **Solution**                                  | Owns architectural integrity of a specific Package. Refines Solution Architecture into Package boundaries, APIs, dependencies, extension points, lifecycle, and Module decomposition. This may be a specialized agent rather than a permanently active role. | `swe-architect`; participates in `swe-design` for Package-wide work                                                                | **Required upstream:** `FEATURE.md`, `IMPLEMENTATION-PLAN.md`, `SOLUTION-ARCHITECTURE.md`, applicable Platform contracts. **Required local:** target `PACKAGE-ARCHITECTURE.md`, child `MODULE-ARCHITECTURE.md` artifacts, Package ADRs if present, public API/source surface, dependency graph.                                        | `PACKAGE-ARCHITECTURE.md`, Package-related ADRs, affected Module architecture                               |
| **`module-architect`**      | **Solution**                                  | Resolves architecture inside a substantial Module when the Module is complex enough to warrant explicit architectural ownership. Bridges Package Architecture and implementation Design.                                                                     | `swe-architect`; may participate in `swe-design`                                                                                   | **Required:** `FEATURE.md`, relevant assignment from `IMPLEMENTATION-PLAN.md`, `SOLUTION-ARCHITECTURE.md`, parent `PACKAGE-ARCHITECTURE.md`, target `MODULE-ARCHITECTURE.md`, relevant contracts, neighboring Module architecture, existing Module source/tests.                                                                       | `MODULE-ARCHITECTURE.md`, Module-level architectural decisions                                              |
| **`solution-developer`**    | **Solution**                                  | General implementation agent for a Feature assignment that spans several Packages or Modules inside a Solution. Best default developer when the work is not narrowly localized.                                                                              | `swe-design`, `swe-implement`, local `swe-validate`                                                                                | **Required upstream:** `FEATURE.md`, `IMPLEMENTATION-PLAN.md`, Platform contracts that apply. **Required local:** `SOLUTION-ARCHITECTURE.md`, affected `PACKAGE-ARCHITECTURE.md`, affected `MODULE-ARCHITECTURE.md`, existing `DESIGN.md` if continuing work, source code and tests.                                                   | `.swe/implementations/{epic}/{feature}/DESIGN.md`, source, tests                                            |
| **`package-developer`**     | **Solution**                                  | Implements a Feature assignment primarily contained within one Package. Maintains Package contracts and respects Package Architecture while making concrete implementation decisions.                                                                        | `swe-design`, `swe-implement`, local `swe-validate`                                                                                | **Required:** `FEATURE.md`, relevant section of `IMPLEMENTATION-PLAN.md`, `SOLUTION-ARCHITECTURE.md`, target `PACKAGE-ARCHITECTURE.md`, affected Module Architecture, `DESIGN.md`, Package source/API/tests, relevant Platform contracts.                                                                                              | `DESIGN.md`, Package source, Package tests                                                                  |
| **`module-developer`**      | **Solution**                                  | Implements narrowly scoped work within one Module. This should be the most localized engineering agent and should receive the smallest relevant context set.                                                                                                 | `swe-design`, `swe-implement`, local `swe-validate`                                                                                | **Required:** `FEATURE.md`, assigned portion of `IMPLEMENTATION-PLAN.md`, parent `PACKAGE-ARCHITECTURE.md`, target `MODULE-ARCHITECTURE.md`, relevant portion of `DESIGN.md`, Module source/tests, directly interacting Module contracts.                                                                                              | `DESIGN.md` when Module-scoped, Module source, Module tests                                                 |
| **`fullstack-developer`**   | **Solution**                                  | Implements vertical Feature slices crossing presentation, application, API, persistence, messaging, or other layers within a Solution. Useful when structural ownership cuts across multiple Packages but still remains within one repository.               | `swe-design`, `swe-implement`, local `swe-validate`                                                                                | **Required:** `FEATURE.md`, `IMPLEMENTATION-PLAN.md`, `SOLUTION-ARCHITECTURE.md`, architecture for every affected Package/Module, API/event contracts, current `DESIGN.md`, affected source and integration/acceptance tests.                                                                                                          | `DESIGN.md`, source across Packages/Modules, integration tests                                              |
| **`integration-engineer`**  | **Solution**, sometimes Platform-coordinated  | Implements and verifies boundaries between Packages, Solutions, services, protocols, events, and external dependencies. Particularly important for cross-repository Features.                                                                                | `swe-design`, `swe-implement`, `swe-validate`                                                                                      | **Required:** `FEATURE.md`, `IMPLEMENTATION-PLAN.md`, applicable cross-Solution contracts, `PLATFORM-ARCHITECTURE.md`, participating `SOLUTION-ARCHITECTURE.md` artifacts, local Designs, integration interfaces, runtime/data-flow views, integration tests.                                                                          | Integration portions of `DESIGN.md`, adapters/contracts implementation, integration tests                   |
| **`feature-validator`**     | **Portfolio / Platform**                      | Determines whether the complete distributed implementation actually satisfies the authoritative Platform Feature rather than merely whether individual repositories compile and pass local tests.                                                            | `swe-validate`                                                                                                                     | **Required:** authoritative `FEATURE.md` including acceptance criteria, `IMPLEMENTATION-PLAN.md`, all participating child `DESIGN.md` artifacts, relevant architecture/contracts, implementation/test results from every assigned Solution, integration/acceptance evidence.                                                           | Feature validation/completion evidence                                                                      |
| **`architecture-reviewer`** | **Portfolio or Solution, depending on scope** | Independent architectural conformance reviewer. Detects contradictions between architecture levels, unauthorized dependency changes, accidental scope leakage, and implementation that has silently changed architecture.                                    | Primarily reviews outputs of `swe-assess-architecture`, `swe-architect`, `swe-design`; may invoke `swe-validate` for conformance   | **Required:** the architecture chain from `PLATFORM-ARCHITECTURE.md` down through affected Solution/Package/Module artifacts, associated ADRs/contracts, `ARCHITECTURE-IMPACT.md`, `IMPLEMENTATION-PLAN.md`, proposed `DESIGN.md`.                                                                                                     | Review findings; potentially requested ADR/architecture corrections                                         |

## I would make these the **core permanent agents**

You probably do **not** need every possible specialist instantiated as a first-class Codex agent. I would start with seven core roles:

```text
PLATFORM / PORTFOLIO
│
├── platform-engineer
├── research-engineer
├── platform-architect
└── feature-validator
          │
          │ delegates across repository boundary
          ▼
SOLUTION
│
├── solution-architect
├── solution-developer
└── integration-engineer
```

Then allow `solution-developer` to delegate downward to specialized implementation personas when the work benefits from narrower context:

```text
solution-developer
      │
      ├── package-developer
      ├── module-developer
      └── fullstack-developer
```

Likewise, `solution-architect` can descend structurally when needed:

```text
solution-architect
      │
      ├── package-architect
      └── module-architect
```

I would make **Package Architect** and **Module Architect** conditional specializations rather than always-running agents. For a small Package, a `solution-architect` can perform the architectural work. For a large foundational Package such as a Component Model, Graph library, Event system, or Agent Runtime, narrower architect agents become useful because their context can be much deeper.

---

## Skill-to-Agent Invocation Matrix

Looking at it from the skill perspective makes the ownership even clearer:

| SWE Skill                 | Primary Caller              | Secondary / Scoped Caller                                                              | Execution Level                |
| ------------------------- | --------------------------- | -------------------------------------------------------------------------------------- | ------------------------------ |
| `swe-new-epic`            | `platform-engineer`         | —                                                                                      | Platform                       |
| `swe-research`            | `research-engineer`         | `platform-architect`, specialist developer for targeted research                       | Primarily Platform             |
| `swe-conceptualize`       | `platform-architect`        | `platform-engineer` participates                                                       | Platform                       |
| `swe-assess-architecture` | `platform-architect`        | `solution-architect` contributes impact analysis for its Solution                      | Platform-led                   |
| `swe-architect`           | `platform-architect`        | `solution-architect`, `package-architect`, `module-architect`                          | Federated by structural scope  |
| `swe-plan-features`       | `platform-engineer`         | `platform-architect`                                                                   | Platform                       |
| `swe-plan-implementation` | `platform-engineer`         | `platform-architect`, affected `solution-architect` agents                             | Platform                       |
| `swe-design`              | `solution-developer`        | `package-developer`, `module-developer`, `fullstack-developer`, `integration-engineer` | Solution                       |
| `swe-implement`           | Appropriate developer agent | Same developer specializations                                                         | Solution                       |
| `swe-validate`            | `feature-validator`         | Developer/integration agents perform local validation first                            | Solution → Platform completion |

The important case is **`swe-architect`**. I would deliberately make that skill **structurally polymorphic**:

```text
swe-architect --scope platform
        → PLATFORM-ARCHITECTURE.md

swe-architect --scope solution
        → SOLUTION-ARCHITECTURE.md

swe-architect --scope package
        → PACKAGE-ARCHITECTURE.md

swe-architect --scope module
        → MODULE-ARCHITECTURE.md
```

The calling agent determines the authority boundary.

---

# Artifact Context Should Be Layered, Not “Read Everything”

This is particularly important for Codex.

I would give every agent three classes of knowledge:

| Context Class | Meaning                                                                      |
| ------------- | ---------------------------------------------------------------------------- |
| **Governing** | Artifacts that establish rules the agent may not violate                     |
| **Task**      | Artifacts describing the specific Epic/Feature/implementation being worked   |
| **Local**     | Architecture, code, tests, and dependencies immediately surrounding the work |

For example, a `module-developer` working on `ComponentModel/Lifecycle` should **not** receive the entire Portfolio by default.

Its context package could be:

```text
GOVERNING
├── FEATURE.md
├── relevant IMPLEMENTATION-PLAN.md section
├── applicable Platform contract(s)
└── parent architecture constraints

LOCAL STRUCTURE
├── SOLUTION-ARCHITECTURE.md
├── ComponentModel/PACKAGE-ARCHITECTURE.md
└── ComponentModel/modules/Lifecycle/MODULE-ARCHITECTURE.md

ENGINEERING
├── .swe/implementations/EPIC-007/FEATURE-003/DESIGN.md
├── relevant source
├── relevant tests
└── directly coupled interfaces/modules
```

It generally does **not** need:

```text
EPIC.md
all RESEARCH/
entire CONCEPT.md
every Platform ADR
unrelated Solution architecture
unrelated Packages
```

unless the task exposes a conflict requiring escalation.

Conversely, the `platform-architect` needs broad context but little implementation detail:

```text
EPIC.md
RESEARCH/
CONCEPT.md
PLATFORM-ARCHITECTURE.md
Platform ADRs
Platform contracts
SOLUTION-ARCHITECTURE.md summaries
SOLUTION-MAP.md
DEPENDENCY-MAP.md
RUNTIME-TOPOLOGY.md
```

but should not normally ingest thousands of implementation files.

That leads to a useful principle for the eventual agent definitions:

> **Agent authority determines both the maximum scope it may change and the minimum authoritative artifact set it must understand.**

---

# The resulting agent hierarchy

I think the target Codex topology should look approximately like this:

```text
                         HUMAN
                           │
                           ▼
                  platform-engineer
                           │
             ┌─────────────┼──────────────┐
             │             │              │
             ▼             ▼              ▼
     research-engineer platform-architect feature-validator
                           │
                           │ Platform Feature +
                           │ Implementation Plan
═══════════════════════════╪════════════════════════════
                  REPOSITORY BOUNDARY
                           │
              ┌────────────┼────────────┐
              ▼            ▼            ▼
       solution-architect  ...    solution-architect
              │
       ┌──────┴──────┐
       ▼             ▼
package-architect module-architect
       │             │
       └──────┬──────┘
              ▼
      solution-developer
              │
     ┌────────┼───────────┐
     ▼        ▼           ▼
 package-   module-    fullstack-
 developer  developer   developer
     │        │           │
     └────────┼───────────┘
              ▼
     integration-engineer
              │
              ▼
         local validation
              │
══════════════╪══════════════════════════════════════
              ▼
       feature-validator
              │
              ▼
        FEATURE COMPLETE
```

## One naming recommendation

I would use **`platform-engineer` rather than `platform-manager` or `product-owner`** for the top-level Codex role.

Your Epics are not merely backlog objects. That agent is coordinating engineering knowledge, architectural transformation, Feature decomposition, and repository allocation. `platform-engineer` captures that responsibility better.

Similarly, I would use:

* `platform-architect`
* `solution-architect`
* `package-architect`
* `module-architect`

for the **Structural axis**, and:

* `solution-developer`
* `package-developer`
* `module-developer`
* `fullstack-developer`
* `integration-engineer`

for increasingly specialized **implementation execution**.

This produces a very useful symmetry:

```text
                 ARCHITECTURE             IMPLEMENTATION

Platform      platform-architect          —
Solution      solution-architect          solution-developer
Package       package-architect           package-developer
Module        module-architect            module-developer
Cross-cutting platform-architect          integration-engineer
Vertical      —                           fullstack-developer
```

I would **not** create a `platform-developer`: by definition in this operating model, the Platform repo coordinates and architects while executable software lives in child Solution repositories.
