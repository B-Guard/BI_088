-- For parameter PM10, show Avg Recorded Value and P95 Recorded Value by 
-- Country for 2023. Return Countries on rows and two columns --Avg Recorded 
-- Value and P95 Recorded Value-- for the year 2023.
set search_path to dwh2_088;

SELECT c.country_name,
    AVG(
        CASE
            WHEN p.param_name = 'PM10' THEN f.recordedvalue_avg
        END
    ) AS "Avg PM10",
    AVG(
        CASE
            WHEN p.param_name = 'PM10' THEN f.recordedvalue_p95
        END
    ) AS "P95 PM10"
FROM ft_param_city_month f
    JOIN dim_timemonth t ON f.month_key = t.month_key
    JOIN dim_city c ON f.city_key = c.city_key
    JOIN dim_param p ON f.param_key = p.param_key
WHERE t.year_num = 2023
GROUP BY c.country_name;