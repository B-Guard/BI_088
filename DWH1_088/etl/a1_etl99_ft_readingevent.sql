SET search_path TO dwh_088,
     stg_088;

TRUNCATE TABLE ft_readingevent RESTART IDENTITY CASCADE;

INSERT INTO ft_readingevent (
          recordedvalue,
          datavolumekb,
          dataquality,
          dateid,
          sensordeviceid,
          parameterid,
          readingmodeid,
          weatherid,
          alertid,
          etl_load_timestamp
     )
SELECT tre.recordedvalue,
     tre.datavolumekb,
     tre.dataquality,
     dd.datekey,
     dsd.sensordevicekey,
     dp.parameterkey,
     drm.readingmodekey,
     dw.weatherkey,
     -- Getting the alertkey is a bit more tricky:
     -- First we need to find all rows in dim_alert refering to the same parametername as dim_parameter.parametername
     -- From those rows, find the one where tb_readingevent.recordedvalue goes over dim_alert.threshold. 
     -- The highest threshold that is still below recordedvalue is the correct alert.
     (SELECT da.alertkey FROM dim_alert da
      WHERE da.parametername = dp.parametername
           AND tre.recordedvalue >= da.threshold
      ORDER BY da.threshold DESC
      LIMIT 1) AS alertkey,
     NOW() 
FROM tb_readingevent tre,
     dim_sensordevice dsd,
     dim_parameter dp,
     dim_readingmode drm,
     dim_timeday dd,
     dim_weather dw,
     dim_alert da
WHERE tre.sensordevid = dsd.oltp_id
     AND tre.paramid = dp.oltp_id
     AND tre.readingmodeid = drm.oltp_id
     AND tre.readat = dd.date
     AND dw.cityname = dsd.cityname
     AND dw.observedate = dd.date;

ANALYZE ft_readingevent;