from collections import deque
from dataclasses import dataclass, field
from datetime import datetime, timezone
from typing import Any


@dataclass
class LogEntry:
    timestamp: str
    payload: dict[str, Any]


segment_events_log: deque[LogEntry] = deque(maxlen=100)
hubspot_writes_log: deque[LogEntry] = deque(maxlen=100)


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
