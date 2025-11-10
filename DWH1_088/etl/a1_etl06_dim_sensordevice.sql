SET
search_path TO dwh_088, stg_088;

TRUNCATE TABLE dim_sensordevice RESTART IDENTITY CASCADE;

INSERT INTO dim_sensordevice (sensortypename,
                              manufacturer,
                              technology,
                              locationname,
                              locationtype,
                              altitude,
                              latitude,
                              longitude,
                              installeddate,
                              cityname,
                              countryname,
                              citypopulation,
                              countrypopulation,
                              oltp_id,
                              etl_load_timestamp)
SELECT st.typename                         AS sensortypename,
       st.manufacturer,
       st.technology,
       sd.locationname,
       sd.locationtype,
       sd.altitude,
       c.latitude,
       c.longitude,
       sd.installedat,
       c.cityname,
       COALESCE(co.countryname, 'Unknown') AS countryname,
       COALESCE(c.population, 0)           AS citypopulation,
       COALESCE(co.population, 0)          AS countrypopulation,
       sd.id,
       NOW()
FROM tb_sensordevice sd
         JOIN tb_sensortype st ON sd.sensortypeid = st.id
         JOIN tb_city c ON sd.cityid = c.id
         LEFT JOIN tb_country co ON c.countryid = co.id;

ANALYZE
dim_sensordevice;
