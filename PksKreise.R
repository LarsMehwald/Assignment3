########################
# Lars Mehwald and Daniel Salgado Moreno
# 13 November 2015
# Assignment 3
# PKS data: Kreise 2013 2014
########################

# Scrapping the data
URL_PKS_Kreise_13_14 <- "http://www.bka.de/SharedDocs/Downloads/DE/Publikationen/PolizeilicheKriminalstatistik/2014/BKATabellen/FaelleLaenderKreiseStaedte/tb01__FaelleGrundtabelleKreiseFallentwicklung__csv,templateId=raw,property=publicationFile.csv/tb01__FaelleGrundtabelleKreiseFallentwicklung__csv.csv"
PKS_Kreise_13_14 <- read.csv(URL_PKS_Kreise_13_14, sep=";")
rm(URL_PKS_Kreise_13_14)

# Delete (for now) unimportant variables
PKS_Kreise_13_14 <- PKS_Kreise_13_14[,-c(1, 4, 7:15)]

# Renaming manually 
NameofVariables <- c("Straftat", "Gemeindeschluessel", "GemeindeName", "2014 - erfasste Faelle", "2013 - erfasste Faelle")
names(PKS_Kreise_13_14) <- NameofVariables 
rm(NameofVariables)

# Delete the first row (before name of variable)
PKS_Kreise_13_14 <- PKS_Kreise_13_14[-c(1),]

# Rearranging data
PKS_Kreise_13_14 <- PKS_Kreise_13_14[c(2,3,1,5,4)]

# Splitting the data
PKS_Kreise_13 <- PKS_Kreise_13_14[,-5]
# PKS_Kreise_14 <- PKS_Kreise_13_14[,c(1,2,4)]
rm(PKS_Kreise_13_14)

# Spread data from wide to long format
PKS_Kreise_13_spread <- spread(PKS_Kreise_13, "Straftat", "2013 - erfasste Faelle")
# PKS_Kreise_14_spread <- spread(PKS_Kreise_14, "Straftat", "2014 - erfasste Faelle")
rm(PKS_Kreise_13)
# rm(PKS_Kreise_14)

# Removing variables (crimes) not relevant to analysis
PKS_Kreise_13_spread <- PKS_Kreise_13_spread[,-c(4,5,6,7,12:19)]
# PKS_Kreise_14_spread <- PKS_Kreise_14_spread[,-c(3,4,5,6,11:18)]

# Translation of variable names into English
NameofVariables <- c("district", "districtName", "bodily harm", "dangerous bodily harm", "violent crime", "murder and manslaughter", "robbery")
names(PKS_Kreise_13_spread) <- NameofVariables 
# names(PKS_Kreise_14_spread) <- NameofVariables 
rm(NameofVariables)

# Adding a time variable: year
PKS_Kreise_13_spread$year <- 2013
# PKS_Kreise_14_spread$year <- 2014

# Correcting problem with Hamburg and Berlin. 
PKS_Kreise_13_spread[,1] <- as.numeric(as.character(PKS_Kreise_13_spread[,1]))
PKS_Kreise_13_spread[22,1]=11
PKS_Kreise_13_spread[99,1]=2  

# Combining district variable with year and rearranging
PKS_Kreise_13_spread$district_year <- paste(PKS_Kreise_13_spread$district, "2013", sep = "y")
PKS_Kreise_13 <- PKS_Kreise_13_spread[,c(9,1,2,8,3:7)]
rm(PKS_Kreise_13_spread)
# PKS_Kreise_14_spread$district_year <- paste(PKS_Kreise_14_spread$district, "2014", sep = "y")
# PKS_Kreise_14 <- PKS_Kreise_14_spread[,c(8,1,2,3,4,5,6,7)]
# rm(PKS_Kreise_14_spread)

# Combining the data frames 
# PKS_Kreise <- rbind(PKS_Kreise_13, PKS_Kreise_14)
# rm(PKS_Kreise_13)
# rm(PKS_Kreise_14)

# Changing the class of variables
PKS_Kreise_13[,2] <- as.numeric(as.character(PKS_Kreise_13[,2]))
PKS_Kreise_13[,3] <- as.numeric(as.character(PKS_Kreise_13[,3]))
PKS_Kreise_13[,4] <- as.numeric(as.character(PKS_Kreise_13[,4]))
PKS_Kreise_13[,5] <- as.numeric(as.character(PKS_Kreise_13[,5]))
PKS_Kreise_13[,6] <- as.numeric(as.character(PKS_Kreise_13[,6]))
PKS_Kreise_13[,7] <- as.numeric(as.character(PKS_Kreise_13[,7]))
PKS_Kreise_13[,8] <- as.numeric(as.character(PKS_Kreise_13[,8]))
PKS_Kreise_13[,9] <- as.numeric(as.character(PKS_Kreise_13[,9]))

# Saving the data 
write.csv(PKS_Kreise_13, file = "data/PKS_Kreise.csv")
