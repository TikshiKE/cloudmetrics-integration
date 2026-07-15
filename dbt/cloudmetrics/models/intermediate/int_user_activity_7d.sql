select
    user_id,
    count_if(event_name = 'Actor Run Completed') as actor_runs_7d,
    count_if(event_name = 'Dashboard Viewed') as dashboard_views_7d,
    max(event_timestamp) as last_event_at
from {{ ref('stg_segment__events') }}
where user_id is not null
  and event_timestamp >= dateadd(day, -7, current_timestamp())
group by 1
