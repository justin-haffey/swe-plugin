---
title: "[SOLUTION_NAME] Context"
artifact_type: "context-vocabulary"
id: "CONTEXT-[SOLUTION_ID]"
status: "draft"
authority: "solution"
scope: "[SOLUTION_ID]"
parent: "[PORTFOLIO_CONTEXT_MAP_ID_OR_NONE]"
upstream:
  repository: "[PORTFOLIO_REPOSITORY_ID_OR_URL]"
  artifact_id: "[PORTFOLIO_CONTEXT_MAP_ID_OR_NONE]"
  path: "[PORTFOLIO_CONTEXT_MAP_PATH_OR_NONE]"
  revision: "[OPTIONAL_COMMIT_OR_TAG]"
owners:
  - "[CONTEXT_OWNER]"
created: "[YYYY-MM-DD]"
updated: "[YYYY-MM-DD]"
template_version: "2.0.0"
---

# [SOLUTION_NAME] Context

[ONE_OR_TWO_SENTENCES_DESCRIBING_THE_SOLUTION_DOMAIN_AND_CONTEXT_BOUNDARY]

## Language

**[PREFERRED_TERM]**: [ONE_OR_TWO_SENTENCE_DOMAIN_DEFINITION]
_Avoid_: [AMBIGUOUS_OR_DEPRECATED_SYNONYMS]

## Relationships

- **[TERM_OR_CONTEXT] -> [TERM_OR_CONTEXT]**: [DOMAIN_RELATIONSHIP_OR_CONTRACT]

## Usage Rules

- Prefer the defined term in architecture, Design, code, tests, and user-facing language within this Solution.
- Include only domain-specific concepts; omit general programming vocabulary.
- Keep definitions concise and name ambiguous or deprecated alternatives under `_Avoid_`.
- When the Solution contains multiple bounded contexts, replace this file with a root `CONTEXT-MAP.md` that links each context-local `CONTEXT.md` and states their relationships.
