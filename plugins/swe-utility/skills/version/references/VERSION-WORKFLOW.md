# Version Workflow Reference

Read this reference whenever `$version` is used. The live governing `VERSION.md` remains the source of truth; this file defines how to apply it safely.

## Command contract

```text
$version [-prefix <proto|alpha|beta|rc|release>] [-major|-minor|-update|-build]
```

- Accept zero or one `-prefix` option and exactly zero or one bump option. At least one of them is required.
- Map `proto`, `alpha`, `beta`, and `rc` to those literal prefixes followed by `-`. Map `release` to no prefix.
- Do not infer a stage transition. A requested prefix is an explicit user decision; if it clearly conflicts with the governing document's stated stage prerequisites, explain the conflict and stop for direction.
- Preserve the selected prefix when no `-prefix` option is given.

## Scope and source selection

1. Run `git rev-parse --show-toplevel` and resolve the current working directory within that worktree.
2. Treat a root `repo/` directory as the requested platform-workspace signal. Also accept root `repos/` as a compatibility alias because the current platform template uses that spelling; report which signal was found.
3. Read the applicable live `VERSION.md` before calculating anything. Resolve one governed inline-code version value using this precedence:

   - If `## Current` exists, read the single inline-code value in that section.
   - Otherwise require `# Version` as the document title and read the single inline-code value in the introductory block before the first `##` heading.

   In either layout, require this shape:

   ```text
   [proto-|alpha-|beta-|rc-]MAJOR.MINOR.UPDATE.BUILD
   ```

   All four components must be decimal integers. Stop if the selected block contains zero or multiple matching values. Never replace placeholders such as `#` or guess a missing component.
4. Resolve scope from the requested operation and location:

   | Operation | Required scope |
   | --- | --- |
   | `-major` | Platform root and its governing root `VERSION.md`. Stop if not in an unambiguous platform workspace. |
   | `-minor` | The current solution and its governing solution `VERSION.md`. Resolve the solution root as the nearest ancestor with a direct `VERSION.md` and either a direct `src/` directory or the governed scaffold markers `architecture/` and `.swe/`. Stop if no candidate exists or multiple candidates at the same authority are plausible. |
   | `-update` or `-build` | The current package/project and its governing package `VERSION.md`. If the invocation is not inside one package, ask the user to run it from the package or supply an unambiguous scope. |
   | `-prefix` only | The unambiguous governing version document for the current scope. |

Never hard-code sample package names or use a version document in a different repository as a substitute.

## Increment rules

Apply the exact rules from the governing document:

| Requested change | Result |
| --- | --- |
| `-major` | Increment `MAJOR`; set `MINOR`, `UPDATE`, and `BUILD` to `0`. |
| `-minor` | Increment `MINOR`; set `UPDATE` and `BUILD` to `0`. |
| `-update` | Increment `UPDATE`; set `BUILD` to `0`. |
| `-build` | Increment `BUILD` only. |
| `-prefix` | Replace only the prefix/stage; leave numeric components unchanged. |

When the effective prefix is `proto-`, a `-build` request leaves `BUILD` at `0`; report that the governing proto exception prevented a build increment. Do not create a synthetic version change to compensate. If no other approved change remains, report a no-op and do not commit, tag, or push. If other approved changes remain, check them in with the unchanged current version in the message and do not create a release tag or release-note update solely for that request.

## Propagation, project versions, and release notes

- For a platform-root major operation, roll the resulting governed version value into project `VERSION.md` documents matched by `repo/*/src/**/VERSION.md` or `repos/*/src/**/VERSION.md` under the selected Git top-level.
- For a solution-level minor operation, roll the resulting governed version value into project `VERSION.md` documents matched by `<solution-root>/src/**/VERSION.md`.
- When a platform-root `-prefix` change is requested, propagate the exact new governed version value to the same platform project-document set. Do not propagate package-only updates or builds.
- Update only the governed code-formatted value selected by the layout rules above in propagated documents; preserve each document's explanatory rules and all unrelated content.
- Before modifying a propagation target, compare its `git rev-parse --show-toplevel` result to the selected worktree. Modify only targets in that same worktree. If a target belongs to a nested or neighboring Git worktree, stop and report it rather than silently crossing repository boundaries.
- For every affected package that contains a .NET project or build configuration, locate the authoritative version carrier by inspecting its project and build configuration. Keep `Version`, package version, assembly/file version, or other existing authoritative carriers aligned with the correlated package version. If a .NET project is present but its carrier cannot be identified or safely aligned, stop before checkin; do not add duplicate XML properties to work around it. Record .NET alignment as not applicable only when no .NET project is affected.
- A major or minor increment whose resulting effective prefix is not `proto-` requires the relevant release notes to be updated with the already-reviewed lower-level features, fixes, and changes. If no release-note location can be identified, stop before checkin. The proto stage does not require release notes.

## Change review and checkin comments

Use Git to gather all staged and unstaged changes before modifying version files:

```text
git status --short
git diff --name-status
git diff --cached --name-status
git diff --stat
```

Read enough of the changed documentation and code to describe actual behavior, not just filenames. Classify candidate files as version metadata, source/configuration, tests, documentation, generated artifacts, or unrelated work. If a path cannot be explained or is outside the requested scope, exclude it and ask the user rather than stage it.

Before approval, baseline both the cached and unstaged paths and hunks for every file that the workflow would edit: the governing and propagated `VERSION.md` files, version carriers, and release notes. If either baseline contains an unrelated path or an unapproved hunk, stop and ask the user to resolve it before mutating or staging. Do not use reset, restore, or unstage commands to alter their work.

Propose a checkin message such as:

```text
Version <new-version>: <concise outcome>

Version: <old-version> -> <new-version>
Scope: <platform|solution|package>
Changes:
- <evidence-based change>
Validation:
- <only checks actually run>
```

Keep the subject concise. Do not invent test results, release claims, or issue identifiers.

For a proto-stage `-build` request that leaves the version unchanged but still has other approved changes, use `Version: unchanged (<current-version>)` in place of an old-to-new transition.

## Git checkin, tag, and synchronization

After the user confirms the exact file list and message:

1. Confirm an upstream exists for the current branch. If it does not, stop before local mutation because the requested synchronization target is unavailable. Fetch it once with `git fetch <remote> --prune`, then compare the branch with its upstream. If the branch is behind or diverged, stop before local mutation; do not merge, rebase, or resolve conflicts automatically.
2. Apply the approved version/document/project/release-note changes. Run relevant validation based on the changed files.
3. Stage only the approved paths with explicit path arguments. Reinspect `git diff --cached --name-status` and the cached diff itself; stop if either contains a path or hunk outside the approved checkin. Then run `git diff --cached --check` before committing.
4. Create the checkin with the approved subject and body. Capture and verify the resulting commit ID.
5. For a major or minor increment, create one annotated immutable tag named exactly after the effective new version, including any prefix, for example `proto-1.0.0.0`. Check both `refs/tags/<new-version>` locally and `git ls-remote --tags <remote> refs/tags/<new-version>` remotely first; if it already exists, stop rather than moving or replacing it.
6. Push the tracked branch with `git push <remote> HEAD:<upstream-branch>`. For a major or minor increment, push only the new tag with `git push <remote> refs/tags/<new-version>`. Verify the remote branch and, when applicable, the exact remote tag afterward.

Never use `git add -A`, `git commit -a`, `--amend`, `--force`, forced tag updates, destructive reset, or automatic merge/rebase. Do not retry a failed commit, tag, or push unchanged. If a tag or commit was created locally but the push fails, leave it intact, report its exact state, and ask for direction.
