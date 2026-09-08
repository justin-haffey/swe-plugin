# Bounded eligibility audit

The coordinator determines the relevant assignment, reads its governing artifacts, and asks `$swe-test` to run [Get-SweEligibility.ps1](../../../scripts/Get-SweEligibility.ps1) with `-InputPath <packet.json>`. This stateless check returns audit observations, not approval or scheduler state. It cannot establish the truth of a caller-supplied semantic finding. Review those findings against the frozen source first.

Use schema `swe-eligibility/v1`. The exact working examples and failure cases live in [the fixture rehearsal](../../../scripts/Test-SweV3Behavior.ps1). Construct one packet per assignment and phase; never combine unrelated decisions into a generic approval flag.

Prefer [the packet builder](../../../references/V31-HELPERS.md) when the owning artifact has reviewed structured findings. It derives IDs, hashes and cycle counts, preserves existing frozen constraints, and lists unresolved fields. The builder and this audit share [mechanical field definitions](../../../references/eligibility-fields.json). Existing packets remain valid; no mandatory retrofit of accepted or legacy artifacts is required.

| Packet fields | Required meaning |
|---|---|
| `assignment_id`, `repository`, `phase` | Stable assignment, exact absolute checkout, and `Design`, `Implementation`, `FeatureCompletion`, or `EpicAcceptance` |
| `feature`, `plan`, `architecture` | Frozen approved locators for this assignment; approved Target architecture remains Target |
| `design` | Frozen accepted local Design; required after Design dispatch |
| `risk` | `class` (Minimal/Standard/Major), rationale, and explicit boolean `isolated`, `reversible`, `reviewed_deferral`, `public_contract`, `cross_solution`, `security`, `persistence`, `concurrency`, `operational`, `mandatory_early_checks` findings |
| `dependencies`, `reviewed_independence`, `behavior_consumers` | Explicit dependency array, reviewed empty-dependency finding, and actual known consumers; unknown is not independence |
| `review` | `consumed_cycles`, frozen `cycle_history`, and a frozen human `human_disposition` when exhausted and unresolved |
| `policy_adoption` or `run_authorization` | Optional frozen human owner decision for the current repository; absence retains human approval default |
| `approval_policies` | Frozen owner decisions for upstream decision repositories where independent agent approval is used |
| `named_approvers` | Optional map of artifact ID to required exact approver identity; standing policy cannot replace it |
| `major_approval` | Frozen named-human approval of Major intent, contracts or risk |
| `epic_id` | Actual Epic identity for any deferred Epic batch; standalone work cannot invent a checkpoint |

A frozen locator contains `repository` (exact absolute repository), `path` (repository-relative), `artifact_id`, and `sha256` of the actual reviewed file. The helper checks identity, lifecycle and independent Approval Record correspondence. Supply actual accepted metadata, not an invented record merely to satisfy the parser. Legacy artifacts remain unchanged: use a reviewed handoff/normalization where their recorded facts cannot be verified mechanically. Never treat an unknown legacy field as an accepted V3 gate.

An owner policy record identifies `adoption_repository`, `approval_policy: risk-based`, and `owner_authorized: true`, with an actual independent human decision. Its scope must match the repository of the decision it governs. The cycle-history record retains `consumed_cycles` and `unresolved: true|false`; successful acceptance on the second permitted repair can proceed, whereas unresolved exhaustion needs human disposition. These are repository artifact fields, not native Codex configuration.

Each dependency has `assignment_id`, `requirement` (`ApprovedContractOrDesign` or `ValidatedBehavior`), `entry_phase` (`Design` or `Implementation`), consumed `criteria`, and a reviewed `cycle_free` finding. Approved-content dependencies add an `artifact` locator. Behavior dependencies add `behavior` with independent `validation`, absolute `receipt`, `receipt_sha256`, and executed `generation`. Validation must bind the receipt path, digest and consumed criteria. The audit verifies receipt/log/observation bytes, the immutable request and current source/test/fixture/configuration/runtime/dependency closure. A deferred or stale producer cannot satisfy this requirement.

At FeatureCompletion or EpicAcceptance, supply `implementation_complete`, exact `criteria`, `pending_checks`, and `delivery` in the same behavior format. EpicAcceptance additionally needs `assignments_complete`, `architecture_reconciled`, and independent `portfolio_validation`. These facts must come from the complete canonical inventory; the audit does not discover omitted assignments or replace portfolio review.

Read `eligible`, `deferral_eligible`, and `reasons`; `grants_acceptance` is always false. A failed gate blocks only affected work. Obtain current evidence or the owning decision rather than changing a packet to conceal its reason.
