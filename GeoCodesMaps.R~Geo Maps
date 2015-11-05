########################
# Lars Mehwald and Daniel Salgado Moreno
# 13 November 2015
# Assignment 3
# Geo codes and maps
########################

# Creating a variable countaining the names of districts
DistrictNames <- CrimesMarriagesGraduatesLabor2013$districtName
length(DistrictNames) # Checking whether all observations are contained in var
DistrictNames <- as.character(DistrictNames)
class(DistrictNames)

# Creating a geo code for every district (using ggmap)
# districtLonLat <- geocode(DistrictNames, source="google", messaging=FALSE) # takes a lot of time!
# write.csv(districtLonLat, file = "data/districtLonLat.csv")
districtLonLat <- read.csv("data/districtLonLat.csv")
rm(DistrictNames)

# Checking whether Lon Lat has reasonable values
summary(districtLonLat$lon) # Some values are extremely small
summary(districtLonLat$lat) # This all seems reasonable 

# Combining the data frames 
CrimesMarriagesGraduatesLaborGeo2013 <- cbind(CrimesMarriagesGraduatesLabor2013, districtLonLat)
rm(CrimesMarriagesGraduatesLabor2013)
rm(districtLonLat)

# The following section has been developed on the basis of:
# http://www.milanor.net/blog/?p=594

# Creating a map with rworldmap package
Germany <- getMap(resolution = "low") 
plot(Germany, xlim = c(8, 13), ylim = c(46, 56), asp = 1) # asp defines the ratio of x and y axis 
points(x = CrimesMarriagesGraduatesLaborGeo2013$lon, 
       y = CrimesMarriagesGraduatesLaborGeo2013$lat, 
       col = "red", type = "p", cex = .6) 
# cex defines diameter of circle 
# type: "p" for points, "l" for lines, "b" for both points and lines, 
# "c" for empty points joined by lines, "o" for overplotted points and lines, 
# "s" and "S" for stair steps and "h" for histogram-like vertical lines. 
# Finally, "n" does not produce any points or lines.
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
  geom_point(aes(x = lon, y = lat, size = robbery), 
             data = CrimesMarriagesGraduatesLaborGeo2013, alpha = .5) 
# from ggplot2 package 
# alpha parameter controls the transparency
# aesthetics = visual elements of a plot
# I dont need to assign this to an new object (GermanyPoints), but this way it stores it
GermanyPoints
rm(GermanyGoogle)
rm(GermanyPoints)