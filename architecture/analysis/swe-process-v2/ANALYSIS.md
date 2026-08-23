---
artifact_type: software_architecture_analysis
analysis_status: Complete
scope_kind: workflow
scope_name: SWE Process v2 instruction system
scope_path: plugins/swe-process
strategies:
  - swa-boundary
  - swa-interface
  - swa-scenario
generated_at: 2026-08-22T20:55:18-04:00
---

# Architecture Analysis: SWE Process v2 Instruction System

## Executive Architectural Review

The new SWE Plugin has a sound conceptual core. Its portfolio and solution governance, 13 process skills, artifact contract, agent roles, templates, and scaffold copier form a recognizable end-to-end engineering method rather than a set of disconnected prompts. The skills provide materially more professional guidance than “fill in this template”: they define authority, eligibility, evidence standards, architecture concerns, failure and security considerations, approval independence, lifecycle rules, and stop conditions. The architecture templates also enforce useful abstraction boundaries and require meaningful views rather than decorative diagrams.

The system is not yet fully coherent at its runtime and role seams. The highest-risk issues are: current Codex configuration uses an undocumented legacy feature key; canonical lifecycle values are contradicted by lowercase skill instructions; implementers are allocated the formally independent validation skill; architecture reviewers are allocated a Feature-validation workflow that does not implement architecture review; and the portfolio integration role is allocated solution-owned Design and Implementation procedures. These defects can lead a capable agent to follow each local instruction correctly while violating the global process.

Overall assessment: **architecturally promising and structurally well validated, but not ready to claim end-to-end governed execution until the priority 1 seams are repaired and exercised through representative workflow scenarios.**

## Scope and Existing Evidence

The target is the distributable SWE Process v2 instruction system and its supporting runtime configuration:

- Repository governance: `AGENTS.md`, `README.md`.
- Context chain: `scaffolds/portfolio/CONTEXT-MAP.md` and all three linked files under `scaffolds/portfolio/.swe/context/`.
- Process contract and workflows: `plugins/swe-process/references/ARTIFACT-CONTRACT.md`, all 13 `plugins/swe-process/skills/*/SKILL.md` files, their `agents/openai.yaml` files, and all 18 canonical templates.
- Generated governance and roles: both scaffold `AGENTS.md` files, both scaffold `.codex/config.toml` files, 8 portfolio agent TOMLs, and 17 solution agent TOMLs.
- Authoring runtime: root `.codex/config.toml` and registered agent paths.
- Supporting package boundaries: all four plugin manifests and the SWA analysis contract.
- Validation: `Test-SweProcess.ps1`, `Test-SwaAnalyze.ps1`, manifest/path/link checks, source/reference scaffold parity, and current official OpenAI documentation for Codex configuration, custom agents, and skills.

The analysis does not assess the quality of generated artifacts from a real Epic, because no full representative workflow was executed. It does not test external MCP servers, Azure actions, browser behavior, or cross-repository writes. The Codex strict-config command was attempted in the root and both scaffolds, including an approved out-of-sandbox retry, but the packaged Windows executable failed to start with `Access is denied`.

## Current Architectural Reading

The context map correctly prevents three category errors:

- Work is `Epic -> Feature -> Implementation Plan`, not software decomposition.
- Structure is `Platform -> Solution -> Package -> Module`; a System is a runtime view, not a fifth level.
- Engineering knowledge progresses from Research and Concept through Architecture, Design, Evidence, and Validation.

That separation is consistently reflected in the two scaffold governance files. The portfolio flow is explicitly documented at `scaffolds/portfolio/AGENTS.md:77`; the solution handoff is explicit at `scaffolds/solution/AGENTS.md:81`; and the README maps every named phase to one of the 13 process skills at `README.md:23-44`. Portfolio and solution ownership is generally clear, dual upstream locators are consistently required, accepted Feature criteria are carried through Plan, Design, Evidence, and Validation, and the approval model consistently prohibits self-approval and inferred force.

The skill layer is concise because detailed output structure is progressively disclosed into references. It is nevertheless professionally substantive. Examples include the bugfix eligibility gate and evidence-backed root cause at `plugins/swe-process/skills/swe-bugfix/SKILL.md:12-23`, bounded uncertainty in research at `plugins/swe-process/skills/swe-research/SKILL.md:10-17`, and Design coverage of interfaces, failure handling, security, migration, observability, tests, and rollout at `plugins/swe-process/skills/swe-design/SKILL.md:13-20`. The platform architect role adds responsibilities, interfaces, data flow, failure modes, security, operability, and migration consequences at `scaffolds/portfolio/.codex/agents/swe/platform-architect.toml:41-47`. This is substantially more than template selection.

The weak point is not the amount of guidance. It is contract compatibility between layers. Several agent allocations invoke skills whose stated authority or output does not match the role, and the structural validator does not test these semantic interfaces.

## Strategy Findings

### Boundary critique

**Strong boundary design.** Portfolio versus solution authority is explicit, repeated, and backed by separate scaffolds. The Concept/Architecture distinction, Feature/Module distinction, Evidence/Validation distinction, and System-view rule are unusually clear. The no-copy portfolio handoff and dual-locator convention are strong safeguards against competing sources of truth.

**Portfolio integration ownership leaks into solution delivery.** Portfolio governance says child repositories own `DESIGN.md`, source, tests, Evidence, and local Validation and prohibits silently mutating a child repository (`scaffolds/portfolio/AGENTS.md:24`). The portfolio `integration-engineer`, however, is allocated `$swe-design` and `$swe-implement` (`scaffolds/portfolio/.codex/agents/swe/integration-engineer.toml:12-14`). Its prose explains integration evidence but does not constrain those write-capable procedures to an explicitly targeted child repository under that child's governance. The combined instruction stack therefore gives two incompatible defaults.

**Epic and Feature criteria share an identifier vocabulary that the contract reserves for Features.** The artifact contract defines `AC-001` as a Feature-local acceptance criterion (`plugins/swe-process/references/ARTIFACT-CONTRACT.md:10-11`), but the Epic template also creates `AC-001` under “Acceptance Outcomes” (`plugins/swe-process/skills/swe-new-epic/references/EPIC-TEMPLATE.md:53-55`). Downstream artifacts preserve exact Feature `AC-NNN` IDs, so identical Epic and Feature tokens invite incorrect traceability even when paths disambiguate them.

**Fast paths collapse authoring, evidence, validation, and closure into one record without a clear authority boundary.** The contract defines `Active -> Implemented -> Validated -> Closed`, while bugfix and enhancement skills require independent validation only when risk warrants it. Their templates contain a verification table but no validator identity, validation decision, approval record, or transition evidence. An implementer can therefore plausibly advance the same artifact through `Validated` and `Closed` without a durable independence test.

### Interface analysis

**The current Codex feature-flag interface is stale.** Root, portfolio, and solution configs use `features.multi_agent_v2` (`.codex/config.toml:56`, `scaffolds/portfolio/.codex/config.toml:41`, and `scaffolds/solution/.codex/config.toml:77`). Current official OpenAI configuration documentation defines `features.multi_agent` and `agents.enabled`; it does not define `multi_agent_v2`. The root config also places `suppress_unstable_features_warning` inside `[features]` at `.codex/config.toml:53-56`, while the current configuration reference defines it as a top-level key. Static repository validation does not detect either issue. Because strict runtime parsing could not be executed, rejection versus silent ignore is unresolved, but the configuration is not aligned with the documented current schema. See [OpenAI configuration reference](https://developers.openai.com/codex/config-reference) and [OpenAI subagent configuration](https://learn.chatgpt.com/docs/agent-configuration/subagents).

**Lifecycle tokens conflict across the contract and skills.** The artifact contract and templates require `Target`, `Implemented`, and `Current` (`plugins/swe-process/references/ARTIFACT-CONTRACT.md:24`). `$swe-architect` tells the agent to set `target` and promote to `implemented` and `current` (`plugins/swe-process/skills/swe-architect/SKILL.md:33-41`); `$swe-validate` repeats the lowercase values (`plugins/swe-process/skills/swe-validate/SKILL.md:18-19`). Since the validator enforces PascalCase template initial states but not instructional prose, generated or updated artifacts can be invalid even when every checked source file passes.

**Formal validation independence is contradicted by agent allocations.** `$swe-validate` is explicitly an independent validation workflow and prohibits the author/implementer from self-approval. Yet all nine solution implementation specialists—solution, package, module, Azure, Azure database, C#, full-stack, MAF, and UI—are allocated `$swe-validate`; the solution integration engineer is allocated both `$swe-implement` and `$swe-validate`. The role prose often means “run implementation checks,” but the allocated skill means “write the formal `VALIDATION.md` and conclude accepted/rejected/blocked.” Self-checks and formal validation are two different interfaces and need different names and owners.

**Architecture review is routed through a Feature-validation skill.** Both architecture-reviewer agents allocate `$swe-validate` as their only SWE process procedure (`scaffolds/portfolio/.codex/agents/swe/architecture-reviewer.toml:10-13` and `scaffolds/solution/.codex/agents/swe/architecture-reviewer.toml:10-14`). The role prose itself contains a credible architecture review method, but `$swe-validate` resolves a Feature, Implementation Plan, Design, Evidence, acceptance-criterion matrix, and `VALIDATION.md`. It does not define how to review a Target architecture or update its Approval Record. The allocation is therefore misleading even though the TOML instructions partially compensate for it.

**The automated contract covers shape, not semantic interoperability.** `Test-SweProcess.ps1` verifies exact rosters, required fields, template headers, initial statuses, traceability maps, diagram presence, registered paths, context layout, scaffold parity, and additive copier behavior. It does not parse TOML/YAML with a runtime parser, verify current Codex keys, compare role allocations with skill authority, assert phase preconditions, verify review independence, or detect conflicting lifecycle prose. Its passing message must be interpreted as structural validation, not end-to-end process proof.

### Scenario stress analysis

**Normal human-approved Feature flow:** The documented sequence is understandable and likely executable. Each phase has a focused skill, authoritative location, expected output, approval rule, and next-handoff summary. This scenario is the strongest part of the design.

**Auto-approved architecture change:** The author/reviewer separation and two-cycle cap are clear, but the architecture reviewer is pointed at the wrong workflow contract. An agent may create a Feature `VALIDATION.md`, attempt to resolve nonexistent implementation evidence, or improvise an undocumented review mutation. This scenario is not deterministic enough yet.

**Developer implements and “validates” a local slice:** A specialist can correctly follow its allocated `$swe-implement` and `$swe-validate` skills while becoming both implementer and formal validator. The skill's prohibition should stop self-approval, but the role allocation encourages entry into a workflow the role cannot complete independently. The likely outcomes are unnecessary blocking, fabricated independence, or inconsistent Validation authorship.

**Cross-solution integration from a portfolio repository:** The handoff and contract model are strong, but the portfolio integration role can select Design and Implementation workflows that write solution-owned artifacts. Without an explicit repository target and child governance preflight, the role can cross an authority boundary.

**Fast-path externally visible defect:** The bugfix skill correctly requires independent validation, but the single `BUGFIX.md` template does not establish who validates, what decision closes the record, or how validation evidence differs from implementer verification. The lifecycle can be advanced without an auditable handoff.

**Fresh Codex installation:** Current official documentation uses `features.multi_agent`, while the scaffolds emit `multi_agent_v2`. A strict client may reject the config or a permissive client may ignore the setting. Multi-agent is currently enabled by default, which can hide the stale key during casual testing and make the defect reappear when defaults change.

## Detailed Recommendations

| Priority | Recommendation | Architectural rationale | Affected authority/artifacts | Expected effect | Trade-offs and validation |
| --- | --- | --- | --- | --- | --- |
| 1 | Align every Codex config with the current documented schema: replace or remove `multi_agent_v2`, keep `shell_tool` under `[features]`, and move the root warning-suppression key to top level. | Runtime configuration is the entry interface for every agent; stale keys can invalidate or silently weaken all higher-level governance. | Root and both scaffold `.codex/config.toml` files; copied scaffold references; validator. | Current, portable agent registration and explicit feature behavior. | Re-run a working current Codex strict parser in all three roots and add a schema-aware regression check. Multi-agent is on by default, so omitting the key may be simpler. |
| 1 | Make lifecycle tokens exact and single-sourced. Replace lowercase status values in `$swe-architect` and `$swe-validate` with the contract's PascalCase values and have the validator scan active prose for illegal lifecycle tokens. | Human-readable instructions currently contradict the machine-checked templates. | Artifact contract, architect and validate skills, validator. | Deterministic state transitions and valid generated headers. | Avoid a blind case-rewrite of ordinary prose; validate tokens only in status/transition contexts. |
| 1 | Separate implementer verification from formal independent validation. Remove `$swe-validate` from implementation-specialist defaults, retain repository-native checks under `$swe-implement`, and add or explicitly designate an independent solution validator for formal `VALIDATION.md`. | Evidence production and independent judgment are different responsibilities in the Engineering context. | Solution agent TOMLs, solution roster/config, `$swe-implement`, `$swe-validate`, scaffold references. | Preserved independence, clearer routing, fewer blocked or self-validating runs. | Adds one role or broadens an existing independent role; test same-agent and independent-agent scenarios under human and auto modes. |
| 1 | Give architecture review its own explicit procedure, either as a focused skill/reference or a formally specified contribution mode of `$swe-architect`; do not label `$swe-validate` as architecture review. | A Feature-validation contract cannot safely stand in for architecture approval. | Both architecture-reviewer TOMLs, approval workflow, possibly a new review template/reference. | Deterministic Target review, Approval Record updates, conflict disclosure, and repair-cycle handling. | A new public skill increases roster size; a skill-local review reference or mode can preserve the 13-skill roster. |
| 2 | Remove `$swe-design` and `$swe-implement` from the portfolio integration role, or require an explicit child repository target plus child `AGENTS.md` preflight before those skills may run. | The portfolio should verify cross-solution behavior without taking silent ownership of child Design/code/Evidence. | Portfolio integration-engineer TOML and portfolio governance. | Cleaner repository authority and safer cross-repository collaboration. | Explicit child execution is still useful; model it as a handoff or targeted child-agent run, not a portfolio default. |
| 2 | Give Epic outcomes a distinct stable identifier such as `EO-001`, reserving `AC-NNN` for Feature-local acceptance criteria as the contract already states. | The Work context distinguishes Epic outcomes from Feature acceptance; identifiers should preserve that semantic distinction. | Epic template, new-Epic skill, artifact contract, validator, migration guidance for existing Epics. | Unambiguous traceability and safer cross-Epic reporting. | Existing Epic artifacts may require compatibility handling; do not renumber accepted Feature criteria. |
| 2 | Add a durable fast-path validation/closure record inside BUGFIX and ENHANCEMENT, including validator, independence, decision, evidence, and transition timestamps; define exactly when independent review is optional versus mandatory. | `Validated` and `Closed` are decision transitions, not synonyms for implementer test success. | Fast-path skills/templates and artifact contract. | Auditable closure without forcing every local fix into the full Feature flow. | Keep the fast path compact; one table is preferable to a separate artifact unless risk requires full Validation. |
| 2 | Extend `Test-SweProcess.ps1` with semantic fixtures: current config keys, skill-allocation existence and authority, lifecycle token case, no implementer-as-formal-validator, reviewer workflow compatibility, and phase precondition scenarios. | Current validation proves structure but misses the defects found in this audit. | Process validator and test fixtures. | Prevents cross-layer regressions while preserving fast local checks. | Avoid pretending static fixtures prove live agent behavior; retain a separate bounded end-to-end scenario matrix. |
| 3 | Add one concise phase-transition and role-ownership matrix to scaffold governance or a shared process reference. Include entry status, producing skill, author role, approver/validator role, output, and next legal states. | The process is understandable after reading several files, but a new agent must currently synthesize the state machine itself. | Both scaffold AGENTS files or one shared generated reference. | Faster correct routing without adding a new lifecycle phase or duplicating templates. | Generate or validate the matrix from the same contract to avoid a second source of truth. |

## Sequencing and Decision Handoffs

1. **Codex runtime owner:** repair config keys and obtain strict-config proof on the root, portfolio scaffold, and solution scaffold.
2. **Process architect:** normalize lifecycle tokens and decide the formal solution-validation owner. This decision precedes agent roster changes.
3. **Process architect plus agent author:** repair architecture-reviewer and portfolio-integration allocations without weakening portfolio/solution boundaries.
4. **Artifact-contract owner:** separate Epic outcome IDs and define fast-path validation/closure semantics. Record compatibility guidance for existing artifacts.
5. **Validator owner:** encode the semantic invariants and add scenario fixtures.
6. **Independent reviewer:** execute at least four dry workflow scenarios: human-approved main flow, auto-approved architecture flow, local implementation plus independent validation, and cross-solution integration handoff. Use generated temporary repositories and assert files, statuses, authors/approvers, locators, and no unauthorized writes.

No recommendation changes an authoritative artifact until the normal architecture and approval workflow accepts it.

## Risks, Assumptions, and Open Questions

- It is unresolved whether the current packaged Codex client rejects `multi_agent_v2` under strict mode or merely ignores it; the executable could not be launched in this environment. The official schema mismatch is confirmed.
- The intended formal validator for a solution-local change is not explicit. Is `architecture-reviewer` meant to validate delivered behavior, or should the solution scaffold have a dedicated `feature-validator`/`solution-validator`?
- Is the portfolio `integration-engineer` intended to work only in the portfolio repository, or to be spawned with explicit write authority inside named child worktrees? The current contract permits both interpretations.
- Are fast-path `Validated` and `Closed` transitions intended to require independent review only above a risk threshold? If so, the threshold and decision record are not defined.
- Existing generated repositories may already contain lowercase architecture statuses, legacy config keys, or Epic `AC-NNN` outcomes. Migration must preserve accepted Feature criterion IDs and avoid overwriting scaffolded user files.
- The process validator and SWA validator passed, but no complete Epic-to-acceptance agent run was performed. Structural success must not be promoted into a behavioral claim.

## Evidence and Coverage

- Codebase Memory project: `swe-plugin`; observed graph size 1,306 nodes and 1,206 edges. Coverage is primarily TOML/YAML sections and variables, so Markdown, PowerShell, templates, and exact configuration values were read directly.
- `powershell -NoProfile -ExecutionPolicy Bypass -File .\plugins\swe-process\scripts\Test-SweProcess.ps1`: passed; reported 13 skills, 18 templates, diagram contracts, scaffold behavior, agent registries, and source/reference parity.
- `powershell -NoProfile -ExecutionPolicy Bypass -File .\plugins\swa-analyze\scripts\Test-SwaAnalyze.ps1`: passed.
- All four plugin manifests parsed as JSON and reported version `2.0.1`, publisher `Ghostworx.ai, LLC`, existing skill paths, and existing assets.
- All skill allocations referenced project skill folders; all checked non-template relative Markdown links resolved; root and scaffold registered agent paths existed.
- Codex strict-config validation: blocked by Windows `Access is denied` for the packaged executable in all three roots, including an approved elevated retry.
- Official runtime checks used [OpenAI configuration reference](https://developers.openai.com/codex/config-reference), [OpenAI subagent configuration](https://learn.chatgpt.com/docs/agent-configuration/subagents), and [OpenAI skill authoring guidance](https://developers.openai.com/codex/skills). The official docs confirm custom-agent required fields and supported override fields, progressive skill disclosure, `features.multi_agent`, `agents.enabled`, `features.shell_tool`, and top-level `suppress_unstable_features_warning`.
- No external MCP connection, live child repository, Azure environment, browser, or full generated workflow was exercised.

## Write Record

Created this advisory report only. No analyzed code or authoritative artifact was modified.
