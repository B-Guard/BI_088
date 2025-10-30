SET
search_path TO dwh_088, stg_088;

TRUNCATE TABLE ft_readingevent RESTART IDENTITY CASCADE;

INSERT INTO ft_readingevent (recordedvalue,
                             datavolumekb,
                             dataquality,
                             dateid,
                             sensordeviceid,
                             parameterid,
                             readingmodeid,
                             weatherid,
                             alertid,
                             etl_load_timestamp)
SELECT re.recordedvalue,
       re.datavolumekb,
       re.dataquality,
       dd.datekey,
       ds.sensordevicekey,
       dp.parameterkey,
       drm.readingmodekey,
       dw.weatherkey,
       da.alertkey,
       NOW()
FROM tb_readingevent re
         JOIN dwh_088.dim_date dd ON dd.date = re.readat
         JOIN dwh_088.dim_sensordevice ds ON ds.sensortypename = (SELECT typename
                                                                  FROM tb_sensortype
                                                                  WHERE id = (SELECT sensortypeid FROM tb_sensordevice WHERE id = re.sensordevid))
         JOIN dwh_088.dim_parameter dp ON dp.parametername = (SELECT paramname FROM tb_param WHERE id = re.paramid)
         JOIN dwh_088.dim_readingmode drm
              ON drm.modename = (SELECT modename FROM tb_readingmode WHERE id = re.readingmodeid)
         LEFT JOIN dwh_088.dim_weather dw ON dw.weatherkey = dw.weatherkey
         LEFT JOIN dwh_088.dim_alert da ON da.alertname = (SELECT alertname FROM tb_alert WHERE id = re.alertid);

ANALYZE
ft_readingevent;
