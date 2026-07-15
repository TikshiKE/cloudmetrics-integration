select
    contact_id,
    lower(trim(email)) as email,
    company,
    lower(trim(plan)) as plan,
    lifecycle_stage,
    company_size,
    updated_at
from {{ source('raw', 'hubspot_contacts') }}
where contact_id is not null
