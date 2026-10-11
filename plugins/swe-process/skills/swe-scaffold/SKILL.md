---
name: swe-scaffold
description: Add missing standalone solution or portfolio scaffolding, optionally declaring an actual federated solution without overwriting existing files.
---
# Scaffold

Use `$swe-scaffold -solution` for standalone delivery or `-portfolio` for related-solution coordination. Optional `-Destination <existing-directory>` defaults to the active repository. A real child uses `-solution -Federated -PortfolioRepository <identity>` with owner authorization. This selects initial content only; skipped governance remains effective.

Run scripts/Invoke-SweScaffold.ps1 with exactly one scaffold switch. Sources are [portfolio](../../scaffolds/portfolio/) and [solution](../../scaffolds/solution/) at the plugin root. No root scaffold tree or duplicate skill-reference trees; see [ownership](references/SCAFFOLD-SOURCES.md).

The copier preflights collisions and atomically creates only absent files. Existing files always skip, regardless of approval/force elsewhere. Legacy root portfolio vocabularies require explicit migration before duplicate context authorities can be created. Preserve existing settings and MCP registrations.

Fresh solution needs no portfolio: local Feature/approach, Evidence, Validation. Bugfix/enhancement remain single-record fast paths. Portfolio adds actual shared contracts/allocation/integration. Scaffolding does not adopt automatic approval.

For customized repositories use [V4 migration](../../references/V4-MIGRATION.md) and a read-only proposed diff; copying is not an upgrade. Request execution checks through swe-test/native tester. Return requested mode, destination, CreatedFiles/SkippedExistingFiles/Counts, skipped governance and adoption limitations. Preserve SchemaVersion 2.0 report compatibility. RequestedDeliveryMode describes the request, not inferred adoption.

Fresh solution guidance branches by its declared mode: local intent in Standalone, upstream allocation in Federated. Keep this guide aligned with the canonical scaffold trees after process changes.
