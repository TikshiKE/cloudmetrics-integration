-- =============================================================================
-- snowflake_account_info.sql
-- Запусти в Snowflake Worksheet → скопируй результат в Segment Account ID
-- =============================================================================

SELECT CURRENT_USER() AS username;
SELECT CURRENT_ACCOUNT() AS account_locator;
SELECT CURRENT_REGION() AS region;

-- Новые аккаунты (2024+): часто нужен формат ORG-ACCOUNT для Segment
SELECT CURRENT_ORGANIZATION_NAME() AS org_name;
SELECT CURRENT_ACCOUNT_NAME() AS account_name;

-- Полный идентификатор (если доступно)
SELECT SYSTEM$GET_SNOWFLAKE_PLATFORM_INFO() AS platform_info;
