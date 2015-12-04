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
LoadandCite(Packages, file = 'References/RpackageCitations.bib')
rm(Packages)

# Loading data set from csv file
DistrictData <- read.csv(file="Analysis/data/DistrictData2013.csv")

# Removing ranking column (it was added in the saving process in DataMerging.R)
DistrictData <- DistrictData[,-1]

########################
# Geo codes and maps 
########################

#DEU_adm3 <- readRDS("DEU_adm3.rds") #Gemeinde
#DEU_adm2 <- readRDS("DEU_adm2.rds") #Kreise

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
