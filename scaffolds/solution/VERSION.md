# Version

## Current

`proto-0.0.0.0`

## Versioning

### Format

`PREFIX-MAJOR.MINOR.UPDATE.BUILD`

**MAJOR-** Significant changes, breaking changes, major redesigns, or a new generation.

- Major versions are updated at the `Platform` level and rolled down to VERSIONS.md in child `Solutions`.

**MINOR-** new features or functionality completed with meaningful improvements that remain backward-compatible.

- Minor versions are incremented at the `Solution` level after any major feature is completed, and the version rolls down to each child `Project`.

**UPDATE-** Patch, hotfix, bugfix, minor change, repo reorginization, codex update.

- Update versions are incremented at the `Project` (Package) level where the issue exists, and will differ between `Projects`

**BUILD-** Incremented after each build

- Build versions are incremented for each post-prototype stage build

### Prefixes

Indicates the "Stage" of architectural and deployment readiness.

- `proto-`: Pre-major version. The architecture is not solidified and may change.
- `alpha-`: Post version 1. The architecture is solidified.
- `beta-`: Post `alpha-`. The package is deployable and functional end-to-end
- `rc-`: Post beta. The package has no known major bugs and is being considered for release.
- `1.#.#.#`: No prefix. The package has been released and MUST (a) maintain backwards compatibility, and (b) support version migrations for breaking changes - from this point forward.

### Rules

- All lower positioned version numbers reset when the immediately proceeding higher version position is incremented
- Major`<MAJOR>.#.#.#` version updates are controlled at the `Platform` level and rolled down to child `Solutions` within `repos/`
- A label is applied to a checkin whenever a MAJOR or MINOR version is updated.
- Whenever a MAJOR or MINOR version number is incremented, release notes are updated for lower-level changes (features, fixes, etc).
- .NET Project version numbers are ALWAYS updated to match the correlated package version.

## Proto Stage Exceptions

- Build version numbers are NOT incremented (the build version remains zero, e.g. `#.#.#.0` ).
- Because releases are not done during the `proto-` stage, release notes do not exist to update.
