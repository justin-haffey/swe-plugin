# Metaphor Replacement

## Core question

Reveal the governing metaphors behind the current design and test whether a different mental model unlocks a better architecture.

## Analyze

- Extract repeated domain and architecture language from Context, Concept, architecture, ADRs, contracts, APIs, and code identifiers.
- Infer the behaviors, boundaries, flows, failure expectations, and control model encouraged by each dominant metaphor.
- Identify evidence that the metaphor no longer fits or hides important actors, states, loops, or modes.
- Propose a small set of alternative mental models and translate each into concrete architectural consequences.
- Choose a replacement only when it improves explanatory power without obscuring established domain facts.

## Recommendation test

A strong recommendation connects a proposed mental-model change to specific responsibility, interface, state, or failure-model improvements and identifies terminology or design decisions that would later need governed revision.

## Avoid

Do not substitute creative language for evidence, rename concepts without architectural consequence, or let a metaphor override established domain vocabulary.

