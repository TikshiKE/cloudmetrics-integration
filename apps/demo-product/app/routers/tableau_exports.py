from typing import Any

from fastapi import APIRouter, Header, HTTPException, Request, Response
from fastapi.responses import JSONResponse
from pydantic import BaseModel, Field

from app.routers.hubspot_mock import _verify_secret
from app.state import (
    TABLEAU_DATASETS,
    get_tableau_export,
    list_tableau_exports,
    update_tableau_export,
)

router = APIRouter(tags=["tableau-exports"])


class TableauCsvPayload(BaseModel):
    csv: str = Field(min_length=1)


@router.post("/api/exports/tableau/{dataset}")
async def ingest_tableau_export(
    dataset: str,
    request: Request,
    x_webhook_secret: str | None = Header(default=None),
) -> dict[str, Any]:
    _verify_secret(x_webhook_secret)
    if dataset not in TABLEAU_DATASETS:
        raise HTTPException(status_code=404, detail=f"Unknown dataset: {dataset}")

    content_type = (request.headers.get("content-type") or "").lower()
    if "application/json" in content_type:
        payload = TableauCsvPayload.model_validate(await request.json())
        csv_text = payload.csv.strip()
    else:
        csv_text = (await request.body()).decode("utf-8-sig").strip()

    if not csv_text:
        raise HTTPException(status_code=400, detail="Empty CSV body")

    meta = update_tableau_export(dataset, csv_text)
    return {"status": "updated", **meta}


@router.get("/exports/tableau/{dataset}.csv")
def download_tableau_export(dataset: str) -> Response:
    export = get_tableau_export(dataset)
    if export is None:
        raise HTTPException(status_code=404, detail=f"Dataset '{dataset}' not found")

    filename = f"{dataset}.csv"
    return Response(
        content=export.csv_body,
        media_type="text/csv; charset=utf-8",
        headers={"Content-Disposition": f'inline; filename="{filename}"'},
    )


@router.get("/exports/tableau/manifest.json")
def tableau_manifest() -> JSONResponse:
    return JSONResponse(list_tableau_exports())
