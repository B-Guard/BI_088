SELECT (SELECT COUNT(DISTINCT id) FROM stg_088.tb_x)                    AS checklists_in_stg,
       (SELECT COUNT(DISTINCT id) FROM dwh_088.dim_checklist) AS checklists_in_dwh,
       (SELECT COUNT(DISTINCT id) FROM stg_088.tb_y)          AS links_in_stg;