
# Fact tables
## Reading Events
### Surrogate
- readingeventkey (PK)
### Measures
- recordedvalue: tb_readingevent.recordedvalue
- datavolume: tb_readingevent.datavolumekb
- dataquality: tb_readingevent.dataquality
### Foreign keys
- datekey
- sensordevicekey
- parameterkey
- readingmodekey
- weatherkey

## Service Events
### Surrogate
- serviceeventkey (PK)
### Measures
- cost: tb_serviceevent.servicecost
- duration: tb_serviceevent.durationminutes
- quality: tb_serviceevent.servicequality
### Foreign keys
- datekey
- employeekey
- sensordevicekey
- servicetypekey


# Dimension tables
## Date Dimension
- datekey (PK)
- date: tb_serviceevent.servicedat OR tb_readingevent.readdat
- dayofweek: derive from date
- month: derive from date
- year: derive from date

## Employee Dimension
- employeekey (PK) (surrogate key)
- badgenumber: tb_employee.badgenumber
- rolelevel: tb_role.rolelevel
- category: tb_role.category
- rolename: tb_role.rolename
- validfrom: tb_employee.validfrom
- validto: tb_employee.validto

## Sensor Device Dimension
- sensordevicekey (PK)
- sensortypename: tb_sensortype.typename
- manufacturer: tb_sensortype.manufacturer
- technology: tb_sensortype.technology
- locationname: tb_sensordevice.locationname
- locationtype: tb_sensordevice.locationtype
- altitude: tb_sensordevice.altitude
- latitude: tb_city.latitude
- longitude: tb_city.longitude
- installeddate: tb_sensordevice.installeddate
- cityname: tb_city.name
- countryname: tb_country.name
- citypopulation: tb_city.population
- countrypopulation: tb_country.population

## Service Type Dimension
- servicetypekey (PK)
- servicetypename: tb_servicetype.servicetypename
- category: tb_servicetype.category
- minlevel: tb_servicetype.minlevel
- servicegroup: tb_servicetype.servicegroup
- details: tb_servicetype.details

## Reading mode Dimension
- readingmodekey (PK)
- readingmodename: tb_readingmode.modename
- latency: tb_readingmode.latency
- validfrom: tb_readingmode.validfrom
- validto: tb_readingmode.validto
- details: tb_readingmode.details

## Parameter Dimension
- parameterkey (PK)
- parametername: tb_param.parametername
- category: tb_param.category
- purpose: tb_param.purpose
- unit: tb_param.unit
- sensortypename: tb_sensortype.typename
- manufacturer: tb_sensortype.manufacturer
- technology: tb_sensortype.technology
- accuracy: tb_paramsensortype.accuracy

## Alert Dimension
- alertkey (PK)
- alertname: tb_alert.alertname
- color: tb_alert.color
- details: tb_alert.details
- threshold: tb_paramalert.threshold

## Weather Dimension
- weatherkey (PK)
- cityname: tb_city.name
- observedate: tb_weather.observedat
- tempdaymin: tb_weather.tempdaymin
- tempdaymax: tb_weather.tempdaymax
- tempdayavg: tb_weather.tempdayavg
- precipmm: tb_weather.precipmm
- pressure: tb_weather.pressure
- windspeed: tb_weather.windspeed
- windgusts: tb_weather.windgusts



---




#### Student A – Focus: Environmental Performance and Device Monitoring

- How do average pollutant levels vary across cities and months, and which cities most frequently exceed Red or Crimson alert thresholds?
- What correlation exists between weather conditions (e.g., wind speed, precipitation) and pollutant concentration levels?
- Which sensor types or manufacturers consistently produce the highest data quality scores?
- How has the number of alert exceedances changed over time per country?
- Which parameters contribute most to high-alert events in industrial vs. urban zones?
- How does data volume per reading mode vary across sensor types, and does higher data volume imply higher quality?

#### Student B – Focus: Operational Efficiency and Technician Analysis

- Which technicians or service groups achieve the highest service quality relative to cost or duration?
- Are there patterns in underqualified service assignments, and how do they impact subsequent device reliability?
- What is the average cost and duration of services per device type, and how does it trend over time?
- How do technician role promotions correlate with improvements in service performance metrics?
- Which cities or devices require the most frequent servicing, indicating potential reliability issues?
- Is there a relationship between service frequency and data quality improvements?