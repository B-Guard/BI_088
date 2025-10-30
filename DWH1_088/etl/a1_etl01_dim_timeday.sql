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
    EXTRACT(ISODOW FROM d)::INT,   -- Monday = 1 ... Sunday = 7
    EXTRACT(MONTH FROM d)::INT,
    EXTRACT(YEAR FROM d)::INT,
    NOW()
FROM generate_series('2020-01-01'::date, '2025-12-31'::date, '1 day') AS d;




