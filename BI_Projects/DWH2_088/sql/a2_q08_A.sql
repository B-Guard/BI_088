-- For 2024, show Avg Data Quality by Country, but only for countries whose
-- 2024 year-total Devices Reporting is at least 2000.
-- Return Countries on rows (filtered to Devices Reporting ≥ 2000)
-- and one column with Avg Data Quality for the year 2024.
set search_path TO dwh2_088;

WITH country_stats AS (SELECT c.country_name,
                              SUM(f.devices_reporting_count) AS devices,
                              AVG(f.data_quality_avg)        AS data_quality
                       FROM ft_param_city_month f
                                JOIN dim_timemonth t ON f.month_key = t.month_key
                                JOIN dim_city c ON f.city_key = c.city_key
                       WHERE t.year_num = 2024
                       GROUP BY c.country_name)

SELECT country_name,
       data_quality
FROM country_stats
WHERE devices >= 2000;