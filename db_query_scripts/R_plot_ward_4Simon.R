############## R-Script written by SJ Teoh to plot likely future suitability for aquaculture #####################

library(sp)
library(lattice)
library(maptools)     # loads sp library too
library(RColorBrewer) # creates nice color schemes
library(classInt)     # finds class intervals for continuous variables
library(RODBC)        # connect to DBs
library(rgdal)        # DB drivers among other handy things

# Set working directory for output (NB. obviously substitute home directory name) 

setwd('/home/dbeare')

# Read in the data from a file

ward <- readShapeSpatial("/srv/public/input_data_files/SolomonIslandsMalaitaShapefiles/Ward_Population_Projection_clip.shp") # Read from directory but better to read from database

# Read in the data from the database instead.

conn <- odbcConnect('aas_base', case = 'postgresql')

sqlQuery(conn,'SET SEARCH_PATH to solomons') # remember to set the search path so R knows where to look 

aas_base_tables <- sqlTables(conn) ## List tables in aas_base 

aas_base_tables$TABLE_NAME ## List all tables in the db

ward <- readOGR(dsn="PG:host=172.16.0.6 user=postgres dbname=aas_base password=gis2013 port=5432", layer = "solomons.socioecon_ward_population_projection", verbose = TRUE) # Population projections

# Plot the data

plot(ward)

# Plot with lattice

spplot(ward)

summary(ward) # Summary information about the table

attributes(ward@data) # Data attributes

names(ward) # Column names

# Test for applying Quantile classification

# Note: When data are read in from a shapefile names are higher case
#plotclr <- brewer.pal(4,"YlGn")
#class <- classIntervals(ward$moz_l_2015, 4, style="quantile")
#colcode <- findColours(class, plotclr)
#spplot(ward, "MOZ_L_2015", col.regions=plotclr, at=round(class$brks, digits=1))


# When data come in from the DB then names are changed to lower case

plotclr <- brewer.pal(4,"YlGn")
class <- classIntervals(ward$moz_l_2015, 4, style="quantile")
colcode <- findColours(class, plotclr)
spplot(ward, "moz_l_2015", col.regions=plotclr, at=round(class$brks, digits=1))

### Mozambique Tilapia

png(filename="MOZ_L.png") # Name of png file to output

spplot(ward, c("moz_l_2015", "moz_l_2030"), 
       names.attr = c("2015","2030"), 
       colorkey=list(space="right"), 
       main="Linear population growth model, Mozambique tilapia \n(lower nutrition gap projection)" 
       )

dev.off()

png(filename="MOZ_U.png")

spplot(ward, c("moz_u_2015", "moz_u_2030"), 
       names.attr = c("2015","2030"), 
       colorkey=list(space="right"), 
       main="Linear population growth model, Mozambique tilapia \n(upper nutrition gap projection)", 
       as.table=TRUE)

dev.off()


png(filename="MOZ_W.png")
spplot(ward, c("moz_w_2015", "moz_w_2030"), 
       names.attr = c("2015","2030"), 
       colorkey=list(space="right"), 
       main="Weeratunge et al. non-linear population growth model, \nMozambique tilapia", 
       as.table=TRUE)
dev.off()


### Nile Tilapia
png(filename="NIL_L.png")

spplot(ward, c("nil_l_2015", "nil_l_2030"), 
       names.attr = c("2015","2030"), 
       colorkey=list(space="right"), 
       main="Linear population growth model, Nile tilapia \n(lower nutrition gap projection)", 
       as.table=TRUE)

dev.off()

png(filename="NIL_U.png")
spplot(ward, c("nil_n_2015", "nil_n_2030"), 
       names.attr = c("2015","2030"), 
       colorkey=list(space="right"), 
       main="Linear population growth model, Nile tilapia \n(upper nutrition gap projection)", 
       as.table=TRUE)
dev.off()

png(filename="NIL_W.png")
spplot(ward, c("nil_w_2015", "nil_w_2030"), 
       names.attr = c("2015","2030"), 
       colorkey=list(space="right"), 
       main="Weeratunge et al. non-linear population growth model, \nNile tilapia", 
       as.table=TRUE)
dev.off()


### THE END ###








