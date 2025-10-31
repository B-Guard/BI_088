SET search_path TO dwh_088,
    stg_088;

TRUNCATE TABLE dim_alert RESTART IDENTITY CASCADE;

INSERT INTO dim_alert (
        alertname,
        color,
        details,
        threshold,
        parametername,
        etl_load_timestamp
    )
SELECT a.alertname,
    a.colour,
    a.details,
    pa.threshold,
    tp.paramname,
    NOW()
FROM tb_alert as a,
    tb_paramalert as pa,
    tb_param as tp
WHERE a.id = pa.alertid
    AND pa.paramid = tp.id;

ANALYZE dim_alert;