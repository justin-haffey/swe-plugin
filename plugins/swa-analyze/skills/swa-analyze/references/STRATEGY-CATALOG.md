# SWA Strategy Catalog

Select the smallest set that attacks the observed architectural problem from meaningfully different angles. One to three strategies is the normal range.

| Skill | Strategic lens | Strong selection signals |
| --- | --- | --- |
| `$swa-leverage-point` | Systems relationships and leverage points | Complexity, feedback, delays, coordination drag, or unclear intervention priority |
| `$swa-boundary` | Boundary critique | Misplaced ownership, excluded stakeholders, scope leakage, or a framing that blocks progress |
| `$swa-metaphor` | Metaphor and mental-model replacement | Architecture vocabulary or analogies silently constrain the design |
| `$swa-abstraction` | Abstraction laddering | Mixed levels of detail, leaked mechanics, missing principles, or poor traceability across levels |
| `$swa-first-principles` | First-principles reconstruction | Inherited choices dominate and incremental change cannot meet the intended outcomes |
| `$swa-inversion` | Assumption reversal | Conventional options are exhausted or a supposedly fixed premise deserves testing |
| `$swa-interface` | Modular interface redesign | Coupling, coordination, contract friction, dependency direction, or module seams are the main problem |
| `$swa-pattern` | Pattern extraction and invention | Repeated structural configurations recur with inconsistent or poor results |
| `$swa-dialectic` | Contradiction mapping and synthesis | Competing qualities, authorities, or operating models create persistent tension |
| `$swa-constraint` | Constraint removal and reintroduction | Assumed limitations suppress better designs or hard and soft constraints are conflated |
| `$swa-perspective` | Multi-perspective re-perception | A fixed part, whole, process, purpose, stakeholder, or operational view hides options |
| `$swa-scenario` | Scenario stress and adaptive redesign | Uncertainty, future change, failure modes, scale, or evolving integrations threaten viability |

Useful combinations include:

- `$swa-leverage-point` + `$swa-boundary` for overcomplicated systems with unclear ownership.
- `$swa-metaphor` + `$swa-first-principles` for designs trapped by inherited language and assumptions.
- `$swa-interface` + `$swa-pattern` for repeated coupling or contract problems.
- `$swa-dialectic` + `$swa-constraint` for tensions sustained by negotiable constraints.
- `$swa-perspective` + `$swa-scenario` for architecture that must serve different actors and remain viable under change.

Do not add a second strategy that merely restates the first. Select additional lenses only when they can change the recommendation, reveal a trade-off, or test the first lens's blind spots.
