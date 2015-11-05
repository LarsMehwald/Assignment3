########################
# Geo codes and maps 
########################

library("ggmap")
library("rworldmap")

# Setting the commonly used working directory
possible_dir <- c('D:/Eigene Dokumente/!1 Vorlesungen/!! WS 2015/Introduction to Collaborative Social Science Data Analysis/Assignment3', 
                  '~/HSoG/DataAnalysis/GitHub/Assignment3')
set_valid_wd(possible_dir)
rm(possible_dir)
# setwd("D:/Eigene Dokumente/!1 Vorlesungen/!! WS 2015/Introduction to Collaborative Social Science Data Analysis/Assignment3")

# Citing R packages 
pkgs <- c('ggmap', 
          'rworldmap')
LoadandCite(pkgs, file = 'References/RpackageCitationsGeoMap.bib')
rm(pkgs)

CrimesMarriagesGraduatesLabor2013<-read.csv(file="data/CrimesMarriagesGraduatesLabor2013.csv")

# Creating a variable countaining the names of districts
DistrictNames <- CrimesMarriagesGraduatesLabor2013$districtName
length(DistrictNames) # Checking whether all observations are contained in variable
DistrictNames <- as.character(DistrictNames)
class(DistrictNames) #"Character"

# Creating a geo code for every district (using ggmap)
# districtLonLat <- geocode(DistrictNames, source="google", messaging=FALSE) # takes a lot of time!
# write.csv(districtLonLat, file = "data/districtLonLat.csv")
districtLonLat <- read.csv("data/districtLonLat.csv") ##### ??? Where does this come from? ?????
rm(DistrictNames)

# Checking whether Lon Lat has reasonable values
summary(districtLonLat$lon) # Some values are extremely small
summary(districtLonLat$lat) # This all seems reasonable 

# Combining the data frames 
CrimesMarriagesGraduatesLaborGeo2013 <- cbind(CrimesMarriagesGraduatesLabor2013, districtLonLat)
rm(CrimesMarriagesGraduatesLabor2013)
rm(districtLonLat)

# The following section has been developed based on:
# http://www.milanor.net/blog/?p=594
?
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