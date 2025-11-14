-- Assignment 2 ETL: ft_param_city_month
-- GRAIN: month_key × city_key × param_key
-- EXAMPLE SHAPE (sketch only):
-- TRUNCATE TABLE ft_param_city_month;
-- WITH cte1 AS (...),
--      cte2 AS (...),
--      cte3 AS (...),
--      ... AS (...),
--      final_cte AS (...)
-- INSERT INTO ft_param_city_month (...columns...)
-- SELECT ... FROM final_cte;
-- Make A2 dwh2_088, stg2_088 schemas the default for this session
SET search_path TO dwh2_088,
    stg2_088;

-- =======================================
-- Load ft_param_city_month
-- =======================================
-- Step 1: Truncate target table - ft_param_city_month
TRUNCATE TABLE ft_param_city_month RESTART IDENTITY CASCADE;

INSERT INTO ft_param_city_month (
        month_key,
        city_key,
        param_key,
        alertpeak_key,
        reading_events_count,
        devices_reporting_count,
        recordedvalue_avg,
        recordedvalue_p95,
        -- count of distinct days in the month where the daily peak 
        -- alert for the city & param reached at least Yellow
        exceed_days_any,
        data_volume_kb_sum,
        data_quality_avg,
        missing_days,
        etl_load_ts
    )
SELECT mk.month_key,
    dc.city_key,
    dp.param_key,
    1, --ap.alertpeak_key,
    2, -- TODO
    COUNT(DISTINCT tre.sensordevid) AS devices_reporting_count,
    AVG(tre.recordedvalue) AS recordedvalue_avg,
    PERCENTILE_CONT(0.95) WITHIN GROUP (
        ORDER BY tre.recordedvalue
    ) AS recordedvalue_p95,
    3, -- TODO
    SUM(tre.datavolumekb) AS data_volume_kb_sum,
    AVG(tre.dataquality) AS data_quality_avg,
    mk.days_in_month - COUNT(DISTINCT DATE_TRUNC('day', tre.readat)) AS missing_days,
    NOW() AS etl_load_ts
FROM tb_readingevent tre
    JOIN dim_timemonth mk ON TO_CHAR(tre.readat, 'YYYYMM')::INTEGER = mk.month_key
        JOIN tb_sensordevice tc ON tre.sensordevid = tc.id
        JOIN tb_city tci ON tc.cityid = tci.id
        JOIN dim_city dc ON tci.cityname = dc.city_name
        JOIN tb_param tp ON tre.paramid = tp.id
        JOIN dim_param dp ON tp.paramname = dp.param_name
GROUP BY mk.month_key,
    dc.city_key,
    dp.param_key;