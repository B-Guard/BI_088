-- Make A1 dwh_xxx, stg_xxx schemas the default for this session
SET
search_path TO dwh_088, stg_088;


TRUNCATE TABLE dim_readingmode RESTART IDENTITY CASCADE;

INSERT INTO dim_readingmode (modename,
                             latency,
                             validfrom,
                             validto,
                             details,
                             oltp_id,
                             etl_load_timestamp)
SELECT rm.modename,
       rm.latency,
       rm.validfrom,
       rm.validto, -- can be NULL
       rm.details,
       rm.id,
       NOW()
FROM tb_readingmode rm;

ANALYZE
dim_readingmode;




