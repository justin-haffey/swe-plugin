---
name: new-plugin
description: Design, scaffold, migrate, or validate a Codex plugin with focused skills, manifest metadata, marketplace registration, safety boundaries, and installation-ready validation. Use when a user asks to create or evolve a Codex plugin, bundle skills, add plugin metadata, or package a reusable Codex solution. Do not use for a one-off skill or agent when no plugin bundle is needed.
---

# New Plugin

Create a minimal, production-ready Codex plugin that bundles reusable workflows without confusing the plugin package with an application, a credential store, or a durable database.

## Core Contract

A plugin has a required `.codex-plugin/plugin.json` and may include one or more `skills/` bundles. Add scripts, assets, MCP/app configuration, or state conventions only when the requested workflow genuinely needs them.

Keep skills declarative where possible. Put credentials in approved environment or secret-management surfaces, durable transactional state behind an external application or source system, and external writes behind explicit authorization and confirmation.

## Workflow

1. Inspect the target repository's marketplace, existing plugins, immediate skill neighbors, and applicable `AGENTS.md` guidance. Treat existing sources as behavior to preserve unless the request explicitly changes them.
2. Define the plugin boundary: intended users, trigger workflows, included skills, inputs/outputs, local files touched, optional tools, and explicit non-goals.
3. Choose the smallest structure that meets the request:
   - Always add `.codex-plugin/plugin.json` and `skills/` when the plugin contains skills.
   - Add `references/` for conditional, durable details; add `scripts/` only for repeatable deterministic work.
   - Add apps, MCP servers, external state, or UI assets only when they are requested and can be implemented safely.
4. Scaffold the plugin with the repository's plugin workflow when available. Keep the directory name and manifest `name` identical, lowercase, hyphenated, and under 64 characters.
5. Create or migrate each skill as a focused bundle with `SKILL.md`; add `agents/openai.yaml` when local conventions use it. Keep frontmatter limited to `name` and `description`.
6. Update the repository marketplace only when the user wants the plugin installable there. Preserve marketplace identity and ordering; append a complete entry with `source`, `policy.installation`, `policy.authentication`, and `category`.
7. Validate manifest JSON, skill frontmatter, resource paths, marketplace paths, and any native agent TOML. Run repository validators when available.

## Safety and State

- Do not embed tokens, OAuth secrets, passwords, private keys, or user-specific credentials in the plugin.
- Do not treat a plugin archive or `references/` files as mutable shared workflow state.
- Prefer conversation state for ephemeral reasoning, repository files for project-local artifacts, and an authenticated application/source system for cross-session or multi-user state.
- Define read/write boundaries before adding tools. External writes, deployments, sends, mutations, or destructive commands require explicit user authorization and a confirmation step.
- Do not add broad network access, package installs, MCP servers, apps, or persistent services merely because a mature plugin could support them.

## Resource Routing

- Use `$new-skill` for every new or materially revised skill.
- Use `$new-agent` when the plugin needs a native Codex custom agent to consume its skills.
- Use `$orchestrate` when the work needs scoped subagents or multi-stage implementation.
- Read `references/plugin-architecture.md` before adding MCP servers, apps, persistent state, or external write actions.

## Validation

Before completion, confirm:

- manifest name matches the plugin directory and contains no placeholders;
- every skill has valid frontmatter, a focused trigger boundary, and existing referenced resources;
- no secrets or unsafe external-write defaults appear in the bundle;
- marketplace entries use `./plugins/<plugin-name>` relative paths and preserve existing entries;
- migrated sources no longer remain as duplicate runnable skills outside the plugin;
- JSON, TOML, and YAML files parse; and
- any available plugin validator completes successfully.

## Output

Report the plugin path, included or migrated skills, marketplace/config changes, validation actually performed, and remaining limitations. Do not claim installation, external integration, authorization, or runtime support that was not verified.
