# Moneta Report Generator — Docker Distribution

Professional Excel financial report generator packaged as a Docker image.  
**No source code is included in this repository.** The Docker build pulls the
private `moneta-report-generator` package at build time.

---

## Quick Start

### 1. Build the image

A GitHub personal-access token with `repo` scope to the private source
repository is required at build time only. It is **not** baked into the
final image (multi-stage build).

```bash
docker build \
  --build-arg GITHUB_TOKEN=<your-token> \
  -t moneta-report:latest .
```

### 2. Generate a report

Place your `report_output.json` in a local folder and mount it:

```bash
docker run -v /path/to/data:/data \
  moneta-report:latest \
  --input /data/report_output.json \
  --output /data/MonetaReport.xlsx -v
```

The generated `MonetaReport.xlsx` will appear in the same folder.

---

## CI Pipeline

The GitHub Actions workflow (`.github/workflows/build.yml`) does the following
on every push to `main`:

| Step | Description |
|------|-------------|
| **Build** | Builds the Docker image using the `SOURCE_REPO_TOKEN` secret |
| **Verify** | Runs `--help` to confirm the image is valid |
| **Generate** | Produces `MonetaReport.xlsx` from sample data (if present) |
| **Artifact** | Uploads the generated report as a downloadable artifact |

### Required Secret

Add `SOURCE_REPO_TOKEN` in **Settings → Secrets → Actions** with a GitHub
PAT that has read access to `poornimaramakrishnan/moneta-report-generator`.

---

## Report Tabs

The generated Excel workbook contains 12 professionally formatted tabs:

1. **Cover** — Company overview, fraud-risk badge, hyperlinked table of contents
2. **Account Summary** — All bank accounts with opening/closing balances
3. **EOD Detailed** — Daily end-of-day balances per account
4. **EOD Combined** — Combined daily balances across all accounts
5. **Liquidity** — Health metrics, runway analysis, monitoring alerts
6. **Transaction Summary** — Volume/value breakdown by category
7. **P&L (Actual)** — Profit & Loss from actual transactions
8. **P&L (Forecast)** — Forward-looking P&L projections
9. **Balance Sheet** — Assets, liabilities, equity snapshot
10. **Metrics** — Key financial ratios with traffic-light indicators
11. **DSCR / DBR** — Debt service coverage & debt burden ratios
12. **Fraud** — Fraud probability, 20-indicator summary, detailed cases

---

## Design System

- **Navy / Gold** brand palette with consistent typography
- Traffic-light cells (green / amber / red) for KPIs
- Print-friendly A4 landscape layout on every tab
- Frozen header rows and navigation bar across all sheets

---

## License

Proprietary. All rights reserved.
