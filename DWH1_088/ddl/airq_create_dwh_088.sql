-- Make A1 dwh_xxx schema the default for this session
SET search_path TO dwh_088;

-- -------------------------------
-- 2) DROP TABLE before attempting to create DWH schema tables
-- -------------------------------
DROP TABLE IF EXISTS dim_timeday;
DROP TABLE IF EXISTS dim_employee;
DROP TABLE IF EXISTS dim_sensordevice;
DROP TABLE IF EXISTS dim_servicetype;
DROP TABLE IF EXISTS dim_readingmode;
DROP TABLE IF EXISTS dim_alert;
DROP TABLE IF EXISTS dim_parameter;
DROP TABLE IF EXISTS dim_parametersensor;
DROP TABLE IF EXISTS dim_weather;
DROP TABLE IF EXISTS dim_checklist;
DROP TABLE IF EXISTS ft_readingevent;
DROP TABLE IF EXISTS ft_serviceevent;

-- -------------------------------
-- 3) CREATE TABLE statements for facts and dimensions
-- Please make sure the order in which individual statements are executed respects the FOREIGN KEY constraints
-- -------------------------------
CREATE TABLE dim_timeday (
  datekey BIGSERIAL PRIMARY KEY,
  date DATE NOT NULL,
  dayofweek INT NOT NULL,
  month INT NOT NULL,
  year INT NOT NULL,
  etl_load_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE dim_employee (
  employeekey BIGSERIAL PRIMARY KEY,
  badgenumber VARCHAR(255) NOT NULL,
  rolelevel INT NOT NULL,
  category VARCHAR(255) NOT NULL,
  rolename VARCHAR(255) NOT NULL,
  validfrom DATE NOT NULL,
  validto DATE DEFAULT NULL,
  etl_load_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT ux_employee_bk_timerange UNIQUE (badgenumber, validfrom, validto)
);

CREATE TABLE dim_sensordevice (
  sensordevicekey BIGSERIAL PRIMARY KEY,
  sensortypename VARCHAR(255) NOT NULL,
  manufacturer VARCHAR(255) NOT NULL,
  technology VARCHAR(255) NOT NULL,
  locationname VARCHAR(255) NOT NULL,
  locationtype VARCHAR(255) NOT NULL,
  altitude FLOAT NOT NULL,
  latitude FLOAT NOT NULL,
  longitude FLOAT NOT NULL,
  installeddate DATE NOT NULL,
  cityname VARCHAR(255) NOT NULL,
  countryname VARCHAR(255) NOT NULL,
  citypopulation INT NOT NULL,
  countrypopulation INT NOT NULL,
  oltp_id BIGINT NOT NULL,
  etl_load_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE dim_servicetype (
  servicetypekey BIGSERIAL PRIMARY KEY,
  servicetypename VARCHAR(255) NOT NULL,
  category VARCHAR(255) NOT NULL,
  minlevel INT NOT NULL,
  servicegroup VARCHAR(255) NOT NULL,
  details VARCHAR(255) NOT NULL,
  etl_load_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE dim_readingmode (
  readingmodekey BIGSERIAL PRIMARY KEY,
  modename VARCHAR(255) NOT NULL,
  latency INT NOT NULL,
  validfrom DATE NOT NULL,
  validto DATE DEFAULT NULL,
  details VARCHAR(255) NOT NULL,
  oltp_id BIGINT NOT NULL,
  etl_load_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE dim_alert (
  alertkey BIGSERIAL PRIMARY KEY,
  alertname VARCHAR(255) NOT NULL,
  color VARCHAR(255) NOT NULL,
  details VARCHAR(255) NOT NULL,
  threshold FLOAT NOT NULL,
  parametername VARCHAR(255) NOT NULL,
  etl_load_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE dim_parameter (
  parameterkey BIGSERIAL PRIMARY KEY,
  parametername VARCHAR(255) NOT NULL,
  category VARCHAR(255) NOT NULL,
  purpose VARCHAR(255) NOT NULL,
  unit VARCHAR(255) NOT NULL,
  sensortypename VARCHAR(255) NOT NULL,
  manufacturer VARCHAR(255) NOT NULL,
  technology VARCHAR(255) NOT NULL,
  accuracy VARCHAR(255) NOT NULL,
  oltp_id BIGINT NOT NULL,
  etl_load_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE dim_weather (
  weatherkey BIGSERIAL PRIMARY KEY,
  cityname VARCHAR(255) NOT NULL,
  observedate DATE NOT NULL,
  tempdaymin FLOAT NOT NULL,
  tempdaymax FLOAT NOT NULL,
  tempdayavg FLOAT NOT NULL,
  precipmm FLOAT NOT NULL,
  pressure FLOAT NOT NULL,
  windspeed FLOAT NOT NULL,
  windgusts FLOAT NOT NULL,
  etl_load_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE dim_checklist (
  id BIGSERIAL NOT NULL PRIMARY KEY,
  checklist_name VARCHAR(255) NOT NULL,
  category VARCHAR(100),
  created_date DATE,
  importance_level VARCHAR(50),
  is_mandatory BOOLEAN,
  etl_load_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- .......
-- FACT 1: 
CREATE TABLE ft_readingevent (
  id BIGSERIAL NOT NULL PRIMARY KEY,
  -- Measures
  recordedvalue FLOAT NOT NULL,
  datavolumekb INT NOT NULL,
  dataquality INT NOT NULL,
  -- Foreign Keys to Dimensions
  dateid BIGINT NOT NULL,
  sensordeviceid BIGINT NOT NULL,
  parameterid BIGINT NOT NULL,
  readingmodeid BIGINT NOT NULL,
  alertid BIGINT, -- can be null, if there is no alert
  weatherid BIGINT NOT NULL,
  etl_load_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_ft_readingevent_dateid FOREIGN KEY (dateid) REFERENCES dim_timeday(datekey),
  CONSTRAINT fk_ft_readingevent_sensordeviceid FOREIGN KEY (sensordeviceid) REFERENCES dim_sensordevice(sensordevicekey),
  CONSTRAINT fk_ft_readingevent_parameterid FOREIGN KEY (parameterid) REFERENCES dim_parameter(parameterkey),
  CONSTRAINT fk_ft_readingevent_readingmodeid FOREIGN KEY (readingmodeid) REFERENCES dim_readingmode(readingmodekey),
  CONSTRAINT fk_ft_readingevent_alertid FOREIGN KEY (alertid) REFERENCES dim_alert(alertkey),
  CONSTRAINT fk_ft_readingevent_weatherid FOREIGN KEY (weatherid) REFERENCES dim_weather(weatherkey)
);

-- helpful indexes for join performance (optional but recommended)
CREATE INDEX ix_ft_readingevent_date           ON ft_readingevent(dateid);
CREATE INDEX ix_ft_readingevent_sensordevice   ON ft_readingevent(sensordeviceid);
CREATE INDEX ix_ft_readingevent_parameter      ON ft_readingevent(parameterid);
-- FACT 2: 
CREATE TABLE ft_serviceevent (
  id BIGSERIAL NOT NULL PRIMARY KEY,
  -- Measures
  servicecost INT NOT NULL,
  durationminutes INT NOT NULL,
  servicequality INT NOT NULL,
  -- Foreign Keys to Dimensions
  dateid BIGINT NOT NULL,
  employeekey BIGINT NOT NULL,
  sensordeviceid BIGINT NOT NULL,
  servicetypekey BIGINT NOT NULL,
  checklistkey BIGINT NOT NULL,
  etl_load_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_ft_serviceevent_dateid FOREIGN KEY (dateid) REFERENCES dim_timeday(datekey),
  CONSTRAINT fk_ft_serviceevent_employeekey FOREIGN KEY (employeekey) REFERENCES dim_employee(employeekey),
  CONSTRAINT fk_ft_serviceevent_sensordeviceid FOREIGN KEY (sensordeviceid) REFERENCES dim_sensordevice(sensordevicekey),
  CONSTRAINT fk_ft_serviceevent_servicetypekey FOREIGN KEY (servicetypekey) REFERENCES dim_servicetype(servicetypekey),
  CONSTRAINT fk_ft_serviceevent_checklistkey FOREIGN KEY (checklistkey) REFERENCES dim_checklist(id)
);

-- helpful indexes for join performance (optional but recommended)
CREATE INDEX ix_ft_serviceevent_day           ON ft_serviceevent(dateid);
CREATE INDEX ix_ft_serviceevent_sensordevice  ON ft_serviceevent(sensordeviceid);
CREATE INDEX ix_ft_serviceevent_employeekey   ON ft_serviceevent(employeekey);