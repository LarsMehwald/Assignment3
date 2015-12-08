########################
# Lars Mehwald and Daniel Salgado Moreno
# December 2015
# Final Paper
# Creating maps with geocoding and geolocation
########################

# Loading required packages 
Packages <- c("rio", "dplyr", "tidyr", "repmis", "httr", "knitr", "ggplot2",
          "xtable", "stargazer", "texreg", "lmtest", "sandwich", "Zelig",
          "ggmap", "rworldmap", "sp", "RColorBrewer", "car", "MASS", 
          "maps", "mapproj", "PerformanceAnalytics", "pscl", "AER", "rgdal", 
          "maptools", "gpclib")
lapply(Packages, require, character.only = TRUE)

# Setting the commonly used working directory
possible_dir <- c('D:/Eigene Dokumente/!1 Vorlesungen/!! WS 2015/Introduction to Collaborative Social Science Data Analysis/Assignment3', 
                  '~/HSoG/DataAnalysis/GitHub/Assignment3')
set_valid_wd(possible_dir)
rm(possible_dir)

# Citing R packages 
#LoadandCite(Packages, file = 'References/RpackageCitations.bib')
rm(Packages)

# Loading data set from csv file
DistrictData <- read.csv(file="Analysis/data/DistrictData2013.csv")

# Removing ranking column (it was added in the saving process in DataMerging.R)
DistrictData <- DistrictData[,-1]

# Converting Character Vectors between Encodings from latin1 to UTF-8
# More compatibility with German characters
DistrictData$DistrictName <- iconv(DistrictData$DistrictName, from ="latin1", to = "UTF-8")

########################
# Geo codes and maps 
########################

# Loading Shape files downloaded from GADM database (www.gadm.org): by country: Germany (shapefile)
spdf <- readOGR(dsn="Analysis/data/DEU_adm_shp", layer= "DEU_adm2") # loading layer for districts
# following guidlines in: https://www.nceas.ucsb.edu/~frazier/RSpatialGuides/OverviewCoordinateReferenceSystems.pdf
spdf <- spTransform(spdf, CRS("+init=epsg:4326")) # transforming layers in the map 

# NOTE: The following algorithm was taken from http://mazamascience.com/WorkingWithData/?p=1277
# Identifying the attributes in spdf to keep and associate new names with them 
names(spdf)
attributes <- c("ID_1", "NAME_1", "NAME_2", "CCA_2")

# User friendly names
newNames <- c("StateId", "StateName", "DistrictName", "district")

# Subset the full dataset extracting only the desired attributes
spdf_subset <- spdf[,attributes]

# Assign the new attribute names
names(spdf_subset) <- newNames

# Create a dataframe name (potentially different from shapefile Name)
data_name <- "GermanDistricts"

# Reproject the data onto a "longlat" projection and assign it to the new name
assign(data_name,spTransform(spdf_subset, CRS("+proj=longlat")))

# The GermanDistricts dataset is now projected in latitude longitude coordinates as a // 
# SpatialPolygonsDataFrame. We save the converted data as .RData for faster loading in the future.
save(list=c(data_name),file=paste("Analysis/data/GermanDistricts.RData",sep="/"))
rm(data_name, attributes, newNames)

# Load again GermanDistricts # Not necessary for now
#file <- paste("Analysis/data/GermanDistricts.RData",sep="/")
#load(file) 

# Inspecting the object class for district within GermanDistricts for merging purposes
class(GermanDistricts$district) #=factor

# Transformation of class needed for district ID in SpatialPolygonsDataFrame
GermanDistricts@data$district <- as.integer(as.character(GermanDistricts@data$district))

###########################
# Preparing data for matching 
###########################
# user friendly name for main variable of interest
names(DistrictData)[names(DistrictData) == 'murderAndManslaughter'] <- 'Murder'

# List of relevant variables for analysis
columns <- c(1,10,17,23,25,48,51,52,53,54,55,56,58,60,62)

# Subset the DistrictData full data frame to extract only desire variables: 
DistrictData_subset <- subset(DistrictData, select=columns)

# Changing district ID for Berlin and Hamburg. 
DistrictData_subset[2,1]=11000
DistrictData_subset[1,1]=02000

# Delete Bodensee observation in SPDF
GermanDistricts@data <- GermanDistricts@data[-6,]

# Order both dataframes by district ID 
DistrictData_subset <- DistrictData_subset[order(DistrictData_subset$district),]
GermanDistricts@data <- GermanDistricts@data[order(GermanDistricts$district),]

# Transformation of class needed for district ID in SpatialPolygonsDataFrame
DistrictData_subset$district <- as.integer(DistrictData_subset$district)

# Merge DistrictData and GermanDistricts by "district"
GermanDistricts@data <- left_join(GermanDistricts@data, DistrictData_subset, by="district")

ggplot(GermanDistricts, aes(long, lat, group = group)) +
  geom_polygon(aes(fill = GermanDistricts@data$MurderRate), colour = alpha("white", 1/2), size = 0.2) + 
  geom_polygon(data = state_df, colour = "white", fill = NA) +
  scale_fill_brewer(palette = "PuRd")


ggplot(GermanDistricts) + geom_polygon(aes(long, lat, group = group, fill = GermanDistricts@data$MurderRate))+
  scale_fill_brewer(palette = "Reds")



#########################
#Plotting Murder Rate per district
#########################

# Cut data into classes
classes <- cut(DistrictData_subset$MurderRate, c(0,1,2,3,4,5,10,15,29.270), right = FALSE)
levels(classes) <- c("0", "1", "2", "3","4", "5", "10", "15 or higher")

# Assign colors
colours <- brewer.pal(8,"Reds") # Pick color palette

# Plot the shapefiles colored
plot(GermanDistricts,border = "darkgrey", col = colours[classes])

#### STARTING here CODE is not cleaned and working





gpclibPermit() # required for fortify method
# rownames
GermanDistricts@data[["district"]] <- rownames(GermanDistricts@data)
row.names(GermanDistricts@data) <- 1:nrow(GermanDistricts@data)
GD <- fortify(GermanDistricts, region= "district")



# Merge DistrictData and GermanDistricts by "district"
#GermanData <- left_join(GermanDistricts@data, DistrictData_subset, by="district", warnings())
## NOTE: Most of not matched NA's cases are in Mecklenburg-Vorpommern. Thus this state is underrepresented in dataframe


# Extracting data frame from SpatialPolygonsDataFrame
#spdf2 <- data.frame(spdf@data)
spdf3 <- data.frame(GermanDistricts@data)
# Renaming district ID in SpatialPolygonsDataFrame 
spdf <- rename(spdf, district=CCA_2)

# Chaning district ID for Berlin and Hamburg. 
spdf@data[141,10]=11000
spdf@data[162,10]=02000

# Transformation of class need for district ID needed in SpatialPolygonsDataFrame
spdf@data$district <- as.character(as.integer(spdf@data$district))

# Merging DataDistrict and SpatialPolygonsDataFrame
df <- merge(DistrictData, spdf@data, by="district")

DistrictData <- rename(DistrictData, CCA_2=district)

a <- merge(DistrictData, shapes_district_df, by="CCA_2") #Merging only 76 districts. 

# Chaning district ID for Berlin and Hamburg. 
spdf@data[2,1]=11000
spdf@data[1,1]=02000

shapes_district_df$CCA_2 <- as.character(shapes_district_df$CCA_2)
shapes_district_df$CCA_2 <- as.integer(shapes_district_df$CCA_2)

b <- merge(DistrictData, shapes_district_df, by="CCA_2")

#Alternative to merging. Not working
spdf@data = data.frame(spdf@data, DistrictData[match(shapes_district@data$CCA_2, DistrictData$CCA_2),])

#Chris version
Shapes_krs <- readOGR(dsn = "Analysis/data/vg2500.utm32s.shape/vg2500", layer = "vg2500_krs") # Load Kreise shapefile
Shapes_krs<-spTransform(Shapes_krs, CRS("+init=epsg:4326")) # Transform to different coordinates format (to WGS84)
Shapes_krs$GEN

DistrictData$DistrictName <- Shapes_krs$GEN




# Reading shape file date into R: 
shapefile <- readShapeSpatial('Analysis/data/DEU_adm_shp/DEU_adm2.shp',proj4string = CRS("+proj=lonlat+datum=WGS84"))
# shapefiles@data$CCA_2 contains district ID 

# Converting to data frame for use with ggplot2/ggmap and plot
data <- fortify(shapefile) # Not sure how it works

MurderRates <- DistrictData[,c(1:2,55,10,40,47,54,50,51,53,22)]
MurderRates <- MurderRates[,c(1:3)]

#Not WOrking on OS El Capitan
# Downloading Geocoordinates for German districs from:
# http://www.geodatenzentrum.de/geodaten/gdz_rahmen.gdz_div?gdz_spr=deu&gdz_akt_zeile=5&gdz_anz_zeile=1&gdz_unt_zeile=19&gdz_user_id=0
# First step is to import the contained map and to load districts shapefile:
#shape_district <- readOGR(dsn = "Analysis/data/vg2500.utm32s.shape/vg2500", layer = "vg2500_krs") 
# Sp transformation to different format (WGS84)
#shape_district <- spTransform(shape_district, CRS("+init=epsg:4326"))


#Extracting object for district names
DistrictName <- DistrictData$DistrictName
DistrictName <- as.character(DistrictName)
DistrictData$DistrictName <- as.character(DistrictData$DistrictName)

# Converting Character Vectors between Encodings from latin1 to UTF-8
# More compatibility with German characters
DistrictName <- iconv(DistrictName, from ="latin1", to = "UTF-8")

# Creating a geo code for every district (using ggmap)
districtLonLat <- geocode(DistrictName, source="google", messaging=TRUE) # takes a lot of time!
#districtLonLat <- data.frame(cbind(DistrictName, districtLonLat))

districtLonLat2 <- geocode(DistrictName, source="dsk", messaging=TRUE) # takes a lot of time!

# Subset for MurderRate + LonLat + DistrictName + district
Murder <- DistrictData[,c(1:2,55,10,40,47,54,50,51,53,22)] #object with relevant variables
Murder <- Murder[,c(1:3)] #keep MurderRate
Murder <- data.frame(cbind(Murder, districtLonLat)) #binding lon lat + MurderRate and creating data.frame

write.csv(Murder, file = "Analysis/data/subsetMurder.csv")
Murder <- read.csv("Analysis/data/subsetMurder.csv")


# Checking whether Lon Lat has reasonable values
summary(districtLonLat$lon) # Some values are extremely small
summary(districtLonLat$lat) # This all seems reasonable 

# The following section has been developed based on:
# http://www.milanor.net/blog/?p=594

# Creating a map with red dots
Germany <- getMap(resolution = "low") # from rworldmap package 
plot(Germany, xlim = c(8, 13), ylim = c(46, 56), asp = 1)
points(CrimesMarriagesGraduatesLaborGeo2013$lon, CrimesMarriagesGraduatesLaborGeo2013$lat, col = "red", cex = .6) # cex defines diameter of circle 
rm(Germany)

# Alternative map (using ggmap)
EuropeGoogle <- get_map(location = 'Europe', zoom = 4) 
# zoom is independent of the location selected
# location centers the map 
ggmap(EuropeGoogle)
rm(EuropeGoogle)

GermanyGoogle <- get_map(location = 'Germany', zoom = 6)
ggmap(GermanyGoogle)
CrimesMarriagesGraduatesLaborGeo2013[,8] <- as.numeric(as.character(CrimesMarriagesGraduatesLaborGeo2013[,8]))
GermanyPoints <- ggmap(GermanyGoogle) + 
  geom_point(aes(x = lon, y = lat, size = robbery), data = CrimesMarriagesGraduatesLaborGeo2013, alpha = .5)
GermanyPoints ### 73 rows containint missing values were removed 
rm(GermanyGoogle)
rm(GermanyPoints)
