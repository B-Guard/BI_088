-- For 2024, show Reading Events by Country × Quarter (Top 10 countries). 
-- Return the four quarters on columns (Q1–Q4) and the Top 10 countries 
-- on rows, ranked by total Reading Events in 2024
SET search_path TO dwh2_088;

SELECT c.country_name,
    SUM(
        CASE
            WHEN t.quarter_num = 1 THEN f.reading_events_count
            ELSE 0
        END
    ) AS q1,
    SUM(
        CASE
            WHEN t.quarter_num = 2 THEN f.reading_events_count
            ELSE 0
        END
    ) AS q2,
    SUM(
        CASE
            WHEN t.quarter_num = 3 THEN f.reading_events_count
            ELSE 0
        END
    ) AS q3,
    SUM(
        CASE
            WHEN t.quarter_num = 4 THEN f.reading_events_count
            ELSE 0
        END
    ) AS q4,
    SUM(f.reading_events_count) AS total_reading_events
FROM ft_param_city_month f
    JOIN dim_timemonth t ON f.month_key = t.month_key
    JOIN dim_city c ON f.city_key = c.city_key
WHERE t.year_num = 2024
GROUP BY c.country_name
ORDER BY total_reading_events DESC
LIMIT 10;