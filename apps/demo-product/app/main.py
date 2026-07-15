import logging

from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles

from app.config import settings
from app.routers import hubspot_mock, product, tableau_exports
from app.segment_client import init_segment

logging.basicConfig(level=logging.INFO)

app = FastAPI(title="CloudMetrics", version="0.1.0")

app.mount("/static", StaticFiles(directory="app/static"), name="static")
app.include_router(product.router)
app.include_router(hubspot_mock.router)
app.include_router(tableau_exports.router)


@app.on_event("startup")
def startup() -> None:
    init_segment()


@app.get("/health")
def health() -> dict[str, str]:
    return {
        "status": "ok",
        "env": settings.app_env,
        "segment": "enabled" if settings.segment_enabled else "disabled",
    }
