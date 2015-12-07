########################
# Lars Mehwald and Daniel Salgado Moreno
# 11 December 2015
# PKS data: Kreise 2013 2014
########################

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
names(PKS_Kreise_13) <- NameofVariables 
rm(NameofVariables)

# Converting Character Vectors between Encodings from latin1 to UTF-8
# More compatibility with German characters
PKS_Kreise_13$DistrictName <- iconv(PKS_Kreise_13$DistrictName, from ="latin1", to = "UTF-8")

# Adding a time variable: year
PKS_Kreise_13$year <- 2013

# Correcting problem with Hamburg and Berlin. 
PKS_Kreise_13[,1] <- as.numeric(as.character(PKS_Kreise_13[,1]))
PKS_Kreise_13[22,1]=11 # Berlin
PKS_Kreise_13[99,1]=2 # Hamburg 

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

# Creating East/West dummy, where East=1 and Berlin coded as 1 (with reference to the Berlin Frage)
PKS_Kreise_13$EastWest <- ifelse(PKS_Kreise_13$district >= 8111 & PKS_Kreise_13$district <= 8437, 0, # Baden-Württemberg
                                 ifelse(PKS_Kreise_13$district >= 9161 & PKS_Kreise_13$district <= 9780, 0, # Bayern
                                   ifelse(PKS_Kreise_13$district == 11, 1, # Berlin
                                     ifelse(PKS_Kreise_13$district >= 12051 & PKS_Kreise_13$district <= 12073, 1, # Brandenburg
                                       ifelse(PKS_Kreise_13$district == 4011 | PKS_Kreise_13$district == 4012, 0, # Bremen
                                         ifelse(PKS_Kreise_13$district == 2, 0, # Hamburg
                                           ifelse(PKS_Kreise_13$district >= 6411 & PKS_Kreise_13$district <= 6636, 0, # Hessen
                                             ifelse(PKS_Kreise_13$district >= 13003 & PKS_Kreise_13$district <= 13076, 1, # Mecklenburg-Vorpommern
                                               ifelse(PKS_Kreise_13$district >= 3101 & PKS_Kreise_13$district <= 3462, 0, # Niedersachen
                                                 ifelse(PKS_Kreise_13$district >= 5111 & PKS_Kreise_13$district <= 5978, 0, # Nordrhein-Westfalen
                                                   ifelse(PKS_Kreise_13$district >= 7111 & PKS_Kreise_13$district <= 7340, 0, # Rheinland-Pfalz
                                                     ifelse(PKS_Kreise_13$district >= 10041 & PKS_Kreise_13$district <= 10046, 0, # Saarland
                                                       ifelse(PKS_Kreise_13$district >= 14511 & PKS_Kreise_13$district <= 14730, 1, # Sachsen
                                                         ifelse(PKS_Kreise_13$district >= 15001 & PKS_Kreise_13$district <= 15091, 1, # Sachsen-Anhalt
                                                           ifelse(PKS_Kreise_13$district >= 1001 & PKS_Kreise_13$district <= 1062, 0, 1 # Schleswig-Holtstein und Türingen (16051 - 16077)
                                                           )))))))))))))))
PKS_Kreise_13[,17] <- as.numeric(as.character(PKS_Kreise_13[,17]))

# Saving the data 
write.csv(PKS_Kreise_13, file = "Analysis/data/PKS_Kreise.csv")
