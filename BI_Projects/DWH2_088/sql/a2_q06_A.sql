-- For 2024, list the Top 10 Cities by total Missing Days (all parameters).
-- Return the 10 cities with
-- the highest totals on rows (highest → lowest)
-- and one column with the 2024 total Missing Days.
set search_path TO dwh2_088;

SELECT c.city_name,
       SUM(f.missing_days) AS missing_days_2024
FROM ft_param_city_month f
         JOIN dim_city c ON f.city_key = c.city_key
         JOIN dim_timemonth t ON f.month_key = t.month_key
WHERE t.year_num = 2024
GROUP BY c.city_name
ORDER BY missing_days_2024 DESC
LIMIT 10;