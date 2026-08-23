# Leverage-Point Analysis

## Core question

Locate the smallest conceptual interventions most likely to improve the architecture as a whole.

## Analyze

- Reconstruct the important responsibilities, dependencies, information flows, feedback, and delays from existing artifacts and implemented relationships.
- Separate symptoms and parameter tuning from structural causes such as ownership, information flow, rules, goals, incentives, and governing assumptions.
- Identify reinforcing and balancing dynamics in prose, including where local optimizations worsen system-level behavior.
- Rank candidate interventions from low leverage to high leverage and explain why the ranking fits this software context.
- Test whether each proposed leverage point is owned at the target scope or requires an upstream/downstream decision.

## Recommendation test

A strong recommendation changes an architectural rule, information flow, responsibility, goal, or model with a plausible causal path to the expected improvement. It names trade-offs and evidence that would show the intervention worked.

## Avoid

Do not draw a new system map, invoke diagram tooling merely because the strategy is called systems mapping, or present a dependency count as a causal explanation.

