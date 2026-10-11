---
name: swe-validate
description: Independently judge standalone, federated or fast-path delivery from actual criteria and evidence.
---
# swe-validate

Apply [the delivery contract](../../references/ARTIFACT-CONTRACT.md). Human approval is default; preserve named Major human decisions, independence and the two-cycle limit.

Branch before requiring inputs:
- Fast path: BUGFIX/ENHANCEMENT owns criteria, approach and evidence. Check eligibility/risk and update only Validation and Closure. No Feature/Plan/Design companions.
- Standalone: approved local Feature/approach (or linked Design), applicable architecture, complete Evidence; no portfolio.
- Federated: approved upstream Feature/allocation and local Design/Evidence. Plan is conditional.
- Portfolio: inspect local independent decisions and actual shared/integration criteria; no blind duplication of local checks.

Be independent of author, designer, implementer and material repairer. Assess actual fixtures/participants/operations, criterion adequacy and current generation. Reuse attributable current receipts; control swe-test requests for missing/stale/independently necessary coverage. Developers own repairs; tester never accepts.

Ordinary delivery uses [VALIDATION-TEMPLATE.md](references/VALIDATION-TEMPLATE.md) beside local Feature/Design or portfolio Feature. Record Accepted, Rejected or Blocked with generation, named approver, independence, receipts and preserved cycle history. Missing/failed/stale required checks cannot pass. Owner fast-path waiver never claims Validated.

Recommend Implemented architecture only with evidence, Current only with operational truth. Never redefine criteria or repair implementation to pass.
