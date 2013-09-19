
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
GROUP BY year, month, country ORDER BY year,month, country 
 ;
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











