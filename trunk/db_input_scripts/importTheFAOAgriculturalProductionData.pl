#!/usr/bin/perl -w

require "aas_db.pl";

 use strict;

### AUTHOR: Doug Beare

####################################
## THIS PROGRAM MUST BE RUN BY POSTGRES#
####################################
 
 ## PURPOSE: CREATE THE FAOSTAT DATABASE

 ## CREATE THE DATABASE AND SCHEMAS IN POSTGRESQL


##################################################################################

print PSQL ("SET SEARCH_PATH TO global; \n");


### Prodstat crops #####################

print PSQL ("DROP TABLE agri_prodstat_crops; \n");

print PSQL ("CREATE TABLE agri_prodstat_crops (
    country_code        integer,
    country       varchar(72),
    item_code     varchar(12),
    item         varchar(72),
    element_group   integer,
    element_code       varchar(24),
    element      varchar(24),
unit varchar(12),
    year         integer,
    quantity float); \n");

print PSQL ("COMMENT ON TABLE agri_prodstat_crops IS 'These are FAOSTAT crop production data Afghanistan to Zimbabwe from the bulk download area http://faostat.fao.org/site/491/default.aspx ';\n"); 
print PSQL ("COMMENT ON COLUMN agri_prodstat_crops_processed.unit IS 'Unit crop quantity is measured in';\n");
print PSQL ("\\COPY agri_prodstat_crops FROM '/srv/public/input_data_files/FAOSTAT/tmp/Relational_production-crops1.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 
print PSQL ("\\COPY agri_prodstat_crops FROM '/srv/public/input_data_files/FAOSTAT/tmp/Relational_production-crops2.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 
print PSQL ("\\COPY agri_prodstat_crops FROM '/srv/public/input_data_files/FAOSTAT/tmp/Relational_production-crops3.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 
print PSQL ("\\COPY agri_prodstat_crops FROM '/srv/public/input_data_files/FAOSTAT/tmp/Relational_production-crops4.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 
print PSQL ("\\COPY agri_prodstat_crops FROM '/srv/public/input_data_files/FAOSTAT/tmp/Relational_production-crops5.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 
print PSQL ("\\COPY agri_prodstat_crops FROM '/srv/public/input_data_files/FAOSTAT/tmp/Relational_production-crops6.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 



# Add on UN georegions and economic groupings

print PSQL ("ALTER TABLE agri_prodstat_crops_processed ADD COLUMN region varchar(36);\n");
print PSQL ("UPDATE agri_prodstat_crops_processed 
SET region = geo_regions.region
FROM geo_regions
WHERE agri_prodstat_crops_processed.country = geo_regions.country;  \n");


print PSQL ("ALTER TABLE agri_prodstat_crops_processed ADD COLUMN continent varchar(36);\n");
print PSQL ("UPDATE agri_prodstat_crops_processed 
SET continent = geo_regions.continent
FROM geo_regions
WHERE agri_prodstat_crops_processed.country = geo_regions.country;  \n");


print PSQL ("ALTER TABLE agri_prodstat_crops_processed ADD COLUMN economic_status varchar(36);\n");
print PSQL ("UPDATE agri_prodstat_crops_processed 
SET economic_status = socioecon_groupings.economic_status
FROM socioecon_groupings
WHERE agri_prodstat_crops_processed.country = socioecon_groupings.country;  \n");












### Prodstat crops processed #####################

print PSQL ("DROP TABLE agri_prodstat_crops_processed; \n");

print PSQL ("CREATE TABLE agri_prodstat_crops_processed (
    country_code        integer,
    country       varchar(72),
    item_code     varchar(12),
    item         varchar(72),
    element_group   integer,
    element_code       varchar(24),
    element      varchar(24),
    year         integer,
    unit  varchar(12),
    quantity     float,
    flag     varchar(12)); \n");

print PSQL ("COMMENT ON TABLE agri_prodstat_crops_processed IS 'These are FAOSTAT processed crop production data Afghanistan to Zimbabwe from the bulk download area http://faostat.fao.org/site/491/default.aspx ';\n"); 
print PSQL ("COMMENT ON COLUMN agri_prodstat_crops_processed.unit IS 'Unit crop quantity is measured in';\n");
print PSQL ("\\COPY agri_prodstat_crops_processed FROM '/srv/public/input_data_files/FAOSTAT/tmp/production-cropsprocessed7.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 


# Add on UN georegions and economic groupings

print PSQL ("ALTER TABLE agri_prodstat_crops_processed ADD COLUMN region varchar(36);\n");
print PSQL ("UPDATE agri_prodstat_crops_processed 
SET region = geo_regions.region
FROM geo_regions
WHERE agri_prodstat_crops_processed.country = geo_regions.country;  \n");


print PSQL ("ALTER TABLE agri_prodstat_crops_processed ADD COLUMN continent varchar(36);\n");
print PSQL ("UPDATE agri_prodstat_crops_processed 
SET continent = geo_regions.continent
FROM geo_regions
WHERE agri_prodstat_crops_processed.country = geo_regions.country;  \n");


print PSQL ("ALTER TABLE agri_prodstat_crops_processed ADD COLUMN economic_status varchar(36);\n");
print PSQL ("UPDATE agri_prodstat_crops_processed 
SET economic_status = socioecon_groupings.economic_status
FROM socioecon_groupings
WHERE agri_prodstat_crops_processed.country = socioecon_groupings.country;  \n");

#################################################################################

#######LIVESTOCK ######################


print PSQL ("DROP TABLE agri_prodstat_livestock; \n");

print PSQL ("CREATE TABLE agri_prodstat_livestock (
    country_code        integer,
    country       varchar(72),
    item_code     varchar(12),
    item         varchar(72),
    element_group integer,
    element_code   integer,
    element        varchar(24),
    year         integer,
    unit         varchar(12),
    quantity     float,
    flag         varchar(12)); \n");

print PSQL ("COMMENT ON TABLE agri_prodstat_livestock IS 'These are FAOSTAT livestock data Afghanistan to Zimbabwe from the bulk download area http://faostat.fao.org/site/491/default.aspx ';\n"); 
print PSQL ("COMMENT ON COLUMN agri_prodstat_livestock.unit IS 'Unit crop quantity is measured in';\n");
print PSQL ("\\COPY agri_prodstat_livestock FROM '/srv/public/input_data_files/FAOSTAT/tmp/production-livestock7.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 


#################################################################################

#######LIVESTOCK ######################


print PSQL ("DROP TABLE agri_prodstat_livestock_primary; \n");

print PSQL ("CREATE TABLE agri_prodstat_livestock_primary (
    country_code        integer,
    country       varchar(72),
    item_code     varchar(12),
    item         varchar(72),
    element_group integer,
    element_code   integer,
    element        varchar(48),
    year         integer,
    unit         varchar(12),
    quantity     float,
    flag varchar(12)); \n");

print PSQL ("COMMENT ON TABLE agri_prodstat_livestock_primary IS 'These are FAOSTAT primary livestock data Afghanistan to Zimbabwe from the bulk download area http://faostat.fao.org/site/491/default.aspx ';\n"); 
print PSQL ("COMMENT ON COLUMN agri_prodstat_livestock_primary.unit IS 'Unit crop quantity is measured in';\n");
print PSQL ("\\COPY agri_prodstat_livestock_primary FROM '/srv/public/input_data_files/FAOSTAT/tmp/production-livestockprimary7.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 


# Add on UN georegions and economic groupings

print PSQL ("ALTER TABLE agri_prodstat_livestock_primary ADD COLUMN region varchar(36);\n");
print PSQL ("UPDATE agri_prodstat_livestock_primary 
SET region = geo_regions.region
FROM geo_regions
WHERE agri_prodstat_livestock_primary.country = geo_regions.country;  \n");


print PSQL ("ALTER TABLE agri_prodstat_livestock_primary ADD COLUMN continent varchar(36);\n");
print PSQL ("UPDATE agri_prodstat_livestock_primary 
SET continent = geo_regions.continent
FROM geo_regions
WHERE agri_prodstat_livestock_primary.country = geo_regions.country;  \n");


print PSQL ("ALTER TABLE agri_prodstat_livestock_primary ADD COLUMN economic_status varchar(36);\n");
print PSQL ("UPDATE agri_prodstat_livestock_primary 
SET economic_status = socioecon_groupings.economic_status
FROM socioecon_groupings
WHERE agri_prodstat_livestock_primary.country = socioecon_groupings.country;  \n");



#################################################################################
############Livestock processed##################################################
#################################################################################


print PSQL ("DROP TABLE agri_prodstat_livestock_processed; \n");

print PSQL ("CREATE TABLE agri_prodstat_livestock_processed (
    country_code        integer,
    country       varchar(72),
    item_code     varchar(12),
    item         varchar(72),
    element_group integer,
    element_code   integer,
    element        varchar(48),
    year         integer,
    unit         varchar(12),
    quantity     float,
    flag  varchar(12)); \n");

print PSQL ("COMMENT ON TABLE agri_prodstat_livestock_processed IS 'These are FAOSTAT processed livestock data Afghanistan to Zimbabwe from http://faostat.fao.org/site/491/default.aspx ';\n"); 
print PSQL ("COMMENT ON COLUMN agri_prodstat_livestock_processed.unit IS 'Unit livestock quantity is measured in';\n");
print PSQL ("\\COPY agri_prodstat_livestock_processed FROM '/srv/public/input_data_files/FAOSTAT/tmp/production-livestockprocessed7.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 


##################################################################################


print PSQL ("DROP TABLE agri_prodstat_value; \n");

print PSQL ("CREATE TABLE agri_prodstat_value (
    country_code        integer,
    country       varchar(72),
    item_code     varchar(72),
    item         varchar(72),
    element_group integer,
    element_code   integer,
    element        varchar(144),
    unit         varchar(72),
    year         integer,
    quantity     float); \n");

print PSQL ("COMMENT ON TABLE agri_prodstat_value IS 'FAOSTAT value of production data Afghan to Zim from the bulk download area http://faostat.fao.org/site/491/default.aspx ';\n"); 
print PSQL ("COMMENT ON COLUMN agri_prodstat_value.unit IS 'Unit crop quantity is measured in';\n");
print PSQL ("\\COPY agri_prodstat_value FROM '/srv/public/input_data_files/FAOSTAT/tmp/Relational_value_of_production1.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 
print PSQL ("\\COPY agri_prodstat_value FROM '/srv/public/input_data_files/FAOSTAT/tmp/Relational_value_of_production2.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 
print PSQL ("\\COPY agri_prodstat_value FROM '/srv/public/input_data_files/FAOSTAT/tmp/Relational_value_of_production3.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 
print PSQL ("\\COPY agri_prodstat_value FROM '/srv/public/input_data_files/FAOSTAT/tmp/Relational_value_of_production4.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 
print PSQL ("\\COPY agri_prodstat_value FROM '/srv/public/input_data_files/FAOSTAT/tmp/Relational_value_of_production5.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 
print PSQL ("\\COPY agri_prodstat_value FROM '/srv/public/input_data_files/FAOSTAT/tmp/Relational_value_of_production6.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 


##################################################################################


print PSQL ("DROP TABLE agri_pins; \n");

print PSQL ("CREATE TABLE agri_pins (
  country_code        integer,
    country       varchar(72),
    item_code     integer,
    item         varchar(72),
    element_group integer,
    element_code   integer,
    element        varchar(144),
    year          integer,
    unit         varchar(72),
    quantity     float,
    flag  varchar(2));\n");

print PSQL ("COMMENT ON TABLE agri_pins IS 'FAOSTAT Production Index Numbers data Afghanistan to Zim from the bulk download area http://faostat.fao.org/site/491/default.aspx ';\n"); 
print PSQL ("COMMENT ON COLUMN agri_pins.unit IS 'Unit quantity is measured in';\n");
print PSQL ("\\COPY agri_pins FROM '/srv/public/input_data_files/FAOSTAT/tmp/pins7.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 


############################################################################################################
#######FILL Trade Statistics data #############################
############################################################################################################

print PSQL ("DROP TABLE agri_trade_crops_livestockproducts; \n");

print PSQL ("CREATE TABLE agri_trade_crops_livestockproducts (
   
    country_code        integer,
    country       varchar(72),
    item_code     integer,
    item         varchar(72),
    element_group integer,
    element_code   integer,
    element        varchar(144),
    unit         varchar(36),
    year          integer,
    quantity     float); \n");

print PSQL ("COMMENT ON TABLE agri_trade_crops_livestockproducts IS 'These are FAOSTAT value of trade statistics data Afghanistan to Zim from the bulk download area http://faostat.fao.org/site/491/default.aspx ';\n"); 
print PSQL ("COMMENT ON COLUMN agri_trade_crops_livestockproducts.unit IS 'Unit crop quantity is measured in';\n");
print PSQL ("\\COPY agri_trade_crops_livestockproducts FROM '/srv/public/input_data_files/FAOSTAT/tmp/Relational_trade-cropslivestockproducts1.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 
print PSQL ("\\COPY agri_trade_crops_livestockproducts FROM '/srv/public/input_data_files/FAOSTAT/tmp/Relational_trade-cropslivestockproducts2.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 
print PSQL ("\\COPY agri_trade_crops_livestockproducts FROM '/srv/public/input_data_files/FAOSTAT/tmp/Relational_trade-cropslivestockproducts3.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 
print PSQL ("\\COPY agri_trade_crops_livestockproducts FROM '/srv/public/input_data_files/FAOSTAT/tmp/Relational_trade-cropslivestockproducts4.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 
print PSQL ("\\COPY agri_trade_crops_livestockproducts FROM '/srv/public/input_data_files/FAOSTAT/tmp/Relational_trade-cropslivestockproducts5.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 
print PSQL ("\\COPY agri_trade_crops_livestockproducts FROM '/srv/public/input_data_files/FAOSTAT/tmp/Relational_trade-cropslivestockproducts6.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 
print PSQL ("\\COPY agri_trade_crops_livestockproducts FROM '/srv/public/input_data_files/FAOSTAT/tmp/Relational_trade-cropslivestockproducts7.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 
print PSQL ("\\COPY agri_trade_crops_livestockproducts FROM '/srv/public/input_data_files/FAOSTAT/tmp/Relational_trade-cropslivestockproducts8.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 



#######################################################################

print PSQL ("DROP TABLE agri_trade_liveanimals; \n");

print PSQL ("CREATE TABLE agri_trade_liveanimals (
    country_code        integer,
    country       varchar(72),
    item_code     integer,
    item         varchar(72),
    element_group integer,
    element_code   integer,
    element        varchar(144),
    year         integer,
    unit         varchar(36),
    quantity     float,
    flag     varchar(2));

 \n");

print PSQL ("COMMENT ON TABLE agri_trade_liveanimals IS 'FAOSTAT cash value of live animals Afghan to Zim from http://faostat.fao.org/site/491/default.aspx ';\n"); 
print PSQL ("COMMENT ON COLUMN agri_trade_liveanimals.unit IS 'Unit cash value is measured in';\n");
print PSQL ("\\COPY agri_trade_liveanimals FROM '/srv/public/input_data_files/FAOSTAT/tmp/trade-liveanimals7.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 

#############Trade index ###############

print PSQL ("DROP TABLE agri_trade_index; \n");

print PSQL ("CREATE TABLE agri_trade_index (
    country_code        integer,
    country       varchar(72),
    item_code     varchar(12),
    item         varchar(72),
    element_group integer,
    element_code   integer,
    element        varchar(72),
    year          integer,
     unit         varchar(12),
    quantity     float,
    flag         varchar(12))   ; \n");


print PSQL ("COMMENT ON TABLE agri_trade_index IS 'These are FAOSTAT value of trade index numbers data Afghanistan to Zim from the bulk download area http://faostat.fao.org/site/491/default.aspx ';\n"); 
print PSQL ("COMMENT ON COLUMN agri_trade_index.unit IS 'Unit quantity is measured in';\n");


print PSQL ("\\COPY agri_trade_index FROM '/srv/public/input_data_files/FAOSTAT/tmp/tradeindexnumbers6.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 


###########################################################################################################
######FILL FOODSUPPLY SCHEMA #############################
###########################################################################################################


print PSQL ("SET SEARCH_PATH TO global;\n");

print PSQL ("DROP TABLE agri_foodsupply_crops_primary_equivalents; \n");

print PSQL ("CREATE TABLE agri_foodsupply_crops_primary_equivalents (
    country_code        integer,
    country       varchar(72),
    item_code     varchar(12),
    item         varchar(72),
    element_group integer,
    element_code   integer,
    element        varchar(72),
    unit         varchar(24),
    year          integer,
    quantity     float) ;
     \n");



print PSQL ("COMMENT ON TABLE agri_foodsupply_crops_primary_equivalents IS 'These are FAOSTAT crop food supply statistics data Afghanistan to Zim from the bulk download area http://faostat.fao.org/site/491/default.aspx ';\n"); 
print PSQL ("COMMENT ON COLUMN agri_foodsupply_crops_primary_equivalents.unit IS 'Unit crop quantity is measured in';\n");
e bulk download file';\n");
print PSQL ("\\COPY agri_foodsupply_crops_primary_equivalents FROM '/srv/public/input_data_files/FAOSTAT/tmp/Relational_foodsupply-cropsprimaryequivalent1.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 
print PSQL ("\\COPY agri_foodsupply_crops_primary_equivalents FROM '/srv/public/input_data_files/FAOSTAT/tmp/Relational_foodsupply-cropsprimaryequivalent2.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 
print PSQL ("\\COPY agri_foodsupply_crops_primary_equivalents FROM '/srv/public/input_data_files/FAOSTAT/tmp/Relational_foodsupply-cropsprimaryequivalent3.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 
print PSQL ("\\COPY agri_foodsupply_crops_primary_equivalents FROM '/srv/public/input_data_files/FAOSTAT/tmp/Relational_foodsupply-cropsprimaryequivalent4.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 
print PSQL ("\\COPY agri_foodsupply_crops_primary_equivalents FROM '/srv/public/input_data_files/FAOSTAT/tmp/Relational_foodsupply-cropsprimaryequivalent5.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 
print PSQL ("\\COPY agri_foodsupply_crops_primary_equivalents FROM '/srv/public/input_data_files/FAOSTAT/tmp/Relational_foodsupply-cropsprimaryequivalent16csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 


# Add on UN georegions and economic groupings

print PSQL ("ALTER TABLE agri_foodsupply_crops_primary_equivalents ADD COLUMN region varchar(36);\n");
print PSQL ("UPDATE agri_foodsupply_crops_primary_equivalents 
SET region = global.geo_regions.region
FROM global.geo_regions
WHERE agri_foodsupply_crops_primary_equivalents.country = global.geo_regions.country;  \n");


print PSQL ("ALTER TABLE agri_foodsupply_crops_primary_equivalents ADD COLUMN continent varchar(36);\n");
print PSQL ("UPDATE agri_foodsupply_crops_primary_equivalents 
SET continent = global.geo_regions.continent
FROM global.geo_regions
WHERE agri_foodsupply_crops_primary_equivalents.country = global.geo_regions.country;  \n");


print PSQL ("ALTER TABLE agri_foodsupply_crops_primary_equivalents ADD COLUMN economic_status varchar(36);\n");
print PSQL ("UPDATE agri_foodsupply_crops_primary_equivalents 
SET economic_status = global.socioecon_groupings.economic_status
FROM global.socioecon_groupings
WHERE agri_foodsupply_crops_primary_equivalents.country = socioecon_groupings.country;  \n");

### LiveStock and Fish Primary Equivalents

print PSQL ("DROP TABLE agri_foodsupply_livestock_fish_equivalents; \n");
print PSQL ("CREATE TABLE agri_foodsupply_livestock_fish_equivalents (
    country_code        integer,
    country       varchar(72),
    item_code     integer,
    item         varchar(72),
    element_group integer,
    element_code   integer,
    element        varchar(144),
    year         integer,
    unit         varchar(36),
    quantity     float,
    flag     varchar(2));\n");

#CountryCode|Country|ItemCode|Item|ElementGroup|ElementCode|Element|Year|Unit|Value|Flag

print PSQL ("COMMENT ON TABLE agri_foodsupply_livestock_fish_equivalents IS 'These are FAOSTAT livestock and fish food supply statistics data Afghanistan to Zim from the bulk download area http://faostat.fao.org/site/491/default.aspx ';\n"); 
print PSQL ("COMMENT ON COLUMN agri_foodsupply_livestock_fish_equivalents.unit IS 'Unit quantity is measured in';\n");


print PSQL ("\\COPY agri_foodsupply_livestock_fish_equivalents FROM '/srv/public/input_data_files/FAOSTAT/tmp/foodsupply-livestockfishprimaryequivalent7.csv.txt' WITH DELIMITER '|' null as '' CSV header \n"); 


print PSQL ("ALTER TABLE agri_foodsupply_livestock_fish_equivalents ADD COLUMN region varchar(36);\n");
print PSQL ("UPDATE agri_foodsupply_livestock_fish_equivalents 
SET region = global.geo_regions.region
FROM global.geo_regions
WHERE agri_foodsupply_livestock_fish_equivalents.country = global.geo_regions.country;  \n");

print PSQL ("ALTER TABLE agri_foodsupply_livestock_fish_equivalents ADD COLUMN continent varchar(36);\n");
print PSQL ("UPDATE agri_foodsupply_livestock_fish_equivalents 
SET continent = global.geo_regions.continent
FROM global.geo_regions
WHERE agri_foodsupply_livestock_fish_equivalents.country = global.geo_regions.country;  \n");

print PSQL ("ALTER TABLE agri_foodsupply_livestock_fish_equivalents ADD COLUMN economic_status varchar(36);\n");
print PSQL ("UPDATE agri_foodsupply_livestock_fish_equivalents 
SET economic_status = global.socioecon_groupings.economic_status
FROM global.socioecon_groupings
WHERE agri_foodsupply_livestock_fish_equivalents.country = global.socioecon_groupings.country;  \n");

###########################################################################################################
######FILL Food balance SCHEMA #############################
###########################################################################################################


print PSQL ("SET SEARCH_PATH TO global;\n");

print PSQL ("DROP TABLE agri_foodbalance__sheets; \n");

print PSQL ("CREATE TABLE agri_foodbalance_sheets (
   country_code        integer,
    country       varchar(72),
    item_code     varchar(12),
    item         varchar(72),
    element_group integer,
    element_code   integer,
    element        varchar(72),
    unit         varchar(24),
    year          integer,
    quantity     float) ;
 \n");

#CountryCode"|"Country"|"ItemCode"|"Item"|"ElementGroup"|"ElementCode"|"Element"|"Unit"|"Year"|"Quantity"


print PSQL ("COMMENT ON TABLE agri_foodbalance_sheets IS 'These are FAOSTAT value of food balance statistics data Afghanistan to Zim from the bulk download area http://faostat.fao.org/site/491/default.aspx ';\n"); 
print PSQL ("COMMENT ON COLUMN foodbalance.sheets.unit IS 'Unit quantity is measured in';\n");

print PSQL ("\\COPY agri_foodbalance_sheets FROM '/srv/public/input_data_files/FAOSTAT/tmp/Relational_foodbalancesheets1.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 
print PSQL ("\\COPY agri_foodbalance_sheets FROM '/srv/public/input_data_files/FAOSTAT/tmp/Relational_foodbalancesheets2.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 
print PSQL ("\\COPY agri_foodbalance_sheets FROM '/srv/public/input_data_files/FAOSTAT/tmp/Relational_foodbalancesheets3.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 
print PSQL ("\\COPY agri_foodbalance_sheets FROM '/srv/public/input_data_files/FAOSTAT/tmp/Relational_foodbalancesheets4.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 
print PSQL ("\\COPY agri_foodbalance_sheets FROM '/srv/public/input_data_files/FAOSTAT/tmp/Relational_foodbalancesheets5.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 
print PSQL ("\\COPY agri_foodbalance_sheets FROM '/srv/public/input_data_files/FAOSTAT/tmp/Relational_foodbalancesheets6csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 
print PSQL ("\\COPY agri_foodbalance_sheets FROM '/srv/public/input_data_files/FAOSTAT/tmp/Relational_foodbalancesheets7csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 
print PSQL ("\\COPY agri_foodbalance_sheets FROM '/srv/public/input_data_files/FAOSTAT/tmp/Relational_foodbalancesheets8csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 




print PSQL ("DROP TABLE agri_foodbalance_commodity_crops; \n");

print PSQL ("CREATE TABLE agri_foodbalance_commodity_crops (
    country_code        integer,
    country       varchar(72),
    item_code     varchar(12),
    item         varchar(72),
    element_group integer,
    element_code   integer,
    element        varchar(72),
    unit         varchar(24),
    year          integer,
    quantity     float) ;



\n");

print PSQL ("COMMENT ON TABLE agri_foodbalance_commodity_crops IS 'These are FAOSTAT value of food balance statistics data Afghanistan to Zim from the bulk download area http://faostat.fao.org/site/491/default.aspx ';\n"); 
print PSQL ("COMMENT ON COLUMN agri_foodbalance_commodity_crops.unit IS 'Unit quantity is measured in';\n");
print PSQL ("\\COPY agri_foodbalance_commodity_crops FROM '/srv/public/input_data_files/FAOSTAT/tmp/Relational_commoditybalances-crops1.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 
print PSQL ("\\COPY agri_foodbalance_commodity_crops FROM '/srv/public/input_data_files/FAOSTAT/tmp/Relational_commoditybalances-crops2.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 
print PSQL ("\\COPY agri_foodbalance_commodity_crops FROM '/srv/public/input_data_files/FAOSTAT/tmp/Relational_commoditybalances-crops3.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 
print PSQL ("\\COPY agri_foodbalance_commodity_crops FROM '/srv/public/input_data_files/FAOSTAT/tmp/Relational_commoditybalances-crops4.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 
print PSQL ("\\COPY agri_foodbalance_commodity_crops FROM '/srv/public/input_data_files/FAOSTAT/tmp/Relational_commoditybalances-crops5.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 
print PSQL ("\\COPY agri_foodbalance_commodity_crops FROM '/srv/public/input_data_files/FAOSTAT/tmp/Relational_commoditybalances-crops6.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 




print PSQL ("DROP TABLE agri_foodbalance_commodity_livestock; \n");


print PSQL ("CREATE TABLE agri_foodbalance_commodity_livestock (
    country_code        integer,
    country       varchar(72),
    item_code     integer,
    item         varchar(72),
    element_group integer,
    element_code   integer,
    element        varchar(144),
    year         integer,
    unit         varchar(36),
    quantity     float,
    flag     varchar(2));

\n");



print PSQL ("COMMENT ON TABLE agri_foodbalance_commodity_livestock IS 'These are FAOSTAT value of food balance statistics data Afghanistan to Zim from the bulk download area http://faostat.fao.org/site/491/default.aspx ';\n"); 
print PSQL ("COMMENT ON COLUMN agri_foodbalance_commodity_livestock.unit IS 'Unit quantity is measured in';\n");

print PSQL ("\\COPY agri_foodbalance_commodity_livestock FROM 'c:/bearedo/DataBase/FAOSTAT/output/Commodity Balances-Livestock1.csv' WITH DELIMITER '|' null as 'NA' CSV header \n"); 


###########################################################################################################
###### FILL PRICES DATA #############################
###########################################################################################################


print PSQL ("SET SEARCH_PATH TO global;\n");

print PSQL ("DROP TABLE agri_price_index_consumer; \n");

print PSQL ("CREATE TABLE agri_price_index_consumer (
    country_code        integer,
    country       varchar(72),
    item_code     varchar(12),
    item         varchar(72),
    element_group integer,
    element_code   integer,
    element        varchar(72),
    unit         varchar(24),
    year          integer,
    quantity     float) ;


; \n");

#CountryCode|Country|ItemCode|Item|ElementGroup|ElementCode|Element|Year|Unit|Value|Flag

print PSQL ("COMMENT ON TABLE agri_price_index_consumer IS 'These are FAOSTAT Agricultural producer prices indices Afghanistan to Zim from the bulk download area http://faostat.fao.org/site/491/default.aspx ';\n"); 
print PSQL ("COMMENT ON COLUMN prices.price_index_agric.unit IS 'Unit quantity is measured in';\n");

print PSQL ("\\COPY agri_price_index_consumer FROM '/srv/public/input_data_files/FAOSTAT/tmp/Relational_consumer_price_indices1.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 

#### Agricultural producer price indices ###

print PSQL ("DROP TABLE agri_price_index_producer; \n");
print PSQL ("CREATE TABLE agri_price_index_producer (
   country_code        integer,
    country       varchar(72),
    item_code     integer,
    item         varchar(72),
    element_group integer,
    element_code   integer,
    element        varchar(144),
    year         integer,
    unit         varchar(36),
    quantity     float,
    flag     varchar(2));

 \n");
print PSQL ("COMMENT ON TABLE agri_price_index_producer IS 'These are FAOSTAT agricultural producer prices indices Afghanistan to Zim from the bulk download area http://faostat.fao.org/site/491/default.aspx ';\n"); 
print PSQL ("COMMENT ON COLUMN agri_price_price_index_consumer.unit IS 'Unit quantity is measured in';\n");

print PSQL ("\\COPY agri_price_index_producer FROM '/srv/public/input_data_files/FAOSTAT/tmp/agricultural_producer_price_indices6.csv.txt' WITH DELIMITER '|' null as '' CSV header \n"); 

####

print PSQL ("DROP TABLE agri_price_stats; \n");

print PSQL ("CREATE TABLE agri_price_stats (
    country_code        integer,
    country       varchar(72),
    item_code     integer,
    item         varchar(72),
    element_group integer,
    element_code   integer,
    element        varchar(144),
    year         integer,
    unit         varchar(36),
    quantity     float,
    flag     varchar(2));


 \n");

print PSQL ("COMMENT ON TABLE agri_price_stats IS 'These are FAOSTAT price statistics Afghanistan to Zim from the bulk download area http://faostat.fao.org/site/491/default.aspx ';\n"); 
print PSQL ("COMMENT ON COLUMN agri_price_stats.unit IS 'Unit quantity is measured in';\n");

print PSQL ("\\COPY agri_price_stats FROM '/srv/public/input_data_files/FAOSTAT/tmp/prices6.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 
print PSQL ("\\COPY agri_price_stats FROM '/srv/public/input_data_files/FAOSTAT/tmp/pricearchive6.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 




############################################################################################################
#######FILL SOCIO-ECONOMIC SCHEMAs #############################
############################################################################################################


print PSQL ("SET SEARCH_PATH TO global;\n");

print PSQL ("DROP TABLE socioecon_population; \n");

print PSQL ("CREATE TABLE socioecon_population (
    country_code        integer,
    country       varchar(72),
    item_code     integer,
    item         varchar(72),
    element_group integer,
    element_code   integer,
    element        varchar(144),
    year         integer,
    unit         varchar(36),
    quantity     float,
    flag     varchar(2));

 \n");

print PSQL ("COMMENT ON TABLE socioecon_population IS 'These are FAOSTAT global human population statistics Afghanistan to Zim from the bulk download area http://faostat.fao.org/site/491/default.aspx ';\n"); 
print PSQL ("COMMENT ON COLUMN socioecon_population.unit IS 'Unit quantity is measured in';\n");
print PSQL ("COMMENT ON COLUMN socioecon_population.source_file  IS 'Name of the bulk download file';\n");
print PSQL ("\\COPY socioecon_population FROM '/srv/public/input_data_files/FAOSTAT/tmp/population-annualtimeseries7.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 

### Investment capital stock ####

print PSQL ("SET SEARCH_PATH TO global;\n");

print PSQL ("DROP TABLE socioecon_investment_capital_stock; \n");

print PSQL ("CREATE TABLE socioecon_investment_capital_stock (
    country_code        integer,
    country       varchar(72),
    item_code     integer,
    item         varchar(72),
    element_group integer,
    element_code   integer,
    element        varchar(144),
    year         integer,
    unit         varchar(36),
    quantity     float,
    flag     varchar(2));

 \n");

print PSQL ("COMMENT ON TABLE socioecon_investment_capital_stock IS 'These are FAOSTAT economic capital investment stock statistics Afghanistan to Zim from the bulk download area http://faostat.fao.org/site/491/default.aspx ';\n"); 
print PSQL ("COMMENT ON COLUMN socioecon_investment_capital_stock.unit IS 'Unit quantity is measured in';\n");
print PSQL ("\\COPY socioecon_investment_capital_stock FROM '/srv/public/input_data_files/FAOSTAT/tmp/investment-capitalstock7.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 

###################### Investment in machinery ############################

print PSQL ("DROP TABLE socioecon_investment_machinery; \n");

print PSQL ("CREATE TABLE socioecon_investment_machinery (
    country_code        integer,
    country       varchar(72),
    item_code     integer,
    item         varchar(72),
    element_group integer,
    element_code   integer,
    element        varchar(144),
    year         integer,
    unit         varchar(36),
    quantity     float,
    flag     varchar(2));

 \n");

print PSQL ("COMMENT ON TABLE socioecon_investment_machinery IS 'These are FAOSTAT economic investment in machinery Afghanistan to Zim from the bulk download area http://faostat.fao.org/site/491/default.aspx ';\n"); 
print PSQL ("COMMENT ON COLUMN socioecon_investment_machinery.unit IS 'Unit quantity is measured in';\n");
print PSQL ("\\COPY socioecon_investment_machinery FROM '/srv/public/input_data_files/FAOSTAT/tmp/investment-machineryarchive7.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 


########################Emissions data ####################################################

## Total emissions 

print PSQL ("DROP TABLE agri_emissions_total; \n");

print PSQL ("CREATE TABLE agri_emissions_total (
    country_code        integer,
    country       varchar(72),
    item_code     integer,
    item         varchar(72),
    element_group integer,
    element_code   integer,
    element        varchar(144),
    year         integer,
    unit         varchar(36),
    quantity     float,
    flag     varchar(2));

 \n");

print PSQL ("COMMENT ON TABLE agri_emissions_total IS 'These are FAOSTAT total GHG emissions from agriculture Afghanistan to Zim from the bulk download area http://faostat.fao.org/site/491/default.aspx ';\n"); 
print PSQL ("COMMENT ON COLUMN agri_emissions_total.unit IS 'Unit quantity is measured in';\n");
print PSQL ("\\COPY agri_emissions_total FROM '/srv/public/input_data_files/FAOSTAT/tmp/emissions_agriculture_agriculture_total7.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 


## Total emissions due to burning crop residues

print PSQL ("DROP TABLE agri_emissions_burning_crop_residues; \n");

print PSQL ("CREATE TABLE agri_emissions_burning_crop_residues (
    country_code        integer,
    country       varchar(72),
    item_code     integer,
    item         varchar(72),
    element_group integer,
    element_code   integer,
    element        varchar(144),
    year         integer,
    unit         varchar(36),
    quantity     float,
    flag     varchar(2));

 \n");

print PSQL ("COMMENT ON TABLE agri_emissions_burning_crop_residues IS 'These are FAOSTAT GHG emissions from burning crop residues in agriculture Afghanistan to Zim from the bulk download area http://faostat.fao.org/site/491/default.aspx ';\n"); 
print PSQL ("COMMENT ON COLUMN agri_emissions_total.unit IS 'Unit quantity is measured in';\n");
print PSQL ("\\COPY agri_emissions_burning_crop_residues FROM '/srv/public/input_data_files/FAOSTAT/tmp/emissions_agriculture_burning_crop_residues7.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 


## Total emissions due to crop residues

print PSQL ("DROP TABLE agri_emissions_crop_residues; \n");

print PSQL ("CREATE TABLE agri_emissions_crop_residues (
    country_code        integer,
    country       varchar(72),
    item_code     integer,
    item         varchar(72),
    element_group integer,
    element_code   integer,
    element        varchar(144),
    year         integer,
    unit         varchar(36),
    quantity     float,
    flag     varchar(2));

 \n");

print PSQL ("COMMENT ON TABLE agri_emissions_crop_residues IS 'These are FAOSTAT GHG emissions from crop residues in agriculture Afghanistan to Zim from the bulk download area http://faostat.fao.org/site/491/default.aspx ';\n"); 
print PSQL ("COMMENT ON COLUMN agri_emissions_crop_residues.unit IS 'Unit quantity is measured in';\n");
print PSQL ("\\COPY agri_emissions_crop_residues FROM '/srv/public/input_data_files/FAOSTAT/tmp/emissions_agriculture_crop_residues7.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 


## Total emissions due to manure applied to soils

print PSQL ("DROP TABLE agri_emissions_manure_soils; \n");

print PSQL ("CREATE TABLE agri_emissions_manure_soils (
    country_code        integer,
    country       varchar(72),
    item_code     integer,
    item         varchar(72),
    element_group integer,
    element_code   integer,
    element        varchar(144),
    year         integer,
    unit         varchar(36),
    quantity     float,
    flag     varchar(2));

 \n");

print PSQL ("COMMENT ON TABLE agri_emissions_manure_soils IS 'These are FAOSTAT GHG emissions from manure applied to soils in agriculture Afghanistan to Zim from the bulk download area http://faostat.fao.org/site/491/default.aspx ';\n"); 
print PSQL ("COMMENT ON COLUMN agri_emissions_manure_soils.unit IS 'Unit quantity is measured in';\n");
print PSQL ("\\COPY agri_emissions_manure_soils FROM '/srv/public/input_data_files/FAOSTAT/tmp/emissions_agriculture_manure_applied_to_soils7.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 


## Total emissions due to manure left on pasture

print PSQL ("DROP TABLE agri_emissions_manure_pasture; \n");

print PSQL ("CREATE TABLE agri_emissions_manure_pasture (
    country_code        integer,
    country       varchar(72),
    item_code     integer,
    item         varchar(72),
    element_group integer,
    element_code   integer,
    element        varchar(144),
    year         integer,
    unit         varchar(36),
    quantity     float,
    flag     varchar(2));

 \n");

print PSQL ("COMMENT ON TABLE agri_emissions_manure_pasture IS 'These are FAOSTAT GHG emissions from manure left on pasture in agriculture Afghanistan to Zim from the bulk download area http://faostat.fao.org/site/491/default.aspx ';\n"); 
print PSQL ("COMMENT ON COLUMN agri_emissions_manure_pasture.unit IS 'Unit quantity is measured in';\n");
print PSQL ("\\COPY agri_emissions_manure_pasture FROM '/srv/public/input_data_files/FAOSTAT/tmp/emissions_agriculture_manure_left_on_pasture7.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 


## Total emissions due to manure management

print PSQL ("DROP TABLE agri_emissions_manure_management; \n");

print PSQL ("CREATE TABLE agri_emissions_manure_management (
    country_code        integer,
    country       varchar(72),
    item_code     integer,
    item         varchar(72),
    element_group integer,
    element_code   integer,
    element        varchar(144),
    year         integer,
    unit         varchar(36),
    quantity     float,
    flag     varchar(2));

 \n");

print PSQL ("COMMENT ON TABLE agri_emissions_manure_management IS 'These are FAOSTAT GHG emissions from manure management in agriculture Afghanistan to Zim from the bulk download area http://faostat.fao.org/site/491/default.aspx ';\n"); 
print PSQL ("COMMENT ON COLUMN agri_emissions_manure_management.unit IS 'Unit quantity is measured in';\n");
print PSQL ("\\COPY agri_emissions_manure_management FROM '/srv/public/input_data_files/FAOSTAT/tmp/emissions_agriculture_manure_management7.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 


## Total emissions due to cultivated organic soils

print PSQL ("DROP TABLE agri_emissions_organic_cult; \n");

print PSQL ("CREATE TABLE agri_emissions_organic_cult (
    country_code        integer,
    country       varchar(72),
    item_code     integer,
    item         varchar(72),
    element_group integer,
    element_code   integer,
    element        varchar(144),
    year         integer,
    unit         varchar(36),
    quantity     float,
    flag     varchar(2));

 \n");

print PSQL ("COMMENT ON TABLE agri_emissions_organic_cult IS 'These are FAOSTAT GHG emissions from cultivated organic soils agriculture Afghanistan to Zim from the bulk download area http://faostat.fao.org/site/491/default.aspx ';\n"); 
print PSQL ("COMMENT ON COLUMN agri_emissions_manure_pasture.unit IS 'Unit quantity is measured in';\n");
print PSQL ("\\COPY agri_emissions_organic_cult FROM '/srv/public/input_data_files/FAOSTAT/tmp/emissions_agriculture_cultivated_organic_soils7.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 

## Total emissions due to enteric fermentation

print PSQL ("DROP TABLE agri_emissions_enteric_ferment; \n");

print PSQL ("CREATE TABLE agri_emissions_enteric_ferment (
    country_code        integer,
    country       varchar(72),
    item_code     integer,
    item         varchar(72),
    element_group integer,
    element_code   integer,
    element        varchar(144),
    year         integer,
    unit         varchar(36),
    quantity     float,
    flag     varchar(2));

 \n");

print PSQL ("COMMENT ON TABLE agri_emissions_enteric_ferment IS 'These are FAOSTAT GHG emissions from cultivated organic soils agriculture Afghanistan to Zim from the bulk download area http://faostat.fao.org/site/491/default.aspx ';\n"); 
print PSQL ("COMMENT ON COLUMN agri_emissions_enteric_ferment.unit IS 'Unit quantity is measured in';\n");
print PSQL ("\\COPY agri_emissions_enteric_ferment FROM '/srv/public/input_data_files/FAOSTAT/tmp/emissions_agriculture_enteric_fermentation7.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 


## Total emissions due to rice cultivation

print PSQL ("DROP TABLE agri_emissions_rice; \n");

print PSQL ("CREATE TABLE agri_emissions_rice (
    country_code        integer,
    country       varchar(72),
    item_code     integer,
    item         varchar(72),
    element_group integer,
    element_code   integer,
    element        varchar(144),
    year         integer,
    unit         varchar(36),
    quantity     float,
    flag     varchar(2));

 \n");

print PSQL ("COMMENT ON TABLE agri_emissions_rice IS 'These are FAOSTAT GHG emissions due to rice cultivation in agriculture Afghanistan to Zim from the bulk download area http://faostat.fao.org/site/491/default.aspx ';\n"); 
print PSQL ("COMMENT ON COLUMN agri_emissions_rice.unit IS 'Unit quantity is measured in';\n");
print PSQL ("\\COPY agri_emissions_rice FROM '/srv/public/input_data_files/FAOSTAT/tmp/emissions_agriculture_rice_cultivation7.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 

# Total emissions due to synthetic fertilisers

print PSQL ("DROP TABLE agri_emissions_fertilisers; \n");

print PSQL ("CREATE TABLE agri_emissions_fertilisers (
    country_code        integer,
    country       varchar(72),
    item_code     integer,
    item         varchar(72),
    element_group integer,
    element_code   integer,
    element        varchar(144),
    year         integer,
    unit         varchar(36),
    quantity     float,
    flag     varchar(2));

 \n");

print PSQL ("COMMENT ON TABLE agri_emissions_fertilisers IS 'These are FAOSTAT GHG emissions due to synthetic fertilisers in agriculture Afghanistan to Zim from the bulk download area http://faostat.fao.org/site/491/default.aspx ';\n"); 
print PSQL ("COMMENT ON COLUMN agri_emissions_fertilisers.unit IS 'Unit quantity is measured in';\n");
print PSQL ("\\COPY agri_emissions_fertilisers FROM '/srv/public/input_data_files/FAOSTAT/tmp/emissions_agriculture_synthetic_fertilizers7.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 


# Total emissions due to crop

print PSQL ("DROP TABLE agri_emissions_cropland; \n");

print PSQL ("CREATE TABLE agri_emissions_cropland (
    country_code        integer,
    country       varchar(72),
    item_code     integer,
    item         varchar(72),
    element_group integer,
    element_code   integer,
    element        varchar(144),
    year         integer,
    unit         varchar(36),
    quantity     float,
    flag     varchar(2));

 \n");

print PSQL ("COMMENT ON TABLE agri_emissions_cropland IS 'These are FAOSTAT GHG emissions from croplands in agriculture Afghanistan to Zim from the bulk download area http://faostat.fao.org/site/491/default.aspx ';\n"); 
print PSQL ("COMMENT ON COLUMN agri_emissions_cropland.unit IS 'Unit quantity is measured in';\n");
print PSQL ("\\COPY agri_emissions_cropland FROM '/srv/public/input_data_files/FAOSTAT/tmp/emissions_land_use_cropland7.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 


# Total emissions due to forests

print PSQL ("DROP TABLE agri_emissions_forest; \n");

print PSQL ("CREATE TABLE agri_emissions_forest (
    country_code        integer,
    country       varchar(72),
    item_code     integer,
    item         varchar(72),
    element_group integer,
    element_code   integer,
    element        varchar(144),
    year         integer,
    unit         varchar(36),
    quantity     float,
    flag     varchar(2));

 \n");

print PSQL ("COMMENT ON TABLE agri_emissions_forest IS 'These are FAOSTAT GHG emissions from forests Afghanistan to Zim from the bulk download area http://faostat.fao.org/site/491/default.aspx ';\n"); 
print PSQL ("COMMENT ON COLUMN agri_emissions_forest.unit IS 'Unit quantity is measured in';\n");
print PSQL ("\\COPY agri_emissions_forest FROM '/srv/public/input_data_files/FAOSTAT/tmp/emissions_land_use_cropland7.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 



########################  Resources data  ####################################################

## Land use ### 

print PSQL ("DROP TABLE agri_resources_land; \n");

print PSQL ("CREATE TABLE agri_resources_land (
    country_code        integer,
    country       varchar(72),
    item_code     integer,
    item         varchar(72),
    element_group integer,
    element_code   integer,
    element        varchar(144),
    year         integer,
    unit         varchar(36),
    quantity     float,
    flag     varchar(2));

 \n");

print PSQL ("COMMENT ON TABLE agri_resources_land IS 'These are FAOSTAT agricultural land use data Afghanistan to Zim from the bulk download area http://faostat.fao.org/site/491/default.aspx ';\n"); 
print PSQL ("COMMENT ON COLUMN agri_resources_land.unit IS 'Unit quantity is measured in';\n");
print PSQL ("\\COPY agri_resources_land FROM '/srv/public/input_data_files/FAOSTAT/tmp/resources-land7.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 

## Fertilizer Use 


print PSQL ("DROP TABLE agri_resources_fertilizers; \n");

print PSQL ("CREATE TABLE agri_resources_fertilizers (
    country_code        integer,
    country       varchar(72),
    item_code     integer,
    item         varchar(72),
    element_group integer,
    element_code   integer,
    element        varchar(144),
    year         integer,
    unit         varchar(36),
    quantity     float,
    flag     varchar(2));

 \n");

print PSQL ("COMMENT ON TABLE agri_resources_fertilizers IS 'These are FAOSTAT agricultural fertilizer use data Afghanistan to Zim from the bulk download area
 http://faostat.fao.org/site/491/default.aspx ';\n"); 
print PSQL ("COMMENT ON COLUMN agri_resources_fertilizers.unit IS 'Unit quantity is measured in';\n");
print PSQL ("\\COPY agri_resources_fertilizers FROM '/srv/public/input_data_files/FAOSTAT/tmp/resources-fertilizers7.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 
print PSQL ("\\COPY agri_resources_fertilizers FROM '/srv/public/input_data_files/FAOSTAT/tmp/resources-fertilizersarchive7.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 



## Pesticide Use (consumption) 


print PSQL ("DROP TABLE agri_resources_pesticides_consumption; \n");

print PSQL ("CREATE TABLE agri_resources_pesticides_consumption (
    country_code        integer,
    country       varchar(72),
    item_code     integer,
    item         varchar(72),
    element_group integer,
    element_code   integer,
    element        varchar(144),
    year         integer,
    unit         varchar(36),
    quantity     float,
    flag     varchar(2));

 \n");

#CountryCode|Country|ItemCode|Item|ElementGroup|ElementCode|Element|Year|Unit|Value|Flag

print PSQL ("COMMENT ON TABLE agri_resources_pesticides_consumption IS 'These are FAOSTAT agricultural pesticide (consumption) data Afghanistan to Zim from the bulk download area
 http://faostat.fao.org/site/491/default.aspx ';\n"); 
print PSQL ("COMMENT ON COLUMN agri_resources_pesticides_consumption.unit IS 'Unit quantity is measured in';\n");
print PSQL ("\\COPY agri_resources_pesticides_consumption FROM '/srv/public/input_data_files/FAOSTAT/tmp/resources-pesticidesconsumption6.csv.txt' WITH DELIMITER '|' null as 'NA' CSV header \n"); 







close(PSQL);










