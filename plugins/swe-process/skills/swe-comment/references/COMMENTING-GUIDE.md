# Commenting Guide

Use this guide after identifying changed code and before making or assigning comment edits.

## What deserves documentation

Prioritize, in order:

1. New or changed public APIs whose repository conventions require doc comments.
2. Contracts that callers must preserve: units, ranges, ownership, ordering, nullability, idempotency, threading, lifetime, side effects, and failure behavior.
3. Non-obvious reasons behind a choice, workaround, guard, compatibility boundary, or security constraint.
4. Algorithms or state transitions whose intent cannot be recovered quickly from names and structure.

A comment is not required merely because a line changed. Clear names and structure are preferable to prose that repeats the code.

## Evidence standard

Ground comments in the current implementation, tests, accepted local contracts, and relevant file history. History can explain why a constraint exists, but source comments should describe the durable constraint rather than a commit, author, ticket conversation, or temporary implementation detail.

When evidence conflicts or intent remains uncertain, do not guess. Leave the code unchanged and report the ambiguity.

## Style

- Match nearby comment syntax, tone, terminology, sentence style, and public API documentation format.
- Keep comments close to the contract or decision they explain.
- Describe observable guarantees precisely; avoid claims such as "always," "safe," or "thread-safe" unless verified.
- Update an existing comment when changed code invalidates it; do not stack a corrective comment beside stale prose.
- Avoid commented-out code, change logs, authorship notes, TODOs without an owned action, and tutorials inside production source.

## Behavior-preserving review

The final diff may contain only comments, doc comments, or docstrings in the selected changed code files. Documentation syntax must not alter runtime values, annotations, generated APIs, executable examples, or build configuration. Treat language constructs with runtime semantics as code, not comments.
