# Engineering

The Engineering context defines the authoritative artifacts that progressively reduce uncertainty about a software initiative. It exists to transform evidence into a coherent concept, structural decisions, and finally implementation-ready design.

## Language

### Knowledge Progression

**Research**:
An evidence artifact that investigates a problem, technology, constraint, existing system, alternative, or unknown sufficiently to support later engineering decisions.
_Avoid_: Concept, Design, Opinion

**Concept**:
An authoritative conceptual model that explains what is being proposed, why it should exist, its core abstractions, capabilities, operating principles, boundaries, and intended behavior without prematurely fixing implementation details.
_Avoid_: Architecture, Design, Requirements Specification

**Architecture**:
The set of significant structural decisions that determine how a Concept is realized through boundaries, responsibilities, relationships, interfaces, runtime topology, dependencies, and quality attributes.
_Avoid_: Concept, Detailed Design, Code Structure alone

**Design**:
An implementation-ready specification that resolves how architectural elements will behave and be constructed through concrete contracts, interactions, state, algorithms, data structures, schemas, concurrency rules, and error semantics.
_Avoid_: Architecture, Concept, Implementation

### Architecture Artifacts

**System Architecture**:
Architecture describing the runtime structure and interaction of a System, including major components, processes, communications, deployment boundaries, data flow, and operational concerns.
_Avoid_: Solution Overview, Module Architecture

**Package Architecture**:
Architecture describing a Package's responsibility, public contract, dependencies, internal Modules, extension points, lifecycle, and package-level design constraints.
_Avoid_: Module Design, API Reference

**Module Architecture**:
Architecture describing a Module's responsibility, abstractions, collaborators, internal topology, contracts, state, lifecycle, and architecturally significant behavior.
_Avoid_: Class Design, Package Architecture

## Context Rules

- The default knowledge progression is **Research → Concept → Architecture → Design**.
- Each artifact is a knowledge state, not merely a filename: Research resolves evidence gaps, Concept resolves conceptual ambiguity, Architecture resolves structural uncertainty, and Design resolves implementation uncertainty.
- **Conceptualization normally occurs at Epic scope** so related Features share one coherent conceptual model.
- A Feature should normally read the parent Epic, Concept, applicable Architecture, and relevant Research before producing Feature-level Design.
- Feature-level Research or Conceptualization is permitted when a Feature introduces a new problem the parent Concept does not adequately resolve.
- Architecture must be authored at the scope where the significant decision belongs; use specialized **System Architecture**, **Package Architecture**, and **Module Architecture** artifacts accordingly.
- Research and Concept artifacts may legitimately reshape Candidate Features before the Work context promotes them to Planned Features.
