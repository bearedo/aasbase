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

print PSQL ("DROP TABLE tradestat.trade_index; \n");

print PSQL ("CREATE TABLE tradestat.trade_index (
    country_code        integer,
    country       varchar(72),
    item_code     varchar(12),
    item         varchar(72),
    element_code   integer,
    element        varchar(72),
    unit         varchar(12),
    source_file  varchar(48),
    year         integer,
    quantity     float); \n");

print PSQL ("COMMENT ON TABLE tradestat.trade_index IS 'These are FAOSTAT value of trade index numbers data Afghanistan to Zim from the bulk download area http://faostat.fao.org/site/491/default.aspx ';\n"); 
print PSQL ("COMMENT ON COLUMN tradestat.trade_index.unit IS 'Unit quantity is measured in';\n");
print PSQL ("COMMENT ON COLUMN tradestat.trade_index.source_file  IS 'Name of the bulk download file';\n");

print PSQL ("\\COPY tradestat.trade_index FROM 'c:/bearedo/DataBase/FAOSTAT/output/Trade Index Numbers1.csv' WITH DELIMITER '|' null as 'NA' CSV header \n"); 


###########################################################################################################
######FILL FOODSUPPLY SCHEMA #############################
###########################################################################################################


print PSQL ("SET SEARCH_PATH TO foodsupply;\n");

print PSQL ("DROP TABLE foodsupply.crops_primary_equivalents; \n");

print PSQL ("CREATE TABLE foodsupply.crops_primary_equivalents (
    country_code        integer,
    country       varchar(72),
    item_code     varchar(12),
    item         varchar(72),
    element_code   integer,
    element        varchar(72),
    unit         varchar(12),
    source_file  varchar(48),
    year         integer,
    quantity     float); \n");

print PSQL ("COMMENT ON TABLE foodsupply.crops_primary_equivalents IS 'These are FAOSTAT crop food supply statistics data Afghanistan to Zim from the bulk download area http://faostat.fao.org/site/491/default.aspx ';\n"); 
print PSQL ("COMMENT ON COLUMN foodsupply.crops_primary_equivalents.unit IS 'Unit crop quantity is measured in';\n");
print PSQL ("COMMENT ON COLUMN foodsupply.crops_primary_equivalents.source_file  IS 'Name of the bulk download file';\n");
print PSQL ("\\COPY foodsupply.crops_primary_equivalents FROM 'c:/bearedo/DataBase/FAOSTAT/output/FoodSupply-CropsPrimaryEquivalent1.csv' WITH DELIMITER '|' null as 'NA' CSV header \n"); 
print PSQL ("\\COPY foodsupply.crops_primary_equivalents FROM 'c:/bearedo/DataBase/FAOSTAT/output/FoodSupply-CropsPrimaryEquivalent2.csv' WITH DELIMITER '|' null as 'NA' CSV header \n"); 


# Add on UN georegions and economic groupings

print PSQL ("ALTER TABLE foodsupply.crops_primary_equivalents ADD COLUMN region varchar(36);\n");
print PSQL ("UPDATE foodsupply.crops_primary_equivalents 
SET region = public.georegions.region
FROM public.georegions
WHERE foodsupply.crops_primary_equivalents.country = public.georegions.country;  \n");


print PSQL ("ALTER TABLE foodsupply.crops_primary_equivalents ADD COLUMN continent varchar(36);\n");
print PSQL ("UPDATE foodsupply.crops_primary_equivalents 
SET continent = public.georegions.continent
FROM public.georegions
WHERE foodsupply.crops_primary_equivalents.country = public.georegions.country;  \n");


print PSQL ("ALTER TABLE foodsupply.crops_primary_equivalents ADD COLUMN economic_status varchar(36);\n");
print PSQL ("UPDATE foodsupply.crops_primary_equivalents 
SET economic_status = public.econgroupings.economic_status
FROM public.econgroupings
WHERE foodsupply.crops_primary_equivalents.country = public.econgroupings.country;  \n");



print PSQL ("DROP TABLE foodsupply.livestock_fish_equivalents; \n");
print PSQL ("CREATE TABLE foodsupply.livestock_fish_equivalents (
    country_code        integer,
    country       varchar(72),
    item_code     varchar(12),
    item         varchar(72),
    element_code   integer,
    element        varchar(72),
    unit         varchar(12),
    source_file  varchar(48),
    year         integer,
    quantity     float); \n");

print PSQL ("COMMENT ON TABLE foodsupply.livestock_fish_equivalents IS 'These are FAOSTAT livestock and fish food supply statistics data Afghanistan to Zim from the bulk download area http://faostat.fao.org/site/491/default.aspx ';\n"); 
print PSQL ("COMMENT ON COLUMN foodsupply.livestock_fish_equivalents.unit IS 'Unit quantity is measured in';\n");
print PSQL ("COMMENT ON COLUMN foodsupply.livestock_fish_equivalents.source_file  IS 'Name of the bulk download file';\n");
print PSQL ("\\COPY foodsupply.livestock_fish_equivalents FROM 'c:/bearedo/DataBase/FAOSTAT/output/FoodSupply-LiveStock&FishPrimaryEquivalent1.csv' WITH DELIMITER '|' null as 'NA' CSV header \n"); 

print PSQL ("ALTER TABLE foodsupply.crops_primary_equivalents ADD COLUMN region varchar(36);\n");
print PSQL ("UPDATE foodsupply.crops_primary_equivalents 
SET region = public.georegions.region
FROM public.georegions
WHERE foodsupply.crops_primary_equivalents.country = public.georegions.country;  \n");

print PSQL ("ALTER TABLE foodsupply.crops_primary_equivalents ADD COLUMN continent varchar(36);\n");
print PSQL ("UPDATE foodsupply.crops_primary_equivalents 
SET continent = public.georegions.continent
FROM public.georegions
WHERE foodsupply.crops_primary_equivalents.country = public.georegions.country;  \n");

print PSQL ("ALTER TABLE foodsupply.crops_primary_equivalents ADD COLUMN economic_status varchar(36);\n");
print PSQL ("UPDATE foodsupply.crops_primary_equivalents 
SET economic_status = public.econgroupings.economic_status
FROM public.econgroupings
WHERE foodsupply.crops_primary_equivalents.country = public.econgroupings.country;  \n");

###########################################################################################################
######FILL Food balance SCHEMA #############################
###########################################################################################################


print PSQL ("SET SEARCH_PATH TO foodbalance;\n");

print PSQL ("DROP TABLE foodbalance.sheets; \n");

print PSQL ("CREATE TABLE foodbalance.sheets (
    country_code        integer,
    country       varchar(72),
    item_code     varchar(12),
    item         varchar(72),
    element_code   integer,
    element        varchar(72),
    unit         varchar(12),
    source_file  varchar(48),
    year         integer,
    quantity     float); \n");

print PSQL ("COMMENT ON TABLE foodbalance.sheets IS 'These are FAOSTAT value of food balance statistics data Afghanistan to Zim from the bulk download area http://faostat.fao.org/site/491/default.aspx ';\n"); 
print PSQL ("COMMENT ON COLUMN foodbalance.sheets.unit IS 'Unit quantity is measured in';\n");
print PSQL ("COMMENT ON COLUMN foodbalance.sheets.source_file  IS 'Name of the bulk download file';\n");
print PSQL ("\\COPY foodbalance.sheets FROM 'c:/bearedo/DataBase/FAOSTAT/output/FoodBalanceSheets1.csv' WITH DELIMITER '|' null as 'NA' CSV header \n"); 
print PSQL ("\\COPY foodbalance.sheets FROM 'c:/bearedo/DataBase/FAOSTAT/output/FoodBalanceSheets2.csv' WITH DELIMITER '|' null as 'NA' CSV header \n"); 
print PSQL ("\\COPY foodbalance.sheets FROM 'c:/bearedo/DataBase/FAOSTAT/output/FoodBalanceSheets3.csv' WITH DELIMITER '|' null as 'NA' CSV header \n"); 
print PSQL ("\\COPY foodbalance.sheets FROM 'c:/bearedo/DataBase/FAOSTAT/output/FoodBalanceSheets4.csv' WITH DELIMITER '|' null as 'NA' CSV header \n"); 
print PSQL ("\\COPY foodbalance.sheets FROM 'c:/bearedo/DataBase/FAOSTAT/output/FoodBalanceSheets5.csv' WITH DELIMITER '|' null as 'NA' CSV header \n"); 


print PSQL ("DROP TABLE foodbalance.commodity_crops; \n");

print PSQL ("CREATE TABLE foodbalance.commodity_crops (
    country_code        integer,
    country       varchar(72),
    item_code     varchar(12),
    item         varchar(72),
    element_code   integer,
    element        varchar(72),
    unit         varchar(12),
    source_file  varchar(48),
    year         integer,
    quantity     float); \n");

print PSQL ("COMMENT ON TABLE foodbalance.commodity_crops IS 'These are FAOSTAT value of food balance statistics data Afghanistan to Zim from the bulk download area http://faostat.fao.org/site/491/default.aspx ';\n"); 
print PSQL ("COMMENT ON COLUMN foodbalance.commodity_crops.unit IS 'Unit quantity is measured in';\n");
print PSQL ("COMMENT ON COLUMN foodbalance.commodity_crops.source_file  IS 'Name of the bulk download file';\n");
print PSQL ("\\COPY foodbalance.commodity_crops FROM 'c:/bearedo/DataBase/FAOSTAT/output/Commodity Balances-Crops1.csv' WITH DELIMITER '|' null as 'NA' CSV header \n"); 
print PSQL ("\\COPY foodbalance.commodity_crops FROM 'c:/bearedo/DataBase/FAOSTAT/output/Commodity Balances-Crops2.csv' WITH DELIMITER '|' null as 'NA' CSV header \n"); 
print PSQL ("\\COPY foodbalance.commodity_crops FROM 'c:/bearedo/DataBase/FAOSTAT/output/Commodity Balances-Crops3.csv' WITH DELIMITER '|' null as 'NA' CSV header \n"); 


print PSQL ("DROP TABLE foodbalance.commodity_livestock; \n");


print PSQL ("CREATE TABLE foodbalance.commodity_livestock (
    country_code        integer,
    country       varchar(72),
    item_code     varchar(12),
    item         varchar(72),
    element_code   integer,
    element        varchar(72),
    unit         varchar(12),
    source_file  varchar(48),
    year         integer,
    quantity     float); \n");

print PSQL ("COMMENT ON TABLE foodbalance.commodity_livestock IS 'These are FAOSTAT value of food balance statistics data Afghanistan to Zim from the bulk download area http://faostat.fao.org/site/491/default.aspx ';\n"); 
print PSQL ("COMMENT ON COLUMN foodbalance.commodity_livestock.unit IS 'Unit quantity is measured in';\n");
print PSQL ("COMMENT ON COLUMN foodbalance.commodity_livestock.source_file  IS 'Name of the bulk download file';\n");
print PSQL ("\\COPY foodbalance.commodity_livestock FROM 'c:/bearedo/DataBase/FAOSTAT/output/Commodity Balances-Livestock1.csv' WITH DELIMITER '|' null as 'NA' CSV header \n"); 


###########################################################################################################
######FILL PRICES SCHEMA #############################
###########################################################################################################


print PSQL ("SET SEARCH_PATH TO prices;\n");

print PSQL ("DROP TABLE prices.price_index_agric; \n");

print PSQL ("CREATE TABLE prices.price_index_agric (
    country_code        integer,
    country       varchar(72),
    item_code     varchar(12),
    item         varchar(72),
    element_code   integer,
    element        varchar(72),
    unit         varchar(12),
    source_file  varchar(48),
    year         integer,
    quantity     float); \n");

print PSQL ("COMMENT ON TABLE prices.price_index_agric IS 'These are FAOSTAT Agricultural producer prices indices Afghanistan to Zim from the bulk download area http://faostat.fao.org/site/491/default.aspx ';\n"); 
print PSQL ("COMMENT ON COLUMN prices.price_index_agric.unit IS 'Unit quantity is measured in';\n");
print PSQL ("COMMENT ON COLUMN prices.price_index_agric.source_file  IS 'Name of the bulk download file';\n");
print PSQL ("\\COPY prices.price_index_agric FROM 'c:/bearedo/DataBase/FAOSTAT/output/Agricultural_Producer_Price_Indices1.csv' WITH DELIMITER '|' null as 'NA' CSV header \n"); 



print PSQL ("DROP TABLE prices.price_index_consumer; \n");

print PSQL ("CREATE TABLE prices.price_index_consumer (
    country_code        integer,
    country       varchar(72),
    item_code     varchar(12),
    item         varchar(72),
    element_code   integer,
    element        varchar(72),
    unit         varchar(12),
    source_file  varchar(48),
    year         integer,
    quantity     float); \n");

print PSQL ("COMMENT ON TABLE prices.price_index_consumer IS 'These are FAOSTAT consumer prices indices Afghanistan to Zim from the bulk download area http://faostat.fao.org/site/491/default.aspx ';\n"); 
print PSQL ("COMMENT ON COLUMN prices.price_index_consumer.unit IS 'Unit quantity is measured in';\n");
print PSQL ("COMMENT ON COLUMN prices.price_index_consumer.source_file  IS 'Name of the bulk download file';\n");
print PSQL ("\\COPY prices.price_index_consumer FROM 'c:/bearedo/DataBase/FAOSTAT/output/Consumer_Price_Indices1.csv' WITH DELIMITER '|' null as 'NA' CSV header \n"); 


print PSQL ("DROP TABLE prices.price_stats; \n");

print PSQL ("CREATE TABLE prices.price_stats (
    country_code        integer,
    country       varchar(72),
    item_code     varchar(12),
    item         varchar(72),
    element_code   integer,
    element        varchar(72),
    unit         varchar(12),
    source_file  varchar(48),
    year         integer,
    quantity     float); \n");

print PSQL ("COMMENT ON TABLE prices.price_stats IS 'These are FAOSTAT price statistics Afghanistan to Zim from the bulk download area http://faostat.fao.org/site/491/default.aspx ';\n"); 
print PSQL ("COMMENT ON COLUMN prices.price_stats.unit IS 'Unit quantity is measured in';\n");
print PSQL ("COMMENT ON COLUMN prices.price_stats.source_file  IS 'Name of the bulk download file';\n");
print PSQL ("\\COPY prices.price_stats FROM 'c:/bearedo/DataBase/FAOSTAT/output/PriceSTAT1.csv' WITH DELIMITER '|' null as 'NA' CSV header \n"); 




############################################################################################################
#######FILL RESOURCES SCHEMA #############################
############################################################################################################


print PSQL ("SET SEARCH_PATH TO resources;\n");

print PSQL ("DROP TABLE resources.population; \n");

print PSQL ("CREATE TABLE resources.population (
    country_code        integer,
    country       varchar(72),
    item_code     varchar(12),
    item         varchar(72),
    element_code   integer,
    element        varchar(72),
    unit         varchar(12),
    source_file  varchar(48),
    year         integer,
    quantity     float); \n");

print PSQL ("COMMENT ON TABLE resources.population IS 'These are FAOSTAT population statistics Afghanistan to Zim from the bulk download area http://faostat.fao.org/site/491/default.aspx ';\n"); 
print PSQL ("COMMENT ON COLUMN resources.population.unit IS 'Unit quantity is measured in';\n");
print PSQL ("COMMENT ON COLUMN resources.population.source_file  IS 'Name of the bulk download file';\n");
print PSQL ("\\COPY resources.population FROM 'c:/bearedo/DataBase/FAOSTAT/output/PopSTAT-Annual-Time-Series1.csv' WITH DELIMITER '|' null as 'NA' CSV header \n"); 



print PSQL ("SET SEARCH_PATH TO resources;\n");

print PSQL ("DROP TABLE resources.economics; \n");

print PSQL ("CREATE TABLE resources.economics (
    country_code        integer,
    country       varchar(72),
    item_code     varchar(12),
    item         varchar(72),
    element_code   integer,
    element        varchar(72),
    unit         varchar(12),
    source_file  varchar(48),
    year         integer,
    quantity     float); \n");

print PSQL ("COMMENT ON TABLE resources.economics IS 'These are FAOSTAT economic capital stock statistics Afghanistan to Zim from the bulk download area http://faostat.fao.org/site/491/default.aspx ';\n"); 
print PSQL ("COMMENT ON COLUMN resources.economics.unit IS 'Unit quantity is measured in';\n");
print PSQL ("COMMENT ON COLUMN resources.economics.source_file  IS 'Name of the bulk download file';\n");
print PSQL ("\\COPY resources.economics FROM 'c:/bearedo/DataBase/FAOSTAT/output/EconSTAT - Capital Stock1.csv' WITH DELIMITER '|' null as 'NA' CSV header \n"); 






close(PSQL);










