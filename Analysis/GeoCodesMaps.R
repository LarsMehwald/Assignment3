########################
# Lars Mehwald and Daniel Salgado Moreno
# December 2015
# Final Paper
# Creating maps with geocoding and geolocation
########################

########## SpatialPolygononsDataFrame

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
GermanDistricts <- GermanDistricts[-6,]

# Order both dataframes by district ID 
DistrictData_subset <- DistrictData_subset[order(DistrictData_subset$district),]
GermanDistricts <- GermanDistricts[order(GermanDistricts@data$district),]

# Transformation of class needed for district ID in SpatialPolygonsDataFrame
DistrictData_subset$district <- as.integer(DistrictData_subset$district)

# Merge DistrictData and GermanDistricts by "district"
GermanDistricts@data <- left_join(GermanDistricts@data, DistrictData_subset, by="district")

#########################
#Plotting Murder Rate per district
#########################

#spdf3 <- data.frame(GermanDistricts@data)

