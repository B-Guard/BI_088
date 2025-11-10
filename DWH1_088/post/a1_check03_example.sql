SELECT 'dim_alert' AS table, COUNT(*) AS rows
FROM dwh_088.dim_alert
UNION ALL
SELECT 'dim_date', COUNT(*)
FROM dwh_088.dim_timeday
UNION ALL
SELECT 'dim_employee', COUNT(*)
FROM dwh_088.dim_employee
UNION ALL
SELECT 'dim_parameter', COUNT(*)
FROM dwh_088.dim_parameter
UNION ALL
SELECT 'dim_readingmode', COUNT(*)
FROM dwh_088.dim_readingmode
UNION ALL
SELECT 'dim_sensordevice', COUNT(*)
FROM dwh_088.dim_sensordevice
UNION ALL
SELECT 'dim_servicetype', COUNT(*)
FROM dwh_088.dim_servicetype
UNION ALL
SELECT 'dim_weather', COUNT(*)
FROM dwh_088.dim_weather
UNION ALL
SELECT 'dim_checklist', COUNT(*)
FROM dwh_088.dim_checklist
UNION ALL
SELECT 'ft_readingevent', COUNT(*)
FROM dwh_088.ft_readingevent
UNION ALL
SELECT 'ft_serviceevent', COUNT(*)
FROM dwh_088.ft_serviceevent;