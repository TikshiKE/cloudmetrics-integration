-- Fallback load: HubSpot + Intercom CSV without Keboola
-- Run in Snowflake Worksheet after 02_create_raw_tables.sql

USE ROLE ACCOUNTADMIN;
USE WAREHOUSE DEV_WH;
USE DATABASE CLOUDMETRICS;
USE SCHEMA RAW;

TRUNCATE TABLE IF EXISTS HUBSPOT_CONTACTS;
TRUNCATE TABLE IF EXISTS INTERCOM_CONVERSATIONS;

INSERT INTO HUBSPOT_CONTACTS (contact_id, email, company, plan, lifecycle_stage, company_size, updated_at) VALUES ('user_001', 'user_001@example.com', 'Interflow 1', 'free', 'evangelist', 10, '2025-06-02T00:00:00Z'::TIMESTAMP_TZ);
INSERT INTO HUBSPOT_CONTACTS (contact_id, email, company, plan, lifecycle_stage, company_size, updated_at) VALUES ('user_002', 'user_002@example.com', 'Interflow 2', 'enterprise', 'marketingqualifiedlead', 25, '2025-06-03T00:00:00Z'::TIMESTAMP_TZ);
INSERT INTO HUBSPOT_CONTACTS (contact_id, email, company, plan, lifecycle_stage, company_size, updated_at) VALUES ('user_003', 'user_003@example.com', 'DataForge 3', 'free', 'salesqualifiedlead', 500, '2025-06-04T00:00:00Z'::TIMESTAMP_TZ);
INSERT INTO HUBSPOT_CONTACTS (contact_id, email, company, plan, lifecycle_stage, company_size, updated_at) VALUES ('user_004', 'user_004@example.com', 'Acme Labs 4', 'free', 'salesqualifiedlead', 100, '2025-06-05T00:00:00Z'::TIMESTAMP_TZ);
INSERT INTO HUBSPOT_CONTACTS (contact_id, email, company, plan, lifecycle_stage, company_size, updated_at) VALUES ('user_005', 'user_005@example.com', 'Interflow 5', 'enterprise', 'salesqualifiedlead', 10, '2025-06-06T00:00:00Z'::TIMESTAMP_TZ);
INSERT INTO HUBSPOT_CONTACTS (contact_id, email, company, plan, lifecycle_stage, company_size, updated_at) VALUES ('user_006', 'user_006@example.com', 'MetricFlow 6', 'starter', 'marketingqualifiedlead', 25, '2025-06-07T00:00:00Z'::TIMESTAMP_TZ);
INSERT INTO HUBSPOT_CONTACTS (contact_id, email, company, plan, lifecycle_stage, company_size, updated_at) VALUES ('user_007', 'user_007@example.com', 'MetricFlow 7', 'free', 'evangelist', 250, '2025-06-08T00:00:00Z'::TIMESTAMP_TZ);
INSERT INTO HUBSPOT_CONTACTS (contact_id, email, company, plan, lifecycle_stage, company_size, updated_at) VALUES ('user_008', 'user_008@example.com', 'CloudNine 8', 'pro', 'customer', 10, '2025-06-09T00:00:00Z'::TIMESTAMP_TZ);
INSERT INTO HUBSPOT_CONTACTS (contact_id, email, company, plan, lifecycle_stage, company_size, updated_at) VALUES ('user_009', 'user_009@example.com', 'Acme Labs 9', 'pro', 'customer', 50, '2025-06-10T00:00:00Z'::TIMESTAMP_TZ);
INSERT INTO HUBSPOT_CONTACTS (contact_id, email, company, plan, lifecycle_stage, company_size, updated_at) VALUES ('user_010', 'user_010@example.com', 'PipeStack 10', 'free', 'customer', 10, '2025-06-11T00:00:00Z'::TIMESTAMP_TZ);
INSERT INTO HUBSPOT_CONTACTS (contact_id, email, company, plan, lifecycle_stage, company_size, updated_at) VALUES ('user_011', 'user_011@example.com', 'SnowBridge 11', 'starter', 'evangelist', 5, '2025-06-12T00:00:00Z'::TIMESTAMP_TZ);
INSERT INTO HUBSPOT_CONTACTS (contact_id, email, company, plan, lifecycle_stage, company_size, updated_at) VALUES ('user_012', 'user_012@example.com', 'CloudNine 12', 'enterprise', 'marketingqualifiedlead', 500, '2025-06-13T00:00:00Z'::TIMESTAMP_TZ);
INSERT INTO HUBSPOT_CONTACTS (contact_id, email, company, plan, lifecycle_stage, company_size, updated_at) VALUES ('user_013', 'user_013@example.com', 'SnowBridge 13', 'starter', 'marketingqualifiedlead', 250, '2025-06-14T00:00:00Z'::TIMESTAMP_TZ);
INSERT INTO HUBSPOT_CONTACTS (contact_id, email, company, plan, lifecycle_stage, company_size, updated_at) VALUES ('user_014', 'user_014@example.com', 'Segmentia 14', 'enterprise', 'customer', 5, '2025-06-15T00:00:00Z'::TIMESTAMP_TZ);
INSERT INTO HUBSPOT_CONTACTS (contact_id, email, company, plan, lifecycle_stage, company_size, updated_at) VALUES ('user_015', 'user_015@example.com', 'ETL Works 15', 'starter', 'lead', 10, '2025-06-16T00:00:00Z'::TIMESTAMP_TZ);
INSERT INTO HUBSPOT_CONTACTS (contact_id, email, company, plan, lifecycle_stage, company_size, updated_at) VALUES ('user_016', 'user_016@example.com', 'Segmentia 16', 'enterprise', 'evangelist', 25, '2025-06-17T00:00:00Z'::TIMESTAMP_TZ);
INSERT INTO HUBSPOT_CONTACTS (contact_id, email, company, plan, lifecycle_stage, company_size, updated_at) VALUES ('user_017', 'user_017@example.com', 'Acme Labs 17', 'pro', 'customer', 100, '2025-06-18T00:00:00Z'::TIMESTAMP_TZ);
INSERT INTO HUBSPOT_CONTACTS (contact_id, email, company, plan, lifecycle_stage, company_size, updated_at) VALUES ('user_018', 'user_018@example.com', 'PipeStack 18', 'enterprise', 'evangelist', 10, '2025-06-19T00:00:00Z'::TIMESTAMP_TZ);
INSERT INTO HUBSPOT_CONTACTS (contact_id, email, company, plan, lifecycle_stage, company_size, updated_at) VALUES ('user_019', 'user_019@example.com', 'Segmentia 19', 'pro', 'evangelist', 50, '2025-06-20T00:00:00Z'::TIMESTAMP_TZ);
INSERT INTO HUBSPOT_CONTACTS (contact_id, email, company, plan, lifecycle_stage, company_size, updated_at) VALUES ('user_020', 'user_020@example.com', 'CloudNine 20', 'pro', 'marketingqualifiedlead', 10, '2025-06-21T00:00:00Z'::TIMESTAMP_TZ);
INSERT INTO HUBSPOT_CONTACTS (contact_id, email, company, plan, lifecycle_stage, company_size, updated_at) VALUES ('user_021', 'user_021@example.com', 'DataForge 21', 'enterprise', 'lead', 50, '2025-06-22T00:00:00Z'::TIMESTAMP_TZ);
INSERT INTO HUBSPOT_CONTACTS (contact_id, email, company, plan, lifecycle_stage, company_size, updated_at) VALUES ('user_022', 'user_022@example.com', 'CloudNine 22', 'pro', 'evangelist', 250, '2025-06-23T00:00:00Z'::TIMESTAMP_TZ);
INSERT INTO HUBSPOT_CONTACTS (contact_id, email, company, plan, lifecycle_stage, company_size, updated_at) VALUES ('user_023', 'user_023@example.com', 'CloudNine 23', 'pro', 'salesqualifiedlead', 250, '2025-06-24T00:00:00Z'::TIMESTAMP_TZ);
INSERT INTO HUBSPOT_CONTACTS (contact_id, email, company, plan, lifecycle_stage, company_size, updated_at) VALUES ('user_024', 'user_024@example.com', 'PipeStack 24', 'free', 'lead', 100, '2025-06-25T00:00:00Z'::TIMESTAMP_TZ);
INSERT INTO HUBSPOT_CONTACTS (contact_id, email, company, plan, lifecycle_stage, company_size, updated_at) VALUES ('user_025', 'user_025@example.com', 'DataForge 25', 'free', 'marketingqualifiedlead', 25, '2025-06-26T00:00:00Z'::TIMESTAMP_TZ);
INSERT INTO HUBSPOT_CONTACTS (contact_id, email, company, plan, lifecycle_stage, company_size, updated_at) VALUES ('user_026', 'user_026@example.com', 'Segmentia 26', 'pro', 'marketingqualifiedlead', 5, '2025-06-27T00:00:00Z'::TIMESTAMP_TZ);
INSERT INTO HUBSPOT_CONTACTS (contact_id, email, company, plan, lifecycle_stage, company_size, updated_at) VALUES ('user_027', 'user_027@example.com', 'Acme Labs 27', 'pro', 'lead', 250, '2025-06-28T00:00:00Z'::TIMESTAMP_TZ);
INSERT INTO HUBSPOT_CONTACTS (contact_id, email, company, plan, lifecycle_stage, company_size, updated_at) VALUES ('user_028', 'user_028@example.com', 'ETL Works 28', 'free', 'marketingqualifiedlead', 5, '2025-06-29T00:00:00Z'::TIMESTAMP_TZ);
INSERT INTO HUBSPOT_CONTACTS (contact_id, email, company, plan, lifecycle_stage, company_size, updated_at) VALUES ('user_029', 'user_029@example.com', 'Segmentia 29', 'free', 'customer', 250, '2025-06-30T00:00:00Z'::TIMESTAMP_TZ);
INSERT INTO HUBSPOT_CONTACTS (contact_id, email, company, plan, lifecycle_stage, company_size, updated_at) VALUES ('user_030', 'user_030@example.com', 'Acme Labs 30', 'pro', 'evangelist', 5, '2025-07-01T00:00:00Z'::TIMESTAMP_TZ);
INSERT INTO HUBSPOT_CONTACTS (contact_id, email, company, plan, lifecycle_stage, company_size, updated_at) VALUES ('user_031', 'user_031@example.com', 'PipeStack 31', 'enterprise', 'customer', 25, '2025-07-02T00:00:00Z'::TIMESTAMP_TZ);
INSERT INTO HUBSPOT_CONTACTS (contact_id, email, company, plan, lifecycle_stage, company_size, updated_at) VALUES ('user_032', 'user_032@example.com', 'HubSync 32', 'enterprise', 'lead', 100, '2025-07-03T00:00:00Z'::TIMESTAMP_TZ);
INSERT INTO HUBSPOT_CONTACTS (contact_id, email, company, plan, lifecycle_stage, company_size, updated_at) VALUES ('user_033', 'user_033@example.com', 'SnowBridge 33', 'starter', 'marketingqualifiedlead', 5, '2025-07-04T00:00:00Z'::TIMESTAMP_TZ);
INSERT INTO HUBSPOT_CONTACTS (contact_id, email, company, plan, lifecycle_stage, company_size, updated_at) VALUES ('user_034', 'user_034@example.com', 'Acme Labs 34', 'pro', 'lead', 25, '2025-07-05T00:00:00Z'::TIMESTAMP_TZ);
INSERT INTO HUBSPOT_CONTACTS (contact_id, email, company, plan, lifecycle_stage, company_size, updated_at) VALUES ('user_035', 'user_035@example.com', 'PipeStack 35', 'free', 'salesqualifiedlead', 50, '2025-07-06T00:00:00Z'::TIMESTAMP_TZ);
INSERT INTO HUBSPOT_CONTACTS (contact_id, email, company, plan, lifecycle_stage, company_size, updated_at) VALUES ('user_036', 'user_036@example.com', 'PipeStack 36', 'pro', 'customer', 25, '2025-07-07T00:00:00Z'::TIMESTAMP_TZ);
INSERT INTO HUBSPOT_CONTACTS (contact_id, email, company, plan, lifecycle_stage, company_size, updated_at) VALUES ('user_037', 'user_037@example.com', 'SnowBridge 37', 'free', 'customer', 50, '2025-07-08T00:00:00Z'::TIMESTAMP_TZ);
INSERT INTO HUBSPOT_CONTACTS (contact_id, email, company, plan, lifecycle_stage, company_size, updated_at) VALUES ('user_038', 'user_038@example.com', 'DataForge 38', 'pro', 'customer', 500, '2025-07-09T00:00:00Z'::TIMESTAMP_TZ);
INSERT INTO HUBSPOT_CONTACTS (contact_id, email, company, plan, lifecycle_stage, company_size, updated_at) VALUES ('user_039', 'user_039@example.com', 'Acme Labs 39', 'starter', 'marketingqualifiedlead', 250, '2025-07-10T00:00:00Z'::TIMESTAMP_TZ);
INSERT INTO HUBSPOT_CONTACTS (contact_id, email, company, plan, lifecycle_stage, company_size, updated_at) VALUES ('user_040', 'user_040@example.com', 'MetricFlow 40', 'starter', 'lead', 10, '2025-07-11T00:00:00Z'::TIMESTAMP_TZ);
INSERT INTO HUBSPOT_CONTACTS (contact_id, email, company, plan, lifecycle_stage, company_size, updated_at) VALUES ('user_041', 'user_041@example.com', 'SnowBridge 41', 'free', 'marketingqualifiedlead', 5, '2025-07-12T00:00:00Z'::TIMESTAMP_TZ);
INSERT INTO HUBSPOT_CONTACTS (contact_id, email, company, plan, lifecycle_stage, company_size, updated_at) VALUES ('user_042', 'user_042@example.com', 'ETL Works 42', 'free', 'evangelist', 250, '2025-07-13T00:00:00Z'::TIMESTAMP_TZ);
INSERT INTO HUBSPOT_CONTACTS (contact_id, email, company, plan, lifecycle_stage, company_size, updated_at) VALUES ('user_043', 'user_043@example.com', 'CloudNine 43', 'starter', 'lead', 25, '2025-07-14T00:00:00Z'::TIMESTAMP_TZ);
INSERT INTO HUBSPOT_CONTACTS (contact_id, email, company, plan, lifecycle_stage, company_size, updated_at) VALUES ('user_044', 'user_044@example.com', 'SnowBridge 44', 'starter', 'customer', 10, '2025-07-15T00:00:00Z'::TIMESTAMP_TZ);
INSERT INTO HUBSPOT_CONTACTS (contact_id, email, company, plan, lifecycle_stage, company_size, updated_at) VALUES ('user_045', 'user_045@example.com', 'Interflow 45', 'free', 'customer', 5, '2025-07-16T00:00:00Z'::TIMESTAMP_TZ);
INSERT INTO HUBSPOT_CONTACTS (contact_id, email, company, plan, lifecycle_stage, company_size, updated_at) VALUES ('user_046', 'user_046@example.com', 'MetricFlow 46', 'starter', 'lead', 10, '2025-07-17T00:00:00Z'::TIMESTAMP_TZ);
INSERT INTO HUBSPOT_CONTACTS (contact_id, email, company, plan, lifecycle_stage, company_size, updated_at) VALUES ('user_047', 'user_047@example.com', 'PipeStack 47', 'free', 'lead', 100, '2025-07-18T00:00:00Z'::TIMESTAMP_TZ);
INSERT INTO HUBSPOT_CONTACTS (contact_id, email, company, plan, lifecycle_stage, company_size, updated_at) VALUES ('user_048', 'user_048@example.com', 'Acme Labs 48', 'starter', 'salesqualifiedlead', 50, '2025-07-19T00:00:00Z'::TIMESTAMP_TZ);
INSERT INTO HUBSPOT_CONTACTS (contact_id, email, company, plan, lifecycle_stage, company_size, updated_at) VALUES ('user_049', 'user_049@example.com', 'Acme Labs 49', 'free', 'evangelist', 100, '2025-07-20T00:00:00Z'::TIMESTAMP_TZ);
INSERT INTO HUBSPOT_CONTACTS (contact_id, email, company, plan, lifecycle_stage, company_size, updated_at) VALUES ('user_050', 'user_050@example.com', 'Acme Labs 50', 'enterprise', 'marketingqualifiedlead', 5, '2025-07-21T00:00:00Z'::TIMESTAMP_TZ);

INSERT INTO INTERCOM_CONVERSATIONS (conversation_id, contact_id, opened_at, resolved_at, status) VALUES ('conv_0001', 'user_037', '2025-06-16T10:00:00Z'::TIMESTAMP_TZ, '2025-06-16T21:00:00Z'::TIMESTAMP_TZ, 'snoozed');
INSERT INTO INTERCOM_CONVERSATIONS (conversation_id, contact_id, opened_at, resolved_at, status) VALUES ('conv_0002', 'user_001', '2025-06-17T12:00:00Z'::TIMESTAMP_TZ, '2025-06-18T01:00:00Z'::TIMESTAMP_TZ, 'closed');
INSERT INTO INTERCOM_CONVERSATIONS (conversation_id, contact_id, opened_at, resolved_at, status) VALUES ('conv_0003', 'user_021', '2025-06-18T06:00:00Z'::TIMESTAMP_TZ, '2025-06-19T10:00:00Z'::TIMESTAMP_TZ, 'closed');
INSERT INTO INTERCOM_CONVERSATIONS (conversation_id, contact_id, opened_at, resolved_at, status) VALUES ('conv_0004', 'user_015', '2025-06-19T09:00:00Z'::TIMESTAMP_TZ, '2025-06-21T02:00:00Z'::TIMESTAMP_TZ, 'open');
INSERT INTO INTERCOM_CONVERSATIONS (conversation_id, contact_id, opened_at, resolved_at, status) VALUES ('conv_0005', 'user_018', '2025-06-20T00:00:00Z'::TIMESTAMP_TZ, '2025-06-20T14:00:00Z'::TIMESTAMP_TZ, 'closed');
INSERT INTO INTERCOM_CONVERSATIONS (conversation_id, contact_id, opened_at, resolved_at, status) VALUES ('conv_0006', 'user_048', '2025-06-21T10:00:00Z'::TIMESTAMP_TZ, '2025-06-21T22:00:00Z'::TIMESTAMP_TZ, 'snoozed');
INSERT INTO INTERCOM_CONVERSATIONS (conversation_id, contact_id, opened_at, resolved_at, status) VALUES ('conv_0007', 'user_001', '2025-06-22T11:00:00Z'::TIMESTAMP_TZ, NULL, 'open');
INSERT INTO INTERCOM_CONVERSATIONS (conversation_id, contact_id, opened_at, resolved_at, status) VALUES ('conv_0008', 'user_021', '2025-06-23T12:00:00Z'::TIMESTAMP_TZ, '2025-06-24T07:00:00Z'::TIMESTAMP_TZ, 'snoozed');
INSERT INTO INTERCOM_CONVERSATIONS (conversation_id, contact_id, opened_at, resolved_at, status) VALUES ('conv_0009', 'user_016', '2025-06-24T04:00:00Z'::TIMESTAMP_TZ, NULL, 'open');
INSERT INTO INTERCOM_CONVERSATIONS (conversation_id, contact_id, opened_at, resolved_at, status) VALUES ('conv_0010', 'user_050', '2025-06-25T03:00:00Z'::TIMESTAMP_TZ, NULL, 'snoozed');
INSERT INTO INTERCOM_CONVERSATIONS (conversation_id, contact_id, opened_at, resolved_at, status) VALUES ('conv_0011', 'user_015', '2025-06-26T08:00:00Z'::TIMESTAMP_TZ, '2025-06-27T23:00:00Z'::TIMESTAMP_TZ, 'open');
INSERT INTO INTERCOM_CONVERSATIONS (conversation_id, contact_id, opened_at, resolved_at, status) VALUES ('conv_0012', 'user_029', '2025-06-27T04:00:00Z'::TIMESTAMP_TZ, '2025-06-28T13:00:00Z'::TIMESTAMP_TZ, 'closed');
INSERT INTO INTERCOM_CONVERSATIONS (conversation_id, contact_id, opened_at, resolved_at, status) VALUES ('conv_0013', 'user_048', '2025-06-28T09:00:00Z'::TIMESTAMP_TZ, '2025-06-29T07:00:00Z'::TIMESTAMP_TZ, 'closed');
INSERT INTO INTERCOM_CONVERSATIONS (conversation_id, contact_id, opened_at, resolved_at, status) VALUES ('conv_0014', 'user_038', '2025-06-29T01:00:00Z'::TIMESTAMP_TZ, '2025-06-30T12:00:00Z'::TIMESTAMP_TZ, 'snoozed');
INSERT INTO INTERCOM_CONVERSATIONS (conversation_id, contact_id, opened_at, resolved_at, status) VALUES ('conv_0015', 'user_008', '2025-06-30T04:00:00Z'::TIMESTAMP_TZ, NULL, 'snoozed');
INSERT INTO INTERCOM_CONVERSATIONS (conversation_id, contact_id, opened_at, resolved_at, status) VALUES ('conv_0016', 'user_025', '2025-07-01T07:00:00Z'::TIMESTAMP_TZ, '2025-07-02T14:00:00Z'::TIMESTAMP_TZ, 'open');
INSERT INTO INTERCOM_CONVERSATIONS (conversation_id, contact_id, opened_at, resolved_at, status) VALUES ('conv_0017', 'user_010', '2025-07-02T07:00:00Z'::TIMESTAMP_TZ, '2025-07-03T19:00:00Z'::TIMESTAMP_TZ, 'open');
INSERT INTO INTERCOM_CONVERSATIONS (conversation_id, contact_id, opened_at, resolved_at, status) VALUES ('conv_0018', 'user_049', '2025-07-03T02:00:00Z'::TIMESTAMP_TZ, '2025-07-04T14:00:00Z'::TIMESTAMP_TZ, 'closed');
INSERT INTO INTERCOM_CONVERSATIONS (conversation_id, contact_id, opened_at, resolved_at, status) VALUES ('conv_0019', 'user_037', '2025-07-04T00:00:00Z'::TIMESTAMP_TZ, '2025-07-04T10:00:00Z'::TIMESTAMP_TZ, 'snoozed');
INSERT INTO INTERCOM_CONVERSATIONS (conversation_id, contact_id, opened_at, resolved_at, status) VALUES ('conv_0020', 'user_018', '2025-07-05T07:00:00Z'::TIMESTAMP_TZ, '2025-07-05T08:00:00Z'::TIMESTAMP_TZ, 'snoozed');
INSERT INTO INTERCOM_CONVERSATIONS (conversation_id, contact_id, opened_at, resolved_at, status) VALUES ('conv_0021', 'user_020', '2025-07-06T07:00:00Z'::TIMESTAMP_TZ, '2025-07-07T13:00:00Z'::TIMESTAMP_TZ, 'open');
INSERT INTO INTERCOM_CONVERSATIONS (conversation_id, contact_id, opened_at, resolved_at, status) VALUES ('conv_0022', 'user_031', '2025-07-07T05:00:00Z'::TIMESTAMP_TZ, '2025-07-08T04:00:00Z'::TIMESTAMP_TZ, 'open');
INSERT INTO INTERCOM_CONVERSATIONS (conversation_id, contact_id, opened_at, resolved_at, status) VALUES ('conv_0023', 'user_024', '2025-07-08T00:00:00Z'::TIMESTAMP_TZ, '2025-07-09T09:00:00Z'::TIMESTAMP_TZ, 'open');
INSERT INTO INTERCOM_CONVERSATIONS (conversation_id, contact_id, opened_at, resolved_at, status) VALUES ('conv_0024', 'user_040', '2025-07-09T03:00:00Z'::TIMESTAMP_TZ, '2025-07-10T12:00:00Z'::TIMESTAMP_TZ, 'open');
INSERT INTO INTERCOM_CONVERSATIONS (conversation_id, contact_id, opened_at, resolved_at, status) VALUES ('conv_0025', 'user_016', '2025-07-10T00:00:00Z'::TIMESTAMP_TZ, NULL, 'snoozed');
INSERT INTO INTERCOM_CONVERSATIONS (conversation_id, contact_id, opened_at, resolved_at, status) VALUES ('conv_0026', 'user_011', '2025-07-11T09:00:00Z'::TIMESTAMP_TZ, '2025-07-12T01:00:00Z'::TIMESTAMP_TZ, 'open');
INSERT INTO INTERCOM_CONVERSATIONS (conversation_id, contact_id, opened_at, resolved_at, status) VALUES ('conv_0027', 'user_008', '2025-07-12T02:00:00Z'::TIMESTAMP_TZ, '2025-07-13T09:00:00Z'::TIMESTAMP_TZ, 'closed');
INSERT INTO INTERCOM_CONVERSATIONS (conversation_id, contact_id, opened_at, resolved_at, status) VALUES ('conv_0028', 'user_047', '2025-07-13T02:00:00Z'::TIMESTAMP_TZ, '2025-07-14T23:00:00Z'::TIMESTAMP_TZ, 'snoozed');
INSERT INTO INTERCOM_CONVERSATIONS (conversation_id, contact_id, opened_at, resolved_at, status) VALUES ('conv_0029', 'user_050', '2025-07-14T05:00:00Z'::TIMESTAMP_TZ, '2025-07-16T03:00:00Z'::TIMESTAMP_TZ, 'snoozed');
INSERT INTO INTERCOM_CONVERSATIONS (conversation_id, contact_id, opened_at, resolved_at, status) VALUES ('conv_0030', 'user_036', '2025-07-15T06:00:00Z'::TIMESTAMP_TZ, '2025-07-15T21:00:00Z'::TIMESTAMP_TZ, 'closed');

SELECT 'HUBSPOT_CONTACTS' AS t, COUNT(*) FROM HUBSPOT_CONTACTS
UNION ALL
SELECT 'INTERCOM_CONVERSATIONS', COUNT(*) FROM INTERCOM_CONVERSATIONS;