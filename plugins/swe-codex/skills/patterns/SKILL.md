---
name: patterns
description: Find relevant agentic design patterns in the bundled read-only library. Use when selecting patterns for an agent, orchestration, memory, tool, evaluation, or safety design. Do not use to implement code or approve architecture.
---

# Find Agentic Patterns

Resolve the design question, affected boundary, and constraints from the user's request and current source. Use this skill to inform the owning design workflow; it grants no lifecycle or repository authority.

Read [the library access policy](references/.codex/patterns/agentic/README.md). Inspect the category names under that directory, then search only the relevant categories for the question. The library covers orchestration, context and memory, feedback, reliability, safety, tool use, and collaboration. Read the smallest useful set of pattern files; do not load the whole library or assume an example is current runtime documentation.

For each selected pattern, explain the problem it addresses, how it fits the proposed design, its tradeoff, and when it would be unnecessary. Link to the actual file. Check runtime-specific assertions against current source or official documentation when they affect the recommendation. Distinguish a reusable idea from an accepted repository decision.

Return a concise recommendation with pattern locators and unresolved constraints. Keep the bundled library read-only. Do not generate new architecture, alter source, run tests, or grant acceptance from this advisory lookup. If the library does not cover the question, report that limitation and hand back to the owning workflow.
