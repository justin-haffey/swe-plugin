---
name: swe-plan-implementation
description: Allocate portfolio criteria to actual solution owners without duplicating local design.
---
# swe-plan-implementation

Apply [the delivery contract](../../references/ARTIFACT-CONTRACT.md). Human approval is default; preserve named Major human decisions, independence and the two-cycle limit.

Cross-solution allocation is not a standalone prerequisite; local task/change maps belong in the Feature approach.

Read governing Feature, contracts, real checkouts and owners. Simple allocation belongs in the Feature. Use [IMPLEMENTATION-PLAN-TEMPLATE.md](references/IMPLEMENTATION-PLAN-TEMPLATE.md) beside it for multiple owners or complex dependencies; never maintain competing allocations.

Each assignment names stable ID, exact repository/allowed paths, criteria, contract obligations, prerequisites/check timing and expected child return. Do not specify local classes/algorithms. Dependencies distinguish Design/Implementation entry and ApprovedContractOrDesign/ValidatedBehavior. Unknown/cyclic dependencies block affected assignments, not unrelated work.

Feature/allocation may be drafted together, approved in dependency order before dispatch. Independent qualified allocation review uses integration-engineer or architecture-reviewer, preserving intent review. Local records live at `.swe/implementations/EPIC-NNN/FEATURE-NNN/`; link, never copy. Return canonical allocation and eligible assignments.
