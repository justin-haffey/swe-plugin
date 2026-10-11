# SWE Plugin 4.0

Governed software delivery with less paperwork. A solution can own and deliver its capabilities independently. A portfolio adds shared intent, contracts, allocation and integration for genuinely related solutions.

Start with the [quickstart](QUICKSTART.md): it walks through ordinary standalone delivery and a coordinated portfolio effort. Existing projects use the [V4 migration guide](plugins/swe-process/references/V4-MIGRATION.md); scaffolding never overwrites their files or adopts automatic approval.

## Delivery

- Ordinary standalone work: Feature with outcome/approach, Evidence, independent Validation.
- Federated work: canonical upstream Feature/allocation, local Design/Evidence/Validation, then portfolio integration acceptance.
- Bugfix/enhancement: intentional single-record fast paths.
- Extra Epics, Plans, research, Concepts and architecture documents: only for real decisions or coordination.

Skills own procedures; AGENTS.md owns repository authority and phase ownership; native agents own expertise/models/independence. Developers repair, test-runner executes bounded checks through swe-test, independent validators judge acceptance. Human approval remains default. Reuse current evidence and avoid repeated ancestor headers, per-agent manifests, or duplicate full test runs.

## Packages

All packages are **4.0.0**: swe-process (delivery), swe-codex (Codex authoring/wrap-up), swe-utility (bounded utilities), swa-analyze (advisory strategic analysis). The [generated skill catalog](plugins/swe-process/references/SKILL-CATALOG.json) is the inventory authority. Use `$swe-max` explicitly for coordinated delivery, or direct skills; `$swe-comment` handles code-local documentation. Prototype Mode is retired; historical journals remain evidence.

## Scaffolds and maintenance

The sole sources are [solution](plugins/swe-process/scaffolds/solution/) and [portfolio](plugins/swe-process/scaffolds/portfolio/). The additive copier merges directories and creates missing files only. Ordinary skill templates live with their creating skill under references. Generated data never grants acceptance.

See [AGENTS.md](AGENTS.md), [delivery contract](plugins/swe-process/references/ARTIFACT-CONTRACT.md), and [V4 implementation plan](docs/V4-IMPLEMENTATION-PLAN.md). Required repository checks run through swe-test/native test-runner. The process suite covers compact metadata, scaffold modes/collisions, direct-link resolution, role contracts and retained legacy behavior; Codex and SWA have their own validators. Runtime host availability must be reported separately from static or fixture results.
