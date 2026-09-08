---
name: swe-scaffold
description: Extend an active repository with the governed SWE portfolio or solution scaffold. Use when the user invokes $swe-scaffold with -portfolio or -solution, asks to initialize SWE process structure in an existing repository, or needs portable .codex agents and artifact directories merged without overwriting existing files. Do not use to replace or reset an existing repository.
---

# SWE Scaffold

Merge one finalized V3 scaffold into the active repository. Create missing directories and files, preserve every existing file, and report both created and skipped paths. Copying files does not adopt new governance in an existing repository.

## Invocation

- `$swe-scaffold -portfolio`
- `$swe-scaffold -solution`
- Optional destination: `-Destination <repository-path>`. Default to the active repository root.

Exactly one scaffold switch is required. Do not infer portfolio versus solution when repository authority is ambiguous.

## Workflow

1. Resolve the destination repository from `-Destination` or the active repository root.
2. Confirm the destination exists and is the repository the user placed in scope.
3. Run `scripts/Invoke-SweScaffold.ps1` with exactly one of `-Portfolio` or `-Solution` and the resolved destination.
4. For a portfolio run, the script first rejects the legacy root-level `WORK-CONTEXT.md`, `STRUCTURAL-CONTEXT.md`, or `ENGINEERING-CONTEXT.md` layout. Explicitly migrate those files to `.swe/context/` and update the root `CONTEXT-MAP.md` before rerunning; the additive copier must not create duplicate context authorities.
5. The script reads the matching `references/portfolio/` or `references/solution/` tree, preflights type collisions, merges missing folders, atomically publishes only absent files, and returns a structured report. Add `-AsJson` for JSON output.
6. Review the report. Never convert a skipped path into an overwrite, and do not add a force-overwrite path.
7. Request bounded executable checks through `$swe-test` and `test-runner` (`gpt-5.6-luna`, `medium`) for governance, agent registry paths, and engineering directories. Discover the actual host role/model and tool permissions; static TOML alone does not prove execution. Existing files are valid skipped results; if older governance or registry prevents tester routing, report the precise adoption/capability blocker without modifying it.
8. For an existing customized repository, start with [the V3.1 adoption preflight](../../references/V31-HELPERS.md) to combine the proposed diff, version/registry checks, owner compatibility review and actual-host smoke evidence. Follow the [V3 migration guide](../../references/V3-MIGRATION.md). Adopt at an explicitly approved Epic/revision boundary using separately authorized edits. Preserve local agents, MCP/settings, accepted history and exhausted review counts; rerunning this copier is not a migration.

## Safety

- Never overwrite, truncate, delete, rename, or relocate an existing destination file.
- On portfolio runs, fail before writing when any legacy root-level context vocabulary is present. Migration is an explicit repository operation, not an additive scaffold side effect.
- Fail before copying if any source directory maps to a destination file or any source file maps to a destination directory.
- Never treat scaffold content as permission to alter credentials, external systems, Git history, production data, or files outside the destination.
- Preserve existing folders and their contents. Directory merging is additive.
- Stop if the reference tree is missing, the destination cannot be resolved, or both/neither scaffold switches are supplied.

## Validation

- The script exits successfully and reports a summary.
- Every source file is either created or reported as an existing skipped file.
- Fresh portfolios and solutions contain their registered role files, including `test-runner` on Luna/medium and the solution's independent `solution-validator`. Derive the roster from each source registry; existing customized registries stay skipped.
- Portfolio runs keep `CONTEXT-MAP.md` at the root, place its three routed vocabularies under `.swe/context/`, and never leave legacy root duplicates.
- No source file is silently omitted and no existing destination file changes.

## Output

Report the selected scaffold, destination, created-file count, skipped-existing count, effective governance/adoption status, tester capability and any validation limitation. Preserve the copier's existing `SchemaVersion: 2.0`, path arrays, and nested `Counts` object for compatible readers; the package version and copied content are V3.
