SET
search_path TO dwh_088, stg_088;

TRUNCATE TABLE dim_weather RESTART IDENTITY CASCADE;

INSERT INTO dim_weather (tempdaymin, tempdaymax, tempdayavg,
                         precipmm, pressure, windspeed, windgusts, etl_load_timestamp)
SELECT tempdaymin,
       tempdaymax,
       (tempdaymin + tempdaymax) / 2.0 AS tempdayavg,
       precipmm,
       pressure,
       windspeed,
       windgusts,
       NOW()
FROM tb_weather;

ANALYZE
dim_weather;