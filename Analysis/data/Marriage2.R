########################
# Lars Mehwald and Daniel Salgado Moreno
# 11 December 2015
# Loading Marriage data
########################

library("tidyr")

# Reading Marriages 2013 csv file 
Marriages <- read.csv(file="Analysis/data/RawData/160-03-4_marriage_2011.csv", 
                           sep=";", 
                           na.strings = c("-","."),
                           nrows = 3150,
                           skip = 9,
                           header=FALSE,
                           col.names=c("district",
                                       "DistrictName", 
                                       "PersonalStatus",
                                       "Total",
                                       "TotalMale",
                                       "TotalFemale",
                                       "TotalGerman",
                                       "TotalForeigner"))

# Converting Character Vectors between Encodings from latin1 to UTF-8
# More compatibility with German characters
Marriages$DistrictName <- iconv(Marriages$DistrictName, from ="latin1", to = "UTF-8")

# Removing observation for Germany as a whole
Marriages <- Marriages[-c(1:6),]

# Removing variables not important to analysis
Marriages <- Marriages[,-c(2,5:8)]

# Changing the class of Variables 
Marriages[,1] <- as.numeric(as.character(Marriages[,1]))
Marriages[,3] <- as.numeric(as.character(Marriages[,3]))

# Spread the data
Marriages <- spread(Marriages, "PersonalStatus", "Total")

# Deleting unimportant categories of personal status
Marriages <- Marriages[,c(1,6)]

# Problem with Hamburg and Berlin: recoding
# Removing higher political units (they are coded with numbers below 1000)
# district$Berlin = 11; district$Hamburg = 2
MarriageBerHam <- subset(Marriages, Marriages$district == 2 | Marriages$district ==11, all(TRUE))
Marriages <- Marriages[Marriages$district > 1000,]
Marriages <- rbind(Marriages, MarriageBerHam)
rm(MarriageBerHam)

# Renaming marriage variable
names(Marriages)[names(Marriages) == "verheiratet / eingetragene Lebenspartnerschaft"] <- "marriageTotal"

# Saving the data
write.csv(Marriages, file = "Analysis/data/Marriages2.csv")
