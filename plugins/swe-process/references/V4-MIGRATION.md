# Adopt V4 without rewriting history

V4 makes standalone delivery complete and reduces new paperwork. Package installation/scaffolding does not adopt approval policy or rewrite active work. Existing accepted IDs, documents, receipts and review-cycle history remain authoritative.

1. The owner selects a new work/revision boundary and declares Standalone, Federated or Portfolio authority in existing governance. For Federated name the actual portfolio and allocated scope. Preserve actual source checkouts and customized configuration.
2. Use Get-SweMigrationDiff.ps1 against `scaffolds/solution` or `scaffolds/portfolio` for a read-only proposal. Review edits separately; the copier never upgrades existing files. Get-SweAdoptionPreflight.ps1 reports compatibility/host evidence, not approval.
3. Record owner, scope/boundary, old/new rules, allowed approval modes and rollback in one existing ADR/governance record. Human approval remains default; no automatic standing approval.
4. New local Features may use combined approach and three records. Existing federated Features/Plans/Designs remain separate until an explicit successor/adoption decision. Do not renumber or silently reinterpret Epic-local IDs as repository-local IDs.
5. Read old full headers unchanged; generate new schema-4 compact headers with direct ID/path links. Explicit repository mapping resolves cross-repository identities. Do not copy lineage into each document.
6. Prototype Mode has no new V4 command. Preserve old journals and reconcile/cancel outstanding obligations explicitly before adoption; do not erase failures, create retrospective acceptance, or reset exhausted review counts.
7. Rehearse standalone, federated, fast-path, no-clobber and legacy-reader cases through swe-test. Verify the actual configured tester role/model. Rollback keeps source/history and uses reviewed governance restoration, never source reset or automatic scaffold overwrite.

Older V3 migration material describes historical adoption only; it does not reactivate retired workflows in V4.
