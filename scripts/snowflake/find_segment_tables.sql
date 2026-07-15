-- =============================================================================
-- find_segment_tables.sql — где Segment реально пишет данные
-- =============================================================================
-- Segment НЕ пишет в RAW.SEGMENT_EVENTS (это наша таблица для Keboola/fallback).
-- Destination создаёт СВОИ таблицы в указанной schema (часто TRACKS, USERS, и т.д.)
-- =============================================================================

USE DATABASE CLOUDMETRICS;

-- 1. Все схемы
SHOW SCHEMAS IN DATABASE CLOUDMETRICS;

-- 2. Все таблицы во всех user-схемах
SELECT table_schema, table_name, row_count, created
FROM CLOUDMETRICS.INFORMATION_SCHEMA.TABLES
WHERE table_schema NOT IN ('INFORMATION_SCHEMA')
ORDER BY created DESC;

-- 3. Если есть schema PUBLIC или SEGMENT — смотри таблицы
-- SHOW TABLES IN SCHEMA CLOUDMETRICS.PUBLIC;
-- SHOW TABLES IN SCHEMA CLOUDMETRICS.RAW;

-- 4. Типичные имена Segment (подставь schema из шага 2)
-- SELECT * FROM CLOUDMETRICS.PUBLIC.TRACKS LIMIT 10;
-- SELECT * FROM CLOUDMETRICS.RAW.TRACKS LIMIT 10;

-- 5. Наша ручная таблица (скорее всего пустая — это нормально)
SELECT COUNT(*) AS our_manual_table_rows FROM CLOUDMETRICS.RAW.SEGMENT_EVENTS;
