-- RAW layer tables for HubSpot and Intercom CSV loads

USE ROLE ACCOUNTADMIN;
USE WAREHOUSE DEV_WH;
USE DATABASE CLOUDMETRICS;
USE SCHEMA RAW;

-- Segment behavioral events (CDP → Snowflake or Keboola CSV fallback)
CREATE OR REPLACE TABLE SEGMENT_EVENTS (
    event_id        VARCHAR(256)   NOT NULL,
    event_name      VARCHAR(256)   NOT NULL,
    user_id         VARCHAR(256),
    anonymous_id    VARCHAR(256),
    timestamp       TIMESTAMP_TZ   NOT NULL,
    properties      VARIANT,
    context         VARIANT,
    received_at     TIMESTAMP_TZ   DEFAULT CURRENT_TIMESTAMP(),
    CONSTRAINT pk_segment_events PRIMARY KEY (event_id)
)
COMMENT = 'Raw Segment track events — see docs/tracking-plan.md';

-- HubSpot CRM contacts (Keboola E+L from data/hubspot_contacts.csv)
CREATE OR REPLACE TABLE HUBSPOT_CONTACTS (
    contact_id        VARCHAR(64)    NOT NULL,
    email             VARCHAR(256)   NOT NULL,
    company           VARCHAR(256),
    plan              VARCHAR(64),
    lifecycle_stage   VARCHAR(128),
    company_size      INTEGER,
    updated_at        TIMESTAMP_TZ,
    CONSTRAINT pk_hubspot_contacts PRIMARY KEY (contact_id)
)
COMMENT = 'HubSpot contacts from Keboola';

-- Intercom support conversations (Keboola E+L from data/intercom_conversations.csv)
CREATE OR REPLACE TABLE INTERCOM_CONVERSATIONS (
    conversation_id   VARCHAR(64)    NOT NULL,
    contact_id        VARCHAR(64)    NOT NULL,
    opened_at         TIMESTAMP_TZ   NOT NULL,
    resolved_at       TIMESTAMP_TZ,
    status            VARCHAR(32),
    CONSTRAINT pk_intercom_conversations PRIMARY KEY (conversation_id)
)
COMMENT = 'Intercom conversations from Keboola';

-- Verify
SHOW TABLES IN SCHEMA CLOUDMETRICS.RAW;

DESCRIBE TABLE SEGMENT_EVENTS;
DESCRIBE TABLE HUBSPOT_CONTACTS;
DESCRIBE TABLE INTERCOM_CONVERSATIONS;
