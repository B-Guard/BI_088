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

WITH daily_alert_ranks AS (SELECT dc.city_key                       AS city_key,
                                  dp.param_key                      AS param_key,
                                  rb.readat::date                   AS day,
                                  TO_CHAR(rb.readat, 'YYYYMM')::int AS month_key,
                                  MAX(
                                          CASE
                                              WHEN rb.recordedvalue > pa.threshold THEN pa.alertid
                                              ELSE 1000
                                              END
                                      )                             AS daily_rank
                           FROM tb_readingevent rb
                                    JOIN tb_sensordevice sd ON sd.id = rb.sensordevid
                                    JOIN tb_city tc ON sd.cityid = tc.id
                                    JOIN dim_city dc ON tc.cityname = dc.city_name
                                    JOIN tb_param tp ON rb.paramid = tp.id
                                    JOIN dim_param dp ON tp.paramname = dp.param_name
                                    LEFT JOIN tb_paramalert pa ON pa.paramid = rb.paramid
                           GROUP BY dc.city_key,
                                    dp.param_key,
                                    rb.readat::date,
                                    TO_CHAR(rb.readat, 'YYYYMM')::int),

     monthly_alert_ranks AS (SELECT month_key,
                                    city_key,
                                    param_key,
                                    MAX(daily_rank)                         AS monthly_peak_rank,
                                    COUNT(*) FILTER (WHERE daily_rank >= 1) AS exceed_days_any
                             FROM daily_alert_ranks
                             GROUP BY month_key, city_key, param_key)

INSERT
INTO ft_param_city_month (month_key,
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
                          etl_load_ts)
SELECT mk.month_key,
       dc.city_key,
       dp.param_key,

       (COALESCE(mar.monthly_peak_rank, 1000))                         AS alertpeak_key,

       COUNT(DISTINCT (tre.sensordevid, tre.readat::date))             AS reading_events_count,
       COUNT(DISTINCT tre.sensordevid)                                 AS devices_reporting_count,
       AVG(tre.recordedvalue)                                          AS recordedvalue_avg,
       PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY tre.recordedvalue) AS recordedvalue_p95,

       COALESCE(mar.exceed_days_any, 0)                                AS exceed_days_any,

       SUM(tre.datavolumekb)                                           AS data_volume_kb_sum,
       AVG(tre.dataquality)                                            AS data_quality_avg,

       mk.days_in_month - COUNT(DISTINCT tre.readat::date)             AS missing_days,
       NOW()                                                           AS etl_load_ts

FROM tb_readingevent tre
         JOIN dim_timemonth mk
              ON TO_CHAR(tre.readat, 'YYYYMM')::int = mk.month_key
         JOIN tb_sensordevice sd ON tre.sensordevid = sd.id
         JOIN tb_city tc ON sd.cityid = tc.id
         JOIN dim_city dc ON tc.cityname = dc.city_name
         JOIN tb_param tp ON tre.paramid = tp.id
         JOIN dim_param dp ON tp.paramname = dp.param_name

         LEFT JOIN monthly_alert_ranks mar
                   ON mar.month_key = mk.month_key
                       AND mar.city_key = dc.city_key
                       AND mar.param_key = dp.param_key

GROUP BY mk.month_key,
         dc.city_key,
         dp.param_key,
         mar.monthly_peak_rank,
         mar.exceed_days_any,
         mk.days_in_month;