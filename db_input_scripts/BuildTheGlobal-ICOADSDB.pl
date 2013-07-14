
#!/usr/bin/perl -w

#use strict;
# AUTHOR: doug.beare@gmail.com
#####################################################
#THIS PROGRAM IS BEST RUN BY POSTGRES SUPERUSER######
#####################################################
 
# PURPOSE: CREATE THE icoads DATABASE
#This database contains met data from 1784 to 2012
# THIS PROGRAM WILL WORK FOR *.gz files from .www.cdc.noaa.gov
# I got them from Zaihua Ji
#Zaihua Ji
#UCAR/NCAR/SCD/Data Support Section
#Phone: (303) 497-1819
#Email: zji@ucar.edu
#Web: http://dss.ucar.edu

require "aas_db.pl";

# CREATE THE DATA TABLE IN POSTGRESQL WHICH WE CALLED icoads_world

# print PSQL ("SET default_tablespace = biospace; \n");


print PSQL ("SET SEARCH_PATH TO global; \n");
##print PSQL ("DROP TABLE global.clim_icoads_world CASCADE; \n");
#
#
##print PSQL ("CREATE TABLESPACE dbspace LOCATION \'G://pGdata\'; \n");
#
#print PSQL ("SET default_tablespace = dbspace; \n");
#
print PSQL ("CREATE TABLE global.clim_icoads_world (
yr int, mo int,dy int,hr float,lat float4,lon float4,im int,ti int,li int,ii int,
id varchar(12),c1 varchar(3),
di int,
d int,   
wi float,
w float,
vv int,
ww varchar(3),
slp float,
at float, 
sst float, 
n int, 
wd int, 
wp int, 
wh int,
sd int,
sp int, 
sh int) WITH OIDS;\n");

#print "$yr|$mo|$dy|$hr|$lat|$lon|$im|$ti|$li|$ii|$id|$c1|$di|$d|$wi|$w|$vv|$ww|$slp|$at|$sst|$n|$wd|$wp|$wh|$sd|$sp|$sh\n";

print PSQL ("COMMENT ON TABLE global.icoads IS 'These are surface data (1784-2012) from icoads in most up to date format (www.cdc.noaa.gov). Future data can be downloaded via ftp with the help of Zaihua';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world.yr IS 'Year (-9999)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world.mo IS 'Month (-99)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world.dy IS 'Day (-99)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world.hr IS 'Hour 0.01hr (-99.99)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world.lat IS 'Digital latitude 0.01N (-999.99)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world.lon IS 'Digital longitude 0.01E (-999.99)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world.ti IS 'Time indic.              (-9)';\n");
#print PSQL ("COMMENT ON COLUMN global.clim_icoads_world.ds IS 'Ship course               (-9)';\n");
#print PSQL ("COMMENT ON COLUMN global.clim_icoads_world.vs IS 'Ship speed  knots         (-9)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world.ii IS 'ID indicator              (-99)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world.id IS 'ID ident/call sign        (-99)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world.c1 IS 'Country code              (-99)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world.di IS 'Wind  Direc. indic.          (-99)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world.d IS 'Wind  Direction    degree    (-99)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world.wi IS 'Wind  Speed Indicator    degree    (-99)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world.w IS 'Wind  Speed   0.1m/s     (-9)';\n");
#print PSQL ("COMMENT ON COLUMN global.clim_icoads_world.vi IS 'vv indic           (-9)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world.vv IS 'Visbility           (-9)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world.ww IS 'Present weather           (-9)';\n");
#print PSQL ("COMMENT ON COLUMN global.clim_icoads_world.w1 IS 'Past weather           (-9)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world.slp IS 'Sea level pressure  0.1hPa   (-9999.9)';\n");
#print PSQL ("COMMENT ON COLUMN global.clim_icoads_world.ppp IS 'Atmospheric pressure tendency   (-99.9)';\n");
##print PSQL ("COMMENT ON COLUMN global.clim_icoads_world.it IS 'Temperature indicator   (-9)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world.at IS 'Air temperature 0.1C   (-999.9)';\n");
##print PSQL ("COMMENT ON COLUMN global.clim_icoads_world.wbti IS 'Indicator for wbt 0.1C   (-999.9)';\n");
##print PSQL ("COMMENT ON COLUMN global.clim_icoads_world.wbt IS ' Wet bulb temp. 0.1C     (-999.9)';\n");
##print PSQL ("COMMENT ON COLUMN global.clim_icoads_world.dpti IS 'Dpt indicator              (-9)';\n");
##print PSQL ("COMMENT ON COLUMN global.clim_icoads_world.dpt IS 'Dew point temperature  0.1C  (-999.9)';\n");
##print PSQL ("COMMENT ON COLUMN global.clim_icoads_world.si IS 'SST measurement method         (-99)';\n");
#print PSQL ("COMMENT ON COLUMN global.clim_icoads_world.sst IS 'Sea surface temperature  0.1C  (-999.9)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world.n IS 'Total cloud amt                  (-9)';\n");
##print PSQL ("COMMENT ON COLUMN global.clim_icoads_world.cl IS 'Low cloud type                   (-999.9)';\n");
##print PSQL ("COMMENT ON COLUMN global.clim_icoads_world.hi IS 'H indic.                             (-9)';\n");
##print PSQL ("COMMENT ON COLUMN global.clim_icoads_world.h IS 'Cloud height    (-9)';\n");
##print PSQL ("COMMENT ON COLUMN global.clim_icoads_world.cm IS 'Mid-cloud height    (-9)';\n");
##print PSQL ("COMMENT ON COLUMN global.clim_icoads_world.ch IS 'High-cloud height    (-9)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world.wd IS 'Wave direction       (-99)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world.wp IS 'Wave period       (-99)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world.wh IS 'Wave height       (-99)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world.sd IS 'Swell direction    (-99)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world.sp IS 'Swell period       (-99)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world.sh IS 'Swell height       (-99)';\n");
#print PSQL ("COMMENT ON COLUMN global.clim_icoads_world.statsq IS 'ICES Statistical Rectangle';\n");
#print PSQL ("COMMENT ON COLUMN global.clim_icoads_world.dck IS 'Deck              (-999)';\n");
#print PSQL ("COMMENT ON COLUMN global.clim_icoads_world.sid IS 'Source ID          (-999)';\n");
#print PSQL ("COMMENT ON COLUMN global.clim_icoads_world.pt  IS 'Platform type          (-999)';\n");
#
# FILL THE TABLE
# Global East
open(DATAFILE, "ls /srv/public/input_data_files/ICOADS-Global/ICOADS-East/tmp/*dat |");
while(<DATAFILE>){
s/^\s*(.*)\s*$/$1/;
chomp;
open(FILE,"<$_") or die "Cannot open file $_: $!\n";
print PSQL ("\\COPY global.clim_icoads_world FROM \'$_\' with delimiter \'|\' null as \'NA\'\n");
print "IMPORTING: $_\n";}

# Global West
open(DATAFILE, "ls /srv/public/input_data_files/ICOADS-Global/ICOADS-West/tmp/*dat |");
while(<DATAFILE>){
s/^\s*(.*)\s*$/$1/;
chomp;
open(FILE,"<$_") or die "Cannot open file $_: $!\n";
print PSQL ("\\COPY global.clim_icoads_world FROM \'$_\' with delimiter \'|\' null as \'NA\'\n");
print "IMPORTING: $_\n";}

close(DATAFILE);

## Drop some columns to save space and speed queries ##

#print PSQL ("
#ALTER TABLE global.clim_icoads_world DROP COLUMN im CASCADE;
#ALTER TABLE global.clim_icoads_world DROP COLUMN ii CASCADE;
#ALTER TABLE global.clim_icoads_world DROP COLUMN id CASCADE;
#ALTER TABLE global.clim_icoads_world DROP COLUMN vv CASCADE;
#ALTER TABLE global.clim_icoads_world DROP COLUMN ww CASCADE;
#\n");

# Drop data before 1900 to save space and speed queries 

#print PSQL ("
#DELETE FROM global.clim_icoads_world
#  WHERE yr < 1900;
#\n");


#
## Create indices ###

print PSQL ("CREATE INDEX icoads_world_mo ON global.clim_icoads_world (mo);\n");
print PSQL ("CREATE INDEX icoads_world_yr ON global.clim_icoads_world (yr);\n");
print PSQL ("CREATE INDEX icoads_world_lat ON global.clim_icoads_world (lat);\n");
print PSQL ("CREATE INDEX icoads_world_lon ON global.clim_icoads_world (lon);\n");

### Add on geometry point ###

print PSQL ("SET SEARCH_PATH to public;\n");
print PSQL ("SELECT addgeometrycolumn('','global','clim_icoads_world','the_point',4326,'POINT',2);\n");
print PSQL ("UPDATE global.clim_icoads_world SET the_point=SETSRID(MAKEPOINT(lon,lat),4326);\n"); 
print PSQL ("CREATE INDEX icoads_world_the_point ON global.clim_icoads_world USING GIST (the_point);\n");



#print "Converting lat/lon position into ICES stat square\n";

#print PSQL ("SELECT icessquare.statsq,ncoads.*
#INTO temp
#FROM icessquare LEFT OUTER JOIN ncoads
#ON point(latitude,longitude) @icessquare.statsqgeom
#WHERE longitude > -3.833 AND longitude < 12.833 AND latitude > 51 AND latitude < 62;          \n");

#print PSQL ("SELECT year,month,statsq,
#AVG(slp) AS slp,
#AVG(winddir) AS winddir,
#AVG(windspeed) AS windspeed
#INTO temp1
#FROM temp
#GROUP BY temp.year,temp.month,temp.statsq
#ORDER BY year;                       \n");



#print PSQL ("GRANT USAGE ON SCHEMA physical TO bearedo;\n");
#print PSQL ("GRANT SELECT ON global.icoads TO bearedo;\n");



close(PSQL);













