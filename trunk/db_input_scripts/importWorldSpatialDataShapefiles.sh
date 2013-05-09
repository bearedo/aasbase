TMPDIR="/srv/public/input_data_files/WorldSpatial"
DIR="/srv/public/input_data_files/WorldSpatialData"
SCHEMA="global"
DB="aas_base"
USER_NAME="postgres"
cd $DIR

## DROP TABLE if it exists

# WorldOceans

#psql -d ${DB} -U postgres -c "DROP TABLE ${SCHEMA}.geo_worldocean;"

shp2pgsql -s 4326 -g the_geom_4326 -I -c -W "latin1" OceanSeas ${SCHEMA}.geo_worldocean_seas > geo_worldocean_seas.sql 

psql -d ${DB} -f geo_worldocean_seas.sql -U postgres

psql -U postgres -d ${DB} -c "COMMENT ON TABLE ${SCHEMA}.geo_worldocean_seas IS 'Polygons for all the main world ocean basins and seas';"


## Bathymetry contours

shp2pgsql -s 4326 -g the_geom_4326 -I -c -W latin1  DepthContours ${SCHEMA}.geo_world_depth_contours > geo_world_depth_contours.sql 

psql -d ${DB} -f geo_world_depth_contours.sql -U postgres

psql -U postgres -d ${DB} -c "COMMENT ON TABLE ${SCHEMA}.geo_world_depth_contours IS 'Lines for ocean depth contours at 200m 600m 1000m 2000m 4000m';"

## Rivers

shp2pgsql -s 4326 -g the_geom_4326 -I -c -W latin1 Rivers ${SCHEMA}.geo_world_rivers > geo_world_rivers.sql 

psql -d ${DB} -f geo_world_rivers.sql -U postgres

psql -U postgres -d ${DB} -c "COMMENT ON TABLE ${SCHEMA}.geo_world_rivers IS 'River Basins of the world';"

## Lakes

shp2pgsql -s 4326 -g the_geiom_4326 -I -c -W latin1 Lakes ${SCHEMA}.geo_world_lakes > geo_world_lakes.sql 

psql -d ${DB} -f geo_world_lakes.sql -U postgres

psql -U postgres -d ${DB} -c "COMMENT ON TABLE ${SCHEMA}.geo_world_lakes IS 'Lakes of the world';"


## Crops

shp2pgsql -s 4326 -g the_geom_4326 -I -c -W latin1 Crops ${SCHEMA}.agri_world_crops > agri_world_crops.sql 

psql -d  ${DB} -f agri_world_crops.sql -U postgres

psql -U postgres -d ${DB} -c "COMMENT ON TABLE ${SCHEMA}.geo_world_lakes IS 'Polygons of the distributions of crops around the world';"



## Swamps

shp2pgsql -s 4326 -g the_geom_4326 -I -c -W latin1 Swamps ${SCHEMA}.geo_world_swamps > geo_world_swamps.sql 

psql -d ${DB} -f geo_world_swamps.sql -U postgres

psql -U postgres -d ${DB} -c "COMMENT ON TABLE ${SCHEMA}.geo_world_swamps IS 'Polygons of the distributions of swamps around the world';"

## Tundra

shp2pgsql -s 4326 -g the_geom_4326 -I -c -W latin1 Tundra ${SCHEMA}.geo_world_tundra > geo_world_tundra.sql 

psql -d ${DB} -f gee_world_tundra.sql -U postgres

psql -U postgres -d ${DB} -c "COMMENT ON TABLE ${SCHEMA}.geo_world_tundra IS 'Polygons of the distributions of tundra';"


## Trees

shp2pgsql -s 4326 -g the_geom_4326  -I -c -W latin1 Trees ${SCHEMA}.bio_world_trees > bio_world_trees.sql 

psql -d ${DB} -f bio_world_trees.sql -U postgres

## Grass

shp2pgsql -s 4326 -g the_geom_4326 -I -c -W latin1 Grass ${SCHEMA}.bio_world_grass > bio_world_grass.sql 

psql -d ${DB} -f bio_world_grass.sql -U postgres

## Canals ##

shp2pgsql -s 4326 -g the_geom_4326 -I -c -W latin1 Canals ${SCHEMA}.geo_world_canals > geo_world_canals.sql 

psql -d ${DB} -f geo_world_canals.sql -U postgres

## Sea Ice ##

shp2pgsql -s 4326 -g the_geom_4326 -I -c -W latin1 SeaIce ${SCHEMA}.geo_world_sea_ice > geo_world_sea_ice.sql 

psql -d ${DB} -f geo_world_sea_ice.sql -U postgres

## Land Ice ##

shp2pgsql -s 4326 -g the_geom_4326 -I -c -W latin1 LandIce ${SCHEMA}.geo_world_land_ice > geo_world_land_ice.sql 

psql -d ${DB} -f geo_world_land_ice.sql -U postgres

## City Areas ##

shp2pgsql -s 4326 -g the_geom_4326 -I -c -W latin1 CityAreas ${SCHEMA}.socioecon_world_city_areas > socioecon_world_city_areas.sql 

psql -d ${DB} -f socioecon_world_city_areas.sql -U postgres

## City Points ##

shp2pgsql -s 4326 -g the_geom_4326 -I -c -W latin1 CityAreas ${SCHEMA}.socioecon_world_city_points > socioecon_world_city_points.sql 

psql -d ${DB} -f socioecon_world_city_points.sql -U postgres

## Native Settlements ##

shp2pgsql -s 4326 -g the_geom_4326 -I -c -W latin1 NativeSettlements ${SCHEMA}.socioecon_native_settlements > socioecon_native_settlements.sql 

psql -d ${DB} -f socioecon_native_settlements.sql -U postgres

## Extraction Points ##

shp2pgsql -s 4326 -g the_geom_4326 -I -c -W latin1 ExtractionPoints ${SCHEMA}.socioecon_extraction_points > socioecon_extraction_points.sql 

psql -d ${DB} -f socioecon_extraction_points.sql -U postgres

## Extraction Areas ##

shp2pgsql -s 4326 -g the_geom_4326 -I -c -W latin1 ExtractionAreas ${SCHEMA}.socioecon_extraction_areas > socioecon_extraction_areas.sql 

psql -d ${DB} -f socioecon_extraction_areas.sql -U postgres


