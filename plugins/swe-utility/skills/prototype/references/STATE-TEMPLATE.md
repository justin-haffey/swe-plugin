---
title: "Prototype Mode State"
artifact_type: "prototype_mode_state"
id: "PROTOTYPE-STATE"
status: "Active"
mode: "On"
authority: "[REPOSITORY_AUTHORITY]"
scope:
  repository: "[REPOSITORY_ID_OR_URL]"
  path: "[REPOSITORY_RELATIVE_SCOPE]"
active_run: "[RUN_ID]"
activated_by: "[ACTOR]"
activated_at: "[ISO_8601_UTC]"
deactivated_by: ""
deactivated_at: ""
updated: "[ISO_8601_UTC]"
template_version: "2.0"
---
# Prototype Mode State

Prototype Mode is on for the recorded repository scope. The active run is [`[RUN_ID]`](runs/[RUN_ID]/PROTOTYPE.md).

## Transition History

<!-- PROTOTYPE:TRANSITIONS:START -->
| Recorded | From | To | Actor | Run | Reason |
| --- | --- | --- | --- | --- | --- |
| [ISO_8601_UTC] | Off | On | [ACTOR] | [RUN_ID] | Explicit `$prototype -on` invocation |
<!-- PROTOTYPE:TRANSITIONS:END -->
