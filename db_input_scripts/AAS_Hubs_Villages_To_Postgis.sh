
psql -h 50.18.115.108 -d aas -U postgres -c "CREATE SCHEMA global";

## Load shapefiles into grouper ## 

DIR="/srv/public/input_data_files/AAS-Hubs"
SCHEMA="global"
DB="aas_base"
USER_NAME="postgres"
cd $DIR

for f in *.shp
do
psql -d ${DB} -U postgres -c "DROP TABLE ${SCHEMA}.${f%.*};"
shp2pgsql -s 4326 -g the_geom_4326 -I -c -W "latin1" $f ${SCHEMA}.${f%.*} | psql -h 172.16.0.6 -d ${DB} -U postgres
done


## Load shapefiles into cloud server ## 

DIR="/srv/public/input_data_files/AAS-Hubs"
SCHEMA="global"
DB="aas"
USER_NAME="postgres"
cd $DIR

for f in *.shp
do
psql -d ${DB} -U postgres -c "DROP TABLE ${SCHEMA}.${f%.*};"
shp2pgsql -s 4326 -g the_geom_4326 -I -c -W "latin1" $f ${SCHEMA}.${f%.*} | psql -h 50.18.115.108 -d ${DB} -U postgres
done




### KML


# Go into relevant directory and unzip kmz file to kml (note that kmz are simply compressed kml)

# for i in /srv/public/input_data_files/AAS-Hubs/*kmz; do name=`basename $i .kmz`; mkdir $name; cd $name; unzip $i; cd ..; done 

# Now I can use ogrinfo to examine each doc.kml file.

# for i in *; do ogrinfo -ro $i/doc.kml; done 

# Now load each dataset thus :

# First into database on grouper

# cd AASHubs_v20140205
# ogr2ogr -f PostgreSQL PG:"host=172.16.0.6 dbname=aas_base user=postgres password=gis2013" doc.kml

# Load into database on cloud:
# cd AASHubs_v20140205
# ogr2ogr -f PostgreSQL PG:"host=50.18.115.108 dbname=aas user=postgres password=gis2013" doc.kml

# cd AASVillages_v20140205
# ogr2ogr -f PostgreSQL PG:"host=172.16.0.6 dbname=aas_base user=postgres password=gis2013" doc.kml

