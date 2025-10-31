-- Make A1 dwh_xxx, stg_xxx schemas the default for this session
SET search_path TO dwh_088,
    stg_088;

TRUNCATE TABLE dim_parameter RESTART IDENTITY CASCADE;

INSERT INTO dim_parameter (
        parametername,
        category,
        purpose,
        unit,
        sensortypename,
        manufacturer,
        technology,
        accuracy,
        oltp_id,
        etl_load_timestamp
    )
SELECT tp.paramname,
    tp.category,
    tp.purpose,
    tp.unit,
    st.typename,
    st.manufacturer,
    st.technology,
    pst.accuracy,
    tp.id,
    NOW()
FROM tb_param as tp,
    tb_paramsensortype pst,
    tb_sensortype st
WHERE tp.id = pst.paramid
    AND pst.sensortypeid = st.id;