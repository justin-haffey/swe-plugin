# Shared Bridge Transport

This is the single transport procedure used by internal `$swe-bridge` and the explicit utility `$bridge` compatibility entry point. Each caller retains its own invocation, destination and lifecycle gates; reading this procedure grants none of them.

## Capability and destination preflight

1. Resolve exact canonical repository/checkout identity, authorized write scope, applicable governance, current dirty state and parent permissions before selecting transport.
2. Discover callable host capabilities, qualified project-scoped agents, result retrieval and the ability to enforce exact working directory/scope. Do not infer callability from an interactive command or TOML file alone.
3. Prefer a bounded project-scoped subagent in the current task for authorized work. Reuse an existing explicitly created child task when its scope and state fit. Create a new user-visible task only when the user or active host instructions authorize it. Fork only when inherited context is necessary and destination can be independently verified; completed transcript inheritance may omit the active turn.
4. A new worktree, branch or integration operation needs its own applicable authority. A transport does not broaden filesystem/runtime/network/Git permissions. If no supported route can honor exact destination, scope and retrieval, return Blocked before dispatch.

## Dispatch and collection

Render the caller's complete compact assignment packet before dispatch. Include identity, relevant governing locators/revisions, scope, selected phase, dependencies, permissions, dirty/concurrency facts and expected results; include no credentials or irrelevant transcript. Send the packet as the child's explicit task instruction regardless of transport.

Capture the actual returned handle, selected transport and message-delivery result. Never invent an identifier. If creation or delivery is ambiguous, inspect the captured operation once; do not repeat a mutation without proven safe idempotency. Record a concrete blocker when ambiguity remains.

Use supported bounded waits for required results, respecting host limits and avoiding rapid polling. Retry a replay-safe transient retrieval failure once with a changed strategy. A timeout is pending execution, not delivery or approval; keep the exact handle and remaining obligations for continuation. Do not create another worker for already dispatched uncertain work.

One coordinating owner controls each checkout. Parallel writers need disjoint ownership; serialize overlap. A shared build-output/dependency closure has one active builder through checks, even across repository boundaries, unless supported output isolation is proven. Release with the actual generation/check receipt.

Inspect the result's exact repository/checkout, changed files and artifact/receipt locators. Verify intended-delivery-checkout integration and relevant generation correspondence before reusing checks. Claimed success without durable evidence is unverified. Preserve caller-specific progress and approval semantics; transport completion never establishes governed acceptance.

## Recovery and safety

Store ordinary routing in memory. Only when required by a caller's recovery contract may a disposable fingerprinted continuation view preserve otherwise unavailable handles and verified receipt locators. Recheck current artifacts, dirty state and live workers/processes before resume; it cannot authorize work or reset review cycles.

Children inherit all repository, sandbox, approval, network, deployment, publishing, dependency, credential, destructive and Git boundaries. All agent-directed checks use `$swe-test` and the effective Luna/medium `test-runner`; authors fix failures, independent validators assess acceptance. Return capability failure, captured handle/delivery state and the ready packet when blocked. Never claim dispatch, timeout or an unverified narrative as completion.
