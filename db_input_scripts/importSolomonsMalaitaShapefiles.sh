TMPDIR="/srv/public/input_data_files/SolomonIslandMalaitaShapefiles"
DIR="/srv/public/input_data_files/SolomonIslandsMalaitaShapefiles"
SCHEMA="solomons"
DB="aas_base"
USER_NAME="postgres"
cd $DIR

## Script written by Doug Beare to import shapefiles to a postgis server. Data originally prepared by SJ Teoh for Simon Attwood during May 2013 as part of ADB project in the Pacific


## DROP TABLE if it exists

# Crop data #

psql -d ${DB} -U postgres -c "DROP TABLE ${SCHEMA}.agri_crops;"

shp2pgsql -s 4326 -g the_geom_4326 -I -c -W "latin1" M_CROPA ${SCHEMA}.agri_crops > agri_crops.sql 

psql -d ${DB} -f agri_crops.sql -U postgres

psql -U postgres -d ${DB} -c "COMMENT ON TABLE ${SCHEMA}.agri_crops IS 'Polygons for the main crop types from the Solomons Office';"

# Orchard data #

psql -d ${DB} -U postgres -c "DROP TABLE ${SCHEMA}.agri_orchard;"

shp2pgsql -s 4326 -g the_geom_4326 -I -c -W "latin1" M_ORCHARDA ${SCHEMA}.agri_orchard > agri_orchard.sql 

psql -d ${DB} -f agri_orchard.sql -U postgres

psql -U postgres -d ${DB} -c "COMMENT ON TABLE ${SCHEMA}.agri_orchard IS 'Polygons for the main orchard types from the Solomons Office';"

# Reefs data #

psql -d ${DB} -U postgres -c "DROP TABLE ${SCHEMA}.bio_reefs;"

shp2pgsql -s 4326 -g the_geom_4326 -I -c -W "latin1" M05_reefs ${SCHEMA}.bio_reefs > bio_reefs.sql 

psql -d ${DB} -f bio_reefs.sql -U postgres

psql -U postgres -d ${DB} -c "COMMENT ON TABLE ${SCHEMA}.bio_reefs IS 'Polygons for the main coral reefs from the Solomons Office';"

# Mangals data #

psql -d ${DB} -U postgres -c "DROP TABLE ${SCHEMA}.bio_mangroves;"

shp2pgsql -s 4326 -g the_geom_4326 -I -c -W "latin1" malaita_mangroves_wcmc ${SCHEMA}.bio_mangroves > bio_mangroves.sql 

psql -d ${DB} -f bio_mangroves.sql -U postgres

psql -U postgres -d ${DB} -c "COMMENT ON TABLE ${SCHEMA}.bio_mangroves IS 'Mangrove data for Malaita downloaded from World Atlas of Mangroves, http://data.unep-wcmc.org/datasets/22; NB. data have a spatial mis-alignment issue';"

# Forest data #

psql -d ${DB} -U postgres -c "DROP TABLE ${SCHEMA}.bio_forest;"

shp2pgsql -s 4326 -g the_geom_4326 -I -c -W "latin1" MALACURRENTLIC_diss ${SCHEMA}.bio_forest > bio_forest.sql 

psql -d ${DB} -f bio_forest.sql -U postgres

psql -U postgres -d ${DB} -c "COMMENT ON TABLE ${SCHEMA}.bio_forest IS 'Forest data for Malaita from Solomons Office';"


# Swamp data #

psql -d ${DB} -U postgres -c "DROP TABLE ${SCHEMA}.bio_swamp;"

shp2pgsql -s 4326 -g the_geom_4326 -I -c -W "latin1" M_SWAMPA ${SCHEMA}.bio_swamp > bio_swamp.sql 

psql -d ${DB} -f bio_swamp.sql -U postgres

psql -U postgres -d ${DB} -c "COMMENT ON TABLE ${SCHEMA}.bio_swamp IS 'Swamp data for Malaita from Solomons Office';"

# Lake and Big Rivers data #

psql -d ${DB} -U postgres -c "DROP TABLE ${SCHEMA}.geo_lakes;"

shp2pgsql -s 4326 -g the_geom_4326 -I -c -W "latin1" M04_lake_river ${SCHEMA}.geo_lakes > geo_lakes.sql 

psql -d ${DB} -f geo_lakes.sql -U postgres

psql -U postgres -d ${DB} -c "COMMENT ON TABLE ${SCHEMA}.geo_lakes IS 'Lakes and large rivers from Solomons Office';"


# Rivers data #

psql -d ${DB} -U postgres -c "DROP TABLE ${SCHEMA}.geo_rivers;"

shp2pgsql -s 4326 -g the_geom_4326 -I -c -W "latin1" M04_river_line ${SCHEMA}.geo_rivers > geo_rivers.sql 

psql -d ${DB} -f geo_rivers.sql -U postgres

psql -U postgres -d ${DB} -c "COMMENT ON TABLE ${SCHEMA}.geo_rivers IS 'Rivers (lines) for Malaita Island from Solomons Office';"


# Coastline data #

psql -d ${DB} -U postgres -c "DROP TABLE ${SCHEMA}.geo_coastline;"

shp2pgsql -s 4326 -g the_geom_4326 -I -c -W "latin1" M03_coastline ${SCHEMA}.geo_coastline > geo_coastline.sql 

psql -d ${DB} -f geo_coastline.sql -U postgres

psql -U postgres -d ${DB} -c "COMMENT ON TABLE ${SCHEMA}.geo_coastline IS 'Coastline for Malaita Island from Solomons Office';"


# Administrative boundaries for wards #

psql -d ${DB} -U postgres -c "DROP TABLE ${SCHEMA}.geo_ward_boundary;"

shp2pgsql -s 4326 -g the_geom_4326 -I -c -W "latin1" M13A_admin ${SCHEMA}.geo_ward_boundary > geo_ward.sql 

psql -d ${DB} -f geo_ward.sql -U postgres

psql -U postgres -d ${DB} -c "COMMENT ON TABLE ${SCHEMA}.geo_ward_boundary IS 'Ward boundaries for Malaita Island from Solomons Office';"


# Population projections for 2015 and 2013 per ward prepared by SJTeoh

psql -d ${DB} -U postgres -c "DROP TABLE ${SCHEMA}.socioecon_ward_population_projection;"

shp2pgsql -s 4326 -g the_geom_4326 -I -c -W "latin1" Ward_Population_Projection_clip ${SCHEMA}.socioecon_ward_population_projection > socioecon_ward_population_projection.sql 

psql -d ${DB} -f socioecon_ward_population_projection.sql -U postgres

psql -U postgres -d ${DB} -c "COMMENT ON TABLE ${SCHEMA}.socioecon_ward_population_projection IS 'Human population projections by ward in 2015 and 2030 from Landscan data for Malaita SIs';"












### RASTERS #######

# Topography # 

psql -d ${DB} -U postgres -c "DROP TABLE ${SCHEMA}.geo_topography;"


raster2pgsql -s 4326 -d -I -C -M SolsTopography.asc -F -t 500x500 ${SCHEMA}.geo_topography > topo.sql

## Upload the sql file to database: ## 

psql -d aas_base -f topo.sql -U postgres

psql -U postgres -d ${DB} -c "COMMENT ON TABLE ${SCHEMA}.geo_topography IS 'Topography (sea floor and land) for Solomons';"


## Get information about the raster file

psql -U postgres -d ${DB} -c "SET SEARCH_PATH to public;
SELECT count(*) AS num_rasters, ST_Height(rast) AS height,
ST_Width(rast) AS width, ST_SRID(rast) AS srid,
ST_NumBands(rast) AS num_bands,
ST_BandPixelType(rast,1) as btype
FROM solomons.geo_topography
GROUP BY ST_Height(rast),
ST_Width(rast), ST_SRID(rast),
ST_NumBands(rast),
ST_BandPixelType(rast,1);"


# Landcover # 

psql -d ${DB} -U postgres -c "DROP TABLE ${SCHEMA}.geo_landcover;"

raster2pgsql -s 4326 -d -I -C -M gcover/w001001.adf -F -t 200x200 ${SCHEMA}.geo_landcover > landcover.sql

## Upload the sql file to database: ## 

psql -d aas_base -f landcover.sql -U postgres

psql -U postgres -d ${DB} -c "COMMENT ON TABLE ${SCHEMA}.geo_landcover IS 'Landcover for Malaita from extracted from global raster map dowlnoaded from http://dup.esrin.esa.it/globcover/ ';"

# Landscan population data for 2011 # 

psql -d ${DB} -U postgres -c "DROP TABLE ${SCHEMA}.socioecon_population;"

raster2pgsql -s 4326 -d -I -C -M pop2011/w001001.adf -F -t 200x200 ${SCHEMA}.socioecon_population > pop.sql

## Upload the sql file to database: ## 

psql -d aas_base -f pop.sql -U postgres

psql -U postgres -d ${DB} -c "COMMENT ON TABLE ${SCHEMA}.socioecon_population IS 'Extracted for Malaita Island from LandScan global population http://www.ornl.gov/sci/landscan/landscan_documentation.shtml (purchase through AAS program) ';"




