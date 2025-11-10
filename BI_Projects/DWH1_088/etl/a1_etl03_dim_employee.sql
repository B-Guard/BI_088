-- Make A1 dwh_xxx, stg_xxx schemas the default for this session
SET
search_path TO dwh_088, stg_088;

TRUNCATE TABLE dim_employee RESTART IDENTITY CASCADE;

INSERT INTO dim_employee (badgenumber,
                          rolelevel,
                          category,
                          rolename,
                          validfrom,
                          validto,
                          etl_load_timestamp)
SELECT e.badgenumber,
       r.rolelevel,
       r.category,
       r.rolename,
       e.validfrom,
       e.validto,
       NOW()
FROM tb_employee e
         JOIN tb_role r ON e.roleid = r.id;

ANALYZE
dim_employee;




