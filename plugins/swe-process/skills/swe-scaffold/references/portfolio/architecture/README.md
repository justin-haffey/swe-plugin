# Platform Architecture

This directory is the durable platform architecture library.

- `PLATFORM-ARCHITECTURE.md` is the canonical platform architecture created or revised through `$swe-architect`.
- `analysis/<scope>/ANALYSIS.md` contains advisory strategic reviews of existing architecture and engineering evidence.
- `decisions/` contains platform ADRs.
- `contracts/` contains versioned cross-solution contracts.
- `views/systems/` contains runtime and operational system views. A System is a view, not an architecture level.

Solution, Package, and Module architecture belongs in child solution repositories. `$swe-architect` owns the architecture templates; do not maintain competing repository-local template copies. Architecture changes begin as `Target`, become `Implemented` only with implementation evidence, and become `Current` only after validation and reconciliation.

Analysis reports may identify concerns and recommend governed follow-up work, but they never approve or directly alter architecture, ADRs, contracts, code, tests, or lifecycle artifacts.
