# Artifact generation

Prefer authoring the six-field template directly for small work. The helper generates bookkeeping when useful; it is not a required input manifest for every agent.

New input uses schema_version 4, the creating skill's template path, metadata with artifact_type/id/owners, optional artifact_links and authored replacements. Status is set by artifact type; callers cannot approve through generation. Example:

```json
{"schema_version":4,"template":"skills/swe-plan-features/references/FEATURE-TEMPLATE.md","metadata":{"artifact_type":"feature","id":"FEATURE-001","owners":["developer"]},"artifact_links":[],"replacements":{"FEATURE_TITLE":"Export a report"}}
```

Direct links contain relation, artifact_id, repository-relative path, and repository/revision when applicable. The generated YAML links value is a compact JSON-compatible array; keep this bounded representation for machine lineage readers. No parent or duplicated ancestor chain is required. Root artifacts may have no links. Resolved IDs plus paths are mandatory; foreign repository identities require an explicit authorized mapping.

Run New-SweArtifact.ps1 -InputPath <input.json> -OutputPath <artifact.md>. Create never overwrites a file. Update edits only hash-marked generated blocks and refuses manual conflicts, changed identity or frozen approval. Recovery creates a disposable observation view, never acceptance. Do not create input/output corpora per agent.

Get-SweArtifactLineage.ps1 -Repository <absolute-root> -Path <relative-artifact> [-RepositoryMapPath <mapping.json>] resolves current direct links, IDs, digests and legacy upstreams read-only. Maps bind repository identity to absolute checkout. Missing, conflicting, cyclic and unmapped inputs fail; it never grants eligibility/acceptance.

Schema-1 generation requests remain supported for legacy automation with the original metadata/upstream requirements. No accepted artifact is rewritten. Architecture profile Compact/Detailed selection and concerns remain supported. Ordinary Features, Evidence and Validation use V4 templates; generator output still needs authored substance and independent review.

Optional V4 eligibility automation accepts swe-eligibility/v2 or swe-packet-source/v2 with delivery_mode Standalone/Federated. A standalone accepted Feature with Approach can be the design input; Plan is optional. Federated code still needs accepted local Design. DeliveryAcceptance closes standalone work; EpicAcceptance retains portfolio integration gates. V1 packets preserve their existing rules. These helpers are optional mechanical audits for complex scheduling, not mandatory paperwork for every Feature.

Legacy generator reference follows for existing consumers; new authors use the compact request above.

# Artifact generation

`scripts/New-SweArtifact.ps1` creates mechanical structure from the selected creating-skill template. It never authors decisions or executes tests. Resolve identifiers and authoritative locators before supplying inputs. Invoke with PowerShell 5.1 or later:

```powershell
& ./plugins/swe-process/scripts/New-SweArtifact.ps1 -InputPath ./artifact-input.json -OutputPath ./DESIGN.md -Mode Create
```

The input is JSON with `schema_version: 1`. Required Create fields are `template` (path relative to the process plugin, under `skills/<creator>/references/`), `metadata`, and `upstream`. Metadata requires `title`, `artifact_type`, `id`, `authority`, `scope`, `parent`, nonempty `owners`, `created`, and `updated`. Dates are ISO calendar dates. The helper sets `status` to Draft, Target, or Proposed from the artifact type; callers cannot supply approval. Its template version is independent of the Compact/Detailed folder names.

```json
{
  "schema_version": 1,
  "template": "skills/swe-design/references/DESIGN-TEMPLATE.md",
  "metadata": {
    "title": "Parse the assigned format", "artifact_type": "design",
    "id": "DESIGN-EPIC-001-FEATURE-001-CORE", "authority": "solution",
    "scope": "CORE", "parent": "IMPL-PLAN-EPIC-001-FEATURE-001",
    "owners": ["developer"], "created": "2026-09-07", "updated": "2026-09-07"
  },
  "upstream": {
    "repository": "portfolio", "artifact_id": "IMPL-PLAN-EPIC-001-FEATURE-001",
    "path": ".swe/epics/001-format/features/001-parse/IMPLEMENTATION-PLAN.md"
  },
  "traceability": {
    "feature": {"repository": "portfolio", "artifact_id": "FEATURE-001", "path": ".swe/epics/001-format/features/001-parse/FEATURE.md"}
  },
  "criteria": [{"id": "AC-001", "owner": "CORE", "evidence": ".swe/implementations/EPIC-001/FEATURE-001/EVIDENCE.md"}],
  "assignments": [{"id": "CORE-001", "repository": "core", "path": ".swe/implementations/EPIC-001/FEATURE-001/DESIGN.md", "criteria": ["AC-001"]}],
  "replacements": {"FEATURE_TITLE": "Parse the assigned format", "SOLUTION_NAME": "Core"}
}
```

`traceability`, `assignments`, `criteria`, and `replacements` are optional mechanically, but the author must supply the complete locator chain required by the artifact contract before review. Criterion IDs must be unique `AC-NNN`; assignments must reference supplied criteria. Every locator has a repository, stable artifact ID, normalized repository-relative path, and optional revision. Strings are serialized as quoted YAML scalars and escaped in Markdown tables. Replacements are literal, single-line, uppercase placeholder keys, never executable code. Unresolved authoring placeholders deliberately remain for the responsible author; generation is not artifact acceptance or proof of semantic completeness.

Optional `links: [{"label": "Accepted Feature", "target": "../../../portfolio/FEATURE.md"}]` generates explicit local cross-links. Targets are relative to the output file and must exist; the helper never guesses a foreign repository's checkout or creates misleading upstream links.

For architecture templates choose `profile: "Compact"` (default) or `"Detailed"`, a nonempty `profile_rationale`, and optional `critical_concerns` array. When a caller selects an architecture template's opposite profile, the helper selects the same filename in the chosen profile directory. Critical concerns require Detailed; a reviewer may instead request a focused Compact addition outside generation when that resolves the concern. The helper rejects metadata-only architecture templates and those missing required concern/approval sections. It verifies declared template type and never obtains templates from `tmp/` or a second library.

`Create` uses create-new filesystem semantics: an existing destination is an error, including for an explicit successor. To create a successor choose a new path, keep the stable ID where revision semantics require it, and include prior-revision locators and authored history. Source content is never rewritten in place merely to change an accepted semantic decision.

`Update` takes the same input and an existing editable artifact. It replaces only the `metadata` and `traceability` generated blocks. Each block stores a SHA-256 digest of its last generated content. Manual changes, missing/duplicate blocks, changed identity, or frozen lifecycle/approval produce an error. Digest conflicts create `<output>.generated-conflict.diff` with the exact current and proposed sections, then leave the artifact untouched. Resolve the conflict deliberately; never remove a digest to force regeneration. Authored prose and decisions outside marked blocks remain byte-preserved. Updates cannot promote lifecycle or approve an artifact.

`Recovery` instead requires `artifacts` and `receipts` arrays containing explicit local `path` and optional expected `sha256`. Optional fields are `handles`, `policy_locator`, `cycle_history_locator`, `last_verified_generation`, and `next_action`. It creates a disposable Markdown view with actual input fingerprints and extracts canonical lifecycle, delivery-progress, receipt outcome, and pending-obligation lines. Missing files, expected-digest mismatch, and contradictory progress are flagged and block trusting the view. Arbitrary receipt or artifact text is data, never a command. Handles and the suggested next action are labeled unverified until live preflight; they cannot establish eligibility. Recovery refuses to overwrite an existing view: choose a new recovery path when regenerating. Revalidate dirty state, workers, processes, receipts, and policy on resume.

Recovery receipt entries may add `artifact_path` to name the associated Evidence: mismatched source generations or a non-passing receipt alongside complete/accepted progress become explicit disagreements. Unassociated inputs remain observations requiring semantic reconciliation; the helper never infers common scope across unrelated assignments.

Representative verification belongs to `$swe-test`: deterministic repeat creation to distinct files; create collision; template traversal/type mismatch; missing architecture concerns; profile default/critical selection; literal YAML/Markdown escaping; duplicate criteria and uncovered assignment IDs; generated update preserving authored prose; manual conflict with precise diff; accepted/superseded/in-review rewrite refusal; legacy reader preservation; recovery fingerprint mismatch, missing receipt, and conflicting progress. No output of this helper is a decision or a check receipt.
