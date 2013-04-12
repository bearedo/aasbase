#!/usr/bin/perl -w

require "common.pl";
#require "common-nrm-gis.pl";


 use strict;

### AUTHOR: Doug Beare

####################################
## THIS PROGRAM MUST BE RUN BY POSTGRES#
####################################
 
 ##PURPOSE: CREATE THE FAOSTAT DATABASE

 ## CREATE THE DATABASE AND SCHEMAS IN POSTGRESQL

print PSQL ("CREATE DATABASE faostat;\n");
print PSQL ("CREATE ROLE beare WITH LOGIN PASSWORD 'beare01'; \n");

print PSQL ("CREATE ROLE tan WITH LOGIN PASSWORD 'tan01';\n");

print PSQL ( "CREATE SCHEMA prodstat; \n");
print PSQL ( "CREATE SCHEMA tradestat;\n");
print PSQL ( "CREATE SCHEMA foodsupply;\n");
print PSQL ( "CREATE SCHEMA foodbalance;\n");
print PSQL ( "CREATE SCHEMA prices;\n");
print PSQL ( "CREATE SCHEMA resources;\n");
print PSQL ( "CREATE SCHEMA fisheries;\n");


print PSQL ("DROP TABLE public.georegions; \n");

print PSQL ("CREATE TABLE public.georegions (
     numerical_code integer,
    country    varchar(72),
    region     varchar(72),
    continent  varchar(72)); \n");

print PSQL ("COMMENT ON TABLE public.georegions IS 'These are United Nations georegions from unstats.un.org/unsd/methods/m49/m49regin.htm ';\n"); 
print PSQL ("\\COPY public.georegions FROM 'c:/bearedo/DataBase/FishStatData/UN-Geographic-Regions.csv' WITH DELIMITER '|' null as 'NA' CSV HEADER \n");


print PSQL ("DROP TABLE public.econgroupings; \n");

print PSQL ("CREATE TABLE public.econgroupings (
     numerical_code integer,
     country       varchar(72),
     economic_status     varchar(72)); \n");

print PSQL ("COMMENT ON TABLE public.econgroupings IS 'These are United Nations economic groupings from unstats.un.org/unsd/methods/m49/m49regin.htm ';\n"); 
print PSQL ("\\COPY public.econgroupings FROM 'c:/bearedo/DataBase/FishStatData/UN-Economic-Groupings.csv' WITH DELIMITER '|' null as 'NA' CSV HEADER \n");


print PSQL ("SET SEARCH_PATH TO prodstat;\n");

print PSQL ("DROP TABLE prodstat.prodstat_crops; \n");

print PSQL ("CREATE TABLE prodstat.prodstat_crops (
    country_code        integer,
    country       varchar(72),
    item_code     varchar(12),
    item         varchar(72),
    element_code   integer,
    element        varchar(24),
    unit         varchar(12),
    source_file  varchar(48),
    year         integer,
    quantity     float); \n");

print PSQL ("COMMENT ON TABLE prodstat.prodstat_crops IS 'These are FAOSTAT crop production data Afghanistan to Zimbabwe from the bulk download area http://faostat.fao.org/site/491/default.aspx ';\n"); 
print PSQL ("COMMENT ON COLUMN prodstat.prodstat_crops.unit IS 'Unit crop quantity is measured in';\n");
print PSQL ("COMMENT ON COLUMN prodstat.prodstat_crops.source_file  IS 'Name of the bulk download file';\n");
print PSQL ("\\COPY prodstat.prodstat_crops FROM 'c:/bearedo/DataBase/FAOSTAT/output/ProdSTAT-Crops1.csv' WITH DELIMITER '|' null as 'NA' CSV HEADER \n"); 

##################################################################################


print PSQL ("DROP TABLE prodstat.prodstat_crops_processed; \n");

print PSQL ("CREATE TABLE prodstat.prodstat_crops_processed (
    country_code        integer,
    country       varchar(72),
    item_code     varchar(12),
    item         varchar(72),
    element_code   integer,
    element        varchar(24),
    unit         varchar(12),
    source_file  varchar(48),
    year         integer,
    quantity     float); \n");

print PSQL ("COMMENT ON TABLE prodstat.prodstat_crops_processed IS 'These are FAOSTAT processed crop production data Afghanistan to Zimbabwe from the bulk download area http://faostat.fao.org/site/491/default.aspx ';\n"); 
print PSQL ("COMMENT ON COLUMN prodstat.prodstat_crops_processed.unit IS 'Unit crop quantity is measured in';\n");
print PSQL ("COMMENT ON COLUMN prodstat.prodstat_crops_processed.source_file  IS 'Name of the bulk download file';\n");
print PSQL ("\\COPY prodstat.prodstat_crops_processed FROM 'c:/bearedo/DataBase/FAOSTAT/output/ProdSTAT-Crops Processed1.csv' WITH DELIMITER '|' null as 'NA' CSV header \n"); 

# Add on UN georegions and economic groupings

print PSQL ("ALTER TABLE prodstat.prodstat_crops_processed ADD COLUMN region varchar(36);\n");
print PSQL ("UPDATE prodstat.prodstat_crops_processed 
SET region = public.georegions.region
FROM public.georegions
WHERE prodstat.prodstat_crops_processed.country = public.georegions.country;  \n");


print PSQL ("ALTER TABLE prodstat.prodstat_crops_processed ADD COLUMN continent varchar(36);\n");
print PSQL ("UPDATE prodstat.prodstat_crops_processed 
SET continent = public.georegions.continent
FROM public.georegions
WHERE prodstat.prodstat_crops_processed.country = public.georegions.country;  \n");


print PSQL ("ALTER TABLE prodstat.prodstat_crops_processed ADD COLUMN economic_status varchar(36);\n");
print PSQL ("UPDATE prodstat.prodstat_crops_processed 
SET economic_status = public.econgroupings.economic_status
FROM public.econgroupings
WHERE prodstat.prodstat_crops_processed.country = public.econgroupings.country;  \n");



 #################################################################################


print PSQL ("DROP TABLE prodstat.prodstat_livestock; \n");

print PSQL ("CREATE TABLE prodstat.prodstat_livestock (
    country_code        integer,
    country       varchar(72),
    item_code     varchar(12),
    item         varchar(72),
    element_code   integer,
    element        varchar(24),
    unit         varchar(12),
    source_file  varchar(48),
    year         integer,
    quantity     float); \n");

print PSQL ("COMMENT ON TABLE prodstat.prodstat_livestock IS 'These are FAOSTAT processed crop production data Afghanistan to Zimbabwe from the bulk download area http://faostat.fao.org/site/491/default.aspx ';\n"); 
print PSQL ("COMMENT ON COLUMN prodstat.prodstat_livestock.unit IS 'Unit crop quantity is measured in';\n");
print PSQL ("COMMENT ON COLUMN prodstat.prodstat_livestock.source_file  IS 'Name of the bulk download file';\n");
print PSQL ("\\COPY prodstat.prodstat_livestock FROM 'c:/bearedo/DataBase/FAOSTAT/output/ProdSTAT-LiveStock1.csv' WITH DELIMITER '|' null as 'NA' CSV header \n"); 


#################################################################################


print PSQL ("DROP TABLE prodstat.prodstat_livestock_primary; \n");

print PSQL ("CREATE TABLE prodstat.prodstat_livestock_primary (
    country_code        integer,
    country       varchar(72),
    item_code     varchar(12),
    item         varchar(72),
    element_code   integer,
    element        varchar(48),
    unit         varchar(12),
    source_file  varchar(48),
    year         integer,
    quantity     float); \n");

print PSQL ("COMMENT ON TABLE prodstat.prodstat_livestock_primary IS 'These are FAOSTAT processed crop production data Afghanistan to Zimbabwe from the bulk download area http://faostat.fao.org/site/491/default.aspx ';\n"); 
print PSQL ("COMMENT ON COLUMN prodstat.prodstat_livestock_primary.unit IS 'Unit crop quantity is measured in';\n");
print PSQL ("COMMENT ON COLUMN prodstat.prodstat_livestock_primary.source_file  IS 'Name of the bulk download file';\n");
print PSQL ("\\COPY prodstat.prodstat_livestock_primary FROM 'c:/bearedo/DataBase/FAOSTAT/output/ProdSTAT-LivestockPrimary1.csv' WITH DELIMITER '|' null as 'NA' CSV header \n"); 


# Add on UN georegions and economic groupings

print PSQL ("ALTER TABLE prodstat.prodstat_livestock_primary ADD COLUMN region varchar(36);\n");
print PSQL ("UPDATE prodstat.prodstat_livestock_primary 
SET region = public.georegions.region
FROM public.georegions
WHERE prodstat.prodstat_livestock_primary.country = public.georegions.country;  \n");


print PSQL ("ALTER TABLE prodstat.prodstat_livestock_primary ADD COLUMN continent varchar(36);\n");
print PSQL ("UPDATE prodstat.prodstat_livestock_primary 
SET continent = public.georegions.continent
FROM public.georegions
WHERE prodstat.prodstat_livestock_primary.country = public.georegions.country;  \n");


print PSQL ("ALTER TABLE prodstat.prodstat_livestock_primary ADD COLUMN economic_status varchar(36);\n");
print PSQL ("UPDATE prodstat.prodstat_livestock_primary 
SET economic_status = public.econgroupings.economic_status
FROM public.econgroupings
WHERE prodstat.prodstat_livestock_primary.country = public.econgroupings.country;  \n");



#################################################################################


print PSQL ("DROP TABLE prodstat.prodstat_livestock_processed; \n");

print PSQL ("CREATE TABLE prodstat.prodstat_livestock_processed (
    country_code        integer,
    country       varchar(72),
    item_code     varchar(12),
    item         varchar(72),
    element_code   integer,
    element        varchar(48),
    unit         varchar(12),
    source_file  varchar(48),
    year         integer,
    quantity     float); \n");

print PSQL ("COMMENT ON TABLE prodstat.prodstat_livestock_processed IS 'These are FAOSTAT processed crop production data Afghanistan to Zimbabwe from the bulk download area http://faostat.fao.org/site/491/default.aspx ';\n"); 
print PSQL ("COMMENT ON COLUMN prodstat.prodstat_livestock_processed.unit IS 'Unit crop quantity is measured in';\n");
print PSQL ("COMMENT ON COLUMN prodstat.prodstat_livestock_processed.source_file  IS 'Name of the bulk download file';\n");
print PSQL ("\\COPY prodstat.prodstat_livestock_processed FROM 'c:/bearedo/DataBase/FAOSTAT/output/ProdSTAT-LivestockProcessed1.csv' WITH DELIMITER '|' null as 'NA' CSV header \n"); 


##################################################################################


print PSQL ("DROP TABLE prodstat.prodstat_value; \n");

print PSQL ("CREATE TABLE prodstat.prodstat_value (
    country_code        integer,
    country       varchar(72),
    tem_code     varchar(12),
    item         varchar(72),
    element_code   integer,
    element        varchar(72),
    unit         varchar(12),
    source_file  varchar(48),
    year         integer,
    quantity     float); \n");

print PSQL ("COMMENT ON TABLE prodstat.prodstat_value IS 'These are FAOSTAT value of production data Afghanistan to Zim from the bulk download area http://faostat.fao.org/site/491/default.aspx ';\n"); 
print PSQL ("COMMENT ON COLUMN prodstat.prodstat_value.unit IS 'Unit crop quantity is measured in';\n");
print PSQL ("COMMENT ON COLUMN prodstat.prodstat_value.source_file  IS 'Name of the bulk download file';\n");
print PSQL ("\\COPY prodstat.prodstat_value FROM 'c:/bearedo/DataBase/FAOSTAT/output/Value of Production1.csv' WITH DELIMITER '|' null as 'NA' CSV header \n"); 
print PSQL ("\\COPY prodstat.prodstat_value FROM 'c:/bearedo/DataBase/FAOSTAT/output/Value of Production2.csv' WITH DELIMITER '|' null as 'NA' CSV  \n"); 


##################################################################################


print PSQL ("DROP TABLE prodstat.pins; \n");

print PSQL ("CREATE TABLE prodstat.pins (
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

print PSQL ("COMMENT ON TABLE prodstat.pins IS 'These are FAOSTAT value of production data Afghanistan to Zim from the bulk download area http://faostat.fao.org/site/491/default.aspx ';\n"); 
print PSQL ("COMMENT ON COLUMN prodstat.pins.unit IS 'Unit crop quantity is measured in';\n");
print PSQL ("COMMENT ON COLUMN prodstat.pins.source_file  IS 'Name of the bulk download file';\n");
print PSQL ("\\COPY prodstat.pins FROM 'c:/bearedo/DataBase/FAOSTAT/output/PINS1.csv' WITH DELIMITER '|' null as 'NA' CSV header \n"); 


############################################################################################################
#######FILL TRADESTAT SCHEMA #############################
############################################################################################################


print PSQL ("SET SEARCH_PATH TO tradestat;\n");

print PSQL ("DROP TABLE tradestat.crops_livestockproducts; \n");

print PSQL ("CREATE TABLE tradestat.crops_livestockproducts (
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

print PSQL ("COMMENT ON TABLE tradestat.crops_livestockproducts IS 'These are FAOSTAT value of trade statistics data Afghanistan to Zim from the bulk download area http://faostat.fao.org/site/491/default.aspx ';\n"); 
print PSQL ("COMMENT ON COLUMN tradestat.crops_livestockproducts.unit IS 'Unit crop quantity is measured in';\n");
print PSQL ("COMMENT ON COLUMN tradestat.crops_livestockproducts.source_file  IS 'Name of the bulk download file';\n");
print PSQL ("\\COPY tradestat.crops_livestockproducts FROM 'c:/bearedo/DataBase/FAOSTAT/output/TradeSTAT-Crops&LiveStockProducts1.csv' WITH DELIMITER '|' null as 'NA' CSV header \n"); 
print PSQL ("\\COPY tradestat.crops_livestockproducts FROM 'c:/bearedo/DataBase/FAOSTAT/output/TradeSTAT-Crops&LiveStockProducts2.csv' WITH DELIMITER '|' null as 'NA' CSV header \n"); 
print PSQL ("\\COPY tradestat.crops_livestockproducts FROM 'c:/bearedo/DataBase/FAOSTAT/output/TradeSTAT-Crops&LiveStockProducts3.csv' WITH DELIMITER '|' null as 'NA' CSV header \n"); 
print PSQL ("\\COPY tradestat.crops_livestockproducts FROM 'c:/bearedo/DataBase/FAOSTAT/output/TradeSTAT-Crops&LiveStockProducts4.csv' WITH DELIMITER '|' null as 'NA' CSV header \n"); 
print PSQL ("\\COPY tradestat.crops_livestockproducts FROM 'c:/bearedo/DataBase/FAOSTAT/output/TradeSTAT-Crops&LiveStockProducts5.csv' WITH DELIMITER '|' null as 'NA' CSV header \n"); 
print PSQL ("\\COPY tradestat.crops_livestockproducts FROM 'c:/bearedo/DataBase/FAOSTAT/output/TradeSTAT-Crops&LiveStockProducts6.csv' WITH DELIMITER '|' null as 'NA' CSV header \n"); 
#
#######################################################################

print PSQL ("DROP TABLE tradestat.live_animals; \n");

print PSQL ("CREATE TABLE tradestat.live_animals (
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

print PSQL ("COMMENT ON TABLE tradestat.live_animals IS 'These are FAOSTAT value of trade statistics data Afghanistan to Zim from the bulk download area http://faostat.fao.org/site/491/default.aspx ';\n"); 
print PSQL ("COMMENT ON COLUMN tradestat.live_animals.unit IS 'Unit crop quantity is measured in';\n");
print PSQL ("COMMENT ON COLUMN tradestat.live_animals.source_file  IS 'Name of the bulk download file';\n");

print PSQL ("\\COPY tradestat.live_animals FROM 'c:/bearedo/DataBase/FAOSTAT/output/TradeSTAT-LiveAnimals1.csv' WITH DELIMITER '|' null as 'NA' CSV header \n"); 



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



############################################################################################################
#######FILL FISHERIES SCHEMA #############################
############################################################################################################

## Capture fisheries ###


print PSQL ("SET SEARCH_PATH TO fisheries;\n");
print PSQL ("DROP TABLE fisheries.capture CASCADE; \n");
print PSQL ("CREATE TABLE fisheries.capture (
    
    country       varchar(72),
    species     varchar(36),
    fishingarea         varchar(72),
    measure   varchar(24),
    year         integer,
    quantity     float); \n");

print PSQL ("COMMENT ON TABLE fisheries.capture IS 'These are FAO global fish capture statistics Afghanistan to Zim dumped from FISHSTATJ';\n"); 
print PSQL ("COMMENT ON COLUMN fisheries.capture.country IS 'Country';\n");
print PSQL ("COMMENT ON COLUMN fisheries.capture.fishingarea  IS 'Fishing area';\n");
print PSQL ("\\COPY fisheries.capture FROM 'c:/bearedo/DataBase/FAOSTAT/output/GlobalCaptureProduction.csv' WITH DELIMITER '|' null as 'NA' CSV header \n"); 


# Aquaculture production ### 


print PSQL ("SET SEARCH_PATH TO fisheries;\n");
print PSQL ("DROP TABLE fisheries.aquaproduction CASCADE; \n");
print PSQL ("CREATE TABLE fisheries.aquaproduction (
    
    country       varchar(72),
    species     varchar(36),
    fishingarea         varchar(72),
    environment   varchar(24),
    year         integer,
    quantity     float); \n");

print PSQL ("COMMENT ON TABLE fisheries.aquaproduction IS 'These are FAO global fish aquaculture production statistics Afghanistan to Zim dumped from FISHSTATJ';\n"); 
print PSQL ("COMMENT ON COLUMN fisheries.aquaproduction.country IS 'Country';\n");
print PSQL ("COMMENT ON COLUMN fisheries.aquaproduction.fishingarea  IS 'Fishing area';\n");
print PSQL ("\\COPY fisheries.aquaproduction FROM 'c:/bearedo/DataBase/FAOSTAT/output/GlobalAquaProduction.csv' WITH DELIMITER '|' null as 'NA' CSV header \n"); 


# Aquaculture value (cash)  ### 


print PSQL ("SET SEARCH_PATH TO fisheries;\n");
print PSQL ("DROP TABLE fisheries.aquavalue CASCADE; \n");
print PSQL ("CREATE TABLE fisheries.aquavalue (
    
    country       varchar(72),
    species     varchar(36),
    fishingarea         varchar(72),
    environment   varchar(24),
    year         integer,
    quantity     float); \n");

print PSQL ("COMMENT ON TABLE fisheries.aquavalue IS 'These are FAO global fish aquaculture cash value statistics Afghanistan to Zim dumped from FISHSTATJ';\n"); 
print PSQL ("COMMENT ON COLUMN fisheries.aquavalue.country IS 'Country';\n");
print PSQL ("COMMENT ON COLUMN fisheries.aquavalue.fishingarea  IS 'Fishing area';\n");
print PSQL ("\\COPY fisheries.aquavalue FROM 'c:/bearedo/DataBase/FAOSTAT/output/GlobalAquaValue.csv' WITH DELIMITER '|' null as 'NA' CSV header \n"); 




close(PSQL);










