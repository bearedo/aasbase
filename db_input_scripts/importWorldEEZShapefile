TMPDIR="/srv/public/input_data_files/World-EEZ"
DIR="/srv/public/input_data_files/World-EEZ"
SCHEMA="global"
DB="aas_base"
USER_NAME="postgres"
cd $DIR

### World maritime boundaries ###

## DROP TABLE if it exists

psql -d aas_base -U postgres -c "DROP TABLE ${SCHEMA}.geo_worldeez;"

## prepare the tables don't load data

shp2pgsql -s 4326 -g the_geom_4326 -I -c -W "latin1" World_EEZ_v5_20091001 ${SCHEMA}.geo_worldeez  > geo_worldeez.sql 

## Load the sql file into the database

psql -d aas_base -f geo_worldeez.sql -U postgres

