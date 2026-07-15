with user_ids as (
    select contact_id as user_id from {{ ref('stg_hubspot__contacts') }}
    union
    select user_id from {{ ref('stg_segment__events') }} where user_id is not null
),

hubspot as (
    select * from {{ ref('stg_hubspot__contacts') }}
),

latest_signup as (
    select
        user_id,
        plan as segment_plan,
        company_size as segment_company_size,
        event_timestamp as signed_up_at
    from {{ ref('stg_segment__events') }}
    where event_name = 'Signed Up'
    qualify row_number() over (partition by user_id order by event_timestamp desc) = 1
),

intercom_stats as (
    select
        user_id,
        count(*) as conversation_count,
        count_if(not is_resolved) as open_conversations
    from {{ ref('stg_intercom__conversations') }}
    group by 1
)

select
    u.user_id,
    h.email,
    coalesce(h.company, 'Unknown') as company,
    coalesce(h.plan, ls.segment_plan, 'free') as plan,
    h.lifecycle_stage,
    coalesce(h.company_size, ls.segment_company_size) as company_size,
    ls.signed_up_at,
    coalesce(i.conversation_count, 0) as intercom_conversation_count,
    coalesce(i.open_conversations, 0) as intercom_open_conversations
from user_ids u
left join hubspot h on u.user_id = h.contact_id
left join latest_signup ls on u.user_id = ls.user_id
left join intercom_stats i on u.user_id = i.user_id
