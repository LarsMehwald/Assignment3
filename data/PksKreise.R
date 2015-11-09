########################
# Lars Mehwald and Daniel Salgado Moreno
# 13 November 2015
# Assignment 3
# PKS data: Kreise 2013 2014
########################

# Loading required package
library("repmis")

# Setting the commonly used working directory
possible_dir <- c('D:/Eigene Dokumente/!1 Vorlesungen/!! WS 2015/Introduction to Collaborative Social Science Data Analysis/Assignment3', 
                  '~/HSoG/DataAnalysis/GitHub/Assignment3')
set_valid_wd(possible_dir)
rm(possible_dir)

# Scrapping the data
URL_PKS_Kreise_13_14 <- "http://www.bka.de/SharedDocs/Downloads/DE/Publikationen/PolizeilicheKriminalstatistik/2014/BKATabellen/FaelleLaenderKreiseStaedte/tb01__FaelleGrundtabelleKreiseFallentwicklung__csv,templateId=raw,property=publicationFile.csv/tb01__FaelleGrundtabelleKreiseFallentwicklung__csv.csv"
PKS_Kreise_13_14 <- read.csv(URL_PKS_Kreise_13_14, sep=";")
rm(URL_PKS_Kreise_13_14)

# Delete (for now) unimportant variables
PKS_Kreise_13_14 <- PKS_Kreise_13_14[,-c(1, 7:15)]

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
rm(PKS_Kreise_13_14)

# Spread data from wide to long format
PKS_Kreise_13 <- spread(PKS_Kreise_13, "Straftat", "2013 - erfasste Faelle")

# Removing variables (crimes) not relevant to analysis
PKS_Kreise_13 <- PKS_Kreise_13[,-c(4:5,12,15,18)]

# Translation of variable names into English
NameofVariables <- c("district", 
                     "DistrictName", 
                     "bodilyHarm", 
                     "robberyFromOrOutOfCars",
                     "robberyOfCars",
                     "dangerousBodilyHarm", 
                     "violentCrime", 
                     "murderAndManslaughter", 
                     "robberyIncludingExtortionAndAttackOfCarDrivers",
                     "vandalism",
                     "vandalismGraffiti",
                     "streetCrime",
                     "burglaryDaylight",
                     "burglary")
# Adding Names of translated Variables 
names(PKS_Kreise_13) <- NameofVariables 
rm(NameofVariables)

# Converting Character Vectors between Encodings from latin1 to UTF-8
# More compatibility with German characters
PKS_Kreise_13$DistrictName <- iconv(PKS_Kreise_13$DistrictName, from ="latin1", to = "UTF-8")

# Adding a time variable: year
PKS_Kreise_13$year <- 2013

# Correcting problem with Hamburg and Berlin. 
PKS_Kreise_13[,1] <- as.numeric(as.character(PKS_Kreise_13[,1]))
PKS_Kreise_13[22,1]=11
PKS_Kreise_13[99,1]=2  

# Combining district variable with year and rearranging
PKS_Kreise_13$district_year <- paste(PKS_Kreise_13$district, "2013", sep = "y")
PKS_Kreise_13 <- PKS_Kreise_13[,c(1,2,15,16,3:14)]

# Changing the class of variables
PKS_Kreise_13[,1] <- as.numeric(as.character(PKS_Kreise_13[,1]))
PKS_Kreise_13[,3] <- as.numeric(as.character(PKS_Kreise_13[,3]))
PKS_Kreise_13[,5] <- as.numeric(as.character(PKS_Kreise_13[,5]))
PKS_Kreise_13[,6] <- as.numeric(as.character(PKS_Kreise_13[,6]))
PKS_Kreise_13[,7] <- as.numeric(as.character(PKS_Kreise_13[,7]))
PKS_Kreise_13[,8] <- as.numeric(as.character(PKS_Kreise_13[,8]))
PKS_Kreise_13[,9] <- as.numeric(as.character(PKS_Kreise_13[,9]))
PKS_Kreise_13[,10] <- as.numeric(as.character(PKS_Kreise_13[,10]))
PKS_Kreise_13[,11] <- as.numeric(as.character(PKS_Kreise_13[,11]))
PKS_Kreise_13[,12] <- as.numeric(as.character(PKS_Kreise_13[,12]))
PKS_Kreise_13[,13] <- as.numeric(as.character(PKS_Kreise_13[,13]))
PKS_Kreise_13[,14] <- as.numeric(as.character(PKS_Kreise_13[,14]))
PKS_Kreise_13[,15] <- as.numeric(as.character(PKS_Kreise_13[,15]))
PKS_Kreise_13[,16] <- as.numeric(as.character(PKS_Kreise_13[,16]))

# Saving the data 
write.csv(PKS_Kreise_13, file = "data/PKS_Kreise.csv")
