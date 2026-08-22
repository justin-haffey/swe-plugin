---
title: "[PLATFORM_NAME] Structural Context"
artifact_type: "context-vocabulary"
id: "CONTEXT-STRUCTURAL-[PLATFORM_ID]"
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

# Structural Context

The Structural context defines where capabilities belong independently of how work is planned.

## Language

**Platform**: The highest reusable capability environment and shared foundation from which multiple Solutions are built.
_Avoid_: Epic, Application

**Solution**: A coherent assembly of software that addresses one substantial problem or operational objective within the Platform.
_Avoid_: Repository, Epic

**Package**: A cohesive, referenceable, usually versionable dependency or distribution boundary with a defined public contract.
_Avoid_: Module

**Module**: A focused responsibility and cohesion boundary nested inside its owning Package.
_Avoid_: Package, Feature, Namespace

**System**: A runtime or operational view of collaborating elements, potentially spanning Packages; it is not another hierarchy level.
_Avoid_: Solution when only runtime topology is meant

## Rules

- The canonical hierarchy is `Platform -> Solution -> Package -> Module`.
- Modules remain nested under their owning Package.
- Systems are documented as views within Platform or Solution architecture.
