---
name: loc
description: Estimate lines of code for the current repository or an optional directory and create or update that directory's .swe/LOC.md report. Invoke when the user asks for a line-count estimate, LOC report, or $loc [DIRECTORY_PATH:OPTIONAL]. Use Codebase Memory Module.end_line values grouped by file type; do not pretend that graph coverage is an exact filesystem count.
---
# Lines of Code

Use this utility as `$loc [DIRECTORY_PATH:OPTIONAL]`. It measures the selected repository scope with Codebase Memory and maintains only the selected scope's `.swe/LOC.md`.

## Scope and safety

- Resolve an omitted `DIRECTORY_PATH` to the current repository/workspace root. Resolve a supplied path and stop if it does not exist or is outside the intended workspace.
- Do not edit plugin manifests, process skills, scaffolds, README files, or any file other than the target `.swe/LOC.md` and its containing `.swe/` directory.
- Treat the result as an estimate. Never report graph totals as exact physical line counts.
- Preserve existing `.swe/LOC.md` history and user-authored content. If the file is malformed or its ownership markers are missing, stop and explain instead of replacing it.

## Measurement workflow

1. Identify the Codebase Memory project for the resolved repository. If it is not indexed, index that repository before measuring.
2. Use `get_architecture` (scoped to `DIRECTORY_PATH` when supplied) and `get_graph_schema` to confirm the indexed project and the `Module`/`File` properties. Use `query_graph` to retrieve one row per module file:

   ```cypher
   MATCH (m:Module)
   RETURN m.file_path AS path, m.end_line AS lines
   ORDER BY path
   ```

   Filter returned paths to the requested directory prefix using normalized `/` separators. Deduplicate by normalized path, retaining the greatest `end_line` for a file. `end_line` is the estimate for that file; do not add duplicate module spans.
3. Group rows by extension. At minimum classify `.md` as Markdown, `.toml` as TOML, `.yaml`/`.yml` as YAML, `.json` as JSON, `.ps1`/`.psm1` as PowerShell, `.cs` as C#, `.js`/`.jsx` as JavaScript, `.ts`/`.tsx` as TypeScript, `.py` as Python, and `.sh` as Shell. Keep any other extension as its own named type rather than silently dropping it.
4. Query graph coverage separately when possible: count scoped `File` nodes and compare them with the deduplicated `Module` rows. List missing or unsupported paths/types in the report. A zero result for a language means “no indexed Module rows matched,” not proof that the filesystem contains no such files.
5. Sum the per-type estimates and verify that the displayed total equals the sum of displayed rows. Record the project, scope, timestamp, method, module-file count, graph-file count, and coverage caveat.

## `.swe/LOC.md` update

Use [`references/LOC-TEMPLATE.md`](references/LOC-TEMPLATE.md) as the structure for a new report. Substitute every `{{...}}` placeholder before writing it; no template placeholders may remain in the generated report.

- If `.swe/LOC.md` is absent, create `.swe/` and render the template with the current estimate and an initial history entry.
- If it exists and contains the `LOC:CURRENT` and `LOC:HISTORY` markers, replace only the current estimate block and append a dated snapshot inside history. Keep prior snapshots byte-for-byte unchanged.
- If it exists without those markers, do not overwrite it. Report the measured estimate and the migration needed to make the file skill-owned.
- Use Markdown tables with numeric `Files` and `Estimated lines` columns. Include a bold `Total` row and a coverage/method note. The report should identify the scope directory and measurement timestamp.

## Validation

Before finishing, confirm that the target `.swe/LOC.md` exists, contains the scope, timestamp, per-type table, bold total, coverage note, and no unresolved `{{...}}` placeholders. Recalculate the total from the table. Do not claim exactness, complete indexing, or a successful write when the graph or filesystem prevents that conclusion.
