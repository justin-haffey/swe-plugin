---
name: swe-scaffold
description: Extend an active repository with the governed SWE portfolio or solution scaffold. Use when the user invokes $swe-scaffold with -portfolio or -solution, asks to initialize SWE process structure in an existing repository, or needs portable .codex agents and artifact directories merged without overwriting existing files. Do not use to replace or reset an existing repository.
---

# SWE Scaffold

Merge one finalized v2 scaffold into the active repository. Create missing directories and files, preserve every existing file, and report both created and skipped paths.

## Invocation

- `$swe-scaffold -portfolio`
- `$swe-scaffold -solution`
- Optional destination: `-Destination <repository-path>`. Default to the active repository root.

Exactly one scaffold switch is required. Do not infer portfolio versus solution when repository authority is ambiguous.

## Workflow

1. Resolve the destination repository from `-Destination` or the active repository root.
2. Confirm the destination exists and is the repository the user placed in scope.
3. Run `scripts/Invoke-SweScaffold.ps1` with exactly one of `-Portfolio` or `-Solution` and the resolved destination.
4. The script reads the matching `references/portfolio/` or `references/solution/` tree, preflights type collisions, merges missing folders, atomically publishes only absent files, and returns a structured report. Add `-AsJson` for JSON output.
5. Review the report. Never convert a skipped path into an overwrite, and do not add a force-overwrite path.
6. Validate that `AGENTS.md`, `README.md`, `VERSION.md`, `.codex/config.toml`, the expected agent roster, and the repository-specific engineering directories exist after the merge. Existing versions of those files are valid skipped results.

## Safety

- Never overwrite, truncate, delete, rename, or relocate an existing destination file.
- Fail before copying if any source directory maps to a destination file or any source file maps to a destination directory.
- Never treat scaffold content as permission to alter credentials, external systems, Git history, production data, or files outside the destination.
- Preserve existing folders and their contents. Directory merging is additive.
- Stop if the reference tree is missing, the destination cannot be resolved, or both/neither scaffold switches are supplied.

## Validation

- The script exits successfully and reports a summary.
- Every source file is either created or reported as an existing skipped file.
- Portfolio runs contain the 8-agent portfolio catalog; solution runs contain the 17-agent solution catalog.
- No source file is silently omitted and no existing destination file changes.

## Output

Report the selected scaffold, destination, created-file count, skipped-existing count, and any validation limitation. Preserve the script's `SchemaVersion`, path arrays, and nested `Counts` object when another tool consumes the result.
