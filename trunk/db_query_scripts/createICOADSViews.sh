
SCHEMA="global"
DB="aas_base"
USER_NAME="postgres"


## Script written by Doug Beare to aggregate ICOADS data.

## Aggregate EEZ data by year, month, and country

psql -d ${DB} -U postgres -c "SET SEARCH_PATH to global; 
DROP TABLE IF EXISTS clim_icoads_world_eez_mth_yr;

SELECT AVG(sst) as mean_sst, AVG(at) as mean_at, EXTRACT(year from timestamp) as year, 
EXTRACT(month from timestamp) as month, COUNT(sst) as n_sst, count(at) as n_at, 
country 
INTO clim_icoads_world_eez_mth_yr
FROM clim_icoads_world_eez 
GROUP BY year, month, country;

COMMENT ON TABLE global.clim_icoads_world_eez_mth_yr IS 'These are global historic marine surface sea surface and air temperature data from icoads aggregated (means) 
over year, month, & EEZ. See (www.cdc.noaa.gov)';
"




## Aggregate EEZ data by year and country

psql -d ${DB} -U postgres -c "SET SEARCH_PATH to global; 
DROP TABLE IF EXISTS clim_icoads_world_eez_yr;

SELECT AVG(sst) as mean_sst, AVG(at) as mean_at, EXTRACT(year from timestamp) as year, 
COUNT(sst) as n_sst, count(at) as n_at, 
country 
INTO clim_icoads_world_eez_yr
FROM clim_icoads_world_eez 
GROUP BY year, country ORDER BY year, country 
 ;
COMMENT ON TABLE global.clim_icoads_world_eez_yr IS 'These are global historic marine surface sea surface and air temperature data from icoads aggregated (means) 
over year & EEZ. See (www.cdc.noaa.gov)';"

#### Do the same with the gridded data : 

### By month and year
### SST 
psql -d ${DB} -U postgres -c "SET SEARCH_PATH to global; 
DROP TABLE IF EXISTS clim_icoads_world_gridded_sst_eez_mth_yr;

SELECT AVG(m) as mean_sst, EXTRACT(year from timestamp) as year, 
EXTRACT(month from timestamp) as month, COUNT(n) as n_sst, 
country 
INTO clim_icoads_world_gridded_sst_eez_mth_yr
FROM clim_icoads_world_gridded_eez 
WHERE clim_icoads_world_gridded_eez.type = 'SST'
GROUP BY year, month, country ORDER BY year,month, country 
 ;
COMMENT ON TABLE global.clim_icoads_world_gridded_sst_eez_mth_yr IS 'These are global historic marine surface sea surface temperature data from icoads gridded data, aggregated (means) 
over year, month, & EEZ. See (www.cdc.noaa.gov)';
"

### AIRT ### 
psql -d ${DB} -U postgres -c "SET SEARCH_PATH to global; 
DROP TABLE IF EXISTS clim_icoads_world_gridded_airt_eez_mth_yr;

SELECT AVG(m) as mean_airt, EXTRACT(year from timestamp) as year, 
EXTRACT(month from timestamp) as month, COUNT(n) as n_airt, 
country 
INTO clim_icoads_world_gridded_airt_eez_mth_yr
FROM clim_icoads_world_gridded_eez 
WHERE clim_icoads_world_gridded_eez.type = 'AIRT'
GROUP BY year, month, country ORDER BY year,month, country 
 ;
COMMENT ON TABLE global.clim_icoads_world_gridded_airt_eez_mth_yr IS 'These are global historic marine surface air temperature data from icoads gridded data, aggregated (means) 
over year, month, & EEZ. See (www.cdc.noaa.gov)';
"

### WINDSTRESS 
psql -d ${DB} -U postgres -c "SET SEARCH_PATH to global; 
DROP TABLE IF EXISTS clim_icoads_world_gridded_windstress_eez_mth_yr;

SELECT AVG(m) as mean_windstress, EXTRACT(year from timestamp) as year, 
EXTRACT(month from timestamp) as month, COUNT(n) as n_windstress, 
country 
INTO clim_icoads_world_gridded_windstress_eez_mth_yr
FROM clim_icoads_world_gridded_eez 
WHERE clim_icoads_world_gridded_eez.type = 'WINDSTRESS'
GROUP BY year, month, country ORDER BY year,month, country 
 ;
COMMENT ON TABLE global.clim_icoads_world_gridded_windstress_eez_mth_yr IS 'These are global historic marine surface windstress data from icoads gridded data, aggregated (means) 
over year, month, & EEZ. See (www.cdc.noaa.gov)';
"


#### Do the same with the gridded data : 

### By year ###
### SST ### 
psql -d ${DB} -U postgres -c "SET SEARCH_PATH to global; 
DROP TABLE IF EXISTS clim_icoads_world_gridded_sst_eez_yr;

SELECT AVG(m) as mean_sst, EXTRACT(year from timestamp) as year, 
COUNT(n) as n_sst, 
country 
INTO clim_icoads_world_gridded_sst_eez_yr
FROM clim_icoads_world_gridded_eez 
WHERE clim_icoads_world_gridded_eez.type = 'SST'
GROUP BY year, country ORDER BY year, country 
 ;
COMMENT ON TABLE global.clim_icoads_world_gridded_sst_eez_yr IS 'These are global historic marine surface sea surface temperature data from icoads gridded data, aggregated (means) 
over year & EEZ. See (www.cdc.noaa.gov)';
"

### AIRT ### 
psql -d ${DB} -U postgres -c "SET SEARCH_PATH to global; 
DROP TABLE IF EXISTS clim_icoads_world_gridded_airt_eez_yr;

SELECT AVG(m) as mean_airt, EXTRACT(year from timestamp) as year, COUNT(n) as n_airt, 
country 
INTO clim_icoads_world_gridded_airt_eez_yr
FROM clim_icoads_world_gridded_eez 
WHERE clim_icoads_world_gridded_eez.type = 'AIRT'
GROUP BY year, country ORDER BY year, country 
 ;
COMMENT ON TABLE global.clim_icoads_world_gridded_airt_eez_yr IS 'These are global historic marine surface air temperature data from icoads gridded data, aggregated (means) 
over year, & EEZ. See (www.cdc.noaa.gov)';
"

### WINDSTRESS 
psql -d ${DB} -U postgres -c "SET SEARCH_PATH to global; 
DROP TABLE IF EXISTS clim_icoads_world_gridded_windstress_eez_yr;

SELECT AVG(m) as mean_windstress, EXTRACT(year from timestamp) as year, COUNT(n) as n_windstress, 
country 
INTO clim_icoads_world_gridded_windstress_eez_yr
FROM clim_icoads_world_gridded_eez 
WHERE clim_icoads_world_gridded_eez.type = 'WINDSTRESS'
GROUP BY year, country ORDER BY year, country 
 ;
COMMENT ON TABLE global.clim_icoads_world_gridded_windstress_eez_yr IS 'These are global historic marine surface windstress data from icoads gridded data, aggregated (means) 
over year, & EEZ. See (www.cdc.noaa.gov)';
"















## Aggregate EEZ data by year and country

psql -d ${DB} -U postgres -c "SET SEARCH_PATH to global; 
DROP TABLE IF EXISTS clim_icoads_world_eez_yr;

SELECT AVG(sst) as mean_sst, AVG(at) as mean_at, EXTRACT(year from timestamp) as year, 
COUNT(sst) as n_sst, count(at) as n_at, 
country 
INTO clim_icoads_world_eez_yr
FROM clim_icoads_world_eez 
GROUP BY year, country ORDER BY year, country 
 ;
COMMENT ON TABLE global.clim_icoads_world_eez_yr IS 'These are global historic marine surface sea surface and air temperature data from icoads aggregated (means) 
over year & EEZ. See (www.cdc.noaa.gov)';"








