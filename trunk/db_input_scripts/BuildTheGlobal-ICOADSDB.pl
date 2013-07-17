
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
print PSQL ("DROP TABLE global.clim_icoads_world_new CASCADE; \n");

#
##print PSQL ("CREATE TABLESPACE dbspace LOCATION \'G://pGdata\'; \n");
#
#print PSQL ("SET default_tablespace = dbspace; \n");
#
print PSQL ("CREATE TABLE global.clim_icoads_world_new (
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

print PSQL ("COMMENT ON TABLE global.clim_icoads_world_new IS 'These are surface data (1970-present) from icoads in most up to date format (www.cdc.noaa.gov). Future data can be downloaded via ftp with the help of Zaihua';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_new.yr IS 'Year (-9999)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_new.mo IS 'Month (-99)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_new.dy IS 'Day (-99)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_new.hr IS 'Hour 0.01hr (-99.99)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_new.lat IS 'Digital latitude 0.01N (-999.99)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_new.lon IS 'Digital longitude 0.01E (-999.99)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_new.ti IS 'Time indic.              (-9)';\n");
#print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_new.ds IS 'Ship course               (-9)';\n");
#print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_new.vs IS 'Ship speed  knots         (-9)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_new.ii IS 'ID indicator              (-99)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_new.id IS 'ID ident/call sign        (-99)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_new.c1 IS 'Country code              (-99)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_new.di IS 'Wind  Direc. indic.          (-99)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_new.d IS 'Wind  Direction    degree    (-99)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_new.wi IS 'Wind  Speed Indicator    degree    (-99)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_new.w IS 'Wind  Speed   0.1m/s     (-9)';\n");
#print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_new.vi IS 'vv indic           (-9)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_new.vv IS 'Visbility           (-9)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_new.ww IS 'Present weather           (-9)';\n");
#print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_new.w1 IS 'Past weather           (-9)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_new.slp IS 'Sea level pressure  0.1hPa   (-9999.9)';\n");
#print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_new.ppp IS 'Atmospheric pressure tendency   (-99.9)';\n");
##print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_new.it IS 'Temperature indicator   (-9)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_new.at IS 'Air temperature 0.1C   (-999.9)';\n");
##print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_new.wbti IS 'Indicator for wbt 0.1C   (-999.9)';\n");
##print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_new.wbt IS ' Wet bulb temp. 0.1C     (-999.9)';\n");
##print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_new.dpti IS 'Dpt indicator              (-9)';\n");
##print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_new.dpt IS 'Dew point temperature  0.1C  (-999.9)';\n");
##print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_new.si IS 'SST measurement method         (-99)';\n");
#print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_new.sst IS 'Sea surface temperature  0.1C  (-999.9)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_new.n IS 'Total cloud amt                  (-9)';\n");
##print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_new.cl IS 'Low cloud type                   (-999.9)';\n");
##print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_new.hi IS 'H indic.                             (-9)';\n");
##print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_new.h IS 'Cloud height    (-9)';\n");
##print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_new.cm IS 'Mid-cloud height    (-9)';\n");
##print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_new.ch IS 'High-cloud height    (-9)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_new.wd IS 'Wave direction       (-99)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_new.wp IS 'Wave period       (-99)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_new.wh IS 'Wave height       (-99)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_new.sd IS 'Swell direction    (-99)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_new.sp IS 'Swell period       (-99)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_new.sh IS 'Swell height       (-99)';\n");
#print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_new.statsq IS 'ICES Statistical Rectangle';\n");
#print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_new.dck IS 'Deck              (-999)';\n");
#print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_new.sid IS 'Source ID          (-999)';\n");
#print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_new.pt  IS 'Platform type          (-999)';\n");
#
# FILL THE TABLE
# Global East
open(DATAFILE, "ls /srv/public/input_data_files/ICOADS-Global/ICOADS-East/tmp1970/*dat |");
while(<DATAFILE>){
s/^\s*(.*)\s*$/$1/;
chomp;
open(FILE,"<$_") or die "Cannot open file $_: $!\n";
print PSQL ("\\COPY global.clim_icoads_world_new FROM \'$_\' with delimiter \'|\' null as \'NA\'\n");
print "IMPORTING: $_\n";}

# Global West
open(DATAFILE, "ls /srv/public/input_data_files/ICOADS-Global/ICOADS-West/tmp1970/*dat |");
while(<DATAFILE>){
s/^\s*(.*)\s*$/$1/;
chomp;
open(FILE,"<$_") or die "Cannot open file $_: $!\n";
print PSQL ("\\COPY global.clim_icoads_world_new FROM \'$_\' with delimiter \'|\' null as \'NA\'\n");
print "IMPORTING: $_\n";}

close(DATAFILE);


## Drop some columns to save space and speed queries ##

print PSQL ("
ALTER TABLE global.clim_icoads_world_new DROP COLUMN im CASCADE;
ALTER TABLE global.clim_icoads_world_new DROP COLUMN ii CASCADE;
ALTER TABLE global.clim_icoads_world_new DROP COLUMN id CASCADE;
ALTER TABLE global.clim_icoads_world_new DROP COLUMN vv CASCADE;
ALTER TABLE global.clim_icoads_world_new DROP COLUMN ww CASCADE;
\n");

# Drop data before 1900 to save space and speed queries 

#print PSQL ("
#DELETE FROM global.clim_icoads_world_new
#  WHERE yr < 1900;
#\n");


#
## Create indices ###

print PSQL ("CREATE INDEX icoads_world_mo ON global.clim_icoads_world_new (mo);\n");
print PSQL ("CREATE INDEX icoads_world_yr ON global.clim_icoads_world_new (yr);\n");
print PSQL ("CREATE INDEX icoads_world_lat ON global.clim_icoads_world_new (lat);\n");
print PSQL ("CREATE INDEX icoads_world_lon ON global.clim_icoads_world_new (lon);\n");

## Make all westerly longitudes icoads_world

#print PSQL ("UPDATE global.clim_icoads_world_new SET lon = lon -360 WHERE lon > 180;\n");

### Add on geometry point ###

print PSQL ("ALTER TABLE global.clim_icoads_world_new ADD COLUMN the_point geometry(Point,4326);\n");
print PSQL ("UPDATE global.clim_icoads_world_new SET the_point = ST_SETSRID(ST_MAKEPOINT(lon,lat),4326);\n"); 

print PSQL ("CREATE INDEX icoads_world_the_point ON global.clim_icoads_world_new USING GIST (the_point);\n");


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













