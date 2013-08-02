TMPDIR="/srv/public/input_data_files/"
DIR="/srv/public/input_data_files/NetherlandsLandingsVMSdata"
SCHEMA="netherlands"
DB="aas_base"
USER_NAME="postgres"
cd $DIR

## Script written by Doug Beare to import sql files for tacsat (VMS) and landings (eflalo format) for the Netherlands 1990-2011. Data originally obtained from IMARES by Doug Beare.

## Import the data 
psql -d ${DB} -U postgres -c "DROP TABLE IF EXISTS eflalo;"
psql -d ${DB} -U postgres -c "DROP TABLE IF EXISTS tacsat;"

psql -d ${DB} -f eflalo.sql -U postgres
psql -d ${DB} -f tacsat.sql -U postgres

## Change schema

psql -U postgres -c "ALTER TABLE eflalo SET SCHEMA netherlands; ALTER TABLE tacsat SET SCHEMA netherlands;"

### Add on geometry point ###

print PSQL (" ALTER TABLE netherlands.tacsat ADD COLUMN the_point geometry(Point,4326);   \n");
print PSQL (" UPDATE netherlands.tacsat SET the_point = ST_SETSRID(ST_MAKEPOINT(si_loni,si_lati),4326); \n"); 


