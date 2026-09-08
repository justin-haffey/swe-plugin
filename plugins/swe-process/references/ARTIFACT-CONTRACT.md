# SWE Artifact Contract

Use these V3 conventions for new process artifacts under an explicitly adopted V3 policy. Existing V2 artifacts remain readable without rewriting IDs, paths, accepted content, or decision history. Package installation alone does not change an in-flight Epic's effective policy.

## Metadata

- Use `snake_case` for `artifact_type` values and `PascalCase` for lifecycle `status` values.
- Preserve stable IDs after creation. Paths are locators, not identities.
- Every `upstream` locator contains `repository`, `artifact_id`, `path`, and optional `revision`.
- Epic acceptance outcomes use stable Epic-local IDs `EO-001`, `EO-002`, and so on.
- Feature acceptance criteria use stable Feature-local IDs `AC-001`, `AC-002`, and so on. Never renumber an accepted criterion; mark it superseded and add a new ID.
- Downstream Implementation Plan, Design, Evidence, and Validation artifacts preserve the exact acceptance criterion IDs they cover.
- A fast-path Enhancement may use local `AC-NNN` criteria inside its `ENHANCEMENT.md`; those IDs do not enter Feature traceability and must not be presented as Feature acceptance criteria.

## Legal lifecycle transitions

Decision-bearing work artifacts (`EPIC`, `CONCEPT`, `ARCHITECTURE-IMPACT`, `FEATURE`, `IMPLEMENTATION-PLAN`, and `DESIGN`) use:

`Draft -> InReview -> Accepted -> Superseded`

- `InReview -> Draft` is allowed after changes are required.
- `InReview -> Rejected` is allowed for a final rejection.
- `Rejected -> Draft` requires an explicit owner decision to reopen and a recorded reason.
- An `Accepted` artifact is immutable except for non-semantic corrections; replace semantic changes with a new revision or successor.

Canonical architecture uses `Target -> Implemented -> Current -> Superseded`. Approval accepts the Target without changing its lifecycle status. Promote to `Implemented` only with implementation evidence and to `Current` only with validation and reconciliation.

ADRs and contracts use `Proposed -> Accepted -> Superseded` or `Proposed -> Rejected`. Validation uses `Draft -> InReview -> Accepted`, `Rejected`, or `Blocked`; a blocked validation may return to `InReview` when its blocker changes. Research and Evidence use the non-decision lifecycle `Draft -> Complete`. A Draft may contain useful partial observations. Complete requires all required observations, results, and coverage to exist; a required missing or blocked observation keeps Evidence Draft. Failed observations remain truthful evidence: Complete with required failures cannot support accepted delivery. Only independent Validation judges whether the observations prove the criteria.

Fast paths normally use `Active -> Implemented -> Validated -> Closed`, or `Active -> Escalated`. `Validated` requires a named independent validator and durable decision evidence. Independent validation is mandatory for externally visible behavior and for security, data, identity, integration, migration, concurrency, or operational risk, as well as whenever repository policy requires it. A low-risk fast path may instead use `Active -> Implemented -> Closed` only when its owner records `Decision: Waived` and a concrete waiver rationale; it must never claim `Validated`. The fast-path record must identify the validator, independence, decision, evidence, transition timestamps, closure owner, and waiver rationale when applicable.

## Approval record

Decision-bearing artifacts include an Approval Record with:

- `Mode`: `human`, `auto-approve`, or `force`.
- `Author`: the artifact author.
- `Approver`: the independent human or agent; for `force`, the human who explicitly authorized the bypass.
- `Decision`: `Pending`, `Accepted`, `ChangesRequired`, `Rejected`, or `Bypassed`.
- `Recorded`: an ISO 8601 timestamp, or `Pending` before review.
- `Evidence`: a review artifact, message, or other durable locator.
- `Bypass reason`: required only when the decision is `Bypassed`.

Human approval is the default. A repository-owner adoption decision or explicit run authorization may establish the risk-based standing policy below; record its exact locator and scope and preserve a named approver. Under `auto-approve`, author and approver must differ and no more than two reject/repair cycles are allowed before human escalation. `force` records a human-authorized bypass; it never fabricates acceptance, validation, or evidence. Resuming, renaming a packet, changing an executor, or starting a successor for the same unresolved decision never resets its repair count. Record the durable cycle-history locator, consumed count, and human disposition when exhausted.

## Risk and testing timing

The allocation proposes `Minimal`, `Standard`, or `Major`, with rationale and affected criterion IDs. Its independent reviewer and the Design reviewer confirm classification and deferral eligibility. Missing classification or unknown dependencies block eligibility until resolved; uncertainty favors earlier tests.

| Risk | Timing | Decision under an adopted V3 standing policy |
|---|---|---|
| Minimal | Behavioral checks may be batched at the Epic implementation checkpoint only for isolated, reversible work without prerequisite consumers. Mandatory structural/build checks still apply. | Independent lightweight delivery decision at the batch boundary. Human decides exceptions and scope changes. |
| Standard | Required checks before Feature completion. | Existing qualified independent review and validation. |
| Major | Early targeted proofs and required checks before dependent behavior is consumed or Feature completion. | Named human approves major intent, contracts, and risk decisions; independent technical review and validation remain. |

Public or cross-solution contracts, security, persistence/migration, concurrency, operational or irreversible effects, and foundational prerequisite behavior are mandatory early-check triggers regardless of the proposed label. Repository-mandated checks override deferral. A standalone fast path cannot defer to an absent Epic checkpoint. An emerging dependent consumer or expanded scope revokes deferral: reclassify, obtain affected approval, and verify the needed behavior before consumption. Deferral never removes Design, allocation, or ordinary pre-code approval gates; Prototype Mode is a separate explicitly authorized exception.

## Assignment and dependency contract

V3.1 may derive mechanical packet fields from an optional reviewed `swe-eligibility` block in the owning editable Plan, Design or handoff. The block is part of that canonical artifact's decision and history, not a second authority. Existing packets and legacy artifacts remain supported without retrofit. The [packet/preflight helpers](V31-HELPERS.md) preserve unknown findings, frozen locators, independent acceptance and separately authorized adoption.

Each Plan assignment has a stable assignment ID, exact repository/checkout identity, allowed write scope, criterion IDs, Feature/Plan/architecture dual locators, local workspace, risk rationale, required checks, timing, policy locator, and expected evidence. Confirm participant availability and authorized work, reachable contract limits, and integration ownership before freezing allocation. A green schema or a nominal operation label does not prove real participant conformance.

Every prerequisite records its assignment/artifact locator, consumed scope or criterion IDs, entry phase (`Design` or `Implementation`), and one requirement: `ApprovedContractOrDesign` or `ValidatedBehavior`. The former requires accepted governing contract/design bytes; the latter requires independent Accepted Validation plus attributable passing evidence for the actual behavior and generation. Unknown or cyclic prerequisites block affected work. An empty dependency list is an explicit reviewed independence finding, not inferred from a missing list.

Design dispatch requires its own Accepted Feature, allocation, applicable architecture, and design-entry prerequisites. Coding additionally requires its Accepted local Design and implementation prerequisites. Unrelated eligible assignments may proceed while another Plan waits; shared contracts and cross-Feature decisions remain gates. Implementation-complete or deferred work never satisfies `ValidatedBehavior`. A semantic upstream change invalidates affected dependent eligibility/results until reconciled, without reopening unrelated decisions.

## Delivery progress and acceptance

Approval and delivery are different: an Accepted Feature specification approves requirements. The solution Evidence owns implementation observations and the following V3 body section. Portfolio progress is a read-only aggregate of child Evidence, receipts, and independent Validation.

```yaml
delivery_progress:
  implementation: NotStarted # NotStarted | InProgress | Complete | Blocked
  verification: Pending # Pending | InProgress | Complete | Blocked
  acceptance: Pending # Pending | Accepted | Rejected | Blocked; derived only
  source_generation: unknown
  acceptance_locator: null # Independent Validation dual locator plus fingerprint
  pending_obligations:
    - check_id: CHECK-001
      criteria: [AC-001]
      reason: Awaiting the approved Epic verification batch.
      due: Epic implementation checkpoint
      owner: test-runner
```

`implementation: Complete` is compatible with Draft Evidence and pending checks. `verification: Complete` requires all required checks to have passed for the relevant source, test, fixture, configuration, runtime, and dependency-output generation; partial, failed, blocked, stale, or unattributed runs cannot satisfy it. The `acceptance` field is generated from a verified independent decision and never grants approval. Missing legacy fields are `unknown` until verified, never automatic completion. A failure must remain visible in its immutable receipt even after a repair passes.

The checkpoints are **Implementation complete -> Verification complete -> Epic accepted**. The final checkpoint requires every deferred obligation drained, necessary repairs retested, complete local independent decisions, portfolio integration decisions, architecture review/reconciliation, and no missing Feature. Interrupted final testing leaves implementation complete and verification pending with exact remaining obligations.

Evidence links check receipts and actual logs rather than copying them. Criterion coverage must bind the concrete fixture, required participant and operation, expected outcome, actual observation, and generation. Unavailable participants/tools, unrealized fixtures, and relabeled dispatches remain coverage gaps despite a successful exit or large test count. Testing, verification builds, lint/static checks, and browser validation are executed through `$swe-test` by `test-runner` on Luna/medium; authors own repairs and independent validators own adequacy and acceptance.

## Compact authoring and shared review

Feature plus Implementation Plan and Concept plus Architecture Impact may share an authoring/review packet while retaining two canonical files, identities, and decisions. Drafting a dependent artifact in the packet is allowed before the paired upstream decision only when the packet marks that decision unresolved; no dependent approval or dispatch is eligible until the upstream decision is actually accepted. Record each decision separately in dependency order. A reviewer may cover multiple decisions only when qualified and authorized for all authorities; otherwise use the smallest distinct reviewer set. Preserve the same independence and two-cycle limits per unresolved decision.

A review packet records the changed decision set, exact input/decision-byte fingerprints or immutable snapshot locators, applicable invariants, evidence, reviewer ownership, and cycle-history locator. Freeze substantive artifact bytes during review and compare before recording acceptance. A mismatch rejects the stale acceptance; review the changed decisions and affected dependents. Generated approval metadata must not be included in its own circular decision-byte fingerprint. Cosmetic preferences alone do not reopen accepted semantic decisions.

Architecture uses Compact (`references/v1/`) by default and Detailed (`references/v2/`) per artifact when critical foundations, trust/ownership boundaries, changed shared contracts, complex state/persistence/concurrency, compatibility, failure, or operations require depth. An ordinary internal interface alone does not require Detailed. Record a one-sentence profile rationale. Both profiles require identity, upstream and parent alignment, responsibilities/exclusions, invariants, relevant qualities/security/failure/operations, alternatives and consequences, feasibility/testing, traceability, divergence, and approval. A missing concern requires a focused addition or Detailed, never a waiver. Add diagrams only when useful; replace inapplicable placeholders with a concise rationale. Preserve existing Accepted documents.

## Generated structure and recovery

Use [artifact generation](ARTIFACT-GENERATION.md) to populate validated metadata, dual locators, assignments, criterion coverage, and cross-links from the creating skill's template. Semantic choices, rationale, tradeoffs, deviations, and decisions remain authored. New artifacts start Draft/Target/Proposed; semantic changes to accepted artifacts require an explicit new revision/successor. Update only marked generated sections in editable records after checking the embedded prior digest; a manual conflict stops the update and produces a precise proposed/current diff. Generated data never overrides authored approvals.

Recovery is a disposable generated view of canonical artifacts and immutable receipts, stamped with input fingerprints. Persist it only when recovery needs it, including otherwise unavailable execution handles, policy/cycle-history locators, last verified generation, pending checks, blockers, and next eligible action. On resume verify current artifacts, dirty state, live workers/processes, shared-output ownership, and receipt provenance. Flag discrepancies instead of selecting the latest prose; a recovery file neither approves work nor resets review counts.

## Compatible adoption

Read V2 schemas unchanged, preserving locators, IDs, accepted decisions, history, and Prototype Mode journal/reconciliation. Missing V3 progress, risk, or dependencies remain unknown and cannot imply eligibility. Record adoption at the next Epic or explicit revision/assignment boundary in an existing owner decision record; name changed rules and the effective scope. Installing packages or adding a tester does not activate V3 in a customized destination.

Feature/Plan, Concept/Impact, Evidence/Validation, architecture levels, and their historical paths remain separate. New writing retires copied upstream narratives, decorative/empty sections, full lifecycle duplication, and hand-transcribed progress; it does not delete historical artifacts. Rollback preserves code and decisions and first drains deferred checks and reconciles V3-only progress through a reviewed successor/handoff. Scaffolding stays create-missing only; governance migration is a separately authorized proposed diff.

## Prototype-first reconciliation

Prototype Mode is a workflow-sequencing exception, not an approval mode. An explicit developer instruction may allow repository-local prototype implementation to begin before ordinary lifecycle artifacts exist or meet their acceptance entry gates. Repository ownership, filesystem scope, destructive-action controls, external-side-effect authority, deployment controls, credentials, Git safety, and tool approvals remain unchanged.

Each prototype run records its exact developer instruction, repository scope, changed paths, observed behavior, checks, decisions, assumptions, and limitations under `.swe/prototype/runs/`. After implementation, agents backtrack from that evidence into the smallest truthful governed route:

- a solution-local bugfix or enhancement fast path when Feature intent, contracts, and accepted architecture are unchanged; or
- the full Epic, Concept, architecture-impact, Target architecture, Feature, Implementation Plan, Design, Evidence, and Validation chain when the implemented capability requires it.

Reconstructed decision-bearing work starts as `Draft`; reconstructed architecture starts as `Target`; ADRs and contracts start as `Proposed`. Approval Records remain `Pending` until ordinary governance supplies a real decision. Prototype Mode never retroactively makes an artifact `Accepted`, treats implementation as approval, edits accepted history to appear forward-governed, or fabricates validation. The mode may return to `Off` only after all open runs are reconciled or explicitly cancelled by the developer.
