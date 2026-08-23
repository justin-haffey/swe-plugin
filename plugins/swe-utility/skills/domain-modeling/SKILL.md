---
name: domain-modeling
description: Refine a repository's domain vocabulary or record a domain architecture decision when explicitly requested. Use for creating or updating CONTEXT.md, CONTEXT-MAP.md, or an ADR with repository-aware authority and approval. Do not use for passive vocabulary reading, ordinary implementation discussion, or unsolicited file changes.
---

# Domain Modeling

Sharpen the project's domain language without turning its glossary into a specification. Record only material, durable decisions and respect the active repository's architecture authority.

## Authorization

This skill is explicit-only. Invocation authorizes analysis, not arbitrary writes.

- For discussion-only requests, return proposed terms, scenarios, or decision wording without changing files.
- Create or update `CONTEXT.md` or `CONTEXT-MAP.md` only when the user asks to capture or refine the vocabulary.
- Create an ADR only when the user explicitly asks to record the decision or an accepted governed workflow assigns that artifact.
- Read the live target immediately before editing. Never overwrite, renumber, or relocate an accepted artifact without explicit authorization.

## Vocabulary Workflow

1. Read the applicable `CONTEXT.md` or use `CONTEXT-MAP.md` to resolve the bounded context.
2. Challenge conflicting or overloaded terms with a concrete scenario.
3. Select one preferred term and list misleading synonyms under `_Avoid_`.
4. Keep each definition to one or two domain-focused sentences. Exclude implementation details, general programming vocabulary, requirements, and transient design notes.
5. When a write is authorized, use [the Context template](references/CONTEXT-TEMPLATE.md). Preserve established content and add only the resolved vocabulary.

For a single context, use root `CONTEXT.md`. For multiple contexts, use a root `CONTEXT-MAP.md` that links `.swe/context/[BOUNDED_CONTEXT]-CONTEXT.md` artifacts and states cross-context relationships. These are mutually exclusive root states. When expanding a single-context repository, move the existing vocabulary under `.swe/context/` without changing its stable ID, give the new map a distinct ID, and set each context vocabulary's parent to that map. If neither root form exists, propose `CONTEXT.md`; create or migrate artifacts only with write authorization.

## ADR Workflow

Offer an ADR only when the decision is hard to reverse, surprising without context, and the result of a real trade-off. Otherwise record no ADR.

Resolve the destination from repository governance:

- Portfolio decision: `architecture/decisions/ADR-###-short-name.md`.
- Solution decision: `architecture/decisions/ADR-###-short-name.md`.
- Package or Module decision: the owning Package's `architecture/packages/[PACKAGE_NAME]/decisions/ADR-###-short-name.md`.
- A repository with an established non-v2 decision directory may retain that convention when its `AGENTS.md` requires it; do not create a competing tree.

Number ADRs locally within the selected `decisions/` directory. Preserve stable `ADR-###` IDs. Use [the ADR template](references/ADR-TEMPLATE.md) and include a dual locator for upstream authority.

Decision-bearing artifacts require approval under the active `AGENTS.md`:

- Default: a named human approves.
- `-auto-approve`: an independent appropriate architecture agent reviews; the author cannot self-approve. Allow at most two repair-and-review cycles before requiring a human decision.
- `-force`: only an explicit human instruction may bypass the gate. Record the human, reason, time, and bypassed gate.

Do not mark an ADR accepted before its required approval. Domain vocabulary updates do not approve architecture decisions.

## Validation

Before completion:

- confirm the target repository, authority, context, and destination;
- validate the 12 required YAML fields and dual locator in each created artifact;
- use only `[UPPER_SNAKE_CASE]` template placeholders;
- verify IDs, repository-relative links, and referenced artifacts;
- verify the author and approver are independent when auto-approved; and
- report discussion-only output as unwritten, and approval or validation not performed as pending.

## Output

Return the resolved vocabulary or decision first. When files changed, list their paths, authority, ID, approval state, and validation performed.
