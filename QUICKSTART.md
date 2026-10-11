# SWE 4.0 quickstart

Start with a standalone solution. Use a portfolio when related solutions share outcomes, contracts, or delivery dependencies. Both use the same developer, tester, and independent-review responsibilities.

Install/enable the four 4.0.0 packages through your host's plugin mechanism. The commands below assume this authoring checkout is available; they do not install plugins or change host configuration. Check that the host can select the repository's registered agents, especially `test-runner`. Models come from native agent configuration, not copied skill instructions.

## 1. A standard solution

From the `swe-plugin` checkout, point the copier at your existing application directory:

```powershell
$sweProcess = (Resolve-Path .\plugins\swe-process).Path
$scaffold = Join-Path $sweProcess 'skills\swe-scaffold\scripts\Invoke-SweScaffold.ps1'
$application = 'C:\Source\my-application' # Replace with your actual existing checkout.
powershell -NoProfile -ExecutionPolicy Bypass -File $scaffold -Solution -Destination $application -AsJson
```

Equivalent agent request in the application workspace:

```text
$swe-scaffold -solution
```

The fresh guide declares **Standalone**. Existing files are skipped; a skipped old guide does not become V4 automatically. Use the [migration guide](plugins/swe-process/references/V4-MIGRATION.md) for customized repositories. Fill the solution context and actual build/test commands with repository facts. No portfolio, Platform architecture, Epic, remote task, or separate Plan is required.

### Deliver a new capability

In that application's workspace:

```text
$swe-max "Let a user export a filtered report as CSV. Preserve the current filters,
escape CSV values correctly, and cover empty results and invalid access. Keep
the work local to this solution. Use the ordinary compact route."
```

The coordinator defines a local Feature, develops the approach, obtains required decisions, implements, requests checks, and hands evidence to an independent validator. It reuses existing applicable architecture; a first application gets an appropriate Solution baseline, not an invented Platform. Human approval is the default. Explicit `-auto-approve` or an adopted policy may authorize independent agent review; Major decisions still retain a named human.

For direct control, use the individual skills in order:

```text
$swe-plan-features "Export the current filtered report as CSV"
$swe-design .swe/features/001-report-export/FEATURE.md
# Review the proposed outcome and approach; record the actual approval.
$swe-implement .swe/features/001-report-export/FEATURE.md
$swe-validate .swe/features/001-report-export/FEATURE.md
```

The allocated directory number/name may differ; use the actual returned path. An author cannot perform their own independent review. Invoke validation in an eligible independent `solution-validator` context. `swe-test` dispatches bounded native checks to the configured tester; developers fix failures. The validator can reuse current attributable receipts and request additional checks where needed.

Expected records:

```text
.swe/features/001-report-export/
  FEATURE.md       outcome, criteria, approach, risk, checks, pre-code decision
  EVIDENCE.md      changed behavior, receipt links, deviations, obligations
  VALIDATION.md    independent delivery decision
```

Test logs/receipts are generated execution outputs, not additional authored plans. A separate `DESIGN.md` is useful for a complex interface, migration, security boundary, or substantial design; it is not the default. Research, Concepts, impact reports and Epics are similarly conditional.

**Done means delivery accepted**, with all required current checks and the independent decision. Implementation complete is an intermediate milestone. Approval of the Feature approves requirements/approach, not the delivered behavior. Deployment and publication need separate authorization.

### Intentional fast paths

```text
$swe-bugfix "The existing CSV export drops the last row; reproduce and repair it"
$swe-enhancement "Add the already-supported report title to the export filename"
```

Use these for eligible bounded repairs/refinements. Each keeps its single `BUGFIX.md` or `ENHANCEMENT.md`, including evidence and Validation/Closure. A required validator writes that section; an allowed low-risk owner waiver closes without claiming validation. New capabilities and architectural changes escalate to ordinary **local** Feature/architecture work, not an invented portfolio.

## 2. A larger effort with related solutions

Ghostworx demonstrates why portfolios remain useful: shared intent and contracts are coordinated in the root, while actual work and evidence belong to child solutions such as `ghostworx-system`. Preserve that ownership, while avoiding a new document or worker for every package/module.

For a new related-project collection, from this authoring checkout:

```powershell
$sweProcess = (Resolve-Path .\plugins\swe-process).Path
$scaffold = Join-Path $sweProcess 'skills\swe-scaffold\scripts\Invoke-SweScaffold.ps1'
$portfolio = 'C:\Source\related-products' # Existing portfolio checkout.
$service = Join-Path $portfolio 'repos\report-service' # Existing child checkout.
$client = Join-Path $portfolio 'repos\report-client'   # Existing child checkout.
powershell -NoProfile -ExecutionPolicy Bypass -File $scaffold -Portfolio -Destination $portfolio
powershell -NoProfile -ExecutionPolicy Bypass -File $scaffold -Solution -Federated -PortfolioRepository related-products -Destination $service
powershell -NoProfile -ExecutionPolicy Bypass -File $scaffold -Solution -Federated -PortfolioRepository related-products -Destination $client
```

These commands require existing directories. They create missing process files; they do not create Git repositories, clone projects, approve adoption, or register new host projects. Open/register each actual child checkout in the host before cross-project dispatch. A requested Federated mode cannot overwrite a skipped Standalone/customized guide.

In the portfolio workspace:

```text
$swe-max "Deliver a report export workflow across report-service and report-client.
The service owns export authorization and the response contract. The client owns
the user interaction. Allocate exact criteria and shared contract dependencies.
Use existing architecture, concise allocation, and local child evidence."
```

Use an Epic for this related outcome, a canonical Feature for observable criteria, and a shared contract when needed. Simple allocation fits in the Feature; use a separate Implementation Plan only when owners/dependencies warrant it. An illustrative allocation:

| Assignment | Owner / scope | Criteria and prerequisite | Return |
| --- | --- | --- | --- |
| EXPORT-SERVICE | Exact report-service checkout; API/auth/export paths | Service criteria; approved response/security contract before code | Local Design, Evidence, independent Validation |
| EXPORT-CLIENT | Exact report-client checkout; export UI/API adapter paths | UI criteria; approved contract for Design; validated service behavior before integration consumption | Local Design, Evidence, independent Validation |

The root coordinator dispatches only eligible assignments through `swe-bridge` using supported, authorized exact-child project transport. If that host capability is unavailable, the same bounded assignment can be carried into the correct child workspace by the human; transport failure does not justify executing against a different checkout. Verify each returned record and generation before continuing. Do not copy child code, upstream Features, or test corpora into scratch repositories.

Children keep their records at `.swe/implementations/EPIC-NNN/FEATURE-NNN/`. Their independent validators accept local delivery. The portfolio `feature-validator` checks the actual cross-solution criteria and integration using applicable child evidence and any necessary integration checks. Unchanged local tests need not run again just because a portfolio review starts.

Unrelated eligible work can proceed while one prerequisite waits. A new shared contract or required behavior remains a genuine gate. Keep one owner per changed path and serialize shared build outputs. Do not spawn every architectural level merely because it exists.

**Portfolio done** means all required local deliveries accepted, shared integration accepted, outstanding checks resolved, and affected architecture reconciled. It does not imply deployment.

## 3. Keep paperwork proportional

- Read governing context once, refresh changed inputs, and expand only to resolve a specific fact.
- Pass six facts to an agent: owned scope, direct inputs, procedure, expected output, current constraints, handoff recipient. No mandatory packet file.
- Keep six core header fields and direct ID/path links. Do not copy every ancestor into each header.
- Reuse accepted architecture and current attributable receipts. Record decisions and results once.
- Preserve author/reviewer independence, human defaults, Major human decisions and the maximum two repair cycles. Simpler paperwork does not erase those protections.

See the [delivery contract](plugins/swe-process/references/ARTIFACT-CONTRACT.md), [implementation plan](docs/V4-IMPLEMENTATION-PLAN.md), and [migration guide](plugins/swe-process/references/V4-MIGRATION.md) for adoption and compatibility details.
