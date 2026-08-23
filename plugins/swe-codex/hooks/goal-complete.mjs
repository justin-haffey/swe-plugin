import process from "node:process";

const chunks = [];

for await (const chunk of process.stdin) {
  chunks.push(chunk);
}

let input;
try {
  input = JSON.parse(Buffer.concat(chunks).toString("utf8"));
} catch {
  process.exit(0);
}

const requestedStatus = input?.tool_input?.status;

function parseResponse(value) {
  if (typeof value !== "string") {
    return value;
  }

  try {
    return JSON.parse(value);
  } catch {
    return null;
  }
}

function hasCompletedGoal(value) {
  const response = parseResponse(value);
  if (response == null || typeof response !== "object") {
    return false;
  }

  if (response.isError === true || response.is_error === true || response.error != null) {
    return false;
  }

  return [response, response.structuredContent]
    .some((candidate) => candidate?.goal?.status === "complete");
}

if (
  input?.hook_event_name !== "PostToolUse" ||
  input?.tool_name !== "update_goal" ||
  requestedStatus !== "complete" ||
  !hasCompletedGoal(input?.tool_response)
) {
  process.exit(0);
}

const additionalContext = [
  "The active goal was just marked complete. Before sending the final response, use $repo-wrap-up for the current repository.",
  "The skill must first attempt the repo-author agent and fall back to a built-in worker subagent if repo-author is unavailable.",
  "Pass the completed-goal summary and repository root, wait for the documentation result, and incorporate its review or blocker evidence.",
  "Do not stage or commit. Pause after documentation and validation so the user can review the changes.",
  "Do not call update_goal again during this wrap-up."
].join(" ");

process.stdout.write(JSON.stringify({
  hookSpecificOutput: {
    hookEventName: "PostToolUse",
    additionalContext
  }
}));
