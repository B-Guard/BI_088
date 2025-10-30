SET
search_path TO dwh_088, stg_088;

TRUNCATE TABLE dim_alert RESTART IDENTITY CASCADE;

INSERT INTO dim_alert (alertname, color, details, threshold, etl_load_timestamp)
SELECT alertname,
       colour,
       details,
       threshold,
       NOW()
FROM tb_alert;

ANALYZE
dim_alert;