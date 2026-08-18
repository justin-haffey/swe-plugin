# ADR-002: Use Scope-Aware Skill Families

> **Status:** Approved— review candidate
>
> **Decision scope:** Process routing and execution
>
> **Source:** [Process Design](DESIGN-scoped-swe-process-and-architecture-library.md)

## Context

Feature-only planning does not describe System, Solution, Workload, Package, or Module work clearly. Conversely, forcing every change through every level would add ceremony without value.

## Decision

Use System, Solution, optional Workload, Package, and Module as architecture and direct-skill scopes. Keep Feature as a functional delivery scope. Make `swe-plan` conversational; make all dash-qualified skills deterministic and fail closed. Higher-scope code skills coordinate and validate child work.

## Consequences

The skill catalog grows, but each skill has a narrow contract and explicit readiness boundary. Workload avoids misusing Module for deployable/operational application roles.

## Verification

Use fixtures for a library Solution without Workloads, a hosted Solution with Workloads, a cross-module Feature, and standalone Module work.
