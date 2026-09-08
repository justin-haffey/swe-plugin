# Skill validation and forward testing

The author defines these obligations and owns repairs. Route executable checks through `$swe-test` to `test-runner` on `gpt-5.6-luna` / `medium`; independent review owns adequacy and acceptance.

Before finalizing:

1. Check the folder basename matches `name`.
2. Check frontmatter parses as YAML.
3. Check frontmatter contains `name` and `description`.
4. Check no scaffold TODO text remains.
5. Check all referenced resources exist.
6. Check scripts are executable or have clear invocation commands.
7. Run any added scripts' representative tests.
8. Run the Codex skill validator when available.

Validator guidance:

- Prefer the system `skill-creator` validator already available in the environment.
- Do not hard-code machine-specific validator paths in the skill.
- If a validator path is unknown, locate it from the available `$skill-creator` skill or use a local equivalent.
- If validation cannot be run, state that clearly and report the manual checks performed.

### 12. Forward-Test Complex Skills

Forward-test when the skill is complex, high-impact, tool-heavy, or likely to be reused often.

Use a fresh subagent or fresh task if available. The test prompt should look like a real user request:

```text
Use $skill-name at <path> to solve: <realistic task>.
```

Do not leak the intended answer. Review whether the agent:

- triggered the skill for the right reason;
- followed resource routing;
- respected safety boundaries;
- produced the requested output;
- avoided unnecessary files, tools, or broad scans.

Patch the skill if the forward-test exposes friction.

