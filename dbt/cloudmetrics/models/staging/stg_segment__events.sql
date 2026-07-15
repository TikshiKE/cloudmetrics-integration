with signed_up as (
    select
        id as event_id,
        'Signed Up' as event_name,
        user_id,
        cast(null as varchar) as anonymous_id,
        timestamp as event_timestamp,
        received_at,
        plan,
        company_size,
        cast(null as varchar) as actor_id,
        cast(null as number) as duration_sec,
        cast(null as boolean) as success,
        cast(null as varchar) as dashboard_id,
        cast(null as varchar) as from_plan,
        cast(null as varchar) as to_plan
    from {{ source('segment', 'signed_up') }}
),

actor_run_completed as (
    select
        id as event_id,
        'Actor Run Completed' as event_name,
        user_id,
        cast(null as varchar) as anonymous_id,
        timestamp as event_timestamp,
        received_at,
        cast(null as varchar) as plan,
        cast(null as number) as company_size,
        actor_id,
        duration_sec,
        success,
        cast(null as varchar) as dashboard_id,
        cast(null as varchar) as from_plan,
        cast(null as varchar) as to_plan
    from {{ source('segment', 'actor_run_completed') }}
),

dashboard_viewed as (
    select
        id as event_id,
        'Dashboard Viewed' as event_name,
        user_id,
        cast(null as varchar) as anonymous_id,
        timestamp as event_timestamp,
        received_at,
        cast(null as varchar) as plan,
        cast(null as number) as company_size,
        cast(null as varchar) as actor_id,
        cast(null as number) as duration_sec,
        cast(null as boolean) as success,
        dashboard_id,
        cast(null as varchar) as from_plan,
        cast(null as varchar) as to_plan
    from {{ source('segment', 'dashboard_viewed') }}
),

upgrade_clicked as (
    select
        id as event_id,
        'Upgrade Clicked' as event_name,
        user_id,
        cast(null as varchar) as anonymous_id,
        timestamp as event_timestamp,
        received_at,
        cast(null as varchar) as plan,
        cast(null as number) as company_size,
        cast(null as varchar) as actor_id,
        cast(null as number) as duration_sec,
        cast(null as boolean) as success,
        cast(null as varchar) as dashboard_id,
        from_plan,
        to_plan
    from {{ source('segment', 'upgrade_clicked') }}
),

unioned as (
    select * from signed_up
    union all
    select * from actor_run_completed
    union all
    select * from dashboard_viewed
    union all
    select * from upgrade_clicked
)

select
    event_id,
    event_name,
    coalesce(user_id, anonymous_id) as user_id,
    anonymous_id,
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
from unioned
where event_id is not null
