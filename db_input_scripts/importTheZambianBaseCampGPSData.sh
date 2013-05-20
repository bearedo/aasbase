TMPDIR="/srv/public/input_data_files/Zambia_GPS_Camps"
DIR="/srv/public/input_data_files/Zambia_GPS_Camps"
SCHEMA="zambia"
DB="aas_base"
USER_NAME="postgres"
cd $DIR

### Hello world ###

## DROP TABLE if it exists

# Zambian Fishing Camps

psql -d ${DB} -U postgres -c "DROP TABLE ${SCHEMA}.geo_zambia_gps_camps;"

# Build the Table 

psql -d ${DB} -U postgres -c "CREATE TABLE  ${SCHEMA}.geo_zambia_gps_camps(
id int, 
name varchar, 
lat float, 
lon float,
stratum int,
population int,
year int,
status varchar
) WITH OIDS;"

# Fill the Table

psql -d ${DB} -U postgres -c "\COPY ${SCHEMA}.geo_zambia_gps_camps FROM '$DIR/Zambia_GPS_camps_Froukje_Mk2.csv' WITH delimiter ',' CSV HEADER NULL AS 'NA';"

# Geometry type

psql -d ${DB} -U postgres -c  "ALTER TABLE ${SCHEMA}.geo_zambia_gps_camps ADD COLUMN the_point geometry(Point,4326);"
psql -d ${DB} -U postgres -c  "UPDATE  ${SCHEMA}.geo_zambia_gps_camps SET the_point = ST_SETSRID(ST_MAKEPOINT(lon,lat),4326);"


# Geography type (all distances computed will be in meters)

#psql -d ${DB} -U postgres -c  "ALTER TABLE ${SCHEMA}.geo_zambia_gps_camps ADD COLUMN the_geog geography(POINT,4326);"
#psql -d ${DB} -U postgres -c  "UPDATE  ${SCHEMA}.geo_zambia_gps_camps SET the_geog = ST_GeogFRomText('SRID=4326;POINT(' || lon || ' ' || lat || ')');  "


psql -U postgres -d ${DB} -c "COMMENT ON TABLE ${SCHEMA}.geo_zambia_gps_camps IS ' The gps data is for fishing camps in the Barotse floodplain, based on a recent Frame Survey implemented by the Zambian Department of Fisheries. Address further queries to Froukje Kruijssen';
COMMENT ON COLUMN ${SCHEMA}.geo_zambia_gps_camps.name IS 'Name of the camp';
COMMENT ON COLUMN ${SCHEMA}.geo_zambia_gps_camps.year IS 'Year camp was established';"


















