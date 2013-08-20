### Prepare data in R first Ring###

#getwd()
#setwd("/srv/public/input_data_files/BangladeshFishRings")
#library(gdata)
#LatsLongs <- read.xls("RingsLocations.xlsx",sheet=1)
#LatsLongs <- LatsLongs[,1:13]
#write.table(LatsLongs,file='BangladeshFishRingLocations.csv', sep="|",row.names=FALSE)


## Shell script to import data to Postgis ## 

TMPDIR="/srv/public/input_data_files/BangladeshFishRings"
DIR="/srv/public/input_data_files/BangladeshFishRings"
SCHEMA="bangladesh"
DB="aas_base"
USER_NAME="postgres"
cd $DIR

### Hello world ###

## DROP TABLE if it exists

# Bangladesh fish rings

psql -d ${DB} -U postgres -c "DROP TABLE ${SCHEMA}.geo_fish_rings;"

# Build the Table 

psql -d ${DB} -U postgres -c "CREATE TABLE  ${SCHEMA}.geo_fish_rings(
id int, 
farmername varchar, 
installation int,
maintenance varchar,
block varchar,
lat float, 
lon float,
numrings int,
topring varchar,
moisture varchar,
topography varchar,
animals varchar,
fishsource varchar
) WITH OIDS;"

# Fill the Table

psql -d ${DB} -U postgres -c "\COPY ${SCHEMA}.geo_fish_rings FROM '$DIR/BangladeshFishRingLocations.csv' WITH delimiter '|' CSV HEADER NULL AS 'NA';"

# Geometry type

psql -d ${DB} -U postgres -c  "
ALTER TABLE ${SCHEMA}.geo_fish_rings ADD COLUMN the_point geometry(Point,4326);
UPDATE  ${SCHEMA}.geo_fish_rings SET the_point = ST_SETSRID(ST_MAKEPOINT(lon,lat),4326);"


# Geography type (all distances computed will be in meters)

#psql -d ${DB} -U postgres -c  "ALTER TABLE ${SCHEMA}.geo_zambia_gps_camps ADD COLUMN the_geog geography(POINT,4326);"
#psql -d ${DB} -U postgres -c  "UPDATE  ${SCHEMA}.geo_zambia_gps_camps SET the_geog = ST_GeogFRomText('SRID=4326;POINT(' || lon || ' ' || lat || ')');  "


psql -U postgres -d ${DB} -c "COMMENT ON TABLE ${SCHEMA}.geo_fish_rings IS ' The locations of fish rings in Bangladesh collected as part of CCAFs project Smart Farm. Address further queries to Melody Braun, Sarah Castine or Doug Beare';
COMMENT ON COLUMN ${SCHEMA}.geo_fish_rings.farmername IS 'Name of the farmer';
COMMENT ON COLUMN ${SCHEMA}.geo_fish_rings.topography IS 'Qualitative appraisal of topography';"




#library(RgoogleMaps)
#require(ggmap)
#require(plyr)
#require(mapproj)

######MapSetUp####

#ringsmap <-get_map(location=c(lon=90.121, lat=22.583), zoom = 16, source = 'google', color='color', maptype='hybrid')
#ringslocations <- ggmap(ringsmap, extent= 'panel', base_layer=ggplot(LatsLongs, aes(x=Longitude, y=Latitude)))
##print(ringslocations)
#ringslocations <- ringslocations + geom_point(color = "red", size = 3)
#print(ringslocations)


####Once rings are categorised by habitat type change 'Block' to 'HabitatType' or whatever that column is called 
#ringslocations <- ringslocations + geom_point(aes(color = Block), size = 3, alpha = 0.8)

## then a little bit of cosmetic work...  change category colors, titles,
#ringslocations <- ringslocations + scale_colour_brewer(palette = "Set1")

#ringslocations <- ringslocations + labs(title = "Fish Rings Habitats, Sth Bangladesh", x = "Longitude", 
#                y = "Latitude")

#ringslocations <- ringslocations + theme(plot.title = element_text(hjust = 0, vjust = 1, face = c("bold")), 
#                 legend.position = "right")


#print(ringslocations)


### Random number generator to choose survey households ##

#x <- 1:212
## a random permutation
#sample(x)
## choose the first 20


######Other options####
##Source = 'stamen. This is good when you have lots of roads etc
#ringsmap <-get_map(location=box, zoom = 15, source = 'stamen', maptype = 'toner', color='color')
#####SettingMapBoundaries####
#### Can't use this for source = 'google' but can use for sourcc = 'stamen'
#lon <- LatsLongs$Longitude
#lat <- LatsLongs$Latitude
#box <- make_bbox(lon, lat, f = 0.1)
#box


##Using PlotOnStaticMap
#SiteMap <- GetMap(c(22.6395, 89.6255), zoom=11, maptype='hydrid')
#PlotOnStaticMap(SiteMap)
