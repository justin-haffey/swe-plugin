---
name: swe-plan-features
description: Define local or portfolio outcome-bounded Features with stable criteria and proportionate approach.
---
# swe-plan-features

Apply [the delivery contract](../../references/ARTIFACT-CONTRACT.md). Human approval is default; preserve named Major human decisions, independence and the two-cycle limit.

Resolve ownership from AGENTS.md. Standalone solutions own Features without a portfolio/Epic. Federated assignments keep one canonical upstream Feature.

1. Read the requested outcome, relevant architecture and code. Read Epic/Concept/impact only when they govern this work; do not create them solely as gates.
2. Use [FEATURE-TEMPLATE.md](references/FEATURE-TEMPLATE.md). Standalone path: `.swe/features/NNN-short-name/`; portfolio: owning Epic's `features/NNN-short-name/`. Allocate IDs in the correct namespace. Optional Epics group related capabilities.
3. Record outcome/exclusions, stable criteria, concise approach/change scope, risk, real dependencies and checks. Use swe-design to develop/review the approach. Draft new Solution architecture alongside the Feature when necessary; approve applicable decisions before code.
4. Portfolio uses swe-plan-implementation for a simple Allocation section or separate Plan when warranted. Every criterion has an owner/integration proof. Never copy intent into children.
5. Review changed decisions once with a qualified independent reviewer or human. Portfolio intent maps to feature-validator; local technical review to swe-design -review. Combine compatible reviews without merging distinct authorities. Return next eligible action and actual blockers.
