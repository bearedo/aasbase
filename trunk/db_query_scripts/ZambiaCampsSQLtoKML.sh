
## Connect to PostGis DB and create a KML file for Froukje's Barotse floodplain, fishing camp maps ##

ogr2ogr -f KML /home/dbeare/Barotse.kml PG:"host=172.16.0.6 dbname=aas_base user=postgres password=gis2013" zambia.geo_zambia_gps_camps

## ogr2ogr -f KML /home/dbeare/worldeez.kml PG:"host=172.16.0.6 dbname=aas_base user=postgres password=gis2013" global.geo_worldeez

#ogr2ogr -f KML /home/dbeare/dutchboats2011.kml PG:"host=172.16.0.6 dbname=aas_base user=postgres password=gis2013" -sql "SELECT * from netherlands.tacsat where year = 2011 ;"






i 
