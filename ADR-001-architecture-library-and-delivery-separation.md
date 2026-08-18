# ADR-001: Separate Durable Architecture from Delivery Records

> **Status:** Approved— review candidate
>
> **Decision scope:** Reusable SWE process
>
> **Source:** [Process Design](DESIGN-scoped-swe-process-and-architecture-library.md)

## Context

The process must govern both portfolio architecture and individual change delivery without duplicating structural truth into every local plan.

## Decision

Use `docs/` as the durable architecture library and `.swe/` as the delivery record. Research exists only in `.swe/00-research/`. A change-specific Design references architecture and proposes a Target record only when it changes enduring structure, contracts, or boundaries.

## Consequences

Architecture can govern several solutions while delivery records remain local and traceable. The process must provide clear links and reconciliation rules to prevent drift.

## Verification

Validate that a Design can reference Current architecture, establish a Target state, and be reconciled by Evidence without duplicate architecture copies.
