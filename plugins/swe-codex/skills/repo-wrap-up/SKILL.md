---
name: repo-wrap-up
description: Wrap up a completed Codex goal by delegating repository documentation reconciliation, repository-native checks, and an exact user-review handoff. Use when a goal-completion hook requests documentation wrap-up or the user explicitly asks to reconcile completed repository work. Do not use for staging, commits, releases, tags, pushes, deployment, or unrelated worktree cleanup.
---

# Repository Wrap-Up

Reconcile a completed goal with the live repository, keep human and agent guidance truthful, and pause with review-ready evidence.

## Core Contract

- Operate only after the goal's implementation and required implementation checks have completed.
- Attempt the project `repo-author` agent first. If it cannot be resolved or started, delegate the same bounded task to the built-in `worker` subagent with execution mode `BUILT_IN_WORKER_FALLBACK`.
- If already running as `repo-author`, or when the allocation contains `BUILT_IN_WORKER_FALLBACK`, execute directly instead of delegating recursively.
- Wait for the delegated wrap-up and review its evidence before reporting completion.
- Preserve unrelated and pre-existing worktree changes. Stop when attribution is ambiguous.
- Update README files for changed human-facing behavior. Update an applicable `AGENTS.md` only when durable governance, workflow, validation, ownership, or safety requirements changed.
- Never stage, commit, push, tag, release, deploy, change a version, rewrite history, or clean unrelated files.

## Workflow

1. Unless running as `repo-author` or under `BUILT_IN_WORKER_FALLBACK`, attempt to delegate to `repo-author`. If that role cannot be resolved or started, delegate once to the built-in `worker` and include `Execution mode: BUILT_IN_WORKER_FALLBACK`; the worker must execute directly and must not delegate again. Give the selected documentation agent the repository root, completed-goal summary, known changed paths, checks already run, and this skill name.
2. Capture the worktree baseline with `git status --short`, staged and unstaged diffs, and the current branch. Treat pre-existing changes as user-owned until evidence ties them to the completed goal.
3. Inspect the attributable diff to understand the delivered behavior. Read only the relevant lifecycle/change artifacts, architecture or contract records, manifests, tests, scripts, and neighboring documentation needed to substantiate updates.
4. Reconcile documentation:
   - update the root or affected-scope `README.md` when capabilities, layout, setup, operation, validation, or user workflow changed;
   - update additional project or directory README files only when the repository uses them and the completed change affects their documented scope;
   - update `AGENTS.md` only for a durable governance change, never merely to summarize implementation;
   - make no documentation edit when the existing text is already accurate.
5. Honor applicable repository-local documentation ownership, generated-file, and parity conventions. Do not assume a particular scaffold layout or run an ad hoc parity scan; rely on applicable repository instructions and repository-native checks.
6. Run repository-native checks for the attributable change plus Markdown link/path checks and `git diff --check`. Report failed or blocked required validation plainly.
7. Read [the review handoff contract](references/REVIEW-HANDOFF.md), re-check the worktree without staging, and prepare the exact user-review handoff.
8. Return the delegated role used, documentation decision, exact changed paths, validation evidence, preserved unrelated changes, and any blocker. Then pause for the user to review.

## Delegation Prompt

Use this allocation without weakening it:

```text
Use $repo-wrap-up to wrap up the completed goal in <repository-root>.
Execution mode: <PRIMARY | BUILT_IN_WORKER_FALLBACK>.
Completed goal: <summary>.
Known changed paths and checks: <evidence>.
Inspect the live Git diff and relevant change artifacts, reconcile README files, change AGENTS.md only for durable governance changes, follow repository-local documentation rules, run repository-native checks, and prepare an exact review handoff. Do not stage or commit. Return the exact changed paths, checks, preserved unrelated changes, or a precise blocker, then pause for user review. Do not call update_goal.
```

## Safety and Permissions

The goal-completion hook authorizes bounded repository documentation edits and validation only. It does not authorize staging, a commit, version or tag changes, push, release, deployment, history rewriting, or unrelated cleanup.

Stop and report when:

- the repository or current branch cannot be established;
- existing staged changes or mixed hunks cannot be confidently attributed to the completed goal;
- required documentation changes cannot be completed safely;
- a required validator fails or is unavailable; or
- the changed path set cannot be separated from unrelated changes.

## Validation

Before completion, confirm:

- the delegated role was `repo-author`, or the result explicitly records built-in `worker` fallback;
- a built-in worker allocation contained `BUILT_IN_WORKER_FALLBACK` and did not delegate again;
- README claims are grounded in current artifacts and source;
- every AGENTS edit represents a real durable governance change;
- repository-native checks and `git diff --check` ran with truthful results;
- no file is staged by the wrap-up; and
- the final status identifies all changed and preserved unrelated paths.

## Output

Report the role used, files reconciled, AGENTS decision, repository-native checks, exact review paths, unrelated changes preserved, and residual blockers. A valid no-op reports why no documentation edit was needed. Always pause for user review without staging or committing.
