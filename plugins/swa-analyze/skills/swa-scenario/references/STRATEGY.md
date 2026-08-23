# Scenario Stress Analysis

## Core question

Expose where the current architecture breaks or becomes costly under plausible change, then improve its robustness and evolvability.

## Analyze

- Derive a small set of materially different scenarios from documented risks, product direction, dependencies, scale, operations, security, and uncertainty.
- For each scenario, trace demand, state, dependencies, ownership, contracts, failure propagation, recovery, observability, and change cost.
- Identify brittle assumptions, irreversible choices, capacity cliffs, coordination bottlenecks, and missing adaptation mechanisms.
- Distinguish resilience to failure from evolvability under planned change and test both.
- Recommend options, seams, buffers, versioning, graceful degradation, or staged commitments proportionate to observed risk.

## Recommendation test

A strong recommendation improves more than one plausible scenario or deliberately buys an option at justified cost. It states leading indicators and a validation exercise that does not endanger shared systems.

## Avoid

Do not predict one future as certain, invent unsupported load numbers, or perform live stress, failure, or external-state changes without separate authorization.

