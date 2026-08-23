---
title: "Goal Completion Repository Closeout Hook"
artifact_type: "enhancement"
id: "ENH-001"
status: "Validated"
authority: "solution"
scope: "swe-codex"
parent: "swe-codex plugin lifecycle automation"
upstream:
  repository: "swe-plugin"
  artifact_id: "SWE-CODEX-PLUGIN"
  path: "plugins/swe-codex/.codex-plugin/plugin.json"
  revision: "ca4f52703630fabe223086117de0ee19f2f56f9d"
owners:
  - "Ghostworx.ai, LLC"
created: "2026_08_23"
updated: "2026_08_23"
template_version: "2.0.0"
---

# Goal Completion Repository Closeout Hook

## Outcome and Value

When a Codex goal is marked complete, the enabled `swe-codex` plugin requests one final repository wrap-up that reconciles documentation and governance with the completed work and pauses with an exact review handoff. This authoring enhancement separately preserves its required scaffold parity.

## Eligibility and Impact

- Existing capability: `swe-codex` packages reusable Codex authoring workflows.
- Fast-path eligible: Yes; this adds a bounded plugin lifecycle automation without changing portfolio intent or a cross-solution contract.
- Architecture/contracts affected: No architecture change. The plugin gains a supported command hook and one utility skill.
- Escalation: None.

## Scope and Design

- In: Observe successful `update_goal(status="complete")` calls; inject a wrap-up continuation; delegate to `repo-author` with built-in `worker` fallback; update README files and governance-only AGENTS files; run repository-native checks; preserve this authoring repository's scaffold parity; and prepare a review handoff.
- Out: Goal creation, staging, commit, deployment, push, tag, release, version changes, and destructive Git operations.
- Design: A plugin-bundled `PostToolUse` command hook, discovered from the conventional `hooks/hooks.json` path, invokes a dependency-free Node script. The script emits concise model context that activates `$repo-wrap-up`. The skill owns delegation, evidence discovery, repository-agnostic documentation boundaries, repository-native checks, and the review pause. It honors parity conventions defined by the active repository without hard-coding this authoring repository's layout or adding a standalone parity scan.

## Acceptance Criteria

- [x] AC-001: The hook emits closeout context only for a successful `update_goal` call whose requested status is `complete`.
- [x] AC-002: `$repo-wrap-up` attempts `repo-author` first and falls back to a built-in `worker` subagent without recursive delegation.
- [x] AC-003: Closeout updates applicable README files and changes AGENTS files only when durable governance changed.
- [x] AC-004: Any changed top-level portfolio or solution scaffold file is mirrored byte-for-byte under the `swe-scaffold` references tree.
- [x] AC-005: The wrap-up does not stage or commit; it pauses after validation with exact changed paths, review evidence, preserved unrelated changes, and blockers.
- [x] AC-006: Hook, skill, manifest, scaffold parity, and repository-native validation pass.

## Change Map

- `plugins/swe-codex/hooks/`: Goal-completion hook configuration and command handler.
- `plugins/swe-codex/skills/repo-wrap-up/`: Reusable repository documentation and review-handoff workflow.
- `plugins/swe-codex/.codex-plugin/plugin.json`: Plugin and skill discoverability metadata; hooks use default plugin discovery.
- `plugins/swe-codex/scripts/Test-SweCodex.ps1`: Focused static and behavioral validation.
- `scaffolds/{portfolio,solution}/`: Human orientation and durable goal-closeout governance.
- `plugins/swe-process/skills/swe-scaffold/references/{portfolio,solution}/`: Byte-equivalent scaffold copies.
- `README.md`: Authoring-repository plugin and validation guidance.

## Verification

| Check | Result | Evidence |
|---|---|---|
| SWE Codex hook and skill validation | Pass | `plugins/swe-codex/scripts/Test-SweCodex.ps1`: `SWE Codex validation passed.` |
| SWE Process and scaffold parity validation | Pass | `plugins/swe-process/scripts/Test-SweProcess.ps1`: source/reference parity validated. |
| JSON, YAML/front matter, Markdown, JavaScript, and whitespace checks | Pass with one unavailable optional validator | JSON parsing, focused front-matter checks, 12-file Markdown link scan, `node --check`, changed-file whitespace scan, and `git diff --check` passed. The system Python skill validator could not run because no Python interpreter is installed. |

## Validation and Closure

| Field | Value |
|---|---|
| Independent validation required | Yes; lifecycle-triggered repository edits warrant an independent configuration and boundary review. |
| Implemented recorded | 2026-08-23T01:37:51-04:00 |
| Validator | Independent explorer `/root/validate_goal_wrap_up` |
| Independence | Confirmed; read-only review with no edits, staging, or commit. |
| Decision | Accepted after one repair cycle |
| Validation recorded | 2026-08-23T01:37:51-04:00 |
| Evidence | Second independent review accepted manifest discovery, completion gating, non-recursive fallback, no-commit boundary, tests, and scaffold parity. |
| Closure owner | User |
| Closure recorded | Pending |
| Waiver rationale | None |

## Residual Risk

- Runtime hook trust remains an explicit user action in Codex. If `repo-author`, the built-in fallback, Node, or Git inspection is unavailable, the wrap-up reports the blocker and leaves the worktree uncommitted for user review.
