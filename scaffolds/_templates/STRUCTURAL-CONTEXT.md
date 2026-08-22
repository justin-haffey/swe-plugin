# Structural

The Structural context defines the logical organization of software functionality from the broadest reusable technology foundation to focused cohesive implementation units. It exists to answer where capabilities belong independently of how work is planned.

## Language

### Logical Structure

**Platform**:
The highest-level reusable software capability environment that provides shared foundations, runtimes, abstractions, services, tooling, and conventions from which multiple Solutions can be built.
_Avoid_: Application, Project, Epic

**Solution**:
A coherent assembly of software that uses Platform capabilities and other dependencies to address a substantial problem domain or operational objective.
_Avoid_: Platform, Epic, Repository

**Package**:
A cohesive, referenceable and typically versionable collection of software that exposes a defined contract and forms a dependency or distribution boundary.
_Avoid_: Library as the canonical architectural term, Module

**Module**:
A cohesive architectural unit inside a Package or larger System that owns a focused responsibility, internal collaborators, and controlled dependencies without necessarily being independently distributed.
_Avoid_: Package, Feature, Namespace

### Structural Scope

**System**:
A runtime-coherent set of collaborating software elements whose interactions, boundaries, deployment, and operational behavior require architecture at a scope broader than a single Package.
_Avoid_: Solution when referring only to runtime structure, Epic

## Context Rules

- The canonical logical hierarchy is **Platform → Solution → Package → Module**.
- **System** is a runtime/architectural scope and may span multiple Packages within a Solution; it is not required to be another fixed level in the logical hierarchy.
- Use **Package** as the architectural term even when the implementation technology calls the artifact a library, assembly, project, crate, or package.
- A **Module** is a cohesion and responsibility boundary; a **Package** is a dependency/distribution boundary.
- Structural elements organize functionality. They do not replace Epics or Features as delivery-planning constructs.
