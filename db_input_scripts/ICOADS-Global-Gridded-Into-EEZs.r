
### R-script to organise global clim_icoads_world database into marine EEZs ###

library(RODBC)
library(rgdal)
library(maptools)
library(doBy)

conn <- odbcConnect('aas_base',case='postgresql')
sqlQuery(conn,'SET SEARCH_PATH to global')

#worldeez <-readOGR(getwd(),"World_EEZ_v5_20091001.shp")

### Get the EEZ polygons from the DB ### 

worldeez <- readOGR(dsn="PG:host=172.16.0.6 user=postgres dbname=aas_base password=gis2013 port=5432", layer = "global.geo_worldeez", verbose = TRUE)

geogWGS84 <- CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs") # Make sure proj is what we think it is.
#setwd("c:/bearedo/generalfishregdata/databases/ArcViewShapeFiles/World_EEZ_v5_20091001/")
#worldeez <-readShapePoly("World_EEZ_v5_20091001.shp",proj4string=geogWGS84 )

polys <- sort(unique(worldeez@data$country))

## Select only countries in the tropics ##

#tropical.polys <- rep(NA,length(polys))

#for( i in 1:length(polys)) {
#  zone <- as.character(polys[i])
#  tpoly <-worldeez[worldeez$country==zone,]
#  print(zone)
#  rr <- bbox(tpoly)[2,]
#  if(rr[1] > -30 & rr[2] < 30)  
#  {
#  tropical.polys[i] <-zone
#}
#}

#tropical.polys <- tropical.polys[!is.na(tropical.polys)]

#tropical.polys

### Now take out those for the AAS countries and those of interest in other projects

#aas.polys <- tropical.polys[tropical.polys %in% c('Philippines','Australia - East Timor','Kiribati','Maldives','Vanuatu','Sri Lanka', 'Myanmar','India','China','Bangladesh','Cambodia','Indonesia','Malaysia','Zambia','Solomon Islands','Tanzania','Thailand','Vietnam','Ghana','East Timor','Papua New Guinea')]

#aas.polys <- tropical.polys[tropical.polys %in% c('Philippines','Australia - East Timor','Bangladesh','Cambodia','Indonesia','Solomon Islands','Tanzania','Thailand','Vietnam','East Timor')]


## Loop round months and years ###


start.year <- 1900
end.year   <- 2012
grid <- expand.grid(yr = start.year:end.year, mo = 1:12)

##Don't have data for last 3 months of 2012

fo<- (1:length(grid[,1]))[grid$yr == 2012 & grid$mo >=9]
grid <- grid[-fo,]

#fo<- (1:length(grid[,1]))[grid$yr <=1933 & grid$mo >6]
#grid <- grid[-fo,]

grid <- orderBy(~yr+mo,data=grid)

grid$seq <- 1:length(grid[,1])
grid[grid$yr==2009 & grid$mo == 10,]


sqlQuery(conn,"SET SEARCH_PATH TO global")
#sqlQuery(conn,"DROP TABLE global.clim_icoads_world_gridded_eez;")
#sqlQuery(conn,"DELETE FROM clim_icoads_world_eez WHERE extract(year from timestamp) = 2009;")




##################################################
##################################################
############Start loop ###########################
##################################################
##################################################

for (i in 1331:length(grid[,1])) 

{


print(grid[i,])


## All of the data
query <- paste("SELECT * from global.clim_icoads_gridded WHERE year = ",grid$yr[i],"AND month =", grid$mo[i],";") 
dat <- sqlQuery(conn,query) #Extract data from dB

## Only go if there are data

#if(nrow(dat) > 0) {

## Put on proper datestring ##

dates <- paste(dat$d,dat$month,dat$year,sep="-")
times <- paste("00","00","00",sep=":")
timestamp <- paste(dates,times)

dat$timestamp <- as.POSIXct(strptime(timestamp,"%d-%m-%Y %H:%M:%S"),tz='GMT')

# Remove the 3 time columns which are now redundant

dat <- dat[,-c(1,2,13)]

## Now create a spatial points dataframe from dat ##

coords <- SpatialPoints(dat[, c("lon", "lat")])
dat.spdf <- SpatialPointsDataFrame(coords,dat,proj4string=geogWGS84) 

out <- NULL

  
for (j in 1:length(polys))  # Start to loop over polygons
  
  {
  
gc(reset=T)  

  zone <- as.character(polys[j])
  print(zone)
  eez  <- worldeez[worldeez$country == zone,]

  ## Do the overlay ##
  
  if(dim(dat.spdf@data)[1] < 200000) #if data has less than 200K rows
    {
  o <- overlay(dat.spdf,eez)
  }
  
  if(dim(dat.spdf@data)[1] >= 200000)# if data has > than 200K rows
  print(">200K rows")
  
{
    
    uu <- round(seq(1,dim(dat.spdf@data)[1],length=20))
    
    dat.spdf1 <- dat.spdf[1:uu[2],]
    dat.spdf2 <- dat.spdf[(uu[2]+1):uu[3],]
    dat.spdf3 <- dat.spdf[(uu[3]+1):uu[4],]
    dat.spdf4 <- dat.spdf[(uu[4]+1):uu[5],]
    dat.spdf5 <- dat.spdf[(uu[5]+1):uu[6],]
    dat.spdf6 <- dat.spdf[(uu[6]+1):uu[7],]
    dat.spdf7 <- dat.spdf[(uu[7]+1):uu[8],]
    dat.spdf8 <- dat.spdf[(uu[8]+1):uu[9],]
    dat.spdf9 <- dat.spdf[(uu[9]+1):uu[10],]
    dat.spdf10 <- dat.spdf[(uu[10]+1):uu[11],]
    dat.spdf11 <- dat.spdf[(uu[11]+1):uu[12],]
    dat.spdf12 <- dat.spdf[(uu[12]+1):uu[13],]
    dat.spdf13 <- dat.spdf[(uu[13]+1):uu[14],]
    dat.spdf14 <- dat.spdf[(uu[14]+1):uu[15],]
    dat.spdf15 <- dat.spdf[(uu[15]+1):uu[16],]
    dat.spdf16 <- dat.spdf[(uu[16]+1):uu[17],]
    dat.spdf17 <- dat.spdf[(uu[17]+1):uu[18],]
    dat.spdf18 <- dat.spdf[(uu[18]+1):uu[19],]
    dat.spdf19 <- dat.spdf[(uu[19]+1):dim(dat.spdf)[1],]
    
    o1 <- overlay(dat.spdf1,eez)
    o2 <- overlay(dat.spdf2,eez)
    o3 <- overlay(dat.spdf3,eez)
    o4 <- overlay(dat.spdf4,eez)
    o5 <- overlay(dat.spdf5,eez)
    o6 <- overlay(dat.spdf6,eez)
    o7 <- overlay(dat.spdf7,eez)
    o8 <- overlay(dat.spdf8,eez)
    o9 <- overlay(dat.spdf9,eez)
    o10 <- overlay(dat.spdf10,eez)
    o11 <- overlay(dat.spdf11,eez)
    o12 <- overlay(dat.spdf12,eez)
    o13 <- overlay(dat.spdf13,eez)
    o14 <- overlay(dat.spdf14,eez)
    o15 <- overlay(dat.spdf15,eez)
    o16 <- overlay(dat.spdf16,eez)
    o17 <- overlay(dat.spdf17,eez)
    o18 <- overlay(dat.spdf18,eez)
    o19 <- overlay(dat.spdf19,eez)

    gc(reset=T)

    o <- c(o1,o2,o3,o4,o5,o6,o7,o8,o9,o10,o11,o12,o13,o14,o15,o16,o17,o18,o19)
  }
   
    if(sum(is.na(o)) < length(o)) 
{
      dat.spdfo <- dat.spdf[!is.na(o),]
      ## Add on the Country string ## 
      dat.spdfo@data$country <- zone
      dat.dfo  <- data.frame(dat.spdfo@data)
      out <- rbind(out,dat.dfo)

      }
   
  }
  
  # End of j loop

print(i)
  if (i == 1 & !is.null(out))
   {
   #sqlQuery(conn,"DROP TABLE global.clim_icoads_world_gridded_eez;")
  sqlQuery(conn,"set search_path to global;")
   sqlSave(conn,out,tablename='clim_icoads_world_gridded_eez',append=F,rownames=FALSE,addPK=TRUE,fast=TRUE,varTypes=c(timestamp="timestamp"),nastring='NA')
   print('Created database')
   
   }    
  

  if(i > 1 & !is.null(out))
  {
    sqlQuery(conn,"set search_path to global;")
  sqlSave(conn,out,tablename='clim_icoads_world_gridded_eez',append=T,rownames=FALSE,addPK=TRUE,varTypes=c(timestamp="timestamp"),fast=TRUE,nastring='NA')
  print('Appended database')
  
  }
  
}
 
  
 
  
#sqlQuery(conn,"CREATE INDEX precipitation_country ON physical.precipitation_country (country);\n");

  #sqlQuery(conn,"DELETE FRoM physical.icoads_world_eez WHERE yr = 2011 AND mo = 1 AND country = 'Philippines'")
