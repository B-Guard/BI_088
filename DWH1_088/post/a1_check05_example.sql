SELECT COUNT(*) AS missing_dim_references
FROM dwh_088.ft_serviceevent f
         LEFT JOIN dwh_088.dim_servicetype st ON f.servicetypekey = st.servicetypekey
         LEFT JOIN dwh_088.dim_employee e ON f.employeekey = e.employeekey
         LEFT JOIN dwh_088.dim_sensordevice s ON f.sensordeviceid = s.sensordevicekey
         LEFT JOIN dwh_088.dim_timeday d ON f.dateid = d.datekey
         LEFT JOIN dwh_088.dim_checklist c ON f.checklistkey = c.id
WHERE st.servicetypekey IS NULL
   OR e.employeekey IS NULL
   OR s.sensordevicekey IS NULL
   OR d.datekey IS NULL;