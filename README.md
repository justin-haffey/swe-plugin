# Software Engineering Codex Plugins [NEEDS MAJOR UPDATE]

## Overview

This repository packages a practical software-engineering toolkit for Codex. It combines governed planning workflows, reusable Codex-authoring workflows, local RAG research helpers, and project-scoped custom agents. Together, these components help a team move from an engineering concept to reviewable design and implementation work while keeping decisions, plans, and evidence in the repository. The `swe-process` plugin begins with `$swe-brainstorm`, a voice-friendly conversational skill for shaping an early software idea into a complete concept before design work begins.

The repository is a local Codex marketplace: [`.agents/plugins/marketplace.json`](.agents/plugins/marketplace.json) exposes the plugin packages under [`plugins/`](plugins/). The scoped SWE process separates durable architecture in [`docs/`](docs/) from delivery evidence in [`.swe/`](.swe/).

## Features

- **Voice-friendly concept discovery:** `$swe-brainstorm` develops and reviews a complete concept through a natural conversation, creating the concept artifact only after explicit approval.
- **Scoped SWE process** — `swe-process` provides conversational routing plus deterministic System, Solution, optional Workload, Package, Module, and Feature workflows. Every scoped Plan has Markdown task tracking.
- **Bounded corrective work** — `$swe-bugfix` records and verifies one defect correction; `$swe-enhancement` records and verifies one bounded improvement without bypassing the normal escalation gates.
- **Codex solution authoring** — `swe-codex` provides focused workflows for creating or evolving Codex plugins, skills, and native custom agents.
- **Local RAG research helpers** — `local-rag-skills` supplies read-only skills for source discovery, status checks, indexing verification, and evidence retrieval through a [Local RAG MCP Server](https://github.com/justin-haffey/local-rag).
- **Project customizations** — [`.codex/config.toml`](.codex/config.toml) registers specialist custom agents and project-level Codex settings.
- **Reviewable engineering artifacts** — [`.codex/AGENTS.md`](.codex/AGENTS.md) defines the canonical `.swe/` artifact layout and the progression from concept through implementation evidence.

## Repository organization

```text
.agents/plugins/marketplace.json   Local marketplace listing
.codex/                            Codex configuration, custom agents, and workflow governance
.swe/                              Delivery, planning, fast-path, and evidence artifacts created by SWE Process workflows
plugins/
  swe-process/                     Governed SWE planning and execution skills
  swe-codex/                       Codex plugin, skill, and agent authoring skills
  local-rag-skills/                Read-only Local RAG research skills and MCP configuration
  local-rag-mgmt/                  Explicitly invoked Local RAG index-management skills
```

Each plugin has a `.codex-plugin/plugin.json` manifest and a `skills/` directory. The marketplace currently makes these packages available:

| Plugin                                           | Purpose                                                                                                                     | Included skills                                                                                                                                                |
| ------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [`swe-process`](plugins/swe-process/)           | Shape concepts conversationally, then route governed scoped Design, Plan, Feature, execution, Bugfix, and Enhancement work. | Root routers plus direct`swe-design-*`, `swe-plan-*`, and `swe-code-*` skills; `swe-bugfix`, `swe-enhancement`, `orchestrate`, `orchestrate-max` |
| [`swe-codex`](plugins/swe-codex/)               | Create and maintain Codex-native plugins, skills, and agents.                                                               | `new-plugin`, `new-skill`, `new-agent`                                                                                                                   |
| [`local-rag-skills`](plugins/local-rag-skills/) | Research indexed local sources through the configured Local RAG MCP server.                                                 | `local-rag-search`, `local-rag-evidence-retrieval`, source/status/indexing helpers, and repository reconnaissance                                          |

## Custom agents

The repository's `.codex` configuration is a first-class part of the solution. Its specialist agents support architecture, implementation, infrastructure, agent/skill design, and documentation work. Choose the narrowest agent that fits the task; their definitive scope and instructions live in [`.codex/agents/swe/`](.codex/agents/swe/).

| Agent area                    | Agents                                                                                                                                                                                                                                                                                                                                                                                                                                                | Primary responsibility                                                                                                            |
| ----------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| Architecture and context      | [`solution-architect`](.codex/agents/swe/architects/solution-architect.toml), [`context-engineer`](.codex/agents/swe/engineers/context-engineer/context-engineer.toml), [`jr-context-engineer`](.codex/agents/swe/engineers/context-engineer/jr-context-engineer.toml)                                                                                                                                                                             | System architecture and context, prompt, workflow, and Codex-instruction design.                                                  |
| Codex solution engineering    | [`codex-engineer`](.codex/agents/swe/engineers/codex-engineer.toml)                                                                                                                                                                                                                                                                                                                                                                                  | Builds and validates project-scoped Codex plugins, skills, agents, and related configuration.                                     |
| Application and platform work | [`csharp-developer`](.codex/agents/swe/developers/csharp-developer.toml), [`full-stack-developer`](.codex/agents/swe/developers/full-stack-developer.toml), [`maf-developer`](.codex/agents/swe/developers/maf-developer.toml), [`ui-designer`](.codex/agents/swe/developers/ui-designer.toml), [`azure-engineer`](.codex/agents/swe/engineers/azure-engineer.toml), [`azure-db-developer`](.codex/agents/swe/database/database-developer.toml) | Application, UI, Microsoft Agent Framework, Azure infrastructure, and Azure data work.                                            |
| Documentation                 | [`code-commenter`](.codex/agents/swe/documentation/code-commentor.toml), [`repo-author`](.codex/agents/swe/documentation/repo-author.toml), <br />`social-author`                                                                                                                                                                                                                                                                                 | Code-local comments and documentation; repository`AGENTS.md` workflow rules and human-facing `README.md` files, respectively. |

## Setup and use

### Prerequisites

- A Codex environment that supports local plugin marketplaces and project `.codex` configuration.
- A local checkout of this repository.
- For `local-rag-skills`, a running Local RAG MCP server at the endpoint configured in [`plugins/local-rag-skills/.mcp.json`](plugins/local-rag-skills/.mcp.json). Its bearer token, when required, is supplied through `LOCALRAG_MCP_TOKEN` rather than committed to the repository.
- For graph navigation, install the `codebase memory mcp` codex plugin.

### Add the marketplace

1. In your Codex environment, add this checkout's [local marketplace descriptor](.agents/plugins/marketplace.json).
2. Install or enable the plugin package needed for the task: `swe-process`, `swe-codex`, or `local-rag-skills`.
3. Open the repository as a trusted project so Codex can load its [project configuration](.codex/config.toml) and custom agents.

The repository does not define a package-manager install, build, or test command. Plugin metadata, skill instructions, and project configuration are the distributable artifacts.

### Common starting points

- Use `$swe-brainstorm` to explore and shape an early software idea through a natural, voice-friendly conversation. It creates one lowercase Concept under `.swe/01-concept/` only after explicit approval.
- Use `$swe-design` to select System, Solution, optional Workload, Package, or Module scope from research, Concepts, and durable architecture, then invoke the matching direct Design skill.
- Use `$swe-plan` to select the correct planning scope after approved Design and ADRs. Every scoped Plan includes Markdown task tracking and sign-off gates.
- Use `$swe-feature` as the compatibility entry point for one Feature; `swe-plan-feature` is the sole producer of `.swe/05-feature/feature-<id>-<slug>.md`.
- Use `$swe-code` to route one approved scoped target. Passing Evidence verifies its Design and moves linked durable architecture from `Target` to `Implemented`; divergence remains explicit and blocks that transition.
- Use `$swe-bugfix` or `$swe-enhancement` for small tracked work that does not warrant a separate Plan, Feature, Package, or Module artifact.
- Use `$new-plugin`, `$new-skill`, or `$new-agent` when extending a Codex solution.
- Use the `local-rag-*` skills to discover and gather bounded evidence from an indexed local source before making a code decision.

## Development and validation

When changing this repository, read [`.codex/AGENTS.md`](.codex/AGENTS.md) first. It governs the required SWE artifact lifecycle, canonical output paths, evidence expectations, and authorization boundaries.

For plugin changes, validate the affected manifest, skill front matter, referenced paths, and marketplace entry. Run `powershell -ExecutionPolicy Bypass -File scripts/Test-SweProcess.ps1` after scoped-process changes. For custom-agent changes, validate the TOML configuration and confirm the corresponding entry in [`.codex/config.toml`](.codex/config.toml). Keep marketplace paths relative to the repository and keep credentials out of tracked files.

## Contributing

Keep changes scoped to the plugin, skill, or agent being improved. Skill-local references are defaults; a repository may replace a Design, Plan, Bugfix, or Enhancement default only with an exact same-name whole-file override under `docs/templates/`. Do not merge template fragments or invent Code overrides. Treat resulting Designs, ADRs, Plans, and Features as review candidates until a reviewer explicitly accepts them.
