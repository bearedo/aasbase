

#!/usr/bin/perl -w

#use strict;
# AUTHOR: doug.beare@gmail.com
#####################################################
#THIS PROGRAM IS BEST RUN BY POSTGRES SUPERUSER######
#####################################################
 
# PURPOSE: CREATE THE Land Precipitation DATABASE
#This database contains met data from 1948 - 2012

#Monthly Analysis of Global Land Precipitation from 1948 to the Present (PREC/L)
#
#1.  filename 
#    
#    precl_mon_v1.0.txt.yyyy.gri0.5m
#    ( yyyy = 1948 - 2003 ) 
#
#2.  description of the data 
#    
#    1)  content: 
#        kyr    ==  year  ( 1948 - 2003 )  
#        kmn    ==  month (1 - 12)  
#        rlat   ==  latitude  (-89.75 --> 89.75)     
#        rlon   ==  longitude (eastward from 0.25 E)   
#        rain   ==  monthly precipitation based on gauge observations from
#                GHCN version 2B and CAMS in (0.1 mm/day)
#                (e.g. 234.0 is 23.4 mm/day);
#        gauge_num == number of gauges in the grid box;
#     
#    2)  coverage: 
#        -89.75S -- 89.75N; 0.25E -> Eastward -> 0.25W 
#
#    3)  resolution: 
#        0.5 deg lat x 0.5 deg lon 
#        monthly  
#  
#    4)  missing values 
#        -999.0  
#
#3.  example program   
#    
#c     program     :     example.f  
#c     objective   :     to read the PREC/L data for 1948    
#c 
#      dimension    rain(720,360),gauge_num(720,360)  
#c
#c     1.  to open the data file 
#c
#      open  (unit=10,file='precl_mon_v1.0.txt.1948.gri0.5m', 
#     #       access='sequential',status='old',form='formatted') 
#c
#c     2.  to read the data 
#c 
#      do 2001 kmon=1,12    
#      do 2001 jj=1,360 
#      do 2001 ii=1,720 
#        read  (10,2901)  kyr,kmn,rlat,rlon, 
#     #                   rain(ii,jj),gauge_num(ii,jj) 
# 2001 continue 
# 2901 format  (2i4,2f8.2,2f8.2) 
#c
#      stop 
#      end  
#
#4.  references: 
#
#    Chen, M., P. Xie, J. E. Janowiak, and P. A. Arkin, Global Land
#          Precipiation: A 50-yr Monthly Analysis Based on Gauge
#          Observations, 2002,  J. Hydrometeor., 3, 249-266.
#
#5. Notice: 
#    
#   1) Please refer to this product as the PRECipitation REConstrucion 
#      over Land (PREC/L)
#
#   2) Please contact us for any problems or questions regarding
#    this product.
#
#    Dr. Mingyue Chen
#    Climate Prediction Center
#    5200 Auth Road, #805B
#    Camp Spings MD 20746
#    Tel:  (301) 763-8000 ext. 7506
#    Fax:  (301) 763-8125
#    E-mail:  mingyue.chen@noaa.gov
#


require "aas_db.pl";
#require "common-nrm-gis.pl";

# CREATE THE DATA TABLE IN POSTGRESQL WHICH WE CALLED  precipitation

print PSQL ("SET SEARCH_PATH TO global; \n");

print PSQL ("DROP TABLE global.precipitation CASCADE; \n");

##print PSQL ("CREATE TABLESPACE dbspace LOCATION \'G://pGdata\'; \n");
#
#print PSQL ("SET default_tablespace = dbspace; \n");
#
print PSQL ("CREATE TABLE global.precipitation (
year int, 
month int, 
lat float4, 
lon float4, 
rain float4 , 
num_gauges float) WITH OIDS;\n");


print PSQL ("COMMENT ON TABLE global.precipitation IS 'These are global land precipitation data from GHCN. See Chen, M., P. Xie, J. E. Janowiak, and P. A. Arkin, Global Land Precipiation: A 50-yr Monthly Analysis Based on Gauge Observations, 2002,  J. Hydrometeor., 3, 249-266.';\n");
print PSQL ("COMMENT ON COLUMN global.precipitation.year IS 'Year';\n");
print PSQL ("COMMENT ON COLUMN global.precipitation.month IS 'Month';\n");
print PSQL ("COMMENT ON COLUMN global.precipitation.lat IS 'Digital latitude';\n");
print PSQL ("COMMENT ON COLUMN global.precipitation.lon IS 'Digital longitude';\n");
print PSQL ("COMMENT ON COLUMN global.precipitation.rain IS 'Monthly precipitation based on gauge observations from GHCN version 2B and CAMS in (0.1 mm/day) (e.g. 234.0 is 23.4 mm/day)';\n");
print PSQL ("COMMENT ON COLUMN global.precipitation.num_gauges IS 'Number of rain gauges making the observation';\n");

## FILL THE TABLE
 
open(DATAFILE, "ls /srv/public/input_data_files/Land-Precipitation-Grid-From-GHCN/tmp/*dat |");
while(<DATAFILE>){
s/^\s*(.*)\s*$/$1/;
chomp;
open(FILE,"<$_") or die "Cannot open file $_: $!\n";
print PSQL ("\\COPY global.precipitation FROM \'$_\' WITH delimiter \',\' null as \'-999.00\'\n");
print "IMPORTING: $_\n";}
close(DATAFILE);

## Create more manageable table from the tropics alone

print PSQL ("DROP TABLE global.precipitation_tropics CASCADE; \n");


print PSQL ("SELECT * INTO global.precipitation_tropics from global.precipitation where lat > -19 AND lat < 27;\n");
print PSQL ("COMMENT ON TABLE global.precipitation_tropics IS 'These are global land precipitation data from GHCN for key tropical countries only';\n");



print PSQL ("ALTER TABLE global.precipitation_tropics ADD PRIMARY KEY (year,month,lat,lon);\n");


#
### Create indices ###
#
print PSQL ("CREATE INDEX precipitation_month ON global.precipitation (month);\n");
print PSQL ("CREATE INDEX precipitation_year ON global.precipitation (year);\n");
print PSQL ("CREATE INDEX precipitation_lat ON global.precipitation (lat);\n");
print PSQL ("CREATE INDEX precipitation_lon ON global.precipitation (lon);\n");
##
##### Add on geometry point ###
##
print PSQL ("SET SEARCH_PATH to public;\n");
#print PSQL ("SELECT addgeometrycolumn('','global','precipitation','the_point',4326,'POINT',2);\n"); # NB. this command appears to be out of date ?

print PSQL ("ALTER TABLE global.precipitation ADD COLUMN the_point geometry(Point,4326);\n");

print PSQL ("UPDATE global.precipitation SET the_point = ST_SETSRID(ST_MAKEPOINT(lon,lat),4326);\n"); 

print PSQL ("CREATE INDEX precipitation_the_point ON global.precipitation USING GIST (the_point);\n");
##
##
##### Split into decadal tables to make data easier to deal with
##
#print PSQL ("DROP TABLE global.precipitation_forties CASCADE; \n");
#print PSQL ("DROP TABLE global.precipitation_fifties CASCADE; \n");
#print PSQL ("DROP TABLE global.precipitation_sixties CASCADE; \n");
#print PSQL ("DROP TABLE global.precipitation_seventies CASCADE; \n");
#print PSQL ("DROP TABLE global.precipitation_eighties CASCADE; \n");
#print PSQL ("DROP TABLE global.precipitation_nineties CASCADE; \n");
#print PSQL ("DROP TABLE global.precipitation_noughties CASCADE; \n");
#print PSQL ("DROP TABLE global.precipitation_twentytens CASCADE; \n");
#
#print PSQL ("select * into global.precipitation_forties from global.precipitation where year < 1950;\n");
#print PSQL ("select * into global.precipitation_fifties from global.precipitation where year > 1949 AND year < 1960 ;\n");
#print PSQL ("select * into global.precipitation_sixties from global.precipitation where year > 1959 AND year < 1970;\n");
#print PSQL ("select * into global.precipitation_seventies from global.precipitation where year > 1969 AND year < 1980;\n");
#print PSQL ("select * into global.precipitation_eighties from global.precipitation where year > 1979 AND year < 1990;\n");
#print PSQL ("select * into global.precipitation_nineties from global.precipitation where year > 1989 AND year < 2000;\n");
#print PSQL ("select * into global.precipitation_noughties from global.precipitation where year > 1999 AND year < 2010;\n");
#print PSQL ("select * into global.precipitation_twentytens from global.precipitation where year > 2009;\n");
##
##print PSQL ("DROP TABLE precipitation;\n");
##
#
## 1940s
#print PSQL ("SET SEARCH_PATH to public;\n");
#print PSQL ("SELECT addgeometrycolumn('','physical','precipitation_forties','the_point',4326,'POINT',2);\n");
#print PSQL ("UPDATE global.precipitation_forties SET the_point=SETSRID(MAKEPOINT(lon,lat),4326);\n"); 
#print PSQL ("CREATE INDEX precipitation_forties_the_point ON global.precipitation_forties USING GIST (the_point);\n");
#
##print PSQL ("ALTER TABLE global.precipitation_forties ADD COLUMN eez varchar(64);\n");
##print PSQL ("UPDATE global.precipitation_forties  SET eez = public.world_eez.eez FROM public.world_eez WHERE ST_Intersects(global.precipitation_forties.the_point,world_eez.the_geom);\n");
##print PSQL ("ALTER TABLE global.precipitation_forties  ADD COLUMN iso_3digit varchar(24);\n");
##print PSQL ("UPDATE global.precipitation_forties  SET iso_3digit = public.world_eez.iso_3digit FROM public.world_eez WHERE ST_Intersects(global.precipitation_forties.the_point,world_eez.the_geom);\n");
##
## 1950s
#print PSQL ("SET SEARCH_PATH to public;\n");
#print PSQL ("SELECT addgeometrycolumn('','physical','precipitation_fifties','the_point',4326,'POINT',2);\n");
#print PSQL ("UPDATE global.precipitation_fifties SET the_point=SETSRID(MAKEPOINT(lon,lat),4326);\n"); 
#print PSQL ("CREATE INDEX precipitation_fifties_the_point ON global.precipitation_fifties USING GIST (the_point);\n");
#
##print PSQL ("ALTER TABLE global.precipitation_fifties ADD COLUMN eez varchar(64);\n");
##print PSQL ("UPDATE global.precipitation_fifties  SET eez = public.world_eez.eez FROM public.world_eez WHERE within(global.precipitation_fifties.the_point,world_eez.the_geom);\n");
##print PSQL ("ALTER TABLE global.precipitation_fifties  ADD COLUMN iso_3digit varchar(24);\n");
##print PSQL ("UPDATE global.precipitation_fifties  SET iso_3digit = public.world_eez.iso_3digit FROM public.world_eez WHERE within(global.precipitation_fifties.the_point,world_eez.the_geom);\n");
##
#
## 1960s
#print PSQL ("SET SEARCH_PATH to public;\n");
#print PSQL ("SELECT addgeometrycolumn('','physical','precipitation_sixties','the_point',4326,'POINT',2);\n");
#print PSQL ("UPDATE global.precipitation_sixties SET the_point=SETSRID(MAKEPOINT(lon,lat),4326);\n"); 
#print PSQL ("CREATE INDEX precipitation_sixties_the_point ON global.precipitation_sixties USING GIST (the_point);\n");
#
##print PSQL ("ALTER TABLE global.precipitation_sixties ADD COLUMN eez varchar(64);\n");
##print PSQL ("UPDATE global.precipitation_sixties  SET eez = public.world_eez.eez FROM public.world_eez WHERE within(global.precipitation_sixties.the_point,world_eez.the_geom);\n");
##print PSQL ("ALTER TABLE global.precipitation_sixties  ADD COLUMN iso_3digit varchar(24);\n");
##print PSQL ("UPDATE global.precipitation_sixties  SET iso_3digit = public.world_eez.iso_3digit FROM public.world_eez WHERE within(global.precipitation_sixties.the_point,world_eez.the_geom);\n");
##
## 1970s
#print PSQL ("SET SEARCH_PATH to public;\n");
#print PSQL ("SELECT addgeometrycolumn('','physical','precipitation_seventies','the_point',4326,'POINT',2);\n");
#print PSQL ("UPDATE global.precipitation_seventies SET the_point=SETSRID(MAKEPOINT(lon,lat),4326);\n"); 
#print PSQL ("CREATE INDEX precipitation_seventies_the_point ON global.precipitation_seventies USING GIST (the_point);\n");
#
#
## 1980s
#print PSQL ("SET SEARCH_PATH to public;\n");
#print PSQL ("SELECT addgeometrycolumn('','physical','precipitation_eighties','the_point',4326,'POINT',2);\n");
#print PSQL ("UPDATE global.precipitation_eighties SET the_point=SETSRID(MAKEPOINT(lon,lat),4326);\n"); 
#print PSQL ("CREATE INDEX precipitation_eighties_the_point ON global.precipitation_eighties USING GIST (the_point);\n");
#
# # 1990s
#print PSQL ("SET SEARCH_PATH to public;\n");
#print PSQL ("SELECT addgeometrycolumn('','physical','precipitation_nineties','the_point',4326,'POINT',2);\n");
#print PSQL ("UPDATE global.precipitation_nineties SET the_point=SETSRID(MAKEPOINT(lon,lat),4326);\n"); 
#print PSQL ("CREATE INDEX precipitation_nineties_the_point ON global.precipitation_nineties USING GIST (the_point);\n");
#
# # 2000s
#print PSQL ("SET SEARCH_PATH to public;\n");
#print PSQL ("SELECT addgeometrycolumn('','physical','precipitation_noughties','the_point',4326,'POINT',2);\n");
#print PSQL ("UPDATE global.precipitation_noughties SET the_point=SETSRID(MAKEPOINT(lon,lat),4326);\n"); 
#print PSQL ("CREATE INDEX precipitation_noughties_the_point ON global.precipitation_noughties USING GIST (the_point);\n");
#
## 2010s
#print PSQL ("SET SEARCH_PATH to public;\n");
#print PSQL ("SELECT addgeometrycolumn('','physical','precipitation_twentytens','the_point',4326,'POINT',2);\n");
#print PSQL ("UPDATE global.precipitation_twentytens SET the_point=SETSRID(MAKEPOINT(lon,lat),4326);\n"); 
#print PSQL ("CREATE INDEX precipitation_twentytens_the_point ON global.precipitation_twentytens USING GIST (the_point);\n");
#
#
#
##Add a column for statistical rectangle
#
##print PSQL ("ALTER TABLE global.icoads ADD COLUMN statsq varchar(4);\n");
##print PSQL ("UPDATE global.icoads SET 
##statsq = public.icessquare.statsq FROM public.icessquare WHERE point(lat, lon) \@public.icessquare.statsqgeom;;\n");
##
#
#
##Add a column for ICES area
#
##print PSQL ("ALTER TABLE global.icoads ADD COLUMN ices_area varchar(4);\n");
##print PSQL ("UPDATE global.icoads
##SET ices_area = icessquare.division_arabic
##FROM public.icessquare
##WHERE public.icessquare.statsq = global.icoads.statsq;\n");
##
##
#
##print "Converting lat/lon position into ICES stat square\n";
#
##print PSQL ("SELECT icessquare.statsq,ncoads.*
##INTO temp
##FROM icessquare LEFT OUTER JOIN ncoads
##ON point(latitude,longitude) @icessquare.statsqgeom
##WHERE longitude > -3.833 AND longitude < 12.833 AND latitude > 51 AND latitude < 62;          \n");
#
##print PSQL ("SELECT year,month,statsq,
##AVG(slp) AS slp,
##AVG(winddir) AS winddir,
##AVG(windspeed) AS windspeed
##INTO temp1
##FROM temp
##GROUP BY temp.year,temp.month,temp.statsq
##ORDER BY year;                       \n");
#
#
#
##print PSQL ("GRANT USAGE ON SCHEMA physical TO bearedo;\n");
##print PSQL ("GRANT SELECT ON global.icoads TO bearedo;\n");
#
#


close(PSQL);













