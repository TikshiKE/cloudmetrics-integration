with upgrade_ever as (
    select
        user_id,
        true as upgrade_clicked_ever
    from {{ ref('stg_segment__events') }}
    where event_name = 'Upgrade Clicked'
      and user_id is not null
    group by 1
),

scored as (
    select
        d.user_id,
        d.email,
        d.company,
        d.plan,
        d.company_size,
        coalesce(a.actor_runs_7d, 0) as actor_runs_7d,
        coalesce(a.dashboard_views_7d, 0) as dashboard_views_7d,
        coalesce(u.upgrade_clicked_ever, false) as upgrade_clicked_ever,
        (
            iff(coalesce(a.actor_runs_7d, 0) >= 5, 30,
                iff(coalesce(a.actor_runs_7d, 0) >= 2, 15, 0))
            + iff(coalesce(a.dashboard_views_7d, 0) >= 3, 20,
                iff(coalesce(a.dashboard_views_7d, 0) >= 1, 10, 0))
            + iff(coalesce(u.upgrade_clicked_ever, false), 20, 0)
            + iff(coalesce(d.company_size, 0) >= 100, 30,
                iff(coalesce(d.company_size, 0) >= 50, 15,
                    iff(coalesce(d.company_size, 0) >= 25, 5, 0)))
            + case lower(coalesce(d.plan, 'free'))
                when 'enterprise' then 15
                when 'pro' then 10
                when 'starter' then 5
                else 0
              end
        ) as pqa_score_raw
    from {{ ref('dim_users') }} d
    left join {{ ref('int_user_activity_7d') }} a on d.user_id = a.user_id
    left join upgrade_ever u on d.user_id = u.user_id
    where d.email is not null
      and trim(d.email) != ''
)

select
    user_id,
    email,
    company,
    plan,
    company_size,
    actor_runs_7d,
    dashboard_views_7d,
    upgrade_clicked_ever,
    least(pqa_score_raw, 100) as pqa_score,
    case
        when least(pqa_score_raw, 100) >= 70 then 'hot'
        when least(pqa_score_raw, 100) >= 40 then 'warm'
        else 'cold'
    end as pqa_tier,
    current_timestamp() as calculated_at
from scored
