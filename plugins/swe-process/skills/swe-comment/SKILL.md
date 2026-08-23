---
name: swe-comment
description: Documents new or modified code from the current Git changes using relevant file history and behavior-preserving comments or API documentation. Use when the user asks to comment, document, or explain changed source code. Do not use for general documentation, code review, refactoring, or behavior changes.
---

# Comment Changed Code

Improve the maintainability of changed source code without changing its behavior. Prefer no edit over a redundant, speculative, or narrating comment.

## Invocation

Accept these forms:

```text
$swe-comment
$swe-comment <pathspec>...
```

Without pathspecs, inspect all attributable staged, unstaged, and untracked source-code changes in the current repository. Pathspecs only narrow that changed-file set; they do not authorize comments in unchanged files.

## Workflow

1. Read applicable `AGENTS.md` files and inventory the working tree with `git status --short`. Preserve all pre-existing and concurrent edits.
2. Build the candidate set from `git diff --name-status -M`, `git diff --cached --name-status -M`, and `git ls-files --others --exclude-standard`. Include only new or modified code files. Exclude deleted files, generated or vendored source, minified files, lockfiles, binaries, and user-narrowed paths that are not changed.
3. Inspect each candidate's current source and changed hunks. Use `git log -n 5 --follow -- <file>` for bounded relevant history. Use more history or blame around a changed symbol only when intent remains unclear. For a new file with no history, inspect nearby code and tests only as needed to learn the repository's documentation conventions.
4. Read [the commenting guide](references/COMMENTING-GUIDE.md) before assigning or making edits. Identify exact files and comment opportunities; do not invent a requirement to edit every candidate.
5. Attempt one subagent assignment with the host's `spawn_agent` operation or exact equivalent, selecting the `code-commenter` role. Give it ownership only of the exact candidate files and relevant history findings. Tell it that other work may be present, it must not revert others' edits, and it may make only behavior-preserving comment, doc-comment, or docstring changes.
6. If and only if the specialized role is unavailable or cannot be created, attempt one built-in `worker` subagent with the same file ownership and constraints. Do not retry either role repeatedly. If subagent support is unavailable or both assignments cannot be created, perform the bounded commenting work locally and report the fallback.
7. After delegation, inspect the resulting diff rather than accepting the subagent's summary. Remove narration, unsupported claims, stale implementation detail, and unrelated edits. If an agent left ambiguous partial changes, reconcile them before assigning the same file again.
8. Run the narrowest available formatting, compile, lint, or test checks that can detect malformed documentation without rewriting unrelated files. Run `git diff --check`. Confirm from the final diff that behavior, executable tokens, dependencies, tests, generated outputs, and non-code documentation did not change.

## Boundaries

- Comments must explain verified intent, contracts, invariants, constraints, side effects, failure behavior, or non-obvious reasoning. Do not restate syntax or speculate about future behavior.
- Follow the language and repository's existing documentation style. Do not introduce a new documentation framework or dependency.
- Do not refactor, rename, reorder, reformat broadly, fix defects, change tests, or alter runtime behavior. Report a suspected defect separately.
- Do not copy sensitive history, private incident details, personal attribution, or secrets into source comments.
- Do not stage, commit, amend, reset, push, tag, publish, deploy, or modify external systems.
- If no material comment is justified, leave the code unchanged and explain why.

## Output

Report the candidate and changed files, whether `code-commenter`, `worker`, or local fallback performed the edits, the bounded history consulted, validation results, files intentionally skipped, and any suspected code issue left unchanged.
