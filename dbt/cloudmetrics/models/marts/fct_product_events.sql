select
    event_id,
    user_id,
    anonymous_id,
    event_name,
    event_timestamp,
    received_at,
    plan,
    company_size,
    actor_id,
    duration_sec,
    success,
    dashboard_id,
    from_plan,
    to_plan
from {{ ref('stg_segment__events') }}
where user_id is not null
