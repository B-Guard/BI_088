-- Make A1 dwh_xxx, stg_xxx schemas the default for this session
SET
search_path TO dwh_088, stg_088;

-- =======================================
-- Load dim_timeday
-- =======================================

-- Step 1: Truncate target table, the dim_timeday in this case
TRUNCATE TABLE dim_timeday RESTART IDENTITY CASCADE;

-- Step 2: Insert data into the dim_timeday
INSERT INTO dim_timeday (datekey, date, dayofweek, month, year, etl_load_timestamp)
SELECT
    TO_CHAR(d, 'YYYYMMDD')::INT,
    d,
    EXTRACT(ISODOW FROM d)::INT,
    EXTRACT(MONTH FROM d)::INT,
    EXTRACT(YEAR FROM d)::INT,
    NOW()
FROM (
    SELECT DISTINCT readat AS d FROM tb_readingevent
    UNION
    SELECT DISTINCT servicedat AS d FROM tb_serviceevent
    UNION
    SELECT DISTINCT observedat AS d FROM tb_weather
) AS dates
WHERE d IS NOT NULL;




