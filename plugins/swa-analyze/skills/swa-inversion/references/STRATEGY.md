# Inversion Analysis

## Core question

Use disciplined reversal to expose hidden options and test whether the current architecture depends on assumptions that need not hold.

## Analyze

- List material premises supported by artifacts and implementation, separating explicit assumptions from inferred ones.
- Invert one premise at a time: producer versus consumer control, push versus pull, centralized versus federated, synchronous versus asynchronous, mutable versus immutable, or another context-specific reversal.
- Trace each inversion through responsibilities, data, contracts, failure modes, security, operations, and user outcomes.
- Reject counterfactuals that violate verified hard constraints; preserve viable partial inversions and hybrid forms.
- Compare the strongest inverted design with the current model and identify the smallest experiment that could test it.

## Recommendation test

A strong recommendation is not merely contrarian; it demonstrates a viable causal path, names newly introduced costs, and explains which assumption is worth changing.

## Avoid

Do not invert every property, ignore evidence that makes a premise hard, or recommend novelty without a plausible transition.

