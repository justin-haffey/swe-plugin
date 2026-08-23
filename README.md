# SWE Plugin

SWE Plugin is a source repository for Codex customizations that make a software-engineering process portable, reviewable, and usable across a portfolio repository and its child solution repositories. Version 2.0.1 centers on a governed artifact flow: portfolio intent becomes an Epic, research, accepted architecture and Features; solution repositories turn allocated work into Design, code, evidence, and validation.

The repository contains four plugins. `swe-process` is the primary v2 package. `swe-codex` provides focused authoring workflows for Codex plugins, skills, and agents, `swe-utility` contains reusable supporting skills, and `swa-analyze` provides portfolio-focused strategic architecture analysis.

## Repository layout

```text
plugins/
  swe-process/        v2 engineering-process skills, templates, validator, and scaffold copier
  swe-codex/          Codex plugin, skill, and agent authoring skills
  swe-utility/        reusable supporting skills
  swa-analyze/        strategic software-architecture analysis router and lenses
scaffolds/
  portfolio/          final scaffold for a portfolio/platform authority repository
  solution/           final scaffold for a child solution repository
tmp/task-materials/   design inputs used to develop v2; not shipped process authority
```

[`scaffolds/_templates/`](scaffolds/_templates/) is a temporary development corpus. The production templates belong with the process skills that create them under [`plugins/swe-process/skills/`](plugins/swe-process/skills/); do not treat the temporary corpus as a runtime override layer.

## SWE Process v2

`swe-process` deliberately has a clean, 13-skill roster:

| Phase | Skill | Outcome |
| --- | --- | --- |
| Portfolio work | `$swe-new-epic` | Creates a governed Epic container. |
| Discovery | `$swe-research` | Records bounded, traceable research. |
| Intent | `$swe-conceptualize` | Produces an Epic-local Concept. |
| Impact | `$swe-assess-architecture` | Determines architecture impact and next authority. |
| Architecture | `$swe-architect` | Authors, reconciles, or independently reviews Platform, Solution, Package, or Module architecture, ADRs, contracts, and system views. |
| Definition | `$swe-plan-features` | Defines canonical portfolio Features and acceptance criteria. |
| Allocation | `$swe-plan-implementation` | Creates the portfolio-owned implementation handoff beside a Feature. |
| Solution design | `$swe-design` | Creates local Design for an allocated implementation. |
| Delivery | `$swe-implement` | Implements approved Design and records Evidence. |
| Verification | `$swe-validate` | Independently validates local delivery or integrated portfolio acceptance evidence. |
| Fast path | `$swe-bugfix` | Records a bounded solution-local defect correction. |
| Fast path | `$swe-enhancement` | Records a bounded solution-local improvement. |
| Initialization | `$swe-scaffold` | Additively extends an existing repository with a portfolio or solution scaffold. |

Architecture is organized as `Platform -> Solution -> Package -> Module`. Systems are runtime or operational views within platform or solution architecture, rather than a separate architecture level. The portfolio owns Epics, Concepts, platform architecture, cross-solution contracts, canonical Features, and their adjacent Implementation Plans. A solution owns solution/package/module architecture, local Design, source, tests, Evidence, and local Validation.

Every cross-repository handoff uses both a stable artifact ID and a repository-relative path, with an optional revision. This dual locator lets a child Solution retain a durable link to the portfolio Feature and Implementation Plan without copying or redefining them. Implementation roles run checks and produce Evidence; independent `solution-validator` and `feature-validator` roles author formal Validation. Architecture reviewers use `$swe-architect -review`, not Feature validation.

## SWA Analyze

`swa-analyze` contains a routing skill and twelve focused strategic lenses: leverage points, boundaries, metaphors, abstraction, first principles, inversion, interfaces, patterns, dialectics, constraints, perspectives, and scenarios. `$swa-analyze [<developer_input>]` inspects the requested scope, selects the smallest useful set of lenses, and produces one evidence-backed report at `architecture/analysis/<scope-key>/ANALYSIS.md`.

The analysis is advisory. It reviews existing SWE artifacts and source evidence, uses Codebase Memory graph discovery with direct-source confirmation, and recommends governed follow-up work without modifying the architecture, lifecycle artifacts, contracts, code, tests, or evidence it examines. Portfolio analysis roles receive explicit `$swa-*` allocations; every portfolio and solution agent TOML explicitly declares its own default skill allocation.

## Approval and lifecycle

Decision-bearing artifacts default to named human approval. `-auto-approve` delegates review only to an independent, appropriate agent; the author cannot approve its own work, and two repair-and-review cycles are the maximum before human escalation. `-force` requires explicit human authorization and records the bypass; it does not invent acceptance, validation, or evidence.

Work artifacts move through `Draft -> InReview -> Accepted -> Superseded`. Architecture moves through `Target -> Implemented -> Current -> Superseded`, with implementation Evidence required for the first promotion and validation plus reconciliation required for the second. See the full rules in the [artifact contract](plugins/swe-process/references/ARTIFACT-CONTRACT.md) and in the generated scaffold governance files.

`$prototype -on` deliberately reverses that sequence for explicitly requested, repository-local prototype work: implementation may begin before the ordinary lifecycle entry gates, but the exact request, scope, changes, behavior, checks, and decisions are recorded durably. After implementation, the workflow backtracks into the smallest truthful fast path or Draft/Target/Proposed artifact chain and submits it to ordinary review and independent validation. `$prototype -off` succeeds only after every open run is reconciled or developer-cancelled. The mode does not grant deployment, external-mutation, destructive-action, credential, dependency, Git, cross-repository, acceptance, or validation authority.

## Using a scaffold

Use the final skill only after choosing the repository’s authority:

```text
$swe-scaffold -portfolio
$swe-scaffold -solution
```

The skill copies from its own `references/portfolio/` or `references/solution/` tree into the active repository (or an explicit destination). It creates missing files and merges folders, but never overwrites, truncates, deletes, renames, or relocates an existing destination file. Its report distinguishes created files from skipped existing files.

The portfolio scaffold includes platform-focused Codex agents and governance. The solution scaffold includes solution, package, and module architecture/development agents, implementation specialists, and an independent solution validator. Both install a repository-local `.codex` configuration, starter README/AGENTS guidance, version source, and governed artifact directories.

## Development and validation

No package-manager build is required; the distributable surface is plugin metadata, Markdown skills/templates, scaffold files, PowerShell, and TOML configuration. Work from the repository root and validate v2 process changes with:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\plugins\swe-process\scripts\Test-SweProcess.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File .\plugins\swa-analyze\scripts\Test-SwaAnalyze.ps1
git diff --check
```

The first command validates the exact process-skill roster, required resources, template metadata and traceability contracts, Prototype Mode integration, lifecycle and phase-gate semantics, the current multi-agent feature plus the repository-required v2 workflow selector, role/skill authority, scaffold references, and agent registrations. Run it again after changing a process template, scaffold, or `swe-scaffold` reference. For all packages, validate JSON manifests, SKILL front matter, relative links, and affected TOML registrations before handing off changes.

## Extending the plugins

Read [AGENTS.md](AGENTS.md) before modifying this repository. It defines the source-of-truth order, the package and scaffold boundaries, plugin/skill conventions, validation expectations, and safe Git practices. In particular, process templates must remain owned by the skill that creates them, scaffold references must match their top-level sources, and `swe-scaffold` is created or refreshed last after both scaffolds are final.
