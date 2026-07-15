-- Optional seed data when Segment destination is not connected yet

USE ROLE ACCOUNTADMIN;
USE WAREHOUSE DEV_WH;
USE DATABASE CLOUDMETRICS;
USE SCHEMA RAW;

TRUNCATE TABLE IF EXISTS SEGMENT_EVENTS;
TRUNCATE TABLE IF EXISTS HUBSPOT_CONTACTS;
TRUNCATE TABLE IF EXISTS INTERCOM_CONVERSATIONS;

-- HubSpot (subset aligned with data/hubspot_contacts.csv)
INSERT INTO HUBSPOT_CONTACTS (
    contact_id, email, company, plan, lifecycle_stage, company_size, updated_at
) VALUES
    ('user_001', 'user_001@example.com', 'Acme Labs', 'free', 'lead', 10, '2025-06-02T00:00:00Z'),
    ('user_002', 'user_002@example.com', 'DataForge', 'starter', 'marketingqualifiedlead', 50, '2025-06-03T00:00:00Z'),
    ('user_003', 'user_003@example.com', 'CloudNine', 'pro', 'salesqualifiedlead', 100, '2025-06-04T00:00:00Z'),
    ('user_004', 'user_004@example.com', 'MetricFlow', 'enterprise', 'customer', 250, '2025-06-05T00:00:00Z'),
    ('user_005', 'user_005@example.com', 'PipeStack', 'free', 'lead', 25, '2025-06-06T00:00:00Z');

-- Intercom (subset aligned with data/intercom_conversations.csv)
INSERT INTO INTERCOM_CONVERSATIONS (
    conversation_id, contact_id, opened_at, resolved_at, status
) VALUES
    ('conv_0001', 'user_001', '2025-06-16T10:00:00Z', '2025-06-16T21:00:00Z', 'closed'),
    ('conv_0002', 'user_002', '2025-06-17T12:00:00Z', NULL, 'open'),
    ('conv_0003', 'user_003', '2025-06-18T06:00:00Z', '2025-06-19T10:00:00Z', 'closed');

-- Segment events (aligned with tracking plan / PQA logic)
INSERT INTO SEGMENT_EVENTS (
    event_id, event_name, user_id, anonymous_id, timestamp, properties, context, received_at
) VALUES
(
    'evt_001_signed_up',
    'Signed Up',
    'user_002',
    NULL,
    '2025-07-10T09:00:00Z',
    PARSE_JSON('{"plan": "starter", "company_size": 50}'),
    PARSE_JSON('{"library": {"name": "analytics-python"}}'),
    '2025-07-10T09:00:01Z'
),
(
    'evt_002_actor_1',
    'Actor Run Completed',
    'user_002',
    NULL,
    '2025-07-11T10:00:00Z',
    PARSE_JSON('{"actor_id": "metrics-sync", "duration_sec": 45, "success": true}'),
    NULL,
    '2025-07-11T10:00:01Z'
),
(
    'evt_003_actor_2',
    'Actor Run Completed',
    'user_002',
    NULL,
    '2025-07-12T11:00:00Z',
    PARSE_JSON('{"actor_id": "data-export", "duration_sec": 30, "success": true}'),
    NULL,
    '2025-07-12T11:00:01Z'
),
(
    'evt_004_actor_3',
    'Actor Run Completed',
    'user_002',
    NULL,
    '2025-07-13T12:00:00Z',
    PARSE_JSON('{"actor_id": "etl-pipeline", "duration_sec": 60, "success": true}'),
    NULL,
    '2025-07-13T12:00:01Z'
),
(
    'evt_005_actor_4',
    'Actor Run Completed',
    'user_002',
    NULL,
    '2025-07-14T08:00:00Z',
    PARSE_JSON('{"actor_id": "alert-runner", "duration_sec": 20, "success": true}'),
    NULL,
    '2025-07-14T08:00:01Z'
),
(
    'evt_006_actor_5',
    'Actor Run Completed',
    'user_002',
    NULL,
    '2025-07-14T14:00:00Z',
    PARSE_JSON('{"actor_id": "metrics-sync", "duration_sec": 55, "success": true}'),
    NULL,
    '2025-07-14T14:00:01Z'
),
(
    'evt_007_dashboard_1',
    'Dashboard Viewed',
    'user_002',
    NULL,
    '2025-07-14T15:00:00Z',
    PARSE_JSON('{"dashboard_id": "overview"}'),
    NULL,
    '2025-07-14T15:00:01Z'
),
(
    'evt_008_dashboard_2',
    'Dashboard Viewed',
    'user_002',
    NULL,
    '2025-07-14T16:00:00Z',
    PARSE_JSON('{"dashboard_id": "usage"}'),
    NULL,
    '2025-07-14T16:00:01Z'
),
(
    'evt_009_dashboard_3',
    'Dashboard Viewed',
    'user_002',
    NULL,
    '2025-07-14T17:00:00Z',
    PARSE_JSON('{"dashboard_id": "billing"}'),
    NULL,
    '2025-07-14T17:00:01Z'
),
(
    'evt_010_upgrade',
    'Upgrade Clicked',
    'user_002',
    NULL,
    '2025-07-14T18:00:00Z',
    PARSE_JSON('{"from_plan": "starter", "to_plan": "pro"}'),
    NULL,
    '2025-07-14T18:00:01Z'
),
(
    'evt_011_signed_up',
    'Signed Up',
    'user_005',
    NULL,
    '2025-07-14T09:00:00Z',
    PARSE_JSON('{"plan": "free", "company_size": 25}'),
    NULL,
    '2025-07-14T09:00:01Z'
);

-- Verify row counts
SELECT 'SEGMENT_EVENTS' AS table_name, COUNT(*) AS row_count FROM SEGMENT_EVENTS
UNION ALL
SELECT 'HUBSPOT_CONTACTS', COUNT(*) FROM HUBSPOT_CONTACTS
UNION ALL
SELECT 'INTERCOM_CONVERSATIONS', COUNT(*) FROM INTERCOM_CONVERSATIONS;

-- Preview PQA candidate (user_002 should score high after dbt)
SELECT event_name, COUNT(*) AS events
FROM SEGMENT_EVENTS
WHERE user_id = 'user_002'
GROUP BY event_name
ORDER BY event_name;
