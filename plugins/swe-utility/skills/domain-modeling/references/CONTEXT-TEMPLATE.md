---
title: "[CONTEXT_NAME] Context Vocabulary"
artifact_type: "context_vocabulary"
id: "[CONTEXT_ID]"
status: "Current"
authority: "[PORTFOLIO_OR_SOLUTION]"
scope: "[PLATFORM_OR_SOLUTION_OR_PACKAGE_OR_MODULE]"
parent: "[PARENT_ARTIFACT_ID_OR_NONE]"
upstream:
  repository: "[REPOSITORY_ID_OR_URL]"
  artifact_id: "[ARTIFACT_ID_OR_NONE]"
  path: "[REPOSITORY_RELATIVE_PATH_OR_NONE]"
  revision: "[OPTIONAL_COMMIT_OR_TAG]"
owners:
  - "[OWNER]"
created: "[CREATED_DATE]"
updated: "[UPDATED_DATE]"
template_version: "2.0.0"
---

# [CONTEXT_NAME]

[ONE_OR_TWO_SENTENCES_DESCRIBING_THIS_DOMAIN_CONTEXT]

## Language

**[PREFERRED_TERM]**: [ONE_OR_TWO_SENTENCE_DOMAIN_DEFINITION]
_Avoid_: [AMBIGUOUS_OR_DEPRECATED_SYNONYMS]

## Relationships

- **[TERM_OR_CONTEXT] -> [TERM_OR_CONTEXT]**: [DOMAIN_RELATIONSHIP_OR_CONTRACT]

## Rules

- Prefer the defined term throughout this context.
- Define domain meaning, not implementation behavior.
- Use root `CONTEXT.md` only for the single-context state.
- For multiple contexts, use a distinct root `CONTEXT-MAP.md` linking `.swe/context/[BOUNDED_CONTEXT]-CONTEXT.md` artifacts and stating their relationships.
- When expanding, preserve this vocabulary's stable ID at its new path and set its parent to the new map. Do not retain both root forms.
