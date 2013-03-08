#!/usr/bin/perl -w

require "common.pl";
#require "common-nrm-gis.pl";

use strict;

### AUTHOR: Doug Beare

####################################
## THIS PROGRAM MUST BE RUN BY POSTGRES#
####################################
 
##PURPOSE: CREATE THE FAOSTAT FISHERIES DATABASE

 
print PSQL ("DROP TABLE global.geo_regions; \n");

print PSQL ("CREATE TABLE global.geo_regions (
     numerical_code integer,
    country    varchar(72),
    region     varchar(72),
    continent  varchar(72)); \n");

print PSQL ("COMMENT ON TABLE public.geo_regions IS 'These are United Nations Geographic regions from unstats.un.org/unsd/methods/m49/m49regin.htm ';\n"); 
print PSQL ("\\COPY public.geo_regions FROM '/srv/public/input_data_files/UN-Groupings/UN-Geographic-Regions.csv' WITH DELIMITER '|' null as 'NA' CSV HEADER \n");


print PSQL ("DROP TABLE global.socioecon_groupings; \n");

print PSQL ("CREATE TABLE global.socioecon_groupings (
     numerical_code integer,
     country       varchar(72),
     economic_status     varchar(72)); \n");

print PSQL ("COMMENT ON TABLE global.socioecon_groupings IS 'These are United Nations economic groupings from unstats.un.org/unsd/methods/m49/m49regin.htm ';\n"); 
print PSQL ("\\COPY global.socioecon_groupings FROM '/srv/public/input_data_files/UN-Groupings/UN-Economic-Groupings.csv' WITH DELIMITER '|' null as 'NA' CSV HEADER \n");


############################################################################################################
#######FILL FISHERIES DATA #############################
############################################################################################################

### Capture fisheries ###


print PSQL ("SET SEARCH_PATH TO global;\n");
print PSQL ("DROP TABLE global.fish_capture CASCADE; \n");
print PSQL ("CREATE TABLE global.fish_capture (
    
    country       varchar(72),
    species     varchar(36),
    prodarea  varchar(72),
    measure   varchar(24),
    year         integer,
    quantity     float,
    source varchar(24)); \n");

print PSQL ("COMMENT ON TABLE global.fish_capture IS 'These are FAO global fish capture statistics Afghanistan to Zim dumped from FISHSTATJ in March 2013 by Doug Beare';\n"); 
print PSQL ("COMMENT ON COLUMN global.fish_capture.country IS 'Country';\n");
print PSQL ("COMMENT ON COLUMN global.fish_capture.prodarea  IS 'FAO Fishing area';\n");
print PSQL ("\\COPY global.fish_capture FROM '/srv/public/input_data_files/FAOSTAT/Relational_Final.GCaptProd2013.csv' WITH DELIMITER '|' null as 'NA' CSV header \n"); 


### Aquaculture production ### 


print PSQL ("SET SEARCH_PATH TO global;\n");
print PSQL ("DROP TABLE global.aqua_production CASCADE; \n");
print PSQL ("CREATE TABLE global.aqua_production (
    
    country       varchar(72),
    species     varchar(36),
    prodarea         varchar(72),
    environment   varchar(24),
    year         integer,
    quantity     float,
    source varchar(24)); \n");

print PSQL ("COMMENT ON TABLE global.aqua_production IS 'These are FAO global fish aquaculture production statistics Afghanistan to Zim dumped from FISHSTATJ';\n"); 
print PSQL ("COMMENT ON COLUMN global.aqua_production.country IS 'Country';\n");
print PSQL ("COMMENT ON COLUMN global.aqua_production.environment  IS 'FAO Aquaculture area';\n");
print PSQL ("\\COPY global.aqua_production FROM '/srv/public/input_data_files/FAOSTAT/Relational_Final.GAquaProd2013.csv' WITH DELIMITER '|' null as 'NA' CSV header \n"); 


### Aquaculture value (cash)  ### 


print PSQL ("SET SEARCH_PATH TO global;\n");
print PSQL ("DROP TABLE global.aqua_value CASCADE; \n");
print PSQL ("CREATE TABLE global.aqua_value (
    
    country       varchar(72),
    species     varchar(36),
    prodarea         varchar(72),
    environment   varchar(24),
    year         integer,
    quantity     float,
    source varchar(24)); \n");

print PSQL ("COMMENT ON TABLE global.aqua_value IS 'These are FAO global fish aquaculture cash value statistics Afghanistan to Zim dumped from FISHSTATJ';\n"); 
print PSQL ("COMMENT ON COLUMN global.aqua_alue.country IS 'Country';\n");
print PSQL ("COMMENT ON COLUMN global.aqua_value.prodarea  IS 'FAO Aquaculture area';\n");
print PSQL ("\\COPY fisheries.aquavalue FROM '/srv/public/input_data_files/FAOSTAT/Relational_Final.AquaVal2013.csv' WITH DELIMITER '|' null as 'NA' CSV header \n"); 


close(PSQL);










