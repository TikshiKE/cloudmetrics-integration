import logging
from typing import Any

import segment.analytics as analytics

from app.config import settings
from app.state import log_segment_event

logger = logging.getLogger(__name__)

_initialized = False


def init_segment() -> None:
    global _initialized
    if _initialized:
        return
    if settings.segment_enabled:
        analytics.write_key = settings.segment_write_key
        analytics.on_error = _on_error
        logger.info("Segment client initialized")
    else:
        logger.warning("SEGMENT_WRITE_KEY not set — events logged locally only")
    _initialized = True


def _on_error(error: Exception, items: list) -> None:
    logger.error("Segment error: %s (batch size %s)", error, len(items))


def identify(user_id: str, traits: dict[str, Any]) -> None:
    init_segment()
    if settings.segment_enabled:
        analytics.identify(user_id, traits)
        analytics.flush()
    log_segment_event(user_id, "identify", {"traits": traits})


def track(user_id: str, event_name: str, properties: dict[str, Any] | None = None) -> None:
    init_segment()
    props = properties or {}
    if settings.segment_enabled:
        analytics.track(user_id, event_name, props)
        analytics.flush()
    log_segment_event(user_id, event_name, props)
