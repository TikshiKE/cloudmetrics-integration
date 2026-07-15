import random
import uuid
from typing import Any

from fastapi import APIRouter, Cookie, Request, Response
from fastapi.templating import Jinja2Templates

from app import segment_client

router = APIRouter(tags=["product"])
templates = Jinja2Templates(directory="app/templates")

PLANS = ["free", "starter", "pro", "enterprise"]


def _ensure_session(
    response: Response,
    anonymous_id: str | None,
    user_id: str | None,
    plan: str | None,
) -> tuple[str, str | None, str]:
    anon = anonymous_id or str(uuid.uuid4())
    current_plan = plan or "free"
    if not anonymous_id:
        response.set_cookie("anonymous_id", anon, max_age=60 * 60 * 24 * 30)
    if user_id:
        response.set_cookie("user_id", user_id, max_age=60 * 60 * 24 * 30)
    response.set_cookie("plan", current_plan, max_age=60 * 60 * 24 * 30)
    return anon, user_id, current_plan


def _recent_actions_html() -> str:
    from app.state import segment_events_log

    if not segment_events_log:
        return '<p class="muted">No actions yet. Click a button above.</p>'

    rows = []
    for entry in list(segment_events_log)[:10]:
        p = entry.payload
        event = p.get("event", "unknown")
        props = p.get("properties", p.get("traits", {}))
        rows.append(
            f'<div class="log-row">'
            f'<span class="log-time">{entry.timestamp[:19]}</span> '
            f'<strong>{event}</strong> '
            f'<code>{props}</code>'
            f"</div>"
        )
    return "\n".join(rows)


@router.get("/")
def dashboard(
    request: Request,
    response: Response,
    anonymous_id: str | None = Cookie(default=None),
    user_id: str | None = Cookie(default=None),
    plan: str | None = Cookie(default=None),
):
    anon, uid, current_plan = _ensure_session(response, anonymous_id, user_id, plan)
    return templates.TemplateResponse(
        request,
        "dashboard.html",
        {
            "user_id": uid,
            "anonymous_id": anon,
            "plan": current_plan,
            "signed_up": uid is not None,
        },
    )


@router.get("/admin")
def admin_page(request: Request):
    from app.state import hubspot_writes_log, segment_events_log

    return templates.TemplateResponse(
        request,
        "admin.html",
        {
            "segment_events": list(segment_events_log)[:20],
            "hubspot_writes": list(hubspot_writes_log)[:20],
        },
    )


@router.post("/actions/sign-up")
def sign_up(
    request: Request,
    response: Response,
    anonymous_id: str | None = Cookie(default=None),
    user_id: str | None = Cookie(default=None),
    plan: str | None = Cookie(default=None),
):
    anon, uid, _ = _ensure_session(response, anonymous_id, user_id, plan)
    if uid:
        uid = uid  # already signed up
    else:
        uid = f"user_{uuid.uuid4().hex[:8]}"
        response.set_cookie("user_id", uid, max_age=60 * 60 * 24 * 30)

    company_size = random.choice([5, 10, 25, 50, 100, 250])
    new_plan = "free"
    response.set_cookie("plan", new_plan, max_age=60 * 60 * 24 * 30)

    traits: dict[str, Any] = {
        "email": f"{uid}@cloudmetrics.demo",
        "company": f"Demo Corp {uid[-4:]}",
        "plan": new_plan,
        "company_size": company_size,
    }
    segment_client.identify(uid, traits)
    segment_client.track(
        uid,
        "Signed Up",
        {"plan": new_plan, "company_size": company_size},
    )

    return _recent_actions_html()


@router.post("/actions/run-actor")
def run_actor(
    response: Response,
    anonymous_id: str | None = Cookie(default=None),
    user_id: str | None = Cookie(default=None),
    plan: str | None = Cookie(default=None),
):
    anon, uid, current_plan = _ensure_session(response, anonymous_id, user_id, plan)
    actor_id = random.choice(["metrics-sync", "data-export", "alert-runner", "etl-pipeline"])
    duration_sec = random.randint(2, 120)
    success = random.random() > 0.1

    segment_client.track(
        uid or anon,
        "Actor Run Completed",
        {
            "actor_id": actor_id,
            "duration_sec": duration_sec,
            "success": success,
        },
    )
    return _recent_actions_html()


@router.post("/actions/view-dashboard")
def view_dashboard(
    response: Response,
    anonymous_id: str | None = Cookie(default=None),
    user_id: str | None = Cookie(default=None),
    plan: str | None = Cookie(default=None),
):
    anon, uid, _ = _ensure_session(response, anonymous_id, user_id, plan)
    dashboard_id = random.choice(["overview", "usage", "billing", "integrations"])

    segment_client.track(
        uid or anon,
        "Dashboard Viewed",
        {"dashboard_id": dashboard_id},
    )
    return _recent_actions_html()


@router.post("/actions/upgrade")
def upgrade(
    response: Response,
    anonymous_id: str | None = Cookie(default=None),
    user_id: str | None = Cookie(default=None),
    plan: str | None = Cookie(default=None),
):
    anon, uid, current_plan = _ensure_session(response, anonymous_id, user_id, plan)
    plan_idx = PLANS.index(current_plan) if current_plan in PLANS else 0
    to_plan = PLANS[min(plan_idx + 1, len(PLANS) - 1)]
    response.set_cookie("plan", to_plan, max_age=60 * 60 * 24 * 30)

    segment_client.track(
        uid or anon,
        "Upgrade Clicked",
        {"from_plan": current_plan, "to_plan": to_plan},
    )
    return _recent_actions_html()
