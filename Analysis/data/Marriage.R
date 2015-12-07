########################
# Lars Mehwald and Daniel Salgado Moreno
# 11 December 2015
# Loading Marriage data from the SBA
########################

# Reading Marriages 2013 csv file 
Marriages <- read.csv(file="Analysis/data/RawData/177-31-4_Marriages_2013.csv", 
                           sep=";", 
                           na.strings = c("-","."),
                           nrows = 525,
                           skip = 9,
                           header=FALSE,
                           col.names=c("year",
                                       "district",
                                       "DistrictName", 
                                       "HusbandAndWifeTotal",
                                       "EhemannesTotal/EhefrauDeutsche",
                                       "EhemannesTotal/EhefrauAuslaenderin",
                                       "EhemannesDeutscher/EhefrauTotal",
                                       "EhemannesDeutscher/EhefrauDeutsche",
                                       "EhemannesDeutscher/EhefrauAuslaenderin",
                                       "EhemannesAuslaender/EhefrauTotal",
                                       "EhemannesAuslaender/EhefrauDeutsche",
                                       "EhemannesAuslaender/EhefrauAuslaender"))

# Converting Character Vectors between Encodings from latin1 to UTF-8
# More compatibility with German characters
Marriages$DistrictName <- iconv(Marriages$DistrictName, from ="latin1", to = "UTF-8")

# Removing observation for Germany as a whole
Marriages <- Marriages[-1,]

# Removing variables
Marriages <- Marriages[,-c(3,5:12)]

# Changing the class of Variables 
Marriages[,1] <- as.numeric(as.character(Marriages[,1]))
Marriages[,2] <- as.numeric(as.character(Marriages[,2]))
Marriages[,3] <- as.numeric(as.character(Marriages[,3]))

# Problem with Hamburg and Berlin: recoding
# Removing higher political units (they are coded with numbers below 1000)
# district$Berlin = 11; district$Hamburg = 2
MarriageBerHam <- subset(Marriages, Marriages$district == 2 | Marriages$district ==11, all(TRUE))
Marriages <- Marriages[Marriages$district > 1000,]
Marriages <- rbind(Marriages, MarriageBerHam)
rm(MarriageBerHam)

# Removing redundant districts
# (We keep for district$Aachen=5334, district$Hannover=3241, district$Saarbrücken=10041)
Marriages <- subset(Marriages, Marriages$district < 17000, all(TRUE))

# Saving the data
write.csv(Marriages, file = "Analysis/data/Marriages.csv")
