---
name: prototype
description: Enable or disable scoped prototype-first delivery with persistent repository state, exact mode sentinels, deferred upfront SWE phase gates, and mandatory post-implementation backtracking. Use only when the developer invokes $prototype -on or $prototype -off.
---
# Prototype Mode

Use this utility as `$prototype [-on|-off]`. Require exactly one flag and reject an omitted flag, both flags, or extra arguments.

Prototype Mode reverses the order of the governed SWE workflow for explicitly requested local prototype work: implement first, then reconstruct and review the appropriate lifecycle artifacts from observed evidence. It is an execution-sequencing exception, not unrestricted authority.

Read [`references/MODE-CONTRACT.md`](references/MODE-CONTRACT.md) before changing mode. Read and follow [`references/BACKTRACKING.md`](references/BACKTRACKING.md) before completing a prototype run or turning the mode off. Render new state and run records from the templates in this skill's `references/` directory.

## Invocation contract

- `$prototype -on` enables Prototype Mode for the current repository scope.
- `$prototype -off` reconciles every open prototype run and disables the mode only after reconciliation succeeds.
- The absence of `.swe/prototype/STATE.md`, or a valid state record whose `mode` is `Off`, means Prototype Mode is off.
- Only the primary agent changes mode state. A delegated agent observes the propagated mode, run ID, and scope but does not independently enable or disable it.
- Treat `<<<<<PROTYPE_MODE_ON>>>>>` and `<<<<<PROTYPE_MODE_OFF>>>>>` as legacy compatibility aliases when received from a trusted parent task. Always emit and persist the correctly spelled canonical forms.

## Enable with `-on`

1. Resolve the current repository root and read its applicable `AGENTS.md` files. Stop if the intended repository or writable scope is ambiguous.
2. Inspect `.swe/prototype/STATE.md` when it exists. If it is malformed, points at another repository, or contains an unknown mode, stop without replacing it.
3. If the state is already `On`, reuse it and its open run. Do not create duplicate state or silently widen its scope.
4. Otherwise, create `.swe/prototype/`, render `STATE.md` from [`references/STATE-TEMPLATE.md`](references/STATE-TEMPLATE.md), generate a unique `PROTOTYPE-RUN-[UTC_TIMESTAMP]` ID, and render `.swe/prototype/runs/[RUN_ID]/PROTOTYPE.md` from [`references/RUN-TEMPLATE.md`](references/RUN-TEMPLATE.md).
5. Record the actor, ISO 8601 activation time, repository identity, repository-relative scope, active run ID, and the transition from `Off` to `On`. Replace every template placeholder.
6. Print this canonical sentinel as a standalone line:

   ```text
   <<<<<PROTOTYPE_MODE_ON>>>>>
   ```

## Behavior while on

Treat the requested phrase `IGNORE Approval Governance` narrowly and literally for sequencing: ignore ordinary SWE artifact-acceptance entry gates before carrying out the developer's explicitly requested, local prototype implementation. A direct developer instruction supplies implementation authority within the recorded repository scope, whether it is semantic prose or an invocation of another available skill.

Prototype Mode does not grant or imply authority to:

- write outside the recorded repository scope;
- deploy, publish, release, send messages, or mutate remote or shared services;
- alter production data, credentials, identity, billing, or security controls;
- perform destructive operations, broad deletion, dependency installation or upgrade, or unrelated cleanup;
- commit, tag, push, rewrite Git history, or bypass sandbox and tool approvals;
- mark an artifact `Accepted`, claim validation, or fabricate evidence without the ordinary required decision.

Those actions still require their normal explicit authorization. Repository authority still decides where artifacts belong; Prototype Mode only lets the requested implementation precede their creation or acceptance.

For every prototype request:

1. Capture the developer's operative instruction verbatim in the active `PROTOTYPE.md`, including text placed in quotation marks or fenced examples. Do not silently normalize quoted example text.
2. Record intended scope and expected behavior before or at the first implementation edit. If the current run is already reconciled, create a new run and make it the state's `active_run` while leaving mode `On`.
3. Execute the requested local work using the named skill or the smallest appropriate implementation workflow. Do not stop merely because the ordinary Epic, Feature, Plan, Design, or approval gate does not yet exist.
4. Record actual changed paths, tests and checks run, observed behavior, deviations, decisions, assumptions, and unresolved risks. Report unrun checks honestly.
5. When delegating or orchestrating, include the canonical on-sentinel, repository scope, and run ID in every task. Workers return evidence to the primary agent; the primary agent owns the durable run record and backtracking closure.
6. Immediately after implementation or orchestration completes, execute the backtracking process. Do not wait for `-off` when the run can be reconciled now.

## Disable with `-off`

1. Resolve and validate the same repository state used by `-on`. If no state exists or the state is already `Off`, make no files and print the canonical off-sentinel idempotently.
2. Change a valid `On` state to `Closing` and record the transition. Do not emit the off-sentinel yet.
3. Find every run under `.swe/prototype/runs/` whose status is not `Reconciled` or `Cancelled`. Follow [`references/BACKTRACKING.md`](references/BACKTRACKING.md) for each one.
4. If evidence, repository access, or required human direction blocks reconciliation, set the affected run to `Blocked`, leave state as `Closing`, report the blocker, and do not print an off-sentinel.
5. After every open run is reconciled or explicitly cancelled by the developer, set `mode` to `Off`, clear `active_run`, record the deactivation actor and time, and append the transition without erasing history.
6. Print this canonical sentinel as a standalone line:

   ```text
   <<<<<PROTOTYPE_MODE_OFF>>>>>
   ```

The off transition hands workflow sequencing back to ordinary repository governance. It does not retroactively accept Draft artifacts or promote Target architecture.

## Validation

Before reporting a transition or completed run, verify:

- `STATE.md` and every run record have bounded, parseable YAML headers and no unresolved `[PLACEHOLDER]` tokens;
- the state repository, scope, mode, `active_run`, and transition history agree;
- on/off output uses exactly the canonical sentinel, with no misspelling inside it;
- the developer instruction is preserved verbatim in the run record;
- implementation evidence identifies actual files and checks without invented results;
- backfilled artifacts remain in their legal initial lifecycle states until ordinary approval;
- all open runs are reconciled or explicitly cancelled before `Off` is recorded.
