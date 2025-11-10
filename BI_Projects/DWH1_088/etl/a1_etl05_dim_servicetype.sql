-- Make A1 dwh_xxx, stg_xxx schemas the default for this session
SET
search_path TO dwh_088, stg_088;

TRUNCATE TABLE dim_servicetype RESTART IDENTITY CASCADE;

INSERT INTO dim_servicetype (servicetypename, category, minlevel, servicegroup, details, etl_load_timestamp)
SELECT typename,
       category,
       minlevel,
       servicegroup,
       details,
       NOW()
FROM tb_servicetype;

ANALYZE
dim_servicetype;





