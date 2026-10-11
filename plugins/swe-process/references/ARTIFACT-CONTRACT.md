# SWE delivery contract - V4

## Authority

AGENTS.md owns repository authority, approval defaults and phase ownership. Skills own procedures; native agent definitions own expertise, allowed scope, configured model and independence. The root coordinator schedules eligible work; scripts record mechanical facts. Read governing inputs once, refresh changed inputs and expand for a concrete missing fact. Never copy the full lifecycle into every assignment.

A solution declares `Delivery mode: Standalone` or `Delivery mode: Federated` in AGENTS.md. A portfolio declares `Repository role: Portfolio`. Standalone is the fresh solution default. Existing repositories require explicit owner adoption; installation, directory location or an unreachable portfolio never changes ownership.

- Standalone solutions own local intent, Features, optional Epics, architecture, implementation and acceptance. No Platform, portfolio Plan, bridge or remote task is required.
- Federated assignments link portfolio-owned Features/allocations/contracts; children own local Design, code, tests, Evidence and Validation. Never copy upstream Features. Local work outside assignments may use local Features only when governance explicitly permits that ownership.
- Portfolios coordinate shared outcomes, actual participants, contracts and integration acceptance. A folder of unrelated projects is not automatically a portfolio.

Structure is Platform -> Solution -> Package -> Module where scopes exist. A standalone Solution is a valid root. Systems are views. Create package/module documents and agents only for meaningful boundaries.

## Minimum records

| Route | Canonical records | Gate |
| --- | --- | --- |
| Ordinary standalone Feature | FEATURE.md with outcome and approach; EVIDENCE.md; VALIDATION.md | Approved outcome/approach, applicable architecture and prerequisites before code; independent acceptance after required checks. |
| Federated assignment | Upstream Feature/allocation links; local DESIGN.md, EVIDENCE.md, VALIDATION.md | Approved allocation/local Design; child acceptance then portfolio integration acceptance. |
| Bugfix / Enhancement | Single BUGFIX.md / ENHANCEMENT.md | Eligibility/risk, evidence and Validation/Closure remain in the same record. |

Standalone Features: `.swe/features/NNN-short-name/`; FEATURE-NNN IDs are repository-local. AC-NNN IDs are scoped by repository and Feature. Optional Epics group related Features. Portfolio Features retain Epic-local identity at `.swe/epics/NNN-name/features/NNN-name/`. Federated local records remain `.swe/implementations/EPIC-NNN/FEATURE-NNN/`. Preserve accepted IDs and paths.

A separate Design is conditional on substantial interface/state/security/migration or independent design-review needs. Otherwise the standalone Feature's Approach and Checks are its design input. Simple portfolio allocation belongs in the Feature; a separate IMPLEMENTATION-PLAN.md is justified by multiple owners or complex dependencies. Research, Concept, architecture-impact and SWA analysis are conditional on real uncertainty/decisions, not universal gates. Reuse applicable accepted architecture; create a baseline for a new Solution without inventing a Platform.

Before code record outcome/exclusions, stable criteria, approach/owned paths, material risk, real prerequisites and checks. A reviewed statement of no dependencies is valid; missing information is unknown. Use prose/tables unless a helper consumes structure. No mandatory request, packet, recovery or review file per agent. An assignment message names scope, direct inputs, procedure, output and handoff. Persist derived recovery only when needed.

## Compact metadata

New templates use six core fields: artifact_type, id, status, owners, schema_version (4), links. Links are an empty reviewed list or direct typed references containing relation, artifact_id, path, optional repository/revision. Paths are repository-relative forward slashes; cross-repository links require repository identity resolved to an explicitly authorized checkout. Retain stable ID plus path and known revisions. Resolve ancestry instead of copying it.

Do not repeat title (use the heading), parent, upstream and the same traceability chain. Decision timestamps, fingerprints and review history belong to the actual decision/receipt. Missing, conflicting, cyclic or stale inputs block affected decisions. Root artifacts may have no upstream. Legacy schema 1 generator inputs and existing accepted artifacts remain readable; never mass-rewrite history. A generated index grants no acceptance.

## Decisions and lifecycle

Human approval is default. Automatic approval needs explicit run authority or recorded owner policy and a named qualified independent reviewer. Major intent, contract and risk decisions retain a named human. Initial review is cycle zero; at most two author-repair/review cycles, preserved across resume, renaming, successors and executors. Exhaustion requires human disposition. Force requires explicit human authorization and a recorded bypass; it cannot fabricate verification.

Use one Approval Record in the governed artifact: Mode, Author, Approver, Decision, Recorded, Evidence, and Bypass reason when applicable. Record reviewed fingerprints and consumed-cycle history there or in an existing review record, not a mandatory companion packet. One review may cover ordinary outcome and approach when qualified for both; separate decisions when authorities differ. Reject stale acceptance if substantive bytes changed. Accepted intent/approach changes need a reviewed successor/revision; progress belongs in Evidence.

Work/design: Draft -> InReview -> Accepted -> Superseded; changes required return to Draft; reopening Rejected needs explicit authority. Architecture: Target -> Implemented -> Current -> Superseded; approving Target does not change lifecycle. ADR/contracts: Proposed -> Accepted -> Superseded or Rejected. Research/Evidence: Draft -> Complete. Validation: Draft -> InReview -> Accepted, Rejected or Blocked. Missing observations keep Evidence Draft; complete failed observations cannot support acceptance. Requirements acceptance and delivery acceptance are distinct; Current architecture requires operational truth.

## Execution and evidence

Developers author tests/repairs. All agent-directed test, verification-build, lint/static and browser execution goes through swe-test to native test-runner. Resolve model/effort from the role configuration and verify the host used it; never substitute silently. Tester executes bounded commands/receipts, never repairs or accepts. Independent validators judge adequacy and request missing, changed or independently necessary checks. A fresh review context does not require repeating all unchanged tests.

Use the actual owning checkout including dirty files, one canonical fixture set and no copied source trees/corpora. Generate provenance; summarize once and link receipts. Shared outputs require serialization or proven isolation. Unknown, failed, unavailable and stale evidence remain explicit. Coverage binds actual criteria, fixtures, participants and operations; exit zero alone is not acceptance.

Risk: Minimal, Standard or Major with rationale. Public/shared contracts, security, persistence/migration, concurrency, operations and consumed prerequisites require early checks. Prerequisites distinguish ApprovedContractOrDesign from ValidatedBehavior and Design versus Implementation entry. Unknown/cyclic dependencies block affected work only. Implementation-complete is not validated behavior.

Default: required checks before acceptance. Batching requires independently confirmed isolated/reversible Minimal work, explicit policy, real checkpoint and owned obligations. Mandatory structural/build checks, prerequisites and fast-path closure never defer. New consumers revoke deferral. Evidence separates implementation/verification and derives acceptance only from independent Validation. Preserve pending obligations, actual generations and failed receipts on interruption.

## Phase ownership

| Phase | Author/executor | Independent decision |
| --- | --- | --- |
| Local outcome/approach | Assigned qualified developer or solution architect | Human by default; qualified independent swe-design -review when authorized; Major human decisions retained. |
| Portfolio intent/allocation | platform-engineer with appropriate architect/integration specialist | feature-validator for intent; independent qualified allocation reviewer. |
| Architecture | Appropriate scope architect | architecture-reviewer via swe-architect -review. |
| Implementation/Evidence | Assigned developer/specialist with explicit file ownership | solution-validator receives evidence; no self-acceptance. |
| Checks | test-runner via swe-test | No acceptance authority. |
| Local delivery | solution-validator via swe-validate | Independent of author, designer, implementer and material repairer; effective human policy retained. |
| Portfolio integration | feature-validator via swe-validate | Verifies shared criteria/local decisions; no default duplicate local validation. |
| Docs | repo-author / code-commenter | Assigned scope only; no invented authority or behavior changes. |

Bugfix and enhancement remain intentional single-record fast paths. Required validator writes their Validation/Closure section. Allowed low-risk owner waiver goes Implemented -> Closed without claiming Validated. Exceeded local scope escalates to local Feature/architecture; shared scope goes to a portfolio only when it exists and owns it.

## Completion and compatibility

Implementation complete -> Verification complete -> Delivery accepted; Epics aggregate accepted delivery. Portfolio additionally requires integration acceptance and affected architecture reconciliation. No universal extra advisory-analysis ceremony; resolve material findings when present. Delegation is not completion evidence.

Adopt V4 explicitly at a work boundary, preserving IDs, decisions, policy, review history and receipts. Scaffolding creates missing files only. Legacy governance stays effective until adoption. Prototype Mode is retired: no new mode or sequencing bypass; preserve old journals and reconcile outstanding work without fabricated retrospective approvals. Deployment, external mutation and Git publication require their own authorization.
