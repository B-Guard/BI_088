SET search_path TO dwh_088, stg_088;

TRUNCATE TABLE ft_serviceevent RESTART IDENTITY CASCADE;

INSERT INTO ft_serviceevent (servicecost,
                             durationminutes,
                             servicequality,
                             dateid,
                             employeekey,
                             sensordeviceid,
                             servicetypekey,
                             checklistkey,
                             etl_load_timestamp)
SELECT s.servicecost,
       s.durationminutes,
       s.servicequality,
       d.datekey,
       e.employeekey,
       sd.sensordevicekey,
       st.servicetypekey,
       c.id AS checklistkey,
       NOW()
FROM tb_serviceevent s
         JOIN dim_timeday d
              ON d.date = s.servicedat
         JOIN tb_employee se
              ON se.id = s.employeeid
         JOIN dim_employee e
              ON e.badgenumber = se.badgenumber
         JOIN tb_sensordevice ss
              ON ss.id = s.sensordevid
         JOIN tb_sensortype stp
              ON stp.id = ss.sensortypeid
         JOIN dim_sensordevice sd
              ON sd.sensortypename = stp.typename
         JOIN tb_servicetype sst
              ON sst.id = s.servicetypeid
         JOIN dim_servicetype st
              ON st.servicetypename = sst.typename
         JOIN tb_checklist_servicetype cst
              ON cst.servicetype_id = s.servicetypeid
         JOIN dim_checklist c
              ON c.id = cst.checklist_id;

ANALYZE ft_serviceevent;
