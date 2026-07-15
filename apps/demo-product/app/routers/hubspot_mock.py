from typing import Any

from fastapi import APIRouter, Header, HTTPException
from pydantic import BaseModel, Field

from app.config import settings
from app.state import log_hubspot_write

router = APIRouter(prefix="/api/hubspot", tags=["hubspot-mock"])


class ContactUpdate(BaseModel):
    pqa_score: int = Field(ge=0, le=100)
    pqa_tier: str = Field(pattern="^(hot|warm|cold)$")


def _verify_secret(x_webhook_secret: str | None) -> None:
    if not settings.hubspot_mock_secret:
        raise HTTPException(status_code=503, detail="HUBSPOT_MOCK_SECRET not configured")
    if x_webhook_secret != settings.hubspot_mock_secret:
        raise HTTPException(status_code=401, detail="Invalid webhook secret")


@router.patch("/contacts/{contact_id}")
def update_contact(
    contact_id: str,
    body: ContactUpdate,
    x_webhook_secret: str | None = Header(default=None),
) -> dict[str, Any]:
    _verify_secret(x_webhook_secret)
    payload = body.model_dump()
    log_hubspot_write(contact_id, payload)
    return {
        "status": "updated",
        "contact_id": contact_id,
        **payload,
    }


@router.get("/contacts/{contact_id}")
def get_contact(contact_id: str) -> dict[str, str]:
    from app.state import hubspot_writes_log

    for entry in hubspot_writes_log:
        if entry.payload.get("contact_id") == contact_id:
            return {"contact_id": contact_id, "source": "write_log", "data": str(entry.payload)}
    return {"contact_id": contact_id, "status": "not_found_in_mock"}
