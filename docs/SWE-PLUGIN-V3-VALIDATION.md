# SWE Plugin V3 implementation and validation

Target release: **3.0.0** for `swe-process`, `swe-codex`, `swe-utility`, and `swa-analyze`.

Authoring baseline: branch `version3`, commit `e342e45a92916715acb9ab302f05ee308e933a7d`; initially only the supplied upgrade-plan file was untracked.

Scope: implementation of [the upgrade plan](SWE-PLUGIN-V3-UPGRADE-PLAN.md) in this authoring checkout. The supplied plan was preserved as the planning baseline. No child repository was migrated, and no commit, tag, push, publication or deployment was performed.

## Implementation coverage

| Work package | Delivered surfaces |
|---|---|
| V3-01 Baseline | Four synchronized manifests/display names, [generated catalog](../plugins/swe-process/references/SKILL-CATALOG.json), catalog drift check, aligned process/Codex/SWA validators and guides. Repaired the existing incomplete `patterns` skill entry point and malformed metadata while preserving its read-only reference library. |
| V3-02 Contracts | [Artifact contract](../plugins/swe-process/references/ARTIFACT-CONTRACT.md), compatible Draft Evidence/progress, risk/deferral, explicit dependency requirements, frozen reviews, independent decisions and durable two-cycle history; owning templates and scaffold governance aligned. |
| V3-03 Testing | [swe-test](../plugins/swe-process/skills/swe-test/SKILL.md), request/receipt schemas, Luna/medium tester roles/registries, [check recorder](../plugins/swe-process/scripts/Invoke-SweChecks.ps1), immutable attributable observations, timeout/failure/coverage/provenance checks and role-specific execution routing. |
| V3-04 Scheduling | Per-assignment Design/code eligibility, three checkpoints, transport-independent bridge, truthful progress/legacy responses, shared-output coordination, bounded recovery and [stateless eligibility audit](../plugins/swe-process/skills/swe-max/references/ELIGIBILITY.md). |
| V3-05 Artifact production | Compact/default and Detailed architecture profiles, repaired detailed Platform template, paired authoring/review with separate decisions, compact roles, and [artifact generation](../plugins/swe-process/references/ARTIFACT-GENERATION.md) with protected generated sections and conflict reports. Removed the unreferenced malformed Workload template that introduced an unsupported hierarchy. |
| V3-06 Packaging/adoption | Portfolio/solution walkthroughs, final source/packaged scaffold parity, create-missing copier compatibility, [migration matrix and read-only proposed diff](../plugins/swe-process/references/V3-MIGRATION.md), legacy/rollback boundaries and supported configured-host smoke. |

The small helpers are separate deterministic operations, not a service or workflow engine: catalog, artifact production/recovery, receipt capture/fingerprinting, eligibility audit, and migration diff. Eligibility was made executable so dependency, approval and resume fixtures exercise the production rules rather than a test-only duplicate. No helper grants acceptance.

## Verification record

The final [tester result bundle](../tmp/v3-validation/FINAL-RESULTS.md) records passing Process, Codex and SWA repository validators. The Process run passed **84 behavioral assertions**, retained 17 native execution receipts, and passed catalog, metadata, lifecycle, role and byte-for-byte scaffold parity checks. `git diff --check` passed. All check execution used the dedicated `gpt-5.6-luna` / `medium` tester.

Focused checks parsed 72 TOML files, validated 48 skill front matters, and checked 97 relative links across 66 changed Markdown files with no broken links. A parsed comparison of 38 pre-existing TOML files found no model, reasoning-effort, MCP or settings changes. A full YAML parser was unavailable; repository-native structural metadata and template-header checks passed, but full YAML parser validation is not claimed. Earlier failed attempts remain separate from the final successful results.

The fixture rehearsal uses a portfolio, a contract-producing solution, a consuming solution and an independent Minimal assignment. It exercises passing/failing/unavailable checks, concrete participant/operation coverage, shared-output exclusion, stale source/dependency/runtime generations, review-byte correspondence, retained review limits, deferral and final acceptance boundaries. It also exercises artifact generation/collisions, Compact versus Detailed selection, legacy preservation, recovery disagreement and migration/customization protection.

Independent logical disposition: **Accepted for the requested V3 implementation scope**. The separate `codex-engineer` reviewer (`/root/independent_review`) did not author or repair these files. It inspected the plan and current source, final native-validator outputs, all 17 rehearsal receipts, the current-source configured-host smoke, TOML parsing/preservation results, and all four live `3.0.0` manifests/display names. Earlier substantive findings were repaired and rechecked; no remaining plan gap was identified. This disposition covers the plugin-authoring implementation and the explicit verification limits below; it does not accept unrelated downstream work.

## Live host scope

The current session's native agent catalog rejected the newly registered `test-runner` name. The documented explicitly configured fallback resolved the registered tester file and launched the exact `gpt-5.6-luna` / `medium` execution role through the available subagent capability. This is a real command execution, not proof that this session's native named-role catalog refreshed.

The canonical [smoke report](../tmp/v3-validation/configured-host-smoke/SMOKE-REPORT.md) records actual session `01a07efc-bf8f-7fc2-8564-4d16b8b2f465`, role/configuration/helper fingerprints and a Passed `HOST/AC-001` result with exit zero, unchanged inputs and no missing coverage. Its final [receipt](../tmp/v3-validation/configured-host-smoke/results-final/c3835fce-e9cf-43c9-afdb-622cad84b922/receipt.json) preserves exact execution provenance after the helper repairs. Earlier failed or superseded smoke attempts remain separately identifiable.

Live application browser behavior and external participant services are outside this plugin-authoring task. Their unavailability is exercised as Blocked evidence, not reported as application validation. No performance percentage or token saving has been measured or asserted.
