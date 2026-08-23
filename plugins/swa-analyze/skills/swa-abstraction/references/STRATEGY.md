# Abstraction Laddering

## Core question

Reconnect principles, capabilities, responsibilities, interfaces, and implementation so each decision sits at the right level.

## Analyze

- Classify material statements as purpose, principle, capability, architecture responsibility, contract, design choice, or implementation mechanism.
- Trace important high-level outcomes downward to concrete responsibilities and code, noting missing or contradictory links.
- Trace prominent implementation structures upward to the principle or requirement that justifies them.
- Identify details placed too high, architectural decisions buried too low, and abstractions that collapse unrelated concerns.
- Propose the simplest abstraction structure that preserves necessary distinctions and traceability.

## Recommendation test

A strong recommendation relocates or reshapes a decision at the proper authority level and shows both its higher-level rationale and lower-level implications.

## Avoid

Do not treat greater generality as better abstraction, invent generic layers without need, or rewrite artifacts during analysis.

