# Repository Wrap-Up Review Handoff

Use this contract after documentation reconciliation and validation. The endpoint is a user review, not a Git mutation.

## Attribution

Build the review path set from the completed-goal handoff, the live diff, relevant change artifacts, and repository evidence. Do not infer that every dirty path belongs to the goal. Identify paths that predate the goal, have unclear ownership, contain unrelated hunks, or were already staged.

If an attributable file also contains unrelated edits that cannot be separated safely, do not rewrite, reset, stash, discard, or stage it. Report the overlap precisely.

## Review Evidence

After the final documentation edit and required checks, capture:

- current branch and `git status --short`;
- `git diff --stat` and the exact completed-goal review paths;
- any pre-existing staged paths from `git diff --cached --name-only`;
- repository-native validation results;
- repository-local documentation, generated-file, or parity checks supplied by applicable instructions or native validation.

Do not run `git add`, `git commit`, `git stash`, `git reset`, `git checkout`, `git clean`, `git push`, or any version, tag, release, or deployment operation.

## Handoff Shape

Return:

1. delegated role used (`repo-author` or built-in `worker` fallback);
2. documentation files changed and why;
3. whether AGENTS files changed and the durable governance reason;
4. repository-local documentation-rule result;
5. checks run with pass, fail, or blocked status;
6. exact paths ready for user review;
7. preserved unrelated or pre-staged paths;
8. remaining blockers or a clear ready-for-review statement.

Pause after this handoff. The user decides whether and how to check in the changes.
