# CloudMetrics Integration

End-to-end data integration: product events → Segment → Snowflake → dbt → n8n reverse ETL and Tableau.

```
Demo App ──► Segment ──► Snowflake RAW
                              │
         Keboola (HubSpot, Intercom CSV)
                              │
                         dbt (hourly)
                              │
                    STAGING / MARTS
                    ┌─────────┼─────────┐
                    ▼         ▼         ▼
               Tableau    n8n       Snowflake
                          ├─► HubSpot mock
                          └─► Tableau CSV feed
```

## Stack

| Layer | Tool |
|-------|------|
| Product | FastAPI, HTMX |
| CDP | Segment |
| Warehouse | Snowflake |
| E+L | Keboola |
| Transform | dbt |
| Orchestration | n8n |
| BI | Tableau Cloud |
| Hosting | Railway |

## Railway services

| Service | Path | Role |
|---------|------|------|
| demo-product | `/` or `apps/demo-product` | Product simulator, webhooks, BI CSV endpoints |
| n8n | `apps/n8n` | Reverse ETL and mart exports |
| dbt | `apps/dbt` | Hourly `dbt run` + `dbt test` (cron `:15` UTC) |

## Live endpoints

| Service | URL |
|---------|-----|
| Demo app | https://cloudmetrics-integration-production.up.railway.app |
| Admin | `/admin` |
| Health | `/health` |
| n8n | https://n8n-production-b51b1.up.railway.app |
| Tableau | Tableau Cloud workbook (live demo on screen share) |

## Snowflake

- Database: `CLOUDMETRICS`
- Schemas: `RAW`, `STAGING`, `MARTS`, Segment destination schema
- Key marts: `MART_PQA_SCORES`, `FCT_PRODUCT_EVENTS`, `DIM_USERS`

## n8n workflows

| Workflow | Schedule |
|----------|----------|
| PQA Score to HubSpot | Hourly |
| Tableau Export Feed | Hourly `:30` UTC |
| Pipeline Health Check | Daily 09:00 UTC |

## Local setup

```bash
cd apps/demo-product
cp .env.example .env
pip install -r requirements.txt
uvicorn app.main:app --reload --port 8080

cd dbt/cloudmetrics
dbt debug && dbt run && dbt test
```

## Repository layout

```
apps/demo-product/   FastAPI app
apps/n8n/            n8n + workflows
apps/dbt/            dbt cron on Railway
dbt/cloudmetrics/    dbt models
scripts/snowflake/   Warehouse DDL and seeds
data/                Source CSVs (gitignored)
```
