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
       dd.datekey,
       de.employeekey,
       ds.sensordevicekey,
       dst.servicetypekey,
       dc.id,
       NOW()
FROM tb_serviceevent s
         JOIN dwh_088.dim_timeday dd ON dd.date = s.servicedat
         JOIN dwh_088.dim_employee de ON de.badgenumber = (SELECT badgenumber FROM tb_employee WHERE id = s.employeeid)
         JOIN dwh_088.dim_sensordevice ds ON ds.sensortypename = (SELECT typename
                                                                  FROM tb_sensortype
                                                                  WHERE id = (SELECT sensortypeid FROM tb_sensordevice WHERE id = s.sensordevid))
         JOIN dwh_088.dim_servicetype dst
              ON dst.servicetypename = (SELECT typename FROM tb_servicetype WHERE id = s.servicetypeid)
         LEFT JOIN dwh_088.dim_checklist dc ON dc.id = dc.id;

ANALYZE ft_serviceevent;
