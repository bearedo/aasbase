
DIR="/srv/public/Marine_Impacts/model"
SCHEMA="global"
DB="aas_base"
USER_NAME="postgres"
cd $DIR

## Import raster file hdr.adf ## 

raster2pgsql -s 4326 -d -I -C -M hdr.adf -F -t 200x200 ${SCHEMA}.socioecon_marine_impact > socioecon_marine_impact.sql

## Upload the sql file to database: ## 

psql -d aas_base -f socioecon_marine_impact.sql -U postgres

## Get information about the raster file

SET SEARCH_PATH to public;
SELECT count(*) AS num_rasters, ST_Height(rast) AS height,
ST_Width(rast) AS width, ST_SRID(rast) AS srid,
ST_NumBands(rast) AS num_bands,
ST_BandPixelType(rast,1) as btype
FROM global.socioecon_marine_impact
GROUP BY ST_Height(rast),
ST_Width(rast), ST_SRID(rast),
ST_NumBands(rast),
ST_BandPixelType(rast,1);



#####################################################################

## Try R instead ###

#library(rgdal)

#setwd("/srv/public/input_data_files/Landscan2011_Global/ArcGIS/Population/lspop2011")
#list.files()
#z <- readGDAL("hdr.adf")
#fullgrid("z") <- FALSE
#as(z,"SpatialPixelsDataFrame")

#setwd("/srv/public/input_data_files/Landscan2011_Global/RasterGISbinary")
#list.files()
#z <- readGDAL("lspop2011.flt")
#fullgrid("z") <- FALSE
#as(z,"SpatialPixelsDataFrame")






