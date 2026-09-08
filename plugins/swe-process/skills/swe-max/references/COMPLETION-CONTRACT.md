# SWE Max Completion Contract

Read this contract at the Implementation complete, Verification complete and Epic accepted checkpoints, for failed decisions and blockers, during remediation, and before any root Goal update.

## Root Goal Ownership

The primary `swe-max` coordinator creates exactly one formal Goal for the invocation and is the only actor allowed to update it. A nested orchestration, subagent, dedicated task, reviewer, architect, or validator must not create, replace, update, complete, or block a Goal.

A completion or blocked transition is invalid unless the primary coordinator issues it against the one Goal created by this invocation. If formal Goal support is absent, the Epic is ambiguous, or another unfinished Goal prevents creation, stop during read-only bootstrap without repository mutation; a nonexistent Goal cannot be marked blocked.

Use only the Goal mechanism's supported terminal updates:

- `complete`: only after every invariant below is verified.
- `blocked`: only after the same blocking condition satisfies the active Goal mechanism's consecutive-turn threshold.

Do not use or invent another terminal state. Do not stop merely because a token budget is low, and do not set a token budget unless the user explicitly requested one.

## Delivery Inventory

Maintain an exact inventory of:

- the resolved Epic and its acceptance outcomes;
- every non-superseded unfinished Feature required by those outcomes, including pre-existing Features in resume mode;
- every Feature or successor created during the run or remediation;
- every child assignment, exact repository and checkout, Design, Evidence, local Validation, and integrated portfolio Validation;
- every criterion keyed by `(Epic ID, Feature ID, AC-NNN)` while preserving the literal Feature-local `AC-NNN` value downstream.

The delivery set must be non-empty when Epic outcomes remain unimplemented. Do not exclude an unfinished Feature without lawful supersession, a lawful successor, or an accepted scope decision. Previously completed work counts only after its states, approvals, Evidence, checks, and Validation are verified.

## Completion Invariants

The coordinator may update the Goal to `complete` only when all of these are true:

1. The Epic and every required decision-bearing artifact have legal lifecycle states, valid dual locators, and real approval records.
2. Effective adoption/run policy and explicitly named approvers are honored, including Major human decisions where required. `Mode: auto-approve` records the actual independent agent, durable evidence and author/reviewer independence for every authorized automatic decision; no approval is fabricated and no `-force` bypass was used.
3. Every Feature in the delivery set is concrete, `Accepted`, implemented in code, and covered by an `Accepted` portfolio Implementation Plan.
4. Every child assignment has an `Accepted` Design, implemented source and tests, a complete `EVIDENCE.md`, and `Accepted` independent local Validation.
5. Exact traceability is complete for every `(Epic ID, Feature ID, AC-NNN)` from Feature through Implementation Plan, Design, Evidence, local Validation, and per-Feature portfolio Validation.
6. Required repository-native format, lint, build, test, security, integration, migration, browser and operational checks pass through `$swe-test` and the effective `test-runner` (`gpt-5.6-luna`, `medium`). Receipts identify the generation actually executed, including dirty source and dependency outputs. An unavailable, partial, stale or unattributed required check is not a pass.
7. A new post-implementation `architecture/analysis/<scope-key>/ANALYSIS.md` covers the resulting portfolio and child boundaries.
8. No unresolved major architectural finding remains. Every remediation successor and Feature has traversed the same Design, implementation, Evidence, local Validation, and portfolio Validation chain.
9. Every check affected by remediation was rerun through `$swe-test`, affected independent Validation was reconfirmed against matching frozen decision bytes, and a fresh affected `$swa-analyze` report confirms the major finding's fixed point. Unaffected current receipts and decisions may be reused.
10. Integrated portfolio `$swe-validate` has an independent `Accepted` decision under the effective approval policy for every Feature in the delivery set; use `-auto-approve` only when authorized.
11. Architecture reconciliation reflects only verified evidence and operational truth; no status was promoted merely to complete the run.
12. Completed child agents and tasks are closed or otherwise cleanly ended, and every required durable artifact locator is collected.
13. No result depends on fabricated approval, unavailable validation, placeholder implementation, unauthorized external action or unintegrated child output. All deferred obligations are drained and required shared-output build slots have receipts matching the consumed generation.

Partial implementation, placeholder or deferred Features, missing Evidence, unavailable required validation, unresolved major findings, or incomplete assignments are never successful completion.

## Checkpoint distinction

Implementation complete (P90) proves all required implementation and mandatory early gates. Reviewed Minimal assignments may still have Draft Evidence and explicit pending checks/local acceptance. This checkpoint never grants accepted delivery or satisfies a `ValidatedBehavior` dependency. Missing implementation or a failed mandatory early gate blocks it; approved deferred obligations do not.

Verification complete (P95) drains those obligations, applies author-owned fixes and necessary refactoring, reruns affected checks through `$swe-test`, and requires Complete Evidence and independent Accepted local Validation for every assignment. Interrupted or unavailable testing preserves pending/blocked progress rather than fabricating a pass. Failed receipts remain evidence after successful repairs.

Epic accepted (P120) additionally requires integrated per-Feature portfolio decisions, architectural analysis/remediation/reconciliation and every invariant above. Portfolio progress is derived from child Evidence and Validation. Legacy `Complete` bridge responses are observations requiring current Evidence/Validation inspection; missing V3 fields remain unknown until verified.

## Architecture Lifecycle

Approval accepts architecture content while leaving its lifecycle at `Target`.

- Promote `Target` to `Implemented` only when the entire affected Target scope has corresponding implementation Evidence and accepted Validation.
- Promote `Implemented` to `Current` only when verified deployed or operational truth shows that the architecture is actually current.
- Deployment is outside ordinary `$swe-max` authority, so `Current` is not a completion prerequisite when that truth is unavailable. Record the truthful status and divergence instead.

## Major Findings and Remediation Fixed Point

A finding is major when it violates a governing invariant or contract, creates material security, data, operational, or integration risk, exposes incorrect ownership or dependency direction, or invalidates a prior Design or Validation.

For every major finding:

1. Record the affected artifacts, Features, criteria, repositories, and governing invariant.
2. Route the repair to the earliest owning lifecycle phase. Never semantically edit an `Accepted` artifact; create a revision or successor.
3. Add remediation Features and assignments to the delivery inventory and complete their full governed delivery.
4. Request affected checks through `$swe-test` and reconfirm independent local and portfolio Validation for the reviewed generation.
5. Rerun affected `$swa-analyze` coverage into a new collision-free advisory report.
6. Preserve durable evidence that the finding is resolved, lawfully superseded, or reclassified with an independent rationale.

Allow at most two author-repair/independent-review cycles for the same unresolved decision or finding. The initial review is cycle zero; each repair after `ChangesRequired` followed by independent review consumes one cycle. Record the durable cycle-history locator. `ChangesRequired` returns repairable work to `Draft`; a final `Rejected` artifact requires an explicit owner decision and reason. Reopening, resume, packet/executor changes or a successor for the same unresolved decision never resets the counter. Exhaustion requires explicit human disposition; a diagnosis cannot add a review cycle. Freeze substantive bytes or use an immutable snapshot, and reject acceptance when current bytes do not match those reviewed.

## Fail-Closed Routing

| Condition | Required route |
| --- | --- |
| Failed automatic approval | Repair and independently review at the owning phase, for no more than two cycles. Final rejection requires an owner decision or the blocker protocol. |
| Unavailable child repository | Preserve its assignment and exact missing path; do not substitute a similarly named checkout or claim delivery. |
| Missing or incomplete Evidence | Pending approved deferred checks may pass P90 with Draft Evidence; missing implementation/early gates may not. Return to the relevant child phase and do not pass P95 or claim Accepted Validation until required observations are complete and successful. |
| Required check unavailable or persistently failing | Record the command, environment, failure, affected criteria, and safe repairs attempted; never call it a pass. |
| Major architectural finding | Enter governed remediation and add all successor work to the delivery set. |
| Required prohibited action | Stop before the action. Explicit risk awareness does not authorize deployment, publishing, dependencies, credentials, destructive work, external mutation, or Git history changes. |
| Selected child transport cannot dispatch, retrieve or integrate safely | Try a supported authorized transport that honors exact scope without duplicate dispatch. New user-visible tasks require user/host authority. If none works, preserve the handoff and use the blocker protocol. |

## Blocker Protocol

Do not mark the Goal blocked merely because work is difficult, slow, uncertain, or would benefit from clarification.

1. Record the exact blocking condition, affected Epic, Features, assignments, artifacts, repository paths, criteria, and safest continuation point.
2. Attempt a bounded `$orchestrate -complex` contribution-mode review with the highest applicable independent reviewer, validator, or architect. Every participant remains forbidden from Goal operations. If orchestration itself has become unavailable after the root Goal was created, record the attempted call and capability failure, perform one bounded coordinator-only diagnosis, and do not fabricate independent review evidence.
3. Attempt every safe, authorized repair and record the attempts and decisions. Respect the two-cycle decision limit.
4. Report the blocker immediately, but keep the Goal active until the same condition has recurred for at least three consecutive Goal turns under the active Goal API. The original or user-triggered turn counts; after a previously blocked Goal is resumed, start a fresh recurrence audit.
5. Only after that threshold is met may the primary coordinator call `update_goal` with `blocked`.

Genuine blockers include ambiguous Epic identity, unavailable required child repositories, missing Goal or orchestration capability, an approval that cannot lawfully be automated, exhausted repair cycles, missing required credentials or external authority, persistent validation failure with no safe repair, or a required destructive, deployment, publishing, dependency, external-mutation, or Git-history action that was not explicitly authorized.

When blocked, return the exact condition, artifacts and Features affected, attempts made, independent review evidence, recurrence count, and safest continuation point.

## Completion Transition

After P120, the primary coordinator re-reads this contract and independently verifies every inventory entry. If any invariant is unproven, keep the Goal active and route to the earliest owning state.

Only when every invariant is proven may the coordinator call `update_goal` with `complete`. If the user explicitly supplied a Goal token budget, include the formal Goal mechanism's final token usage in the handoff. Never mark completion merely because time or budget is nearly exhausted.
