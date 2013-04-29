
#!/usr/bin/perl -w

require "aas_db.pl";
## require "common.pl";

#use strict;

print PSQL ("SET SEARCH_PATH TO global;\n");

print PSQL ("CREATE OR REPLACE VIEW fish_global_fish_production 
AS 
SELECT fish_capture.country, fish_capture.species, fish_capture.prodarea, fish_capture.measure, 
fish_capture.year, sum(fish_capture.quantity) AS landings_sum, count(fish_capture.quantity) AS landings_count, 
sum(aqua_production.quantity) AS aqua_production_sum, count(aqua_production.quantity) AS aqua_production_count
FROM global.fish_capture, global.aqua_production
GROUP BY fish_capture.country, fish_capture.species, fish_capture.prodarea, fish_capture.measure, fish_capture.year;
 \n");
 
print PSQL ("COMMENT ON VIEW fish_global_fish_production IS 'Capture and aquaculture production by species, year, country and fishing area for the globe from FAO time-series data';\n");


print PSQL ("DROP VIEW  fish_global_capture_production_by_economic_region CASCADE;\n");

print PSQL ("CREATE VIEW fish_global_capture_production_by_economic_region
  AS
  SELECT  
  fish_capture.species, 
  fish_capture.prodarea, 
  fish_capture.measure, 
  fish_capture.year, 
  fish_capture.quantity, 
  socioecon_groupings.country, 
  socioecon_groupings.economic_status
FROM 
  global.fish_capture, 
  global.socioecon_groupings
WHERE 
  fish_capture.measure = 'Quantity (tonnes)' AND fish_capture.country = socioecon_groupings.country 
ORDER BY
  fish_capture.year ASC, 
  fish_capture.species ASC, 
  fish_capture.country ASC;            \n");
 
print PSQL ("COMMENT ON VIEW fish_global_capture_production_by_economic_region IS 'Landings by Economic Region';\n");

###########################################################################################

print PSQL ("DROP VIEW   GlobalAquacultureProductionByEconomicRegion  CASCADE;\n");

print PSQL ("CREATE VIEW GlobalAquacultureProductionByEconomicRegion 
AS

 SELECT  
  aquaproduction.species, 
  aquaproduction.fishingarea, 
  aquaproduction.environment, 
  aquaproduction.year, 
  aquaproduction.quantity as weight,
  aquavalue.quantity      as cash_value, 
  econgroupings.country, 
  econgroupings.economic_status
FROM 
  fisheries.aquaproduction,
  fisheries.aquavalue, 
  public.econgroupings
WHERE 
  aquaproduction.country = econgroupings.country
ORDER BY
  aquaproduction.year ASC, 
  aquaproduction.country ASC, 
  aquaproduction.species ASC ;\n");  
 
 
 
print PSQL ("COMMENT ON VIEW GlobalAquacultureProductionByEconomicRegion IS 'Aquaculture production (weight and cash) by Economic Region';\n");


##########################################################################################

print PSQL ("DROP VIEW  GlobalCaptureFishProductionByEconomicRegionWithPopulation CASCADE;\n");

print PSQL ("CREATE VIEW GlobalCaptureFishProductionByEconomicRegionWithPopulation 
  AS

SELECT 
  capture.species, 
  capture.fishingarea, 
  capture.measure, 
  capture.quantity as weight, 
  econgroupings.country, 
  econgroupings.economic_status, 
  population.quantity as population, 
  population.year, 
  population.unit, 
  population.element, 
  population.item
FROM 
  fisheries.capture, 
  public.econgroupings, 
  resources.population
WHERE 
  capture.measure = 'Quantity (tonnes)' AND 
  capture.country = econgroupings.country AND
  capture.country = population.country AND
  capture.year    = population.year AND
  population.element = 'Total Population - Both sexes'
ORDER BY
  capture.year ASC, 
  capture.country ASC, 
  capture.species ASC; \n");


##########################################################################################

### Capture fisheries by country starting with E Timor and the Hubs ## 

### East Timor 

print PSQL ("DROP VIEW  CaptureFishProductionETimorWithPopulation CASCADE;\n");

print PSQL ("CREATE VIEW CaptureFishProductionETimorWithPopulation 
  AS

SELECT 
  capture.species, 
  capture.fishingarea, 
  capture.measure, 
  capture.quantity as weight,
  capture.country,
  population.quantity as population, 
  population.year, 
  population.unit, 
  population.element, 
  population.item
FROM 
  fisheries.capture, 
  resources.population
WHERE 
  capture.measure = 'Quantity (tonnes)' AND 
  capture.country = population.country AND
  capture.country = 'Timor-Leste' AND
  capture.year    = population.year AND
  population.element = 'Total Population - Both sexes'
ORDER BY
  capture.year ASC, 
  capture.country ASC, 
  capture.species ASC; \n");

print PSQL ("COMMENT ON VIEW CaptureFishProductionETimorWithPopulation  IS 'Capture fish production (weight and cash) in East Timor with human population information';\n");

### Bangladesh 

print PSQL ("DROP VIEW  CaptureFishProductionBanglaWithPopulation CASCADE;\n");

print PSQL ("CREATE VIEW CaptureFishProductionBanglaWithPopulation 
  AS

SELECT 
  capture.species, 
  capture.fishingarea, 
  capture.measure, 
  capture.quantity as weight,
  capture.country,
  population.quantity as population, 
  population.year, 
  population.unit, 
  population.element, 
  population.item
FROM 
  fisheries.capture, 
  resources.population
WHERE 
  capture.measure = 'Quantity (tonnes)' AND 
  capture.country = population.country AND
  capture.country = 'Bangladesh' AND
  capture.year    = population.year AND
  population.element = 'Total Population - Both sexes'
ORDER BY
  capture.year ASC, 
  capture.country ASC, 
  capture.species ASC; \n");

print PSQL ("COMMENT ON VIEW CaptureFishProductionBanglaWithPopulation IS 'Capture fish production (weight and cash) in Bangladesh with human population information';\n");


### Sollies 

print PSQL ("DROP VIEW  CaptureFishProductionSolomonWithPopulation CASCADE;\n");

print PSQL ("CREATE VIEW CaptureFishProductionSolomonWithPopulation 
  AS

SELECT 
  capture.species, 
  capture.fishingarea, 
  capture.measure, 
  capture.quantity as weight,
  capture.country,
  population.quantity as population, 
  population.year, 
  population.unit, 
  population.element, 
  population.item
FROM 
  fisheries.capture, 
  resources.population
WHERE 
  capture.measure = 'Quantity (tonnes)' AND 
  capture.country = population.country AND
  capture.country = 'Solomon Islands' AND
  capture.year    = population.year AND
  population.element = 'Total Population - Both sexes'
ORDER BY
  capture.year ASC, 
  capture.country ASC, 
  capture.species ASC; \n");

print PSQL ("COMMENT ON VIEW CaptureFishProductionSolomonWithPopulation IS 'Capture fish production (weight and cash) in Solomon Islands with human population information';\n");


### Cambodia 

print PSQL ("DROP VIEW  CaptureFishProductionCambodiaWithPopulation CASCADE;\n");

print PSQL ("CREATE VIEW CaptureFishProductionCambodiaWithPopulation 
  AS

SELECT 
  capture.species, 
  capture.fishingarea, 
  capture.measure, 
  capture.quantity as weight,
  capture.country,
  population.quantity as population, 
  population.year, 
  population.unit, 
  population.element, 
  population.item
FROM 
  fisheries.capture, 
  resources.population
WHERE 
  capture.measure = 'Quantity (tonnes)' AND 
  capture.country = population.country AND
  capture.country = 'Cambodia' AND
  capture.year    = population.year AND
  population.element = 'Total Population - Both sexes'
ORDER BY
  capture.year ASC, 
  capture.country ASC, 
  capture.species ASC; \n");

print PSQL ("COMMENT ON VIEW CaptureFishProductionCambodiaWithPopulation IS 'Capture fish production (weight and cash) in Cambodia with human population information';\n");


### Zambia 

print PSQL ("DROP VIEW  CaptureFishProductionZambiaWithPopulation CASCADE;\n");

print PSQL ("CREATE VIEW CaptureFishProductionZambiaWithPopulation 
  AS

SELECT 
  capture.species, 
  capture.fishingarea, 
  capture.measure, 
  capture.quantity as weight,
  capture.country,
  population.quantity as population, 
  population.year, 
  population.unit, 
  population.element, 
  population.item
FROM 
  fisheries.capture, 
  resources.population
WHERE 
  capture.measure = 'Quantity (tonnes)' AND 
  capture.country = population.country AND
  capture.country = 'Zambia' AND
  capture.year    = population.year AND
  population.element = 'Total Population - Both sexes'
ORDER BY
  capture.year ASC, 
  capture.country ASC, 
  capture.species ASC; \n");

print PSQL ("COMMENT ON VIEW CaptureFishProductionZambiaWithPopulation IS 'Capture fish production (weight and cash) in Zambia with human population information';\n");


### Phillies 

print PSQL ("DROP VIEW  CaptureFishProductionPhilippinesWithPopulation CASCADE;\n");

print PSQL ("CREATE VIEW CaptureFishProductionPhilippinesWithPopulation 
  AS

SELECT 
  capture.species, 
  capture.fishingarea, 
  capture.measure, 
  capture.quantity as weight,
  capture.country,
  population.quantity as population, 
  population.year, 
  population.unit, 
  population.element, 
  population.item
FROM 
  fisheries.capture, 
  resources.population
WHERE 
  capture.measure = 'Quantity (tonnes)' AND 
  capture.country = population.country AND
  capture.country = 'Philippines' AND
  capture.year    = population.year AND
  population.element = 'Total Population - Both sexes'
ORDER BY
  capture.year ASC, 
  capture.country ASC, 
  capture.species ASC; \n");

print PSQL ("COMMENT ON VIEW CaptureFishProductionPhilippinesWithPopulation IS 'Capture fish production (weight and cash) in Philippines with human population information';\n");


############# Aquaculture by Country ############################

## East Timor

print PSQL ("DROP VIEW   AquacultureProductionETimor  CASCADE;\n");

print PSQL ("CREATE VIEW AquacultureProductionETimor 
AS

 SELECT  
  aquaproduction.species, 
  aquaproduction.fishingarea, 
  aquaproduction.environment,
  aquaproduction.country, 
  aquaproduction.year, 
  aquaproduction.quantity as weight,
  aquavalue.quantity      as cash_value 
  
FROM 
  fisheries.aquaproduction,
  fisheries.aquavalue 

WHERE 
  aquaproduction.country = 'Timor-Leste' 
ORDER BY
  aquaproduction.year ASC, 
  aquaproduction.country ASC, 
  aquaproduction.species ASC ;\n");  
 
 
 
print PSQL ("COMMENT ON VIEW AquacultureProductionETimor IS 'Aquaculture production (weight and cash) in East Timor';\n");

## Bangladesh ## 

print PSQL ("DROP VIEW   fisheries.AquacultureProductionBangladesh CASCADE;\n");

print PSQL ("CREATE VIEW fisheries.AquacultureProductionBangledesh
AS
SELECT  
  aquaproduction.species, 
  aquaproduction.fishingarea, 
  aquaproduction.environment,
  aquaproduction.country, 
  aquaproduction.year, 
  aquaproduction.quantity as weight,
  aquavalue.quantity      as cash_value  
FROM 
  fisheries.aquaproduction,
  fisheries.aquavalue 

WHERE 
  aquaproduction.country = 'Bangladesh' 
ORDER BY
  aquaproduction.year ASC, 
  aquaproduction.country ASC, 
  aquaproduction.species ASC ;\n");  
 
 print PSQL ("COMMENT ON VIEW AquacultureProductionBangladesh IS 'Aquaculture production (weight and cash) in Bangladesh';\n");









close(PSQL);



