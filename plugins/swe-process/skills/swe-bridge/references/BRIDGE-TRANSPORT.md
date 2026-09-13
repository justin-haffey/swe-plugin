# Shared Bridge Transport

This is the single transport procedure used by internal `$swe-bridge` and the explicit utility `$bridge` compatibility entry point. Each caller retains its own invocation, destination and lifecycle gates; reading this procedure grants none of them.

## Capability and destination preflight

1. Resolve exact canonical repository/checkout identity, authorized write scope, applicable governance, current dirty state and parent permissions before selecting transport.
2. Discover callable host capabilities that can start or select an execution context whose registered project/workspace root is the exact child repository, send the packet, return a real handle and retrieve results. Verify the selected project identity and its root before dispatch; a matching path in the prompt, tool `workdir`, Git checkout or Codebase Memory project selection alone does not establish child project context. Do not infer callability from an interactive command or TOML file alone.
3. Prefer an authorized separate child-project task: reuse an existing child-project task only when its registered project root, scope and state fit, otherwise start a new task in that child project when user or active host authority permits. Do not use a subagent attached to the parent task as bridge transport, even if it sets the child path as its working directory. A fork is eligible only if the host can retarget or create it in the child project before the first child instruction; inherited history is optional because the packet is self-contained. A parent-project `/fork` with only a changed working directory is ineligible.
4. A new worktree, branch or integration operation needs its own applicable authority. A transport does not broaden filesystem/runtime/network/Git permissions. If no authorized route can establish and verify child project context, exact destination, scope and retrieval, return Blocked before dispatch with the ready packet.

## Dispatch and collection

Render the caller's complete compact assignment packet before dispatch. Include identity, relevant governing locators/revisions, scope, selected phase, dependencies, permissions, dirty/concurrency facts and expected results; include no credentials or irrelevant transcript. Send the packet as the child's explicit task instruction regardless of transport.

Capture the actual returned handle, selected child project identity/root, transport and message-delivery result. Before child work, have the child confirm its active project/workspace root and canonical Git root are the exact repository; stop on mismatch. Never invent an identifier. If creation or delivery is ambiguous, inspect the captured operation once; do not repeat a mutation without proven safe idempotency. Record a concrete blocker when ambiguity remains.

Use supported bounded waits for required results, respecting host limits and avoiding rapid polling. Retry a replay-safe transient retrieval failure once with a changed strategy. A timeout is pending execution, not delivery or approval; keep the exact handle and remaining obligations for continuation. Do not create another worker for already dispatched uncertain work.

One coordinating owner controls each checkout. Parallel writers need disjoint ownership; serialize overlap. A shared build-output/dependency closure has one active builder through checks, even across repository boundaries, unless supported output isolation is proven. Release with the actual generation/check receipt.

Inspect the result's exact repository/checkout, changed files and artifact/receipt locators. Verify intended-delivery-checkout integration and relevant generation correspondence before reusing checks. Claimed success without durable evidence is unverified. Preserve caller-specific progress and approval semantics; transport completion never establishes governed acceptance.

## Recovery and safety

Store ordinary routing in memory. Only when required by a caller's recovery contract may a disposable fingerprinted continuation view preserve otherwise unavailable handles and verified receipt locators. Recheck current artifacts, dirty state and live workers/processes before resume; it cannot authorize work or reset review cycles.

Children inherit all repository, sandbox, approval, network, deployment, publishing, dependency, credential, destructive and Git boundaries. All agent-directed checks use `$swe-test` and the effective Luna/medium `test-runner`; authors fix failures, independent validators assess acceptance. Return capability failure, captured handle/delivery state and the ready packet when blocked. Never claim dispatch, timeout or an unverified narrative as completion.
