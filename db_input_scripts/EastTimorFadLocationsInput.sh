DIR="/srv/public/input_data_files/EastTimorFadLocationsFromDaveMills"
SCHEMA="timorleste"
DB="aas_base"
USER_NAME="postgres"
cd $DIR

## Script written by Doug Beare to import shapefiles to a postgis server.

# Atauro #

psql -d ${DB} -U postgres -c "DROP TABLE ${SCHEMA}.atauro_stns;"

shp2pgsql -s 4326 -g the_geom_4326 -I -c -W "latin1" Final_Atauro_STN ${SCHEMA}.atauro_stns > atauro_stns.sql 

psql -d ${DB} -f atauro_stns.sql -U postgres

psql -U postgres -d ${DB} -c "COMMENT ON TABLE ${SCHEMA}.atauro_stns IS 'Point data for Atauro Stations';"

# Batugade #

psql -d ${DB} -U postgres -c "DROP TABLE ${SCHEMA}.batugade_stns;"

shp2pgsql -s 4326 -g the_geom_4326 -I -c -W "latin1" Final_Batugade_STN_Expansion ${SCHEMA}.batugade_stns > batugade_stns.sql 

psql -d ${DB} -f batugade_stns.sql -U postgres

psql -U postgres -d ${DB} -c "COMMENT ON TABLE ${SCHEMA}.batugade_stns IS 'Point data for Batugade Stations';"

# Convert to KML #

ogr2ogr -f KML /home/dbeare/Atauro_STNS.kml PG:"host=172.16.0.6 dbname=aas_base user=postgres password=gis2013" timorleste.atauro_stns
ogr2ogr -f KML /home/dbeare/Batugade_STNS.kml PG:"host=172.16.0.6 dbname=aas_base user=postgres password=gis2013" timorleste.batugade_stns








