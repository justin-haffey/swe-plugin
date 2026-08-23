# Interface Redesign

## Core question

Find where interfaces or modularization create friction and propose seams that improve cohesion, autonomy, and evolvability.

## Analyze

- Map responsibility owners, callers, consumers, data ownership, protocol or API contracts, lifecycle, and failure behavior at the target seams.
- Distinguish semantic coupling from transport, temporal, deployment, data, and organizational coupling.
- Identify chatty interactions, bidirectional dependencies, shared mutable state, leaky abstractions, unstable contracts, and coordination-heavy changes.
- Test alternative dependency directions, contract granularity, event versus request models, anti-corruption boundaries, or module decomposition.
- Preserve necessary domain invariants and compatibility obligations while evaluating migration steps.

## Recommendation test

A strong recommendation names the revised responsibilities and contract, reduces a demonstrated coupling cost, and explains compatibility, failure, observability, and migration consequences.

## Avoid

Do not optimize an interface from signatures alone, assume fewer calls always means less coupling, or edit contracts during analysis.

