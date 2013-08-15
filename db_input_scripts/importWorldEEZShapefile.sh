TMPDIR="/srv/public/input_data_files/World-EEZ"
DIR="/srv/public/input_data_files/World-EEZ"
SCHEMA="global"
DB="aas_base"
USER_NAME="postgres"
cd $DIR

### World maritime boundaries ###

## DROP TABLE if it exists

psql -d aas_base -U postgres -c "DROP TABLE ${SCHEMA}.geo_worldeez;"

## Geography type

#shp2pgsql -G -s 4326 the_geog_4326 -I -c -W "latin1" World_EEZ_v5_20091001 ${SCHEMA}.geo_worldeez  > geo_worldeez.sql 

## Load the sql file into the database

#psql -d aas_base -f geo_worldeez.sql -U postgres

## Geometry type ##

shp2pgsql -s 4326 -g the_geom_4326 -I -c -W "latin1" World_EEZ_v5_20091001 ${SCHEMA}.geo_worldeez  > geo_worldeez.sql 

## Load the sql file into the database

psql -d aas_base -f geo_worldeez.sql -U postgres

psql -d aas_base -U postgres -c "ALTER TABLE ${SCHEMA}.geo_worldeez ADD COLUMN the_geog geography(Multipolygon,4326);"

psql -d aas_base -U postgres -c "UPDATE  ${SCHEMA}.geo_worldeez SET the_geog = Geography(ST_Transform(the_geom_4326,4326));"



## Create indices

psql -d aas_base -U postgres -c "CREATE INDEX idx_eez_the_geom_4326 ON ${SCHEMA}.geo_worldeez USING gist(the_geom_4326);"

## Add Comment to table

psql -U postgres -d ${DB} -c "COMMENT ON TABLE ${SCHEMA}.geo_worldeez IS 'Multipolygon file of the World (Marine) Exclusive Economic Zones';"





