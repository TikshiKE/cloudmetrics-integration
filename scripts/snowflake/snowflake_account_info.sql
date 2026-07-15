-- Snowflake account identifiers (for Segment destination setup)

SELECT CURRENT_USER() AS username;
SELECT CURRENT_ACCOUNT() AS account_locator;
SELECT CURRENT_REGION() AS region;
SELECT CURRENT_ORGANIZATION_NAME() AS org_name;
SELECT CURRENT_ACCOUNT_NAME() AS account_name;
