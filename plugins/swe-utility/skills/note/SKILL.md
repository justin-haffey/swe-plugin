---
name: note
description: Create a note.
---------------------------

# Note

Summarize the a topic or topics discussed in the current session, and persist as notes: `NOTE_<name>.md` in `notes/*`.

## Invocation Contract

Accept this signature by itself, or within a larger prompt. Examples:

### Example 1

Take a single note for the last topic discussed.

```text
$note
```

### Example 2

Take multiple notes.

```text
$note down the the last 3 topics we discussed.
```

Workflow

## Naming Convention

Use descriptive titles for notes, e.g.; `NOTE_<topic-name>.md`, `NOTE_<idea-name>.md`, `NOTE_<module-name>.md`, etc.

## Preservation

When authoring a `NOTE_<name>.md`, ensure to include any:

- Key points
- Important Terms/Vocabulary
- Charts, Graphs, Tables, Figures and Diagrams (mermaid). Update for accuracy if any of the prior were outdated later in the session.
- Domain, Conceptual, and Other Models
- Specific instructions, rules, decisions, etc.

## Save Path

Save notes in `notes/*`

## Output

Return:

- a list with the **`note-name`** - `<brief_descrition>`
- a very short summary explaination explaining how you logically organized the note(s) and why.
