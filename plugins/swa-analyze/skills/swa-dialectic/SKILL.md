---
name: swa-dialectic
description: Map persistent contradictions and opposing architectural forces, then propose higher-order syntheses that preserve the real value on both sides. Use when centralization versus autonomy, consistency versus speed, or similar tensions block design progress. Do not resolve the tension by editing artifacts.
---

# Dialectical Analysis

Make architectural contradictions explicit and find a synthesis more capable than choosing one pole by default.

## Analyze

1. Resolve the exact repository target and existing SWE artifact chain with [the shared analysis contract](../swa-analyze/references/ANALYSIS-CONTRACT.md).
2. Read [the strategy guide](references/STRATEGY.md) and apply its questions to the documented and implemented architecture.
3. Gather structural code evidence with [the Codebase Memory workflow](../swa-analyze/references/CODEBASE-MEMORY.md), then verify material claims against direct source and non-code artifacts.
4. Develop prioritized architectural recommendations with explicit evidence, affected authority, expected effect, trade-offs, migration implications, and validation tests.

## Output

- On a direct or autonomous invocation, create `architecture/analysis/<scope-key>/ANALYSIS.md` and return its repository-relative path to the calling agent.
- When `$swa-analyze` selects this skill in contribution mode, return structured findings, recommendations, evidence, assumptions, and limitations to the router; do not write a separate report.
- Never overwrite an existing report without explicit user authorization. Never modify analyzed code or authoritative artifacts.
