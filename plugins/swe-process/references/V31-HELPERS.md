# V3.1 packet preparation and adoption preflight

These bounded helpers reduce repeated mechanical work. They produce disposable observations and proposals, never approvals, governance changes or scheduling authority. Run verification through `$swe-test` and the exact Luna/medium tester. A coordinator may prepare inputs from canonical artifacts; users do not need to write JSON.

## Prepare an eligibility packet

Run `scripts/Get-SweEligibilityPacket.ps1 -InputPath <source.json>` from the installed process package. It writes JSON to standard output and does not edit any artifact. Save its `packet` member only when a scratch output is authorized, then run `Get-SweEligibility.ps1 -InputPath <packet.json>` through the tester. `ready_for_audit` means mechanically populated, not eligible or accepted. Review `unresolved` first.

Minimal source input:

```json
{
  "schema": "swe-packet-source/v1",
  "repository": "C:/work/solution",
  "assignment_id": "CORE-001",
  "phase": "Design",
  "findings_artifact": {"repository":"C:/work/portfolio", "path":".swe/epics/001-example/features/001-core/IMPLEMENTATION-PLAN.md"},
  "artifacts": {
    "plan": {"repository":"C:/work/portfolio", "path":".swe/epics/001-example/features/001-core/IMPLEMENTATION-PLAN.md"},
    "feature": {"repository":"C:/work/portfolio", "path":".swe/epics/001-example/features/001-core/FEATURE.md"},
    "architecture": {"path":"architecture/ARCHITECTURE.md"}
  }
}
```

The named Plan, Design or reviewed handoff may contain exactly one fenced `swe-eligibility` JSON block for the assignment. It records already-owned semantic findings: `assignment_id`, `risk` (class, rationale and explicit booleans), `dependencies`, `reviewed_independence`, `behavior_consumers`, and `review` with a `cycle_history` address. Use the existing [eligibility contract](../skills/swe-max/references/ELIGIBILITY.md) for these fields and later phases. Author the block while the canonical artifact is editable and review it as part of that artifact; do not retrofit accepted files without a reviewed successor. Existing packets and legacy artifacts remain supported unchanged. A block is optional for existing workflows, not a new mandatory artifact.

Addresses can omit repository when local, and omit ID/hash when not already frozen. The builder reads exact canonical IDs and hashes, retains supplied expected ID/hash constraints, and derives `consumed_cycles` from durable history. Frozen inputs that changed remain unresolved rather than silently refreshed. It freezes dependency artifacts, behavior Validation and policy locators, but preserves previously reviewed receipt digests and generations. It never guesses risk, independence, consumers, approvals, behavior truth or omitted inventory. The generated `findings_source` binds the reviewed source; the audit requires its independent decision and unchanged bytes.

[eligibility-fields.json](eligibility-fields.json) is the shared mechanical field definition used by the builder and audit. [Swe-ArtifactFields.ps1](../scripts/Swe-ArtifactFields.ps1) owns their shared path, identity and byte reader. New field requirements belong there once; semantic gate decisions remain in the audit and artifact contract. Linked/escaping file paths are rejected. Source text is never executed.

## Run adoption preflight

After resolving the actual installed package roots and destination, invoke:

```powershell
& '<swe-process>/scripts/Get-SweAdoptionPreflight.ps1' -Destination '<repository>' -Kind solution -Baseline '<known-prior-scaffold>' -PackageRoots @('<swa-analyze>','<swe-codex>','<swe-process>','<swe-utility>') -PolicyPath 'architecture/adr/ADOPTION.md' -HostEvidencePath '<host-evidence.json>'
```

`Baseline` may be omitted, in which case differing existing files require ownership review. `PackageRoots` defaults to sibling packages for authoring checkouts; installed caches may require four explicit paths. The matching packaged scaffold is the proposal. `-IncludeContent` includes exact baseline/current/proposed text only when that destination content is authorized. No helper applies the proposal. Recheck hashes before separately authorized edits.

The report checks four distinct manifest identities and matching versions/display names; emits the existing three-way migration proposal; checks the destination tester registration, current role and installed skill; and verifies policy and actual host evidence. Static inspection supports the scaffold's quoted TOML form; other legal TOML syntax is reported for host resolution, not declared invalid TOML. A host parser and its actual dispatch remain authoritative.

The owner compatibility/adoption artifact uses ordinary metadata and independent human Approval Record. Record `adoption_repository`, `target_version`, `governance_sha256` (current destination AGENTS bytes), and `compatibility: Compatible`. This may approve compatibility while retaining human-default approvals; it does not have to adopt standing automatic approval. A missing decision is `ReviewRequired`, never implicit adoption. Do not invent a human decision to obtain a green report.

The caller discovers the actual host role first, using the documented configured fallback only if necessary, then asks the selected tester for a real bounded `HOST/AC-001` smoke in the destination. Include current config/role/skill and relevant runtime/command bytes in its fingerprint scope. Record actual dispatch output as evidence. The host packet is:

```json
{
  "schema": "swe-host-preflight/v1",
  "repository": "C:/work/solution",
  "role": "test-runner", "model": "gpt-5.6-luna", "reasoning_effort": "medium",
  "session_id": "actual-host-session", "route": "ConfiguredFallback",
  "config_file": {"path":"C:/work/solution/.codex/config.toml", "sha256":"actual-digest"},
  "role_file": {"path":"C:/work/solution/.codex/agents/swe/test-runner.toml", "sha256":"actual-digest"},
  "skill_file": {"path":"C:/installed/swe-process/skills/swe-test/SKILL.md", "sha256":"actual-digest"},
  "dispatch_evidence": {"path":"C:/work/scratch/host-dispatch.txt", "sha256":"actual-digest"},
  "receipt": {"path":"C:/work/scratch/smoke/receipt.json", "sha256":"actual-digest"}
}
```

`NativeRole` and `ConfiguredFallback` are the supported route values. Paths/digests and session/model must come from actual observations. Preflight binds current configuration to supplied dispatch evidence and verifies receipt identity, real zero-exit smoke, output/request integrity and current source/runtime generation. A local script cannot attest its own model or prove that a human-authored dispatch record is truthful; the caller independently checks the actual host result. Missing capabilities, stale bytes, unknown policy or migration conflicts produce `Blocked` with reasons. A complete report says `ReadyForReview`, never adopted, deployed, or accepted. Destination writes and policy activation remain zero/false.

## Deferred measurement

The user deferred efficiency measurement to the real Epic 003 use case. V3.1 adds no synthetic performance claim or benchmark substitute. During that later authorized run, compare elapsed time, tokens, dispatch count, repeated checks, review repairs and defects with an explicitly comparable baseline. Tune batching/reuse only from those observations while retaining existing gates.
