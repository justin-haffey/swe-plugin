# SWE Max Completion Contract

Read this contract at the all-coded gate, for failed decisions and blockers, during architectural remediation, and before any root Goal update.

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
2. `Mode: auto-approve` records the actual independent agent, durable evidence, and author/reviewer independence for every automatic decision; no approval is fabricated and no `-force` bypass was used.
3. Every Feature in the delivery set is concrete, `Accepted`, implemented in code, and covered by an `Accepted` portfolio Implementation Plan.
4. Every child assignment has an `Accepted` Design, implemented source and tests, a complete `EVIDENCE.md`, and `Accepted` independent local Validation.
5. Exact traceability is complete for every `(Epic ID, Feature ID, AC-NNN)` from Feature through Implementation Plan, Design, Evidence, local Validation, and per-Feature portfolio Validation.
6. Required repository-native format, lint, build, test, security, integration, migration, and operational checks pass. An unavailable required check is not a pass.
7. A new post-implementation `architecture/analysis/<scope-key>/ANALYSIS.md` covers the resulting portfolio and child boundaries.
8. No unresolved major architectural finding remains. Every remediation successor and Feature has traversed the same Design, implementation, Evidence, local Validation, and portfolio Validation chain.
9. Every check and independent Validation affected by remediation was rerun, and a fresh affected `$swa-analyze` report confirms the major finding's fixed point.
10. Integrated portfolio `$swe-validate -auto-approve` has an `Accepted` decision for every Feature in the delivery set.
11. Architecture reconciliation reflects only verified evidence and operational truth; no status was promoted merely to complete the run.
12. Completed child agents and tasks are closed or otherwise cleanly ended, and every required durable artifact locator is collected.
13. No result depends on a fabricated approval, unavailable validation, placeholder implementation, unauthorized external action, or unintegrated child-task output.

Partial implementation, placeholder or deferred Features, missing Evidence, unavailable required validation, unresolved major findings, or incomplete assignments are never successful completion.

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
4. Rerun all affected checks and independent local and portfolio Validation.
5. Rerun affected `$swa-analyze` coverage into a new collision-free advisory report.
6. Preserve durable evidence that the finding is resolved, lawfully superseded, or reclassified with an independent rationale.

Allow at most two author-repair/independent-review cycles for the same artifact revision and decision or the same finding. The initial review is cycle zero; each repair after `ChangesRequired` followed by another independent review consumes one cycle. `ChangesRequired` returns repairable work to `Draft`; a final `Rejected` artifact requires an explicit decision and reason from an owner named in its metadata or governing repository policy. Reopening the same rejected revision does not reset the counter. Exhausted lawful cycles are a blocker, not permission to weaken governance.

## Fail-Closed Routing

| Condition | Required route |
| --- | --- |
| Failed automatic approval | Repair and independently review at the owning phase, for no more than two cycles. Final rejection requires an owner decision or the blocker protocol. |
| Unavailable child repository | Preserve its assignment and exact missing path; do not substitute a similarly named checkout or claim delivery. |
| Missing or incomplete Evidence | Return to child delivery. Do not run successful Validation or pass the all-coded gate. |
| Required check unavailable or persistently failing | Record the command, environment, failure, affected criteria, and safe repairs attempted; never call it a pass. |
| Major architectural finding | Enter governed remediation and add all successor work to the delivery set. |
| Required prohibited action | Stop before the action. Explicit risk awareness does not authorize deployment, publishing, dependencies, credentials, destructive work, external mutation, or Git history changes. |
| Dedicated task cannot be created, read, or integrated | Fall back to project-scoped custom agents in the exact repository; if that also fails, preserve the handoff and use the blocker protocol. |

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
