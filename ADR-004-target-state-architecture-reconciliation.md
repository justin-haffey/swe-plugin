# ADR-004: Reconcile Target Architecture Through Evidence

> **Status:** Approved — review candidate
>
> **Decision scope:** Architecture change governance
>
> **Source:** [Process Design](DESIGN-scoped-swe-process-and-architecture-library.md)

## Context

Waiting until after code to change architecture obscures approved intent; changing it with no implementation verification can make the library claim a state that does not exist.

## Decision

Allow approved Designs to create linked Target architecture states. Mark the Design Verified and the architecture Implemented only when Evidence confirms reality. If reality diverges, revise both linked records with the reason.

## Consequences

Reviewers can see intended and realized architecture separately. The process needs explicit state-transition checks and Evidence linkage.

## Verification

Test Current-to-Target-to-Implemented, rejected transition without Evidence, and an explicit divergence workflow.
