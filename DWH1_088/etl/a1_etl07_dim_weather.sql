SET
search_path TO dwh_088, stg_088;

TRUNCATE TABLE dim_weather RESTART IDENTITY CASCADE;

INSERT INTO dim_weather (tempdaymin, tempdaymax, tempdayavg,
                         precipmm, pressure, windspeed, windgusts, etl_load_timestamp, cityname, observedate)
SELECT tw.tempdaymin,
       tw.tempdaymax,
       tw.tempdayavg,
       tw.precipmm,
       tw.pressure,
       tw.windspeed,
       tw.windgusts,
       NOW(),
       tc.cityname,
       tw.observedat
FROM tb_weather as tw, tb_city as tc
WHERE tw.cityid = tc.id;

ANALYZE
dim_weather;