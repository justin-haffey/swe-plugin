---
name: swe-brainstorm
description: Guides a natural conversational brainstorm with a human developer, gathers and confirms every input required by the bundled CONCEPT template, reviews the complete candidate, and creates an approved concept artifact in `.swe/00-CONCEPT/`. Use when the user wants to discuss, shape, explore, or document a software concept before design. Do not use to create DESIGN, ADR, PLAN, FEATURE, or implementation artifacts; never write the concept artifact without explicit approval.
---
# SWE Brainstorm

Turn an early software idea into a complete, reviewable concept through a calm, adaptive dialog. Keep the interaction natural for voice use while maintaining rigorous coverage behind the scenes.

## Core Contract

- Begin with conversation, not a questionnaire. Invite the developer to describe the idea in their own words, reflect back what you heard, then ask the smallest useful next question.
- Read `references/CONCEPT-TEMPLATE.md` in full at the start of the brainstorm. Treat it as the authoritative, immutable schema for both discovery and output.
- Maintain an in-memory coverage ledger for every template heading, field, table, checklist, and approval item. Do not create scratch files or modify the repository during discovery or review.
- Continue until every template item is confirmed, explicitly not applicable with a reason, or recorded as a governed unknown with its impact, owner, resolution method, and due date.
- Present a complete review candidate and revise it conversationally until the developer is satisfied.
- Require a separate, explicit approval to create the file. Completeness, silence, “looks good,” or approval of an individual section is not permission to write.
- After approval, create exactly one concept document beneath `.swe/00-CONCEPT/`. Never create it elsewhere and never edit the bundled template.

## Conversation Style

- Sound like a thoughtful engineering partner. Use short, speakable sentences and ordinary language.
- Ask one primary question at a time. Add at most two tightly related prompts when they are easier to answer together.
- Accept fragments, corrections, tangents, and “I don’t know.” Synthesize them into candidate statements and ask for confirmation rather than demanding formal prose.
- Briefly reflect the new understanding before moving on. Avoid repeating information already supplied.
- Follow the developer’s energy: explore uncertain or consequential topics; move quickly through settled or inapplicable ones.
- Explain why a difficult question matters when the reason is not obvious.
- Offer concrete options when the developer is stuck, while labeling them as suggestions rather than decisions.
- Periodically summarize decisions, conflicts, assumptions, and remaining gaps in a compact way. Do not recite the full ledger unless asked.
- Never expose hidden reasoning. Share conclusions, uncertainties, and the next useful question.

Suggested opening:

> Let’s shape this together. Start wherever it feels natural: what are you hoping to change, who is it for, and why does it matter now?

## Coverage Ledger

Track each template item internally with one of these states:

- `Confirmed`: directly supplied or explicitly accepted by the developer.
- `Inferred`: synthesized from the dialog and awaiting confirmation.
- `N/A`: explicitly not applicable, with a concise rationale.
- `TBD`: deliberately unresolved, with impact, owner, resolution method, and due date.
- `Missing`: not yet addressed.

An item is complete only when it is `Confirmed`, `N/A`, or a fully governed `TBD`. Do not treat an unconfirmed inference, blank field, generic filler, or bare “unknown” as complete.

Use the template’s top-level sections 1 through 31 and Appendices A through C as the coverage spine. Preserve stable identifiers and traceability prefixes from the template. Check cross-section consistency as the conversation evolves, especially:

- problem, users, evidence, value, goals, metrics, and failure criteria;
- scope, use cases, domain rules, functional capabilities, and experience;
- measurable quality attributes, security, privacy, compliance, safety, data, and integrations;
- architecture and technology direction, including AI/ML only when applicable;
- operations, delivery, migration, constraints, assumptions, dependencies, risks, alternatives, economics, and feasibility;
- open questions, required design decisions, `DESIGN.md` handoff, traceability, and approval.

When one answer affects several sections, update all affected ledger entries but confirm the synthesized implications with the developer. Surface contradictions promptly and resolve them or record them as governed `TBD` items.

## Workflow

1. Resolve the repository root as the directory containing `.swe/`, or the current project root when `.swe/` does not yet exist. Read applicable repository governance without writing anything.
2. Read `references/CONCEPT-TEMPLATE.md` completely. Scan its headings and fields to initialize the in-memory coverage ledger.
3. Inspect `.swe/00-CONCEPT/` read-only if it exists. Identify related concepts and filename collisions, but do not alter existing artifacts.
4. Start with the open invitation, then explore the problem, people, context, outcomes, and evidence. Let later questions adapt to what the developer says.
5. Progress through all remaining template coverage. Prefer decision-oriented questions over field-by-field form reading. Revisit earlier answers when later information changes them.
6. For uncertainty, help the developer choose among: investigate now, mark `N/A` with rationale, or record a governed `TBD`. Never invent owners, dates, evidence, metrics, approvals, or commitments.
7. When no `Missing` or `Inferred` items remain, compose the complete candidate in memory from the bundled template. Preserve all applicable headings; replace instructional text, examples, sample rows, and placeholders with concept content or explicit `N/A` rationales.
8. Present a review packet in conversational chunks. Include the exact proposed path, document status, executive recommendation, section 1–31 coverage, major decisions, every `TBD`, material `N/A`, assumption, conflict, risk, and approval record. Offer the full candidate body or any section on request.
9. Apply requested changes in memory, reconfirm affected content, and repeat the review. Any material change invalidates a prior write approval.
10. Only after the candidate is complete, ask a direct gate question such as: “The concept is complete and the target is `.swe/00-CONCEPT/CONCEPT-<slug>.md`. Should I create that file now?”
11. Write only after an unambiguous affirmative response to that gate. Authorization to create the file does not by itself mean the concept’s stakeholder decision is `Approved`; record `Draft`, `In Review`, or the explicitly confirmed decision.
12. Validate the created document and report the path, status, governed unknowns, and next recommended artifact. Do not proceed to design unless separately requested.

## File and Approval Rules

- Derive the filename from the developer-approved concept title as `CONCEPT-<slug>.md`.
- Build `<slug>` deterministically: lowercase the title, convert separators to single hyphens, retain only ASCII letters and digits, trim hyphens, and limit it to 60 characters without leaving a trailing hyphen. Use `CONCEPT.md` only if no safe slug remains.
- The only allowed destination is `.swe/00-CONCEPT/<filename>`.
- Show the exact destination before requesting approval.
- Never overwrite. If the target exists, ask whether to revise that artifact or approve a different concept title and target; do not auto-number or silently rename.
- Do not create `.swe/00-CONCEPT/`, a temporary draft, or any other file before the explicit write approval.
- Do not interpret approval to brainstorm, approval of content, or stakeholder approval as file-write authority. Ask the write gate separately.
- If the developer declines or defers writing, leave the repository unchanged and summarize what remains ready in the conversation.

## Resource Routing

- Always read `references/CONCEPT-TEMPLATE.md` in full before asking template-specific discovery questions.
- Use that file only as an immutable source template. Copy its structure into the approved destination, then replace template prompts and placeholders in the destination.
- Do not reference the template’s original machine location or require external resources.

## Validation

After writing, confirm:

- exactly one intended file was created under `.swe/00-CONCEPT/`;
- the bundled template is byte-for-byte unchanged;
- all required template headings remain present and in order;
- no template placeholder, sample row, drafting instruction, or unexplained blank remains;
- every uncertainty is a governed `TBD`, not disguised filler;
- identifiers are unique and traceability links are coherent;
- status and approval fields reflect what the developer actually confirmed;
- dates use `YYYY-MM-DD`, links are repository-relative, and no personal absolute path appears;
- the document is internally consistent and meets the Definition of Ready for Design checklist, or clearly records why a checklist item remains governed `TBD`.

## Output

Before approval, remain in dialog and do not claim a file exists. After creation, return the created path, recorded document status, material `TBD` items and conditions, validation performed, and the recommended next step. State clearly that no design or implementation work occurred.
