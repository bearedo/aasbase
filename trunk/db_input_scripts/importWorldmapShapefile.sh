TMPDIR="/srv/public/input_data_files/WorldMap"
DIR="/srv/public/input_data_files/WorldMap"
SCHEMA="global"
DB="aas_base"
USER_NAME="postgres"
cd $DIR

### World maritime boundaries ###

## DROP TABLE if it exists

psql -d aas_base -U postgres -c "DROP TABLE ${SCHEMA}.geo_worldmap;"

## prepare the tables don't load data

shp2pgsql -s 4326 -g the_geom_4326 -I -c -W "latin1" g2008_0 ${SCHEMA}.geo_worldmap  > geo_worldmap.sql 

## Load the sql file into the database

psql -d aas_base -f geo_worldmap.sql -U postgres

