---
name: swe-implement
description: Implement an approved solution-local DESIGN.md with scoped source, tests, documentation, and repository evidence.
---
# Implement

Transform an accepted Design into executable software within the active repository's authority.

Apply the locator-chain and acceptance-ID rules in [the artifact contract](../../references/ARTIFACT-CONTRACT.md). Evidence is non-decision-bearing.

## Workflow

1. Resolve the accepted `DESIGN.md`, its upstream Feature assignment, applicable architecture, and local `AGENTS.md` instructions.
2. Inventory dirty worktree state and preserve unrelated changes. Confirm the planned files and permissions before side effects.
3. Implement the smallest coherent change, including tests and necessary local documentation. Do not mutate portfolio-owned artifacts.
4. Validate incrementally with repository-native format, lint, build, test, security, and integration checks proportional to risk.
5. Write or update `.swe/implementations/EPIC-NNN/FEATURE-NNN/EVIDENCE.md` from [references/EVIDENCE-TEMPLATE.md](references/EVIDENCE-TEMPLATE.md), preserving covered `AC-NNN` IDs verbatim.
6. Record deviations from Design. If a deviation changes accepted architecture or a cross-solution contract, stop for review before continuing.

No invocation grants destructive commands, credential access, publishing, deployment, dependency upgrades, or external mutations unless those actions are separately authorized. Do not retry non-idempotent side effects automatically.

Evidence does not self-approve. Return changed paths, tests, evidence path, deviations, and residual risk.
