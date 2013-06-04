
DIR="/srv/public/input_data_files/Cambodia-CLEAR"
SCHEMA="cambodia"
DB="aas_base"
USER_NAME="postgres"
cd $DIR

## Base Data ##

cd CLEAR\ Base\ Data/
cd Data

for f in *.shp
do
psql -d ${DB} -U postgres -c "DROP TABLE ${SCHEMA}.${f%.*};"
shp2pgsql -s 4326 -g the_geom_4326 -I -c -W "latin1" $f ${SCHEMA}.${f%.*} | psql -h 172.16.0.6 -d ${DB} -U postgres
done


## Land & Environment ##

cd ../../CLEAR\ Land\ and\ Environment/
cd Data

for f in *.shp
do
#psql -d ${DB} -U postgres -c "DROP TABLE ${SCHEMA}.${f%.*};"
shp2pgsql -s 4326 -g the_geom_4326 -I -c -W "latin1" $f ${SCHEMA}.${f%.*} | psql -h 172.16.0.6 -d ${DB} -U postgres
done

## Agriculture and Extensions ##

cd ../../CLEAR\ Agricultural\ Development\ and\ Extension/
cd Data

for f in *.shp
do
#psql -d ${DB} -U postgres -c "DROP TABLE ${SCHEMA}.${f%.*};"
shp2pgsql -s 4326 -g the_geom_4326 -I -c -W "latin1" $f ${SCHEMA}.${f%.*} | psql -h 172.16.0.6 -d ${DB} -U postgres
done


