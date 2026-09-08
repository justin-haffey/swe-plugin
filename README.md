# SWE Plugin

SWE Plugin **3.1.0** provides portable engineering workflows for a portfolio and its child solutions. V3 reduces repeated artifact writing, starts work when its actual prerequisites permit it, and separates implementation progress from tested, independently accepted delivery.

V3.1 adds [canonical eligibility packet preparation and consolidated adoption preflight](plugins/swe-process/references/V31-HELPERS.md). The packet builder derives IDs, hashes and review counts while preserving unresolved judgments; preflight combines exact migration proposals, package and registry checks, owner compatibility review, and actual-host smoke evidence. Both are read-only and cannot approve work or activate policy. Efficiency measurement is deferred to the real Epic 003 use case; no measured speed or token savings are claimed.

The four packages remain:

| Package | Responsibility |
| --- | --- |
| `swe-process` | Governed lifecycle, internal delivery bridge, bounded testing, templates and scaffolds |
| `swe-codex` | Plugin, skill and agent authoring, advisory pattern lookup and repository wrap-up |
| `swe-utility` | Optional discovery, orchestration, prototype, style and versioning helpers |
| `swa-analyze` | Advisory strategic architecture analysis of existing artifacts and source |

The [generated skill catalog](plugins/swe-process/references/SKILL-CATALOG.json) is the exact inventory across packages. Specialist commands remain callable. `$swe-comment` still documents changed code without changing behavior; `$swe-bridge` is internal to the coordinator. The public utility `$bridge` handles explicit direct requests under the same transport rules without acquiring lifecycle authority.

## Start here

| Task | Command |
| --- | --- |
| Initialize portfolio governance | `$swe-scaffold -portfolio` |
| Initialize a child solution | `$swe-scaffold -solution` |
| Deliver an Epic | `$swe-max -epic <Epic ID or path>` |
| Correct a bounded local defect | `$swe-bugfix` |
| Refine a bounded local capability | `$swe-enhancement` |
| Run required checks for a change or verification batch | `$swe-test <scope>` |

Install the appropriate packages through your configured Codex marketplace. Installing a package does not automatically migrate existing repository governance. Verify the target host exposes the required skills, Goal tools and subagent transport before starting `$swe-max`.

## Portfolio walkthrough

Start with an Epic and reuse applicable verified research. Concept and Architecture Impact share an authoring/review packet but retain their distinct decisions. Change only the affected architecture, contracts and ADRs. Co-author each Feature and its adjacent Implementation Plan, preserving distinct approvals and explicit assignment dependencies.

The coordinator sends an assignment as soon as its approved Feature, allocation, affected architecture and Design-entry prerequisites are ready. A child can enter Design before it has an approved local Design; coding requires that approval. Unrelated assignments can proceed while a prerequisite is blocked. A dependency that requires validated behavior cannot consume an implementation-complete result with checks pending.

After all work is implemented, drain deferred verification batches and necessary fixes, complete independent solution decisions, then reconcile every Feature's cross-solution criteria. A scoped integrated architecture assessment, any required remediation and final reconciliation precede Epic acceptance.

## Solution walkthrough

Verify the exact checkout, dirty baseline, allowed files and upstream Feature/Plan IDs and paths. Author implementation choices and concrete test obligations in the local Design, referencing approved upstream intent. Choose the appropriate developer for the work; the existence of Solution, Package and Module roles does not require three handoffs.

Developers write source and tests and own repairs. `$swe-test` dispatches bounded execution to `test-runner` using **gpt-5.6-luna / medium**, including verification builds, static checks, browser checks and reruns. The tester saves actual outputs and attributable receipts, with no source, test, configuration or assertion repairs. The independent validator judges criterion coverage and can request a fresh tester execution; a green exit or test count alone does not establish acceptance.

Use these checkpoints precisely:

**Implementation complete → Verification complete → Epic accepted**

Evidence can be Draft with implementation complete and checks pending. Complete Evidence requires all required observations; verification complete requires successful checks for the relevant generation. Failed observations remain evidence and cannot prove accepted delivery. Acceptance comes from the actual independent Validation decision, never a developer-written progress field.

## Risk and approval

Minimal-risk work may batch behavioral checks at the Epic implementation checkpoint only when an independent reviewer confirms it is isolated and reversible. Required structural/build checks still run. Public or cross-solution contracts, security, persistence, concurrency, operational effects and foundational prerequisite behavior require early checks. Uncertain dependencies or risk block deferral. Standalone fast paths finish their required checks before closure.

Human approval remains the default unless the repository owner records a V3 standing policy or supplies explicit run authorization. Major intent, contract and risk decisions retain named human approval; technical review stays independent. Preserve a specifically named approver. Automatic review allows at most two repair/review cycles across resumes or renamed packets. Explicit human `-force` records a bypass, never acceptance.

`$prototype -on` remains a separately authorized sequencing exception. It records repository-local observations and backtracks into Draft/Target/Proposed artifacts for ordinary review. It does not grant acceptance, cross-repository writes, external mutation, deployment or Git authority, or reset historical review limits.

## Artifact and role ownership

Architecture stays **Platform → Solution → Package → Module**; systems are views. Portfolio owns Epics, Concepts, impact assessments, Platform architecture, shared contracts, Features and adjacent Plans. Solutions own local architecture, Design, code, tests, Evidence and local Validation. Preserve stable IDs, criterion IDs, dual locators and accepted history; do not copy portfolio artifacts into solutions.

Skills define procedures and output contracts. Agent TOMLs define expertise, model, scope and independence. `agents/openai.yaml` describes a skill to the host; it does not implement or launch a worker. The coordinator schedules work; scripts generate repetitive structure and capture observations. A role file alone does not prove host availability. See [official subagent configuration](https://learn.chatgpt.com/docs/agent-configuration/subagents).

Use Compact architecture templates (`references/v1/`) by default. Select Detailed (`references/v2/`) per artifact for critical boundaries or complex state, failure, compatibility or operational concerns. Record one sentence explaining the choice. Both profiles preserve the same governance; existing accepted Detailed artifacts need no shortening rewrite.

The [artifact contract](plugins/swe-process/references/ARTIFACT-CONTRACT.md) supplies the authoritative lifecycle and progress rules. `$swa-analyze` writes only advisory `architecture/analysis/<scope-key>/ANALYSIS.md`; it cannot change or approve the system it examines.

## Scaffolding and adoption

The final sources are [portfolio](scaffolds/portfolio/) and [solution](scaffolds/solution/). Their packaged copies under `swe-scaffold/references/` must match byte for byte. The copier creates missing files and merges directories; every existing file is skipped. A copied tester alone does not activate V3 in older governance.

Use the [migration and compatibility guide](plugins/swe-process/references/V3-MIGRATION.md) for a read-only proposed diff and separately authorized adoption, preferably at the next Epic or assignment revision. Retain customized agents, MCP registrations and settings. Re-running the scaffold is not a migration. Rollback requires draining V3 deferred obligations and a reviewable handoff; it does not undo code or historical approvals.

Production templates live with their creating skill under `references/`. `scaffolds/_templates/` and `tmp/task-materials/` remain development evidence, not runtime template authorities. Generated coverage and metadata sections never author decisions or overwrite accepted content.

## Maintainer commands

No package-manager build is required. The shipped surface is Markdown, JSON/YAML/TOML, PowerShell, hooks and scaffold assets. Refresh the catalog after an intentional inventory change:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\plugins\swe-process\scripts\Get-SweCatalog.ps1 -Write
```

Route agent-directed validation through `$swe-test`. Native commands are:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\plugins\swe-process\scripts\Test-SweProcess.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File .\plugins\swe-codex\scripts\Test-SweCodex.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File .\plugins\swa-analyze\scripts\Test-SwaAnalyze.ps1
git diff --check
```

Validation covers inventory/version consistency, artifact metadata and locators, role routing, workflow boundaries, scaffold collisions and parity, hook behavior and the new helpers. Also parse affected JSON, YAML and TOML and resolve Markdown references. Static checks cannot prove live role discovery; run the supported-host tester smoke test and fixture rehearsal when changing dispatch or execution.

The trusted `swe-codex` goal-completion hook requests `$repo-wrap-up`: a repository author reconciles documentation, routes checks through the tester and returns exact review paths. It does not stage, commit, publish, version or deploy. Read [AGENTS.md](AGENTS.md) before extending these packages.
