---
title: "[PLATFORM_NAME] Context Map"
artifact_type: "context-map"
id: "CONTEXT-MAP-[PLATFORM_ID]"
status: "draft"
authority: "portfolio"
scope: "[PLATFORM_ID]"
parent: "[PORTFOLIO_ARTIFACT_ID_OR_NONE]"
upstream:
  repository: "[REPOSITORY_ID_OR_URL]"
  artifact_id: "[ARTIFACT_ID_OR_NONE]"
  path: "[REPOSITORY_RELATIVE_PATH_OR_NONE]"
  revision: "[OPTIONAL_COMMIT_OR_TAG]"
owners:
  - "[CONTEXT_OWNER]"
created: "[YYYY-MM-DD]"
updated: "[YYYY-MM-DD]"
template_version: "2.0.0"
---

# [PLATFORM_NAME] Context Map

This repository uses three independent vocabularies so delivery intent, software structure, and engineering knowledge are not collapsed into one hierarchy.

## Contexts

- [Work](./.swe/context/WORK-CONTEXT.md): Epic, Feature, and implementation-allocation vocabulary.
- [Structural](./.swe/context/STRUCTURAL-CONTEXT.md): Platform, Solution, Package, Module, and System-view vocabulary.
- [Engineering](./.swe/context/ENGINEERING-CONTEXT.md): Research, Concept, Architecture, Design, Evidence, and Validation vocabulary.

## Relationships

- **Work -> Structural**: Features describe capabilities and may affect multiple structural scopes; a Feature is not a Module.
- **Work -> Engineering**: Epics and Features provide intent consumed by progressively more concrete engineering artifacts.
- **Structural -> Engineering**: Architecture is authored at the structural scope that owns the significant decision.
- **Engineering -> Work**: evidence and architecture may refine candidate capability boundaries before a Feature is accepted.

## Governing Model

```text
WORK                STRUCTURAL                ENGINEERING
Epic                Platform                  Research
  Feature             Solution                  Concept
                        Package                  Architecture
                          Module                 Design
                                                 Evidence
                                                 Validation
```

Keep each context authoritative for its terms. Add narrower domain `CONTEXT.md` files only when a Solution or bounded context requires vocabulary beyond this map.
