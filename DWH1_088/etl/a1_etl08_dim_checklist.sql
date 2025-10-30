-- Make A1 dwh_xxx, stg_xxx schemas the default for this session
SET search_path TO dwh_088, stg_088;

-- 1) Truncate target
TRUNCATE TABLE dim_checklist RESTART IDENTITY CASCADE;

-- 2) Insert data from staging
WITH src AS (
    SELECT DISTINCT
        c.id                AS checklist_id,
        c.checklist_name,
        c.category,
        c.is_mandatory,
        cs.importance_level
    FROM stg_088.tb_checklist c
    LEFT JOIN stg_088.tb_checklist_servicetype cs
        ON c.id = cs.checklist_id
)
INSERT INTO dim_checklist (
    checklist_id,
    checklist_name,
    category,
    is_mandatory,
    importance_level
)
SELECT
    checklist_id,
    checklist_name,
    category,
    is_mandatory,
    importance_level
FROM src
ORDER BY checklist_id;

-- 3) Refresh stats (optional but recommended)
ANALYZE dim_checklist;

