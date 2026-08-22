# Agent Authoring Reference

Use the current Codex custom-agent schema and the destination repository's local conventions. Do not assume this source repository's registry or folder layout exists in the destination.

## Official Sources

- https://developers.openai.com/codex/subagents
- https://developers.openai.com/codex/config-basic
- https://developers.openai.com/codex/config-reference
- https://developers.openai.com/codex/skills

## Repository Pattern Discovery

- Prefer a user-specified target path.
- Otherwise inspect the destination repository's `.codex/agents/` and `.codex/config.toml` narrowly.
- Preserve established subfolders when they exist; do not invent a collection name.
- A standalone `.codex/agents/<agent-name>.toml` file is sufficient unless the destination config or instructions require registry wiring.

## Standard Custom-Agent Schema

The Codex docs require every standalone custom agent file to define:

- `name`
- `description`
- `developer_instructions`

Optional fields include:

- `nickname_candidates`
- `model`
- `model_reasoning_effort`
- `sandbox_mode`
- `mcp_servers`
- `skills.config`

The `name` field is the source of truth. Match the filename to the name when practical, but do not treat the filename as authoritative.

## Canonical Field Order

Use this order unless a local sample in the same folder clearly diverges:

1. `name`
2. `description`
3. `nickname_candidates` if needed
4. `model`
5. `model_reasoning_effort`
6. `sandbox_mode`
7. `developer_instructions`
8. `mcp_servers` if needed
9. `skills.config` if needed

## Canonical TOML Template

```toml
name = "agent-name"
description = "Use this agent for ..."
nickname_candidates = ["Display Name", "Alt Name"] # optional
developer_instructions = """
You are a focused <role> agent for Codex subagent workflows.

Primary responsibilities:
- <objective>
- <objective>

Operating rules:
- <rule>
- <rule>

Non-goals:
- <boundary>
- <boundary>

Output expectations:
- <expected result>
- <expected result>
"""

# Optional agent-local MCP servers only when they materially help this agent.
[mcp_servers.microsoft_learn]
url = "https://learn.microsoft.com/api/mcp"

# Optional skills dependencies only when this agent truly needs them.
[[skills.config]]
path = ".agents/skills/repository-review/SKILL.md"
enabled = true
```

## Optional Registry Entry Template

When the destination repository registers agents in `.codex/config.toml`, add a matching entry using a path relative to that `.codex/` directory:

```toml
[agents.my_agent]
description = "Use this agent for ..."
config_file = "agents/swe/my-agent.toml"
```

Use the actual destination subfolder in `config_file`. Update a nearby `AGENTS.override.md` only when that destination already uses one for agent routing.

## MCP Server Rules

Start with the smallest working set.

- Discover exact server names and configuration from the destination repository or current runtime; do not invent a familiar-looking name.
- Use an agent-local server only for a capability the role actually requires, such as current documentation, repository discovery, browser validation, or a bounded external system.
- Preserve an active shared server instead of duplicating it into the agent file.

Decision rules:

- Prefer one server at a time unless two are clearly complementary.
- Keep agent-local MCP wiring local when the server is only useful to one agent.
- Mirror a server into `.codex/config.toml` when the repo should expose it as a shared capability.
- Do not add a new server block just to make the file look more complete.

## Field Guidance

- Keep `description` concise, triggerable, and specific enough for implicit invocation.
- Keep `developer_instructions` imperative and structured by role, objectives, boundaries, tool use, and output expectations.
- Use `nickname_candidates` only when multiple spawned instances need distinct readable labels.
- Omit `model` and `model_reasoning_effort` to inherit the active parent or repository defaults. When an override is intentional, verify the exact model ID and supported effort against the current runtime or official documentation before writing it.
- Omit `sandbox_mode` to inherit permissions. Use `read-only` for an intentionally stricter agent; grant a write-capable override only when the task, user authorization, and destination repository require it.

## Validation Checklist

- The TOML parses cleanly.
- `name`, filename, and root registry key all correspond.
- The root registry points at the correct file path.
- Shared MCP servers are registered where the repo expects them.
- Agent-local MCP servers are justified and minimal.
- `skills.config` entries point at real skill paths.
- Collection-specific agents update a nearby `AGENTS.override.md` only when that convention already exists.

## Reference Links

- https://developers.openai.com/codex/subagents
- https://developers.openai.com/codex/config-basic
- https://developers.openai.com/codex/config-reference
- https://developers.openai.com/codex/skills
