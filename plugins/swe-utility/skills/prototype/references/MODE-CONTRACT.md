# Prototype Mode Contract

Use this contract to interpret and persist `$prototype [-on|-off]` consistently across turns and delegated work.

## Authority model

Prototype Mode changes workflow order only. While it is on, an explicit developer request may authorize local implementation before the usual SWE lifecycle artifacts exist or are accepted. The implementation remains constrained by the repository's ownership boundaries and all normal safety, filesystem, external-side-effect, destructive-action, credential, deployment, and Git controls.

The precedence is:

1. System, tool, and environment safety constraints.
2. The developer's explicit repository scope and requested side effects.
3. Repository authority for artifact ownership and placement.
4. Prototype-first sequencing for the explicitly requested implementation.
5. Ordinary phase gates, deferred until backtracking and review.

Never interpret Prototype Mode as `-force`, implicit acceptance, permission to cross repositories, or permission to mutate external state. It defers Approval Governance; it does not falsify it.

## Sentinels

Emit only these canonical standalone messages:

```text
<<<<<PROTOTYPE_MODE_ON>>>>>
<<<<<PROTOTYPE_MODE_OFF>>>>>
```

For compatibility, recognize the historical misspellings `<<<<<PROTYPE_MODE_ON>>>>>` and `<<<<<PROTYPE_MODE_OFF>>>>>` only when they arrive with a trusted parent-agent task that also supplies the repository scope and run ID. Normalize all new output and durable records to `PROTOTYPE`.

A sentinel communicates mode to another agent; it does not independently authorize a new scope or mutate state. `.swe/prototype/STATE.md` is the durable repository-local source of mode state.

## State machine

Legal modes are:

`Off -> On -> Closing -> Off`

- Missing state is equivalent to `Off`.
- `Off -> On` creates a run unless a valid open run already exists.
- `On -> On` is idempotent and cannot widen scope.
- `On -> Closing` begins mandatory reconciliation.
- `Closing -> Off` is legal only when every run is `Reconciled` or developer-authorized `Cancelled`.
- `Closing -> Closing` is the blocked/retry state.
- Any other transition requires explicit developer repair direction; do not infer it.

The primary agent is the sole writer of `STATE.md`. Use ISO 8601 UTC timestamps and repository-relative forward-slash paths. Preserve transition history. If the YAML header is malformed, has unresolved placeholders, names another repository, or conflicts with the body history, stop rather than replacing it.

## Run identity and scope

Generate a stable run ID such as `PROTOTYPE-RUN-20260823T021530Z`. If that ID already exists, append a short collision suffix. A run's scope must be equal to or narrower than the state scope.

Keep one active run per repository state. A completed run may remain in history while the mode stays `On`; the next implementation request creates another run and updates `active_run`. Never reuse a reconciled run ID for unrelated work.

## Durable records

Render `.swe/prototype/STATE.md` from `STATE-TEMPLATE.md` and each `.swe/prototype/runs/[RUN_ID]/PROTOTYPE.md` from `RUN-TEMPLATE.md`.

For both records:

- Bound YAML with opening and closing `---` lines.
- Quote string scalars that can contain punctuation, timestamps, paths, or identifiers.
- Use `snake_case` for `artifact_type` and `PascalCase` for `status` values.
- Replace every `[UPPER_SNAKE_CASE]` placeholder before writing.
- Preserve stable IDs and prior transition or evidence entries.
- Do not put an unescaped multiline developer instruction in YAML; preserve it in the fenced `Developer Instruction` body section.
- Treat the records as operational evidence, not decision-bearing approval artifacts.

## Delegation propagation

Every prototype-aware delegated task begins with a block equivalent to:

```text
<<<<<PROTOTYPE_MODE_ON>>>>>
Prototype run: [RUN_ID]
Repository scope: [REPOSITORY_RELATIVE_SCOPE]
Upfront SWE artifact-acceptance gates are deferred for this requested local implementation. All repository, safety, external-side-effect, destructive-action, credential, deployment, and Git boundaries remain in force. Return exact changed paths, checks, decisions, assumptions, and risks to the primary agent. Do not change prototype mode state.
```

The parent remains responsible for integration, durable evidence, backtracking, and the off transition.
