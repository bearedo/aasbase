##########################################################################################################
### R-script to organise global precipitation database into a new database grouped by Country polygons ###
##########################################################################################################


install.packages("rgdal")
install.packages("maptools")
library(RODBC)
library(rgdal)
library(maptools)

conn <- odbcConnect('aas_base',case='postgresql')
sqlQuery(conn,'SET SEARCH_PATH to global')


## Get the Country polygons ## 

geogWGS84 <- CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs") # Make sure proj is what we think it is.

setwd('C:/Users/dbeare/Dropbox/Projects/ChallengesWorkshop/ClimateIn5Hubs') #Set WD but obvioulsy this may change.

#worldmap <-readShapePoly("g2008_0.shp",proj4string=geogWGS84)

## Try reading direct from the database ### 

worldmap <- readOGR(dsn="PG:host=172.16.0.6 user=postgres dbname=aas_base password=gis2013 port=5432", layer = "global.geo_worldmap", verbose = TRUE)

# Plot the map with data superimposed 

plot(worldmap,border="blue",axes=T,las=1)

## Getting access to the parts of worldmap

names(worldmap)

# [1] "AREA"       "PERIMETER"  "G2008_0_"   "G2008_0_ID" "ADM0_CODE" 
# [6] "ADM0_NAME"  "LAST_UPDAT" "CONTINENT"  "REGION"     "STR_YEAR0" 
# [11] "EXP_YEAR0" 

slotNames(worldmap)

# [1] "data"        "polygons"    "plotOrder"   "bbox"       
# [5] "proj4string"

polys <- sort(unique(worldmap$adm0_name))

## Select only countries in the tropics ##

tropical.polys <- rep(NA,length(polys))

for( i in 1:length(polys)) {

  country <- as.character(polys[i])
  tpoly <-worldmap[worldmap$adm0_name==country,]
  print(country)
  rr <- bbox(tpoly)[2,]
  if(rr[1] > -27 & rr[2] < 28)  
  {
    tropical.polys[i] <- country
  }
}

tropical.polys <- tropical.polys[!is.na(tropical.polys)]



### Now take out those for the AAS countries and those of interest in other projects

aas.polys <- tropical.polys[tropical.polys %in% c('Philippines','Timor-Leste','Kiribati','Maldives',
'Vanuatu','Sri Lanka', 'Myanmar','India','China','Bangladesh','Cambodia','Indonesia','Malaysia','Zambia',
'Solomon Islands','Tanzania','Thailand','Vietnam','Ghana','East Timor','Papua New Guinea')]



## Loop round months and years ###


sqlQuery(conn,"select max(month) from global.precipitation_tropics where year = 2012;")



start.year <- 1948
end.year   <- 2011
grid <- expand.grid(year = start.year:end.year, month = 1:12)


#sqlQuery(conn,"DROP TABLE physical.precipitation_country;")


##################################################
##################################################
############Start loop ###########################
##################################################
##################################################



for (i in 1:length(grid[,1])) {
  
  print(grid[i,])
  
  query <- paste("SELECT * from global.precipitation_tropics WHERE year = ",grid$year[i],"AND month =", grid$month[i],";") 
  
  dat <- sqlQuery(conn,query) #Extract data from dB
  dd <- dim(dat)[[1]]
  dat <- dat[,-dd]
  
  ## Now create a spatial points dataframe from dat ##
  
  coords <- SpatialPoints(dat[, c("lon", "lat")])
  dat.spdf <- SpatialPointsDataFrame(coords,dat,proj4string=geogWGS84) 
  
  
  out <- NULL
  
  
  for (j in 1:length(tropical.polys)) { # Start to loop over polygons
    
{

  country.tex <- as.character(tropical.polys[j])
  print(country.tex)
  country  <- worldmap[worldmap$adm0_name == country.tex,]
  ## Do the overlay ##
  
  if(dim(dat.spdf@data)[1] < 250000) #if dat has less than 250K rows
  {
    o <- overlay(dat.spdf,country)
    
  }
  
  if(dim(dat.spdf@data)[1] > 249999) 
  {
    
    print("Data set has gt 250K rows")
    
    uu <- round(seq(1,dim(dat.spdf@data)[1],length=10))
    
    dat.spdf1 <- dat.spdf[1:uu[2],]
    dat.spdf2 <- dat.spdf[(uu[2]+1):uu[3],]
    dat.spdf3 <- dat.spdf[(uu[3]+1):uu[4],]
    dat.spdf4 <- dat.spdf[(uu[4]+1):uu[5],]
    dat.spdf5 <- dat.spdf[(uu[5]+1):uu[6],]
    dat.spdf6 <- dat.spdf[(uu[6]+1):uu[7],]
    dat.spdf7 <- dat.spdf[(uu[7]+1):uu[8],]
    dat.spdf8 <- dat.spdf[(uu[8]+1):uu[9],]
    dat.spdf9 <- dat.spdf[(uu[9]+1):dim(dat.spdf)[1],]
    
    
    o1 <- overlay(dat.spdf1,country)
    o2 <- overlay(dat.spdf2,country)
    o3 <- overlay(dat.spdf3,country)
    o4 <- overlay(dat.spdf4,country)
    o5 <- overlay(dat.spdf5,country)
    o6 <- overlay(dat.spdf6,country)
    o7 <- overlay(dat.spdf7,country)
    o8 <- overlay(dat.spdf8,country)
    o9 <- overlay(dat.spdf9,country)
    gc(reset=T)
    
    o <- c(o1,o2,o3,o4,o5,o6,o7,o8,o9)
  }
  
  
  if(sum(is.na(o)) < length(o)) {
    dat.spdfo <- dat.spdf[!is.na(o),]
    ## Add on the Country string ## 
    dat.spdfo@data$country <- country.tex
    dat.dfo  <- data.frame(dat.spdfo@data)
  
  
  out <- rbind(out,dat.dfo)
  }
} 
}


# End of j loop

if (!is.null(out) & i == 1)
{

  sqlSave(conn,out,tablename='global.precipitation_country',append=F,rownames=FALSE,addPK=TRUE,nastring=NA)
  print('Created Database')

}

if(!is.null(out) & i > 0)
  {
  sqlSave(conn,out,tablename='global.precipitation_country',append=T,rownames=FALSE,addPK=TRUE,nastring=NA)
  print('Appended database')
  
  }

  }  # End of i loop



#sqlQuery(conn,"DELETE FRoM physical.precipitation_eez WHERE yr = 2011 AND mo = 1 AND country = 'Philippines'")
