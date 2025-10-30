SELECT 'dim_checklist' AS table,
       COUNT(*) - COUNT(DISTINCT id) AS duplicates FROM dwh_088.dim_checklist
UNION ALL
SELECT 'dim_servicetype', COUNT(*) - COUNT(DISTINCT servicetypekey) FROM dwh_088.dim_servicetype
UNION ALL
SELECT 'ft_serviceevent', COUNT(*) - COUNT(DISTINCT id) FROM dwh_088.ft_serviceevent;
