-- Make A1 dwh_xxx, stg_xxx schemas the default for this session
SET
search_path TO dwh_088, stg_088;


TRUNCATE TABLE dim_readingmode RESTART IDENTITY CASCADE;

INSERT INTO dim_readingmode (modename,
                             latency,
                             validfrom,
                             validto,
                             details,
                             etl_load_timestamp)
SELECT rm.modename,
       rm.latency,
       rm.validfrom,
       COALESCE(rm.validto, DATE '9999-12-31') AS validto,
       rm.details,
       NOW()
FROM tb_readingmode rm;

ANALYZE
dim_readingmode;





