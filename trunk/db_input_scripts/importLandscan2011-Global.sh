TMPDIR="/srv/public/input_data_files/Landscan2011_Global/ArcGIS/Population/lspop2011"
DIR="/srv/public/input_data_files/Landscan2011_Global/ArcGIS/Population/lspop2011"
SCHEMA="global"
DB="aas_base"
USER_NAME="postgres"
cd $DIR

## Import raster file:

raster2pgsql -s 4326 -I -C -M w001001x.adf -F -t 200x200 ${SCHEMA}.socioecon_population_landscan > socioecon_population_landscan.sql

## Upload the sql file to database:

psql -d aas_base -f socioecon_population_landscan.sql -U postgres



