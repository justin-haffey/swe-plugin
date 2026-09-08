---
name: swe-test
description: Execute scoped tests, verification builds, static checks, and browser validation through the Luna test-runner. Use for a Feature, Design, Epic verification batch, or named local change. Does not repair code or approve delivery.
---
# Test

Resolve the exact checkout, authorized scope, criteria, risk, prerequisites, and timing from repository policy and accepted artifacts. Ordinary users supply a scope, not a manifest. Discover existing native commands; confirm affected consumers when graph coverage is incomplete. Follow [TEST-RULES.md](references/TEST-RULES.md) for requests, receipts, and failure handling.

Dispatch a bounded request to `test-runner` using `gpt-5.6-luna`, `medium`, and `execution_role: test-runner`. Verify effective host capability; unavailable routing is Blocked. When already that selected execution role, execute directly without spawning another tester. Reuse its session for related batches; independent validators control a fresh invocation.

Run the smallest command union covering required behavior and dependencies. Respect early risk gates and shared-output ownership. Capture source, tests, configuration, fixtures, runtime, and actual dependency identities before and after execution, exact commands, exits, observations, and immutable logs/receipts using the [receipt helper](../../scripts/Invoke-SweChecks.ps1).

Never edit source, tests, configuration, assertions, or snapshots; run fix/update modes; waive checks; or grant acceptance. Writes are limited to authorized command-generated scratch, receipts, and logs. Return failures to the developer. Permit one recorded retry only for a replay-safe transient launch failure. Preserve earlier attempts.

Report Passed, Failed, or Blocked, stale evidence, missing coverage, pending obligations, and receipt/log locators. A green command cannot establish unrealized conformance cases. After repairs rerun affected checks; otherwise stop when required checks pass unless new changes or unresolved evidence justify more work. Independent Validation retains acceptance authority.
