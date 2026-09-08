# SWE Plugin 3.1 implementation and validation

Release target: **3.1.0** for `swe-process`, `swe-codex`, `swe-utility`, and `swa-analyze`.

This increment preserves the existing uncommitted V3 implementation and supplied upgrade plan. The user authorized improvements 1 and 3 from the subsequent assessment, then explicitly deferred improvement 2 (real-use efficiency comparison) to Epic 003. No benchmark, measured improvement claim, child-repository migration, policy adoption, staging, commit or publication is part of this change.

## Delivered behavior

| Improvement | Implementation and boundaries |
|---|---|
| Canonical packet preparation | `Get-SweEligibilityPacket.ps1` reads one reviewed findings block and derives canonical IDs/hashes and durable cycle counts. Shared `eligibility-fields.json` and `Swe-ArtifactFields.ps1` serve both builder and existing audit. Missing semantics, changed frozen files, escaping paths and contradictory locators stay unresolved. Existing packets remain supported; legacy/accepted artifacts require no retrofit. |
| Consolidated adoption preflight | `Get-SweAdoptionPreflight.ps1` combines package versions, three-way migration proposals, destination tester registry/role, installed skill, owner compatibility decision and current actual-host smoke evidence. Missing/stale evidence and unresolved customization produce Blocked. ReadyForReview grants neither acceptance nor adoption; destination writes remain zero. |
| Packaging and routing | All four manifests/display names, release catalog and version checks are 3.1.0. Coordinator/scaffold references and source/packaged scaffold README guidance expose the helpers without new public skills or agent model changes. |
| Discovered schema repair | Corrected an unclosed object in the existing receipt JSON Schema and added permanent JSON parsing to the Process validator. Prior failed output remains attributable in the tester bundle. |

The [helper guide](../plugins/swe-process/references/V31-HELPERS.md) documents exact inputs, field ownership, host evidence limitations and the Epic 003 measurement deferral. The helpers produce disposable reports; they do not create an alternative policy or scheduling authority.

## Validation

The dedicated `/root/test_runner` (`gpt-5.6-luna`, medium) executed the current-source checks:

- Process validator passed **19 V3.1 assertions plus 84 V3 assertions**, catalog, metadata, roles, lifecycle and byte-for-byte scaffold parity. [Final raw output](../tmp/v31-validation/Test-SweProcess-rerun.stdout.txt) and [exit zero](../tmp/v31-validation/Test-SweProcess-rerun.exit.txt) are retained.
- [Codex](../tmp/v31-validation/Test-SweCodex.stdout.txt) and [SWA](../tmp/v31-validation/Test-SwaAnalyze.stdout.txt) validators passed; their unchanged results remain applicable after the final Process-only repairs.
- All nine plugin JSON files parse; 72 TOML files parse and 48 skill front matters pass structural checks. The link scan covered 359 Markdown files and 337 links; its sole unresolved path is the existing `Research/` example in the non-runtime `scaffolds/_templates/WORK/EPIC-TEMPLATE.md`. No shipped/runtime documentation link break was found. `git diff --check` passed. [Static results](../tmp/v31-validation/final-static-checks.txt) retain the exact findings.
- Python `jsonschema` was unavailable, so full semantic JSON Schema validation against receipts is not claimed. JSON parsing and native behavior/provenance checks passed. No dependency was installed. Earlier failed JSON-parser output remains separately identifiable.

A fresh configured tester, `/root/v31_forward_test` on the exact Luna/medium model, followed the adoption procedure. Its real [HOST/AC-001 receipt](../tmp/v31-forward-test/results/9e11ec8a-8d22-4e5d-a008-27a9e8b2234e/receipt.json) passed with exit zero, unchanged current-source generation and no missing coverage. Fingerprints include the config, registered role, installed skill, preflight/shared/check helpers and smoke script. [Host evidence](../tmp/v31-forward-test/host-evidence.json) records the actual configured-fallback dispatch.

The [live preflight report](../tmp/v31-forward-test/adoption-preflight.json) reports `AttestedSmokePassed` and overall `Blocked`: this authoring checkout has no supplied adoption compatibility decision or prior-scaffold baseline, so existing differing files require review. This is the expected safe result, not a failed plugin check. It reports zero destination writes and no policy activation. The complete ReadyForReview path and negative policy/staleness cases were exercised in isolated fixtures with explicitly labeled fixture decisions; those records do not approve any real repository.

Historical 3.0 validation remains in its separate report. Efficiency measurement remains deferred to the real Epic 003 use case as instructed.
