-- For 2024, list the Top 10 Countries by Avg Data Quality. Return the 10 countries
-- with the highest values on rows (highest → lowest)
-- and one column with Avg Data Quality for 2024.

SELECT c.country_name,
       AVG(f.data_quality_avg) AS data_quality
FROM ft_param_city_month f
         JOIN dim_timemonth t ON f.month_key = t.month_key
         JOIN dim_city c ON f.city_key = c.city_key
WHERE t.year_num = 2024
GROUP BY c.country_name
ORDER BY data_quality DESC
LIMIT 10;