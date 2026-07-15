select
    conversation_id,
    contact_id as user_id,
    opened_at,
    resolved_at,
    lower(trim(status)) as status,
    resolved_at is not null as is_resolved
from {{ source('raw', 'intercom_conversations') }}
where conversation_id is not null
