SELECT st.servicetypename, COUNT(DISTINCT c.id) AS checklist_count
FROM dwh_088.ft_serviceevent f
         JOIN dwh_088.dim_servicetype st ON f.servicetypekey = st.servicetypekey
         LEFT JOIN dwh_088.dim_checklist c ON f.checklistkey = c.id
GROUP BY st.servicetypename
ORDER BY checklist_count DESC LIMIT 10;