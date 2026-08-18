
Yes. The architecture makes sense, with one important adjustment:

**Use Agent Framework’s context-provider mechanism for the World Model, not `ChatHistoryMemoryProvider` itself.**

Your conceptual stack is excellent, but I would implement it as a **Context Stack** rather than making all four layers chat history.

```text
┌───────────────────────────────────────────────┐
│ 4. DIALOG                                     │
│    Mutable / append-only / short-term         │
│    ChatHistoryProvider                        │
├───────────────────────────────────────────────┤
│ 3. WORLD MODEL                                │
│    Mutable / canonical / structured           │
│    WorldModelContextProvider                  │
├───────────────────────────────────────────────┤
│ 2. BOOT CONTEXT                               │
│    Immutable / environment & identity         │
│    BootContextProvider                        │
├───────────────────────────────────────────────┤
│ 1. SYSTEM INSTRUCTIONS                        │
│    Immutable / behavioral authority           │
│    Agent Instructions                         │
└───────────────────────────────────────────────┘
```

That maps almost perfectly onto the current Agent Framework pipeline. `ChatHistoryProvider` loads conversation history first; then `AIContextProvider`s can inject messages, tools, instructions, or state before the model invocation. Both history and context providers then receive the results after the invocation. ([Microsoft Learn][1])

## Why I would **not** use `ChatHistoryMemoryProvider` for the World Model

There are actually two similarly named concepts worth separating.

`ChatHistoryProvider` is the **canonical conversational history mechanism**. It exposes `ProvideChatHistoryAsync()` and `StoreChatHistoryAsync()`, so a custom implementation could theoretically construct any history stack you want. ([Microsoft Learn][2])

`ChatHistoryMemoryProvider`, however, is specifically a **semantic-memory context provider**. It takes chat messages, embeds them into a vector store, then retrieves semantically similar historical messages later. ([Microsoft Learn][3])

That second behavior is wrong for a World Model.

A World Model should answer:

> **What does the agent currently believe the world looks like?**

Semantic chat memory answers:

> **What things from previous conversations resemble what we're talking about now?**

Those are fundamentally different abstractions.

For example, imagine this evolution:

```text
Turn 12:
Server = 192.168.50.15

Turn 47:
Server moved to 192.168.50.25
```

Semantic memory can retrieve **both statements**.

A World Model should contain:

```text
Server.Address = 192.168.50.25
```

possibly with provenance:

```text
PreviousValue = 192.168.50.15
ChangedAt = Turn 47
Evidence = UserStatement
Confidence = 1.0
```

That is **state reduction**, not retrieval.

---

# I would make `WorldModelContextProvider` a first-class component

This is almost exactly what `AIContextProvider` is designed to support. Microsoft explicitly describes custom context providers as appropriate when you need to inject dynamic instructions/messages/tools **and extract state after runs**. It also gives providers access to `AgentSession` and `ProviderSessionState<T>` for typed state. ([Microsoft Learn][4])

Conceptually:

```csharp
public sealed class WorldModelContextProvider : AIContextProvider
{
    private readonly IWorldModelStore _store;
    private readonly IWorldModelReducer _reducer;

    protected override async ValueTask<AIContext> ProvideAIContextAsync(
        InvokingContext context,
        CancellationToken cancellationToken)
    {
        var world = await _store.GetAsync(
            context.Session,
            cancellationToken);

        return new AIContext
        {
            Instructions = BuildWorldModelContext(world)
        };
    }

    protected override async ValueTask StoreAIContextAsync(
        InvokedContext context,
        CancellationToken cancellationToken)
    {
        var current = await _store.GetAsync(
            context.Session,
            cancellationToken);

        var delta = await _reducer.DetermineChangesAsync(
            current,
            context.RequestMessages,
            context.ResponseMessages,
            cancellationToken);

        await _store.ApplyAsync(
            current.Version,
            delta,
            cancellationToken);
    }
}
```

I wouldn't necessarily put the entire implementation in `AgentSession.StateBag`, though. Agent Framework explicitly supports typed provider-specific state there, but for a substantial World Model I'd store an **ID/version/reference in `StateBag` and the actual model in an external durable store**. ([Microsoft Learn][5])

Something like:

```text
AgentSession
│
├─ SessionId
├─ StateBag
│   ├─ WorldModelId = "wm-47382"
│   ├─ WorldModelVersion = 137
│   └─ BootContextId = "ghostworx-dev-01"
│
└─ Chat History
```

Then:

```text
WorldModelStore
    wm-47382
       ├── Entities
       ├── Relationships
       ├── Environment
       ├── Goals
       ├── Constraints
       ├── Resources
       ├── Observations
       ├── Hypotheses
       ├── Decisions
       ├── OpenQuestions
       └── Provenance
```

## Your four layers then have very different lifecycle semantics

| Layer                           | Semantics                                     |             Mutation | Mechanism                     |
| ------------------------------- | --------------------------------------------- | -------------------: | ----------------------------- |
| **1 System Instructions** | Constitution / behavioral contract            |                Never | `ChatOptions.Instructions`  |
| **2 Boot Context**        | Initial environment / identity / capabilities | Never during session | `BootContextProvider`       |
| **3 World Model**         | Current canonical understanding of reality    |    State transitions | `WorldModelContextProvider` |
| **4 Dialog**              | Recent conversational trajectory              |        Append/reduce | `ChatHistoryProvider`       |

And I would add an **optional fifth service beside the stack**, not inside it:

```text
                  ┌───────────────────────┐
                  │ Semantic / Episodic   │
                  │ Memory                │
                  │                       │
                  │ ChatHistoryMemory-    │
                  │ Provider / Vector DB  │
                  └──────────┬────────────┘
                             │ relevant recall
                             ▼
┌───────────────────────────────────────────────┐
│ DIALOG                                        │
├───────────────────────────────────────────────┤
│ WORLD MODEL  ◄──── canonical truth/state      │
├───────────────────────────────────────────────┤
│ BOOT CONTEXT                                  │
├───────────────────────────────────────────────┤
│ SYSTEM INSTRUCTIONS                           │
└───────────────────────────────────────────────┘
```

`ChatHistoryMemoryProvider` is excellent for that episodic-memory role because it can store per session but search more broadly across a user, agent, or application scope. Microsoft exposes separate `storageScope` and `searchScope` precisely for this. ([Microsoft Learn][3])

---

# The interesting part: the World Model is a **reducer**

I think this is the critical architectural insight.

Don't think:

```text
Conversation → summarize → World Model
```

Think:

```text
                   observation
                       │
                       ▼
Current World ──► WORLD MODEL REDUCER ──► New World
                       ▲
                       │
                tool observations
                user statements
                agent actions
                environment events
```

Formally:

```text
W(t+1) = Reduce(
    W(t),
    UserObservation,
    ToolObservations,
    AgentActions,
    ExternalEvents
)
```

This lets the model distinguish **state** from **history**.

Suppose:

```text
User: We're going to use PostgreSQL.

World:
    Database.Engine = PostgreSQL
    Database.Status = Planned
```

Later:

```text
Tool: docker ps
      postgres:18 running

World:
    Database.Engine = PostgreSQL
    Database.Status = Running
    Database.Runtime = Docker
    Database.Version = 18
    Evidence = ToolObservation
```

Later:

```text
User: Forget Postgres. We're moving this to Cosmos.

World:
    Database.Engine = CosmosDB
    Database.Status = Planned

Historical event:
    PostgreSQL decision superseded.
```

The conversation remembers **all three events**.

The World Model contains **the third state**.

That distinction becomes extremely powerful for long-running agents.

---

# I would also separate **facts from beliefs**

A sophisticated world representation should not just be a dictionary.

Something closer to:

```csharp
WorldModel
{
    Version

    Entities
    Relationships

    Facts
    Assumptions
    Hypotheses

    Goals
    Constraints
    Intentions

    Environment
    Resources
    Capabilities

    CurrentTasks
    CompletedTasks
    Blockers

    Decisions
    OpenQuestions

    TemporalState

    Provenance
}
```

And an individual assertion:

```csharp
WorldAssertion
{
    Subject
    Predicate
    Object

    Status:
        Observed
        Reported
        Inferred
        Assumed
        Desired
        Superseded

    Confidence

    Source
    CreatedAt
    UpdatedAt

    Evidence[]
}
```

Now your agent can reason differently about:

```text
OBSERVED:
Docker container postgres is running.

REPORTED:
User says production uses PostgreSQL.

INFERRED:
The application's DB provider is probably Npgsql.

DESIRED:
Production should move to Cosmos DB.
```

Without this separation, all four often collapse into "facts" in an LLM context.

---

# There's also a very nice Agent Framework lifecycle here

The current pipeline is approximately: history is loaded, context providers enrich the invocation, the LLM runs, and afterward history/context providers are notified to persist new state. ([Microsoft Learn][1])

You can exploit that:

```text
                    AGENT TURN
                       │
        ┌──────────────▼──────────────┐
        │ 1. System Instructions      │
        ├─────────────────────────────┤
        │ 2. Load Boot Context        │
        ├─────────────────────────────┤
        │ 3. Load World Model         │
        ├─────────────────────────────┤
        │ 4. Load Recent Dialog       │
        ├─────────────────────────────┤
        │ 5. Retrieve Episodic Memory │
        └──────────────┬──────────────┘
                       │
                       ▼
                     LLM
                       │
                tool calls/actions
                       │
                       ▼
               Assistant response
                       │
         ┌─────────────┴──────────────┐
         │                            │
         ▼                            ▼
 Append Dialog                WorldModelReducer
                                      │
                                      ▼
                              World Model vN+1
```

### One modification to your original notation

I would actually write the architecture this way:

```text
AGENT CONTEXT
──────────────────────────────────────────
4. Dialog             [ephemeral / append]
3. World Model        [mutable / reduced]
2. Boot Context       [immutable]
1. System Instructions[immutable]
──────────────────────────────────────────

MEMORY SERVICES
──────────────────────────────────────────
• Episodic Memory     [semantic retrieval]
• Artifact Memory     [RAG]
• World History       [event log]
──────────────────────────────────────────
```

The reason is subtle but important:

**World Model ≠ Memory.**

The World Model is **the agent's current state of understanding**.

Memory is evidence from which that understanding can be reconstructed, questioned, or updated.

That gives you a really clean agent architecture:

> **Memory tells the agent what happened.**
> **The World Model tells the agent what is true now.**
> **Dialog tells the agent what we're doing right now.**
> **Boot Context tells the agent where it woke up.**
> **System Instructions tell the agent what it is and how it must behave.**

I think this is a substantially stronger abstraction than simply extending chat history. And Agent Framework's `AIContextProvider` + `AgentSession.StateBag` lifecycle is unusually well matched to implementing it. ([Microsoft Learn][4])

The next logical design step would be to define **`IWorldModel`, `IWorldModelStore`, `IWorldModelReducer`, and `WorldModelContextProvider`**, because those four abstractions would turn this from a context-management idea into a reusable Agent Framework subsystem.

[1]: https://learn.microsoft.com/en-us/agent-framework/agents/agent-pipeline
[2]: https://learn.microsoft.com/en-us/agent-framework/agents/conversations/storage
[3]: https://learn.microsoft.com/en-us/agent-framework/integrations/chat-history-memory-provider
[4]: https://learn.microsoft.com/en-us/agent-framework/agents/conversations/context-providers
[5]: https://learn.microsoft.com/en-us/agent-framework/agents/conversations/session
