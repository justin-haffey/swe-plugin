---
title: "[RESEARCH_TITLE]"
artifact_type: "research"
id: "RESEARCH-[TOPIC]"
status: "Draft"
authority: "portfolio"
scope: "[EPIC_ID]"
parent: "[EPIC_ID]"
upstream:
  repository: "[REPOSITORY_ID_OR_URL]"
  artifact_id: "[EPIC_ID]"
  path: ".swe/epics/[EPIC_DIRECTORY]/EPIC.md"
  revision: "[OPTIONAL_COMMIT_OR_TAG]"
owners:
  - "[RESEARCHER]"
created: "[YYYY_MM_DD]"
updated: "[YYYY_MM_DD]"
template_version: "3.0.0"
---

# [RESEARCH_TITLE]

## Question

[DECISION_RELEVANT_QUESTION]

## Method and Boundaries

[METHOD_SCOPE_AND_FRESHNESS]

- Reused research: [SOURCE_LOCATORS_OR_NONE]
- Applicability and freshness: [VERIFIED_SCOPE_DATE_AND_LIMITATIONS]
- New unresolved questions covered: [DECISION_RELEVANT_GAPS]

Keep Draft while the scoped investigation is unfinished. Complete records the finished investigation, including bounded unknowns; it is not approval of the resulting engineering decisions.

## Findings

| Finding | Confidence | Evidence |
|---|---|---|
| [FINDING] | [HIGH_MEDIUM_LOW] | [SOURCE_LINK_OR_LOCATOR] |

## Alternatives

- [ALTERNATIVE]: [TRADEOFF]

## Implications

- [IMPLICATION_FOR_CONCEPT_OR_ARCHITECTURE]

## Unknowns

- [BOUNDED_UNCERTAINTY]

## Sources

- [SOURCE_TITLE] — [URL_OR_REPOSITORY_RELATIVE_PATH], accessed [YYYY_MM_DD]
