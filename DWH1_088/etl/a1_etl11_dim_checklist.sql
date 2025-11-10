SET
search_path TO dwh_088, stg_088;

TRUNCATE TABLE dim_checklist RESTART IDENTITY CASCADE;
WITH importance_rank AS (
    SELECT
        c.id,
        c.checklist_name,
        c.category,
        c.created_date,
        c.is_mandatory,
        CASE
            WHEN cs.importance_level = 'Critical' THEN 3
            WHEN cs.importance_level = 'Recommended' THEN 2
            WHEN cs.importance_level = 'Optional' THEN 1
            ELSE 0
        END AS importance_rank,
        cs.importance_level
    FROM tb_checklist c
    LEFT JOIN tb_checklist_servicetype cs
        ON c.id = cs.checklist_id
),
src AS (
    SELECT DISTINCT ON (id)
        id,
        checklist_name,
        category,
        created_date,
        is_mandatory,
        importance_level
    FROM importance_rank
    ORDER BY id, importance_rank DESC
)
INSERT INTO dim_checklist (
    id,
    checklist_name,
    category,
    created_date,
    is_mandatory,
    importance_level
)
SELECT
    id,
    checklist_name,
    category,
    created_date,
    is_mandatory,
    COALESCE(importance_level, 'Unknown')
FROM src
ORDER BY id;

ANALYZE dim_checklist;