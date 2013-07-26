
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

# CREATE THE DATA TABLES IN POSTGRESQL for ICOADs

# print PSQL ("SET default_tablespace = biospace; \n");

print PSQL ("SET SEARCH_PATH TO global; \n");
print PSQL ("DROP TABLE global.clim_icoads_world_2000_present CASCADE; \n");

#
##print PSQL ("CREATE TABLESPACE dbspace LOCATION \'G://pGdata\'; \n");
#
#print PSQL ("SET default_tablespace = dbspace; \n");
#

print PSQL ("CREATE TABLE global.clim_icoads_world_2000_present (
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

print PSQL ("COMMENT ON TABLE global.clim_icoads_world_2000_present IS 'These are global historic marine surface data (2000-present). See(www.cdc.noaa.gov)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_2000_present.yr IS 'Year (-9999)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_2000_present.mo IS 'Month (-99)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_2000_present.dy IS 'Day (-99)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_2000_present.hr IS 'Hour 0.01hr (-99.99)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_2000_present.lat IS 'Digital latitude 0.01N (-999.99)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_2000_present.lon IS 'Digital longitude 0.01E (-999.99)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_2000_present.ti IS 'Time indic.              (-9)';\n");
#print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_2000_present.ds IS 'Ship course               (-9)';\n");
#print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_2000_present.vs IS 'Ship speed  knots         (-9)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_2000_present.ii IS 'ID indicator              (-99)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_2000_present.id IS 'ID ident/call sign        (-99)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_2000_present.c1 IS 'Country code              (-99)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_2000_present.di IS 'Wind  Direc. indic.          (-99)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_2000_present.d IS 'Wind  Direction    degree    (-99)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_2000_present.wi IS 'Wind  Speed Indicator    degree    (-99)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_2000_present.w IS 'Wind  Speed   0.1m/s     (-9)';\n");
#print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_2000_present.vi IS 'vv indic           (-9)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_2000_present.vv IS 'Visbility           (-9)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_2000_present.ww IS 'Present weather           (-9)';\n");
#print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_2000_present.w1 IS 'Past weather           (-9)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_2000_present.slp IS 'Sea level pressure  0.1hPa   (-9999.9)';\n");
#print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_2000_present.ppp IS 'Atmospheric pressure tendency   (-99.9)';\n");
##print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_2000_present.it IS 'Temperature indicator   (-9)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_2000_present.at IS 'Air temperature 0.1C   (-999.9)';\n");
##print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_2000_present.wbti IS 'Indicator for wbt 0.1C   (-999.9)';\n");
##print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_2000_present.wbt IS ' Wet bulb temp. 0.1C     (-999.9)';\n");
##print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_2000_present.dpti IS 'Dpt indicator              (-9)';\n");
##print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_2000_present.dpt IS 'Dew point temperature  0.1C  (-999.9)';\n");
##print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_2000_present.si IS 'SST measurement method         (-99)';\n");
#print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_2000_present.sst IS 'Sea surface temperature  0.1C  (-999.9)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_2000_present.n IS 'Total cloud amt                  (-9)';\n");
##print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_2000_present.cl IS 'Low cloud type                   (-999.9)';\n");
##print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_2000_present.hi IS 'H indic.                             (-9)';\n");
##print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_2000_present.h IS 'Cloud height    (-9)';\n");
##print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_2000_present.cm IS 'Mid-cloud height    (-9)';\n");
##print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_2000_present.ch IS 'High-cloud height    (-9)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_2000_present.wd IS 'Wave direction       (-99)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_2000_present.wp IS 'Wave period       (-99)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_2000_present.wh IS 'Wave height       (-99)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_2000_present.sd IS 'Swell direction    (-99)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_2000_present.sp IS 'Swell period       (-99)';\n");
print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_2000_present.sh IS 'Swell height       (-99)';\n");
#print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_2000_present.statsq IS 'ICES Statistical Rectangle';\n");
#print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_2000_present.dck IS 'Deck              (-999)';\n");
#print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_2000_present.sid IS 'Source ID          (-999)';\n");
#print PSQL ("COMMENT ON COLUMN global.clim_icoads_world_2000_present.pt  IS 'Platform type          (-999)';\n");
#
# FILL THE TABLE
# Global East
open(DATAFILE, "ls /srv/public/input_data_files/ICOADS-Global/ICOADS-East/tmp2000-present/*dat |");
while(<DATAFILE>){
s/^\s*(.*)\s*$/$1/;
chomp;
open(FILE,"<$_") or die "Cannot open file $_: $!\n";
print PSQL ("\\COPY global.clim_icoads_world_2000_present FROM \'$_\' with delimiter \'|\' null as \'NA\'\n");
print "IMPORTING: $_\n";}

close(DATAFILE);

# Global West
open(DATAFILE, "ls /srv/public/input_data_files/ICOADS-Global/ICOADS-West/tmp2000-present/*dat |");
while(<DATAFILE>){
s/^\s*(.*)\s*$/$1/;
chomp;
open(FILE,"<$_") or die "Cannot open file $_: $!\n";
print PSQL ("\\COPY global.clim_icoads_world_2000_present FROM \'$_\' with delimiter \'|\' null as \'NA\'\n");
print "IMPORTING: $_\n";}

close(DATAFILE);


## Drop some columns to save space and speed queries ##

#print PSQL ("
#ALTER TABLE global.clim_icoads_world_2000_present DROP COLUMN im CASCADE;
#ALTER TABLE global.clim_icoads_world_2000_present DROP COLUMN ii CASCADE;


# Drop data before 1900 to save space and speed queries 

#print PSQL ("
#DELETE FROM global.clim_icoads_world_2000_present
#  WHERE yr < 1900;
#\n");

print PSQL ("UPDATE global.clim_icoads_world_2000_present SET lon = (lon-360) WHERE lon > 180;\n");


#
## Create indices ###

print PSQL ("
CREATE INDEX icoads_world_2000_present_mo ON global.clim_icoads_world_2000_present (mo);
CREATE INDEX icoads_world_2000_present_yr ON global.clim_icoads_world_2000_present (yr);
CREATE INDEX icoads_world_2000_present_lat ON global.clim_icoads_world_2000_present (lat);
CREATE INDEX icoads_world_2000_present_lon ON global.clim_icoads_world_2000_present (lon);
\n");

### Add on geometry point ###

print PSQL ("ALTER TABLE global.clim_icoads_world_2000_present ADD COLUMN the_point geometry(Point,4326);\n");
print PSQL ("UPDATE global.clim_icoads_world_2000_present SET the_point = ST_SETSRID(ST_MAKEPOINT(lon,lat),4326);\n"); 

print PSQL ("CREATE INDEX icoads_world_2000_present_the_point ON global.clim_icoads_world_2000_present USING GIST (the_point);\n");



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














