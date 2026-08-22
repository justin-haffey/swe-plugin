---
name: version
description: Increment a documented repository version, prepare a reviewed checkin, synchronize its tracked branch, and tag major or minor releases. Use only when the user explicitly invokes $version for a Git worktree; do not use for version questions, release planning, or read-only audits.
---
# Version

Use this skill for a deliberate versioned checkin. It updates only the version-bearing files and reviewed changes within the current Git worktree; it never versions, stages, commits, tags, or pushes a neighboring checkout.

```text
$version [-prefix <proto|alpha|beta|rc|release>] [-major|-minor|-update|-build]
```

Require exactly one version action: `-prefix`, one bump option, or both. Reject multiple bump options and treat a plain `$version` request as incomplete rather than as a generic commit command.

If the prompt includes the `-help` flag, DO NOT PROCEED FURTHER.  STOP and print the following to the console or ui:

`$version [optional: -prefix <proto|alpha|beta|rc|release>] [-major|-minor|-update|-build]`

## Authority and source of truth

An explicit `$version` request authorizes analysis and preparation for the current worktree. Before any version-file edits, staging, commit, tag, fetch, or push, present the exact proposed version, file list, checkin message, tag (if any), and sync target. Require an affirmative confirmation for those specific writes.

Read the governing live `VERSION.md` document and the current source/configuration it affects. Do not use examples, remembered rules, or an older version document as a substitute. Use Codebase Memory for code-symbol discovery when it is available; verify version documents, Git state, and final edits directly in the current worktree.

Read [the version workflow reference](references/VERSION-WORKFLOW.md) on every invocation. It defines scope selection, arithmetic, propagation, .NET alignment, review/comment rules, tagging, Git sequencing, and stop conditions.

## Preflight

Before asking for confirmation:

1. Establish the Git root, current branch, upstream, remotes, and whether the worktree is a platform workspace.
2. Identify the governing `VERSION.md`; parse exactly one numeric `## Current` value. Stop on placeholders, malformed values, ambiguous scope, or a missing required version document.
3. Inspect staged and unstaged changes with Git, then read enough of each candidate documentation/configuration/code change to explain it accurately. Use this evidence to form a concise checkin subject and body.
4. Resolve the version change, files that must change, release-note obligation, .NET version carriers, propagation targets, and the tag requirement. Do not infer an unreviewed file into the checkin.
5. Stop before mutation when the index or worktree contains a path or hunk outside the approved checkin scope, including a pre-existing unapproved edit to any governed version, propagated version, project-version, or release-note file. Do not unstage, reset, or overwrite user work to make the index clean.

## Execute after confirmation

Apply the approved version mutation and the required propagation only. Keep unrelated user changes intact. Update .NET project version (or other language) properties only after locating the authoritative carrier; never add competing version properties merely to make a value appear updated.

Validate the rendered versions, selected version files, code/config carriers, release notes when required, and the exact staged diff. Stage reviewed paths explicitly, then require the cached paths and hunks to match the approved checkin before committing. Do not use `git add -A`, `git commit -a`, force push, amend, reset, tag replacement, or automatic conflict resolution.

Commit the approved change, create an annotated Git tag only for a major or minor increment, and push the tracked branch and tag. Stop and report the exact local state if any non-replay-safe Git operation fails.

## Handoff

Report the old and new version, changed files, version scope, generated checkin summary, commit ID, tag state, remote synchronization result, validations run, and any intentionally deferred or blocked action. Never claim a commit, tag, push, test, or remote verification without checking its result.
