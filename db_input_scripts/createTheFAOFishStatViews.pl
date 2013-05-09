
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

###### Global capture fish production by economic region #########

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

print PSQL ("DROP VIEW   aqua_global_production_with_economic_region  CASCADE;\n");

print PSQL ("CREATE VIEW aqua_global_production_with_economic_region
AS

 SELECT  
  aqua_production.species, 
  aqua_production.environment, 
  aqua_production.year, 
  aqua_production.quantity as weight,
  aqua_value.quantity      as cash_value, 
  socioecon_groupings.country, 
  socioecon_groupings.economic_status
FROM 
  aqua_production,
  aqua_value, 
  socioecon_groupings
WHERE 
  aqua_production.country = socioecon_groupings.country
ORDER BY
  aqua_production.year ASC, 
  aqua_production.country ASC, 
  aqua_production.species ASC ;\n");  
 
 
 
print PSQL ("COMMENT ON VIEW aqua_global_production_with_economic_region IS  'Total aquaculture production (weight and cash) with economic region';\n");

##########################################################################################

print PSQL ("DROP VIEW  fish_capture_production_with_economic_region_and_population CASCADE;\n");

print PSQL ("CREATE VIEW fish_capture_production_with_economic_region_and_population
  AS

SELECT 
  fish_capture.species, 
  fish_capture.prodarea, 
  fish_capture.measure, 
  fish_capture.quantity as weight, 
  socioecon_groupings.country, 
  socioecon_groupings.economic_status, 
  socioecon_population.quantity as population, 
  socioecon_population.year, 
  socioecon_population.unit, 
  socioecon_population.element, 
  socioecon_population.item
FROM 
  fish_capture, 
  socioecon_groupings, 
  socioecon_population
WHERE 
  fish_capture.measure = 'Quantity (tonnes)' AND 
  fish_capture.country = socioecon_groupings.country AND
  fish_capture.country = socioecon_population.country AND
  fish_capture.year    = socioecon_population.year AND
  socioecon_population.element = 'Total Population - Both sexes'
ORDER BY
  fish_capture.year ASC, 
  fish_capture.country ASC, 
  fish_capture.species ASC; \n");

print PSQL ("COMMENT ON VIEW fish_capture_production_with_economic_region_and_population IS  'Total capture production (tonnes) with economic region and population';\n");




##########################################################################################

### Capture fisheries by country starting with E Timor and the Hubs ## 

### East Timor 

print PSQL ("SET SEARCH_PATH to timorleste;\n");

print PSQL ("DROP VIEW  timorleste.fish_capture_production_with_population CASCADE;\n");

print PSQL ("CREATE VIEW timorleste.fish_capture_production_with_population
  AS

SELECT 
  fish_capture.species, 
  fish_capture.prodarea, 
  fish_capture.measure, 
  fish_capture.quantity as weight,
  fish_capture.country,
  socioecon_population.quantity as population, 
  socioecon_population.year, 
  socioecon_population.unit, 
  socioecon_population.element, 
  socioecon_population.item
FROM 
  global.fish_capture, 
  global.socioecon_population
WHERE 
  fish_capture.measure = 'Quantity (tonnes)' AND 
  fish_capture.country = socioecon_population.country AND
  fish_capture.country = 'Timor-Leste' AND
  fish_capture.year    = socioecon_population.year AND
  socioecon_population.element = 'Total Population - Both sexes'
ORDER BY
  fish_capture.year ASC, 
  fish_capture.country ASC, 
  fish_capture.species ASC; \n");

print PSQL ("COMMENT ON VIEW timorleste.fish_capture_production_with_population IS 'Capture fish production (weight and cash) in East Timor with human population information'; \n");

### Bangladesh #########


print PSQL ("SET SEARCH_PATH to bangladesh;\n");

print PSQL ("DROP VIEW  bangladesh.fish_capture_production_with_population CASCADE;\n");

print PSQL ("CREATE VIEW bangladesh.fish_capture_production_with_population
  AS

SELECT 
  fish_capture.species, 
  fish_capture.prodarea, 
  fish_capture.measure, 
  fish_capture.quantity as weight,
  fish_capture.country,
  socioecon_population.quantity as population, 
  socioecon_population.year, 
  socioecon_population.unit, 
  socioecon_population.element, 
  socioecon_population.item
FROM 
  global.fish_capture, 
  global.socioecon_population
WHERE 
  fish_capture.measure = 'Quantity (tonnes)' AND 
  fish_capture.country = socioecon_population.country AND
  fish_capture.country = 'Bangladesh' AND
  fish_capture.year    = socioecon_population.year AND
  socioecon_population.element = 'Total Population - Both sexes'
ORDER BY
  fish_capture.year ASC, 
  fish_capture.country ASC, 
  fish_capture.species ASC; \n");

print PSQL ("COMMENT ON VIEW bangladesh.fish_capture_production_with_population IS 'Capture fish production (weight and cash) in Bangladesh with human population information'; \n");



### Sollies 

print PSQL ("SET SEARCH_PATH to Solomons;\n");

print PSQL ("DROP VIEW  solomons.fish_capture_production_with_population CASCADE;\n");

print PSQL ("CREATE VIEW solomons.fish_capture_production_with_population
  AS

SELECT 
  fish_capture.species, 
  fish_capture.prodarea, 
  fish_capture.measure, 
  fish_capture.quantity as weight,
  fish_capture.country,
  socioecon_population.quantity as population, 
  socioecon_population.year, 
  socioecon_population.unit, 
  socioecon_population.element, 
  socioecon_population.item
FROM 
  global.fish_capture, 
  global.socioecon_population
WHERE 
  fish_capture.measure = 'Quantity (tonnes)' AND 
  fish_capture.country = socioecon_population.country AND
  fish_capture.country = 'Solomon Islands' AND
  fish_capture.year    = socioecon_population.year AND
  socioecon_population.element = 'Total Population - Both sexes'
ORDER BY
  fish_capture.year ASC, 
  fish_capture.country ASC, 
  fish_capture.species ASC; \n");

print PSQL ("COMMENT ON VIEW solomons.fish_capture_production_with_population IS 'Capture fish production (weight, tonnes) in Solomons with human population information'; \n");


### Cambodia 

print PSQL ("SET SEARCH_PATH to cambodia;\n");

print PSQL ("DROP VIEW  cambodia.fish_capture_production_with_population CASCADE;\n");

print PSQL ("CREATE VIEW cambodia.fish_capture_production_with_population
  AS

SELECT 
  fish_capture.species, 
  fish_capture.prodarea, 
  fish_capture.measure, 
  fish_capture.quantity as weight,
  fish_capture.country,
  socioecon_population.quantity as population, 
  socioecon_population.year, 
  socioecon_population.unit, 
  socioecon_population.element, 
  socioecon_population.item
FROM 
  global.fish_capture, 
  global.socioecon_population
WHERE 
  fish_capture.measure = 'Quantity (tonnes)' AND 
  fish_capture.country = socioecon_population.country AND
  fish_capture.country = 'Cambodia' AND
  fish_capture.year    = socioecon_population.year AND
  socioecon_population.element = 'Total Population - Both sexes'
ORDER BY
  fish_capture.year ASC, 
  fish_capture.country ASC, 
  fish_capture.species ASC; \n");

print PSQL ("COMMENT ON VIEW cambodia.fish_capture_production_with_population IS 'Capture fish production (weight, tonnes) in cambodia with human population information'; \n");


### Zambia 

print PSQL ("SET SEARCH_PATH to zambia;\n");

print PSQL ("DROP VIEW  zambia.fish_capture_production_with_population CASCADE;\n");

print PSQL ("CREATE VIEW zambia.fish_capture_production_with_population
  AS

SELECT 
  fish_capture.species, 
  fish_capture.prodarea, 
  fish_capture.measure, 
  fish_capture.quantity as weight,
  fish_capture.country,
  socioecon_population.quantity as population, 
  socioecon_population.year, 
  socioecon_population.unit, 
  socioecon_population.element, 
  socioecon_population.item
FROM 
  global.fish_capture, 
  global.socioecon_population
WHERE 
  fish_capture.measure = 'Quantity (tonnes)' AND 
  fish_capture.country = socioecon_population.country AND
  fish_capture.country = 'Zambia' AND
  fish_capture.year    = socioecon_population.year AND
  socioecon_population.element = 'Total Population - Both sexes'
ORDER BY
  fish_capture.year ASC, 
  fish_capture.country ASC, 
  fish_capture.species ASC; \n");

print PSQL ("COMMENT ON VIEW zambia.fish_capture_production_with_population IS 'Capture fish production (weight, tonnes) in Zambia with human population information'; \n");


### Phillies 

print PSQL ("SET SEARCH_PATH to philippines;\n");

print PSQL ("DROP VIEW  philippines.fish_capture_production_with_population CASCADE;\n");

print PSQL ("CREATE VIEW philippines.fish_capture_production_with_population
  AS

SELECT 
  fish_capture.species, 
  fish_capture.prodarea, 
  fish_capture.measure, 
  fish_capture.quantity as weight,
  fish_capture.country,
  socioecon_population.quantity as population, 
  socioecon_population.year, 
  socioecon_population.unit, 
  socioecon_population.element, 
  socioecon_population.item
FROM 
  global.fish_capture, 
  global.socioecon_population
WHERE 
  fish_capture.measure = 'Quantity (tonnes)' AND 
  fish_capture.country = 'Philippines' AND socioecon_population.country = 'Philippines' AND
  fish_capture.year    = socioecon_population.year AND
  socioecon_population.element = 'Total Population - Both sexes'
ORDER BY
  fish_capture.year ASC, 
  fish_capture.country ASC, 
  fish_capture.species ASC; \n");

print PSQL ("COMMENT ON VIEW philippines.fish_capture_production_with_population IS 'Capture fish production (weight, tonnes) in Philippines with human population information'; \n");


### Vietnam

print PSQL ("SET SEARCH_PATH to vietnam;\n");

print PSQL ("DROP VIEW  vietnam.fish_capture_production_with_population CASCADE;\n");

print PSQL ("CREATE VIEW vietnam.fish_capture_production_with_population
  AS

SELECT 
  fish_capture.species, 
  fish_capture.prodarea, 
  fish_capture.measure, 
  fish_capture.quantity as weight,
  fish_capture.country,
  socioecon_population.quantity as population, 
  socioecon_population.year, 
  socioecon_population.unit, 
  socioecon_population.element, 
  socioecon_population.item
FROM 
  global.fish_capture, 
  global.socioecon_population
WHERE 
  fish_capture.measure = 'Quantity (tonnes)' AND 
  fish_capture.country = 'Viet Nam' AND socioecon_population.country = 'Viet Nam' AND
  fish_capture.year    = socioecon_population.year AND
  socioecon_population.element = 'Total Population - Both sexes'
ORDER BY
  fish_capture.year ASC, 
  fish_capture.country ASC, 
  fish_capture.species ASC; \n");

print PSQL ("COMMENT ON VIEW vietnam.fish_capture_production_with_population IS 'Capture fish production (weight, tonnes) in Vietnam with human population information'; \n");










#################################################################
############# Aquaculture by Country ############################

## East Timor

print PSQL ("SET SEARCH_PATH to timorleste;\n");

print PSQL ("DROP VIEW   aqua_production_and_cash  CASCADE;\n");

print PSQL ("CREATE VIEW aqua_production_and_cash
AS

 SELECT  
  aqua_production.species, 
  aqua_production.prodarea, 
  aqua_production.environment,
  aqua_production.country, 
  aqua_production.year, 
  aqua_production.quantity as weight,
  aqua_value.quantity      as cash_value 
  
FROM 
  global.aqua_production,
  global.aqua_value 

WHERE 
  aqua_production.country = 'Timor-Leste' AND aqua_value.country = 'Timor-Leste'
ORDER BY
  aqua_production.year ASC, 
  aqua_production.country ASC, 
  aqua_production.species ASC ;\n");  
 
 
print PSQL ("COMMENT ON VIEW aqua_production_and_cash IS 'Aquaculture production (weight and cash) in East Timor';\n");

## Bangladesh ## 

print PSQL ("SET SEARCH_PATH to bangladesh;\n");

print PSQL ("DROP VIEW   aqua_production_and_cash  CASCADE;\n");

print PSQL ("CREATE VIEW aqua_production_and_cash
AS

 SELECT  
  aqua_production.species, 
  aqua_production.prodarea, 
  aqua_production.environment,
  aqua_production.country, 
  aqua_production.year, 
  aqua_production.quantity as weight,
  aqua_value.quantity      as cash_value 
  
FROM 
  global.aqua_production,
  global.aqua_value 

WHERE 
  aqua_production.country = 'Bangladesh' AND aqua_value.country = 'Bangladesh'
ORDER BY
  aqua_production.year ASC, 
  aqua_production.country ASC, 
  aqua_production.species ASC ;\n");  
 
 
 
print PSQL ("COMMENT ON VIEW aqua_production_and_cash IS 'Aquaculture production (weight and cash) in Bangladesh';\n");

##### Cambodia ##########

print PSQL ("SET SEARCH_PATH to cambodia;\n");

print PSQL ("DROP VIEW   aqua_production_and_cash  CASCADE;\n");

print PSQL ("CREATE VIEW aqua_production_and_cash
AS

 SELECT  
  aqua_production.species, 
  aqua_production.prodarea, 
  aqua_production.environment,
  aqua_production.country, 
  aqua_production.year, 
  aqua_production.quantity as weight,
  aqua_value.quantity      as cash_value 
  
FROM 
  global.aqua_production,
  global.aqua_value 

WHERE 
  aqua_production.country = 'Cambodia' AND aqua_value.country = 'Cambodia'
ORDER BY
  aqua_production.year ASC, 
  aqua_production.country ASC, 
  aqua_production.species ASC ;\n");  
 
 
 
print PSQL ("COMMENT ON VIEW aqua_production_and_cash IS 'Aquaculture production (weight and cash) in Cambodia';\n");

##### Vietnam ##########

print PSQL ("SET SEARCH_PATH to vietnam;\n");

print PSQL ("DROP VIEW   aqua_production_and_cash  CASCADE;\n");

print PSQL ("CREATE VIEW aqua_production_and_cash
AS

 SELECT  
  aqua_production.species, 
  aqua_production.prodarea, 
  aqua_production.environment,
  aqua_production.country, 
  aqua_production.year, 
  aqua_production.quantity as weight,
  aqua_value.quantity      as cash_value 
  
FROM 
  global.aqua_production,
  global.aqua_value 

WHERE 
  aqua_production.country = 'Viet Nam' AND aqua_value.country = 'Viet Nam'
ORDER BY
  aqua_production.year ASC, 
  aqua_production.country ASC, 
  aqua_production.species ASC ;\n");  
 
 
 
print PSQL ("COMMENT ON VIEW aqua_production_and_cash IS 'Aquaculture production (weight and cash) in Vietnam';\n");






close(PSQL);



