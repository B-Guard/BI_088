-- please remember to give a meaningful name to both Table X (instead of tb_x) and TableY (instead of tb_y)

-- Make the A1's stg_xxx schema the default for this session
SET search_path TO stg_088;

-- -------------------------------
-- 2) DROP TABLE before attempting to create OLTP snapshot tables
-- -------------------------------
DROP TABLE IF EXISTS tb_checklist_servicetype;
DROP TABLE IF EXISTS tb_checklist;


-- Table_X contains checklists that describe the steps or safety procedures
CREATE TABLE tb_checklist (
    id INT NOT NULL PRIMARY KEY,
    checklist_name VARCHAR(255) NOT NULL,
    category VARCHAR(100),
    created_date DATE,
    is_mandatory BOOLEAN
);

-- Table_Y connects checklist to service type
CREATE TABLE tb_checklist_servicetype (
    PRIMARY KEY (checklist_id, servicetype_id),
    checklist_id INTEGER NOT NULL REFERENCES tb_checklist(id),
    servicetype_id INTEGER NOT NULL REFERENCES tb_servicetype(id),
    importance_level VARCHAR(50)  -- Critical, Recommended, Optional
);
