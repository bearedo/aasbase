TMPDIR="/srv/public/input_data_files/Zambia_GPS_Camps"
DIR="/srv/public/input_data_files/Zambia_GPS_Camps"
SCHEMA="zambia"
DB="aas_base"
USER_NAME="postgres"
cd $DIR

## DROP TABLE if it exists

# WorldOceans

psql -d ${DB} -U postgres -c "DROP TABLE ${SCHEMA}.geo_zambia_gps_camps;"

# Build the Table 

psql -d ${DB} -U postgres -c "CREATE TABLE  ${SCHEMA}.geo_zambia_gps_camps(
id int, 
name varchar, 
lat float4, 
lon float4) WITH OIDS;"


psql -d ${DB} -U postgres -c "\COPY ${SCHEMA}.geo_zambia_gps_camps FROM '$DIR/Zambia_GPS_camps_Froukje.csv' WITH delimiter '|' CSV HEADER ;"
psql -d ${DB} -U postgres -c  "ALTER TABLE ${SCHEMA}.geo_zambia_gps_camps ADD COLUMN the_point geometry(Point,4326);"
psql -d ${DB} -U postgres -c  "UPDATE  ${SCHEMA}.geo_zambia_gps_camps SET the_point = ST_SETSRID(ST_MAKEPOINT(lon,lat),4326);"





psql -U postgres -d ${DB} -c "COMMENT ON TABLE ${SCHEMA}.geo_zambia_gps_camps IS 'Point locations for camps in Zambia from Froukje ';"
