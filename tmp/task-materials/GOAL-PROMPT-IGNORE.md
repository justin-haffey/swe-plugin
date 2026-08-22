# Goal

Your goal is complete when every step has been completed, and version 2.0 of the swe-plugin codex solution is finished.

## Workflow:

**Steps:**

1. First Seek to Understand

Your goal is to (1) first digest the bulleted directories below to learn and understand (a) the design context and (b) objectives and (2) analyze the root project using codebases memory to understand the current state/status of current skills clearly. Note platform and portfolio are used interchangably.
	
Note: We are starting over with some carryover skills and artifacts that certainly need updates or upgrades, or to be replaced or removed. Read in sequence:

	- [Artifact Templates](scaffold/_templates/)

	This directory aggregates all of the templates that have been produced for this effort.  They are in various states, some are near-final and some are blank. In step 3 you will finalize the remainder of these templates.

	Equally as important, this directory contains a set of CONTEXT.md files. These documents define a vocabulary that will be EXTREMELY helpful while performing your work.

	- [Portfolio Scaffold](scaffold/portfolio/)

	This directory mirros the workspace root for a portfolio/platform repo. 

	- [Solution Scaffold](scaffold/solution/)

	This directory mirrors a child solution repo. 

	- [Task Materials](tmp/task-materials/)

	This directory contains design artifacts critical for your codex development task.

2. Questions

Use the $grill (plugins\swe-utility\skills\grill\SKILL.md) skill to question me about what you just read in Step 1 until we are comfortable that we have a solid design.

3. Codex Development
`
Leverage the materials in `tmp\task-materials\*`

Your implementation work should target the `plugins/`, `scaffolds/portfolio/` and `scaffolds/solution/` directories ONLY. Treat `scaffolds/*` directories as if they were the actual platform and solution repos and as if the .codex directories within this structure will be the actual .codex directories for new repos.

The `_templates/` directory is TEMPORARY and will be manually removed later.  Templates should "live" with the skill that creates it (`references/`).

The `swe-scaffold [-portfolio|-solution]` skill should copy the corresponding scaffold to the repo where the skill is invoked. therefore it must live with the skill (copy/store the Scaffolds with the plugin skill) IMPORTANT NOTE: This should be the last skill you create. 

Orchestrate one or more instances of the @codex-engineer when performing your work.

Scope: End-to-end customizations for software engineering; codex plugins, supporting .md materials, and production ready scaffolds for a platform/portfolio repo and a (b) solution repo.

	- Complete set of swe-process skills
	- MAJORLY upgraded set of process aware [codex agents](/scaffolds/<porfolio|solution>/.codex/agents/swe/*)
	

4. Critique

Perform a complete review of the solution to determine readiness, identify gaps and inconsistencies, artifact readiness, skill/process issues. 

	- Does the process make sense at each Engineering phase?
	- Do template artifacts have descriptive yaml headers? Do sections and content align with the intendend purpose and process?
	- Do skills include a reference/ directory with appropriate templates or documents?
	- Do template artifacts effectively reference and cross-link? Do they do so across Platform/Solution boundaries?
	- Does `scaffolds/*` AGENT.md effectively educate and govern agents? and is README.md presently informational and extensible for use in new repos?

5. Refactor

Orchestrate @codex-engineer agents to rectify all readiness gaps and process inconsistencies. Address and resolved all issues identified in the Critique.

6. Finalize Implementation

Shift your implementation target from `plugins/` and `scaffolds/*` to cleaning up the swe-plugin workspace root a Use the @repo-author to

	- Update the swe-plugin project README.md ensuring it logically informs and structurally defines the repo.
	- Add and AGENTS.md file authored to instruct future agents that will modify or extend plugins.