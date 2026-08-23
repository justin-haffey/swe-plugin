# Prototype Backtracking Process

Use this process immediately after each prototype implementation or orchestration and before `$prototype -off`. Its purpose is to let governance work backward from verified implementation evidence without rewriting history or inventing intent.

## Governing principles

- Treat the exact developer instruction, source diff, executable behavior, tests, logs, and existing accepted artifacts as evidence in descending order of directness.
- “Intuit and work in review” means infer candidate intent and architecture from that evidence, label every inference, and submit it through the normal review path. It never means invent acceptance criteria, backdate a decision, or claim prior approval.
- Do not edit an `Accepted` decision-bearing artifact semantically. Create a successor or new revision and preserve the prior artifact's stable identity and history.
- Create decision-bearing work as `Draft`, architecture as `Target`, ADRs and contracts as `Proposed`, and evidence as `Complete` only when its recorded checks are actually complete.
- Prototype backtracking does not imply `-auto-approve` or `-force`. Approval records remain `Pending` until ordinary governance supplies a valid decision.
- Work only in repositories already authorized by the developer. When a required portfolio or child repository is unavailable or out of scope, write a precise handoff in the run record instead of crossing the boundary.

## Trigger and owner

The primary agent starts backtracking when implementation, a delegated workflow, or an orchestration completes. It first freezes the evidence section of the active `PROTOTYPE.md` sufficiently to identify the request, actual changed paths, observed behavior, checks, and unresolved risk. Later additions are appended; existing evidence is not silently rewritten.

The primary agent coordinates the roles below when they are available. In a solo environment, one agent may perform multiple authoring steps but must preserve reviewer independence: it cannot approve its own architecture or formally validate its own implementation.

## Route selection

Choose the smallest truthful governance route:

| Observed prototype scope | Backtracking route |
| --- | --- |
| Bounded solution-local defect; no changed Feature intent, cross-solution contract, or accepted architecture | `$swe-bugfix` fast path |
| Bounded solution-local refinement; no changed Feature intent, cross-solution contract, or accepted architecture | `$swe-enhancement` fast path |
| New user-visible capability, changed Feature intent, cross-solution behavior, new contract, or material architectural change | Full Epic-to-Feature lifecycle |
| Evidence is insufficient to classify safely | Mark the run `Blocked` and request the missing developer decision |

Do not force a prototype into a fast path merely because implementation already exists.

## Roles and explicit responsibilities

Use repository-provided agents when present; otherwise select equivalent appropriate roles.

| Responsibility | Preferred agent or role | Required output |
| --- | --- | --- |
| Preserve the request, diff, implementation decisions, tests, and limitations | Primary agent plus `solution-developer`, `package-developer`, `module-developer`, or relevant implementation specialist | Updated `PROTOTYPE.md` and solution `EVIDENCE.md` or fast-path evidence |
| Inspect boundaries, integrations, contract effects, and cross-repository behavior | `integration-engineer` | Evidence-backed integration findings and required handoffs; no child-repository mutation from a portfolio role |
| Reconstruct local Design and affected Solution/Package/Module architecture | `solution-architect`, `package-architect`, and/or `module-architect` with the implementation role | `DESIGN.md` in `Draft`; architecture in `Target`; Proposed ADRs where necessary |
| Review reconstructed architecture independently | `architecture-reviewer` or appropriate parent-scope architect | Review finding or ordinary `$swe-architect -review` result; no fabricated acceptance |
| Reconstruct portfolio outcome, Epic, Feature, and allocation | `platform-engineer` | Draft `EPIC.md`, `FEATURE.md`, and adjacent `IMPLEMENTATION-PLAN.md` as required |
| Reconstruct Concept, impact, platform architecture, ADRs, and contracts | `platform-architect`, informed by `research-engineer` where real research is needed | Draft Concept/impact artifacts, Target architecture, Proposed ADRs/contracts; all in portfolio authority |
| Independently validate delivered local behavior | `solution-validator` | `VALIDATION.md` and requirement-to-test findings under ordinary validation governance |
| Assess cross-solution completion and final Feature acceptance | `feature-validator` | Portfolio validation finding after child evidence and local validations are available |

Implementation agents may test and produce Evidence, but they do not author formal Validation for their own work. Architecture reviewers do not substitute for delivery validators.

## Procedure

1. **Normalize the evidence.** Update the active `PROTOTYPE.md` with the exact developer instruction, repository and revision/worktree anchor, changed paths, checks actually run, observed behavior, embodied decisions, assumptions, divergences, and blockers. Preserve quoted text verbatim.
2. **Classify scope and route.** Compare the prototype with current accepted Feature intent, contracts, and architecture. Select fast path or full lifecycle using the table above, and record the evidence for that choice.
3. **Capture as-built delivery.** The implementation role creates or updates solution-owned `EVIDENCE.md`, or the chosen fast-path record, from verified results. It maps observed behaviors to tests and records failures or unrun checks plainly.
4. **Reconstruct local intent.** The appropriate developer and architect create a Draft `DESIGN.md` that describes the behavior that now exists, alternatives still open, debt deliberately accepted for the prototype, and the changes required to make it production-ready. Reconcile affected architecture as `Target`; never relabel the implementation as approved architecture retroactively.
5. **Reconstruct portfolio intent when required.** In portfolio authority, create or update the smallest coherent chain of Draft Epic, Concept, architecture-impact assessment, Draft Feature, and Draft Implementation Plan. Create Target platform architecture or Proposed contracts/ADRs only where the evidence demonstrates a need. Link child and portfolio artifacts with stable IDs, repository-relative paths, and revision when known.
6. **Review reconstructed architecture.** An independent architecture reviewer compares the candidate Target with the as-built evidence and existing Current architecture. It records conflicts, debt, and required repair. Normal approval policy decides whether the Target is accepted; Prototype Mode does not.
7. **Validate behavior independently.** A `solution-validator` checks the prototype against the reconstructed criteria, Design, architecture, and Evidence. A `feature-validator` performs portfolio acceptance only after all required child evidence and local validation exist. Record `Blocked` when criteria are still ambiguous rather than manufacturing a pass.
8. **Reconcile differences.** For every mismatch, choose and record one of: repair implementation, revise Draft intent, create a Proposed architecture decision, defer as named debt with an owner, or block for a developer decision. Never edit an accepted artifact to make the history appear forward-governed.
9. **Close the run.** Set the run header `backtracking_status` and body status to `Complete`, then set run `status` to `Reconciled` only when the route, artifacts, evidence, reviews, validation state, handoffs, and remaining decisions are all durable. Update the state transition/history. A blocked run prevents the mode from turning off.

## Exact orchestration example

If the developer sends the following while Prototype Mode is on:

```plaintext
$orchestrate code feature-001
```

then the primary agent must preserve `$orchestrate code feature-001` verbatim in the active run record, propagate the canonical on-sentinel plus the run ID and repository scope to the orchestration, implement the requested feature without requiring pre-existing accepted lifecycle artifacts, integrate the results, and then execute this backtracking process. The orchestration does not end at working code.

## YAML header and traceability checks

Before reconciliation, validate every created or updated SWE artifact against the canonical artifact template and artifact contract that owns it. At minimum verify:

- bounded YAML frontmatter and legal `artifact_type`/`status` casing;
- stable IDs and no renumbering of accepted `EO-NNN` or `AC-NNN` identifiers;
- portfolio versus solution authority and canonical artifact placement;
- dual upstream locators containing repository, artifact ID, path, and revision when known;
- Draft/Target/Proposed initial state for reconstructed decisions;
- Approval Records that remain `Pending` unless a real ordinary-governance decision occurred;
- exact criteria-to-Design-to-Evidence-to-Validation traceability;
- no unresolved template placeholders, invented test results, fabricated acceptance, or silent cross-repository copies.

## Reconciliation completion criteria

A prototype run is `Reconciled` only when:

- its exact developer request and complete changed-path inventory are durable;
- actual verification evidence and limitations are recorded;
- the route selection is justified;
- all in-scope artifacts are created or updated in their authoritative repositories;
- inaccessible out-of-scope work is represented by explicit handoffs;
- architecture review and independent validation are complete or honestly recorded as pending/blocked under ordinary governance;
- divergences and debt have owners or recorded developer decisions;
- no artifact claims an approval, promotion, test, or status transition that did not occur.
