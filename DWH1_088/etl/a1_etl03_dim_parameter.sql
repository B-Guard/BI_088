-- Make A1 dwh_xxx, stg_xxx schemas the default for this session
SET search_path TO dwh_088, stg_088;

-- =======================================
-- Load [table name]
-- =======================================

-- Step 1: Truncate target table
TRUNCATE TABLE dim_parameter RESTART IDENTITY CASCADE;

INSERT INTO dim_parameter (parametername, category, purpose, unit, etl_load_timestamp)
SELECT
    paramname,
    category,
    purpose,
    unit,
    NOW()
FROM tb_param;





