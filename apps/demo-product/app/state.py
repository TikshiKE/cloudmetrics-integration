from collections import deque
from dataclasses import dataclass
from datetime import datetime, timezone
from typing import Any


@dataclass
class LogEntry:
    timestamp: str
    payload: dict[str, Any]


@dataclass
class TableauExport:
    dataset: str
    csv_body: str
    updated_at: str
    row_count: int


segment_events_log: deque[LogEntry] = deque(maxlen=100)
hubspot_writes_log: deque[LogEntry] = deque(maxlen=100)

TABLEAU_DATASETS = ("pqa_tier", "pqa_top", "funnel", "health")

TABLEAU_DEFAULT_HEADERS: dict[str, str] = {
    "pqa_tier": "pqa_tier,user_count",
    "pqa_top": (
        "user_id,email,company,plan,pqa_score,pqa_tier,"
        "actor_runs_7d,dashboard_views_7d,upgrade_clicked_ever,company_size,calculated_at"
    ),
    "funnel": "funnel_stage,users",
    "health": "mart_table,row_count,last_record_at,hours_stale",
}

tableau_exports: dict[str, TableauExport] = {
    name: TableauExport(
        dataset=name,
        csv_body=f"{header}\n",
        updated_at="",
        row_count=0,
    )
    for name, header in TABLEAU_DEFAULT_HEADERS.items()
}


def utc_now_iso() -> str:
    return datetime.now(timezone.utc).isoformat()


def log_segment_event(user_id: str, event_name: str, properties: dict[str, Any]) -> None:
    segment_events_log.appendleft(
        LogEntry(
            timestamp=utc_now_iso(),
            payload={
                "user_id": user_id,
                "event": event_name,
                "properties": properties,
            },
        )
    )


def log_hubspot_write(contact_id: str, payload: dict[str, Any]) -> None:
    hubspot_writes_log.appendleft(
        LogEntry(
            timestamp=utc_now_iso(),
            payload={"contact_id": contact_id, **payload},
        )
    )


def update_tableau_export(dataset: str, csv_body: str) -> dict[str, Any]:
    row_count = max(len(csv_body.splitlines()) - 1, 0)
    export = TableauExport(
        dataset=dataset,
        csv_body=csv_body if csv_body.endswith("\n") else f"{csv_body}\n",
        updated_at=utc_now_iso(),
        row_count=row_count,
    )
    tableau_exports[dataset] = export
    return {
        "dataset": dataset,
        "row_count": row_count,
        "updated_at": export.updated_at,
        "url": f"/exports/tableau/{dataset}.csv",
    }


def get_tableau_export(dataset: str) -> TableauExport | None:
    export = tableau_exports.get(dataset)
    if export is None or not export.updated_at:
        return None
    return export


def list_tableau_exports() -> dict[str, Any]:
    datasets: list[dict[str, Any]] = []
    for name in TABLEAU_DATASETS:
        export = tableau_exports[name]
        datasets.append(
            {
                "dataset": name,
                "url": f"/exports/tableau/{name}.csv",
                "updated_at": export.updated_at or None,
                "row_count": export.row_count,
                "ready": bool(export.updated_at),
            }
        )
    ready_count = sum(1 for item in datasets if item["ready"])
    return {
        "ready_datasets": ready_count,
        "total_datasets": len(TABLEAU_DATASETS),
        "datasets": datasets,
    }
