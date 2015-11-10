########################
# Lars Mehwald and Daniel Salgado Moreno
# 13 November 2015
# Assignment 3
# Loading Religion data
########################

# Loading requires packages 
library("tidyr")
library("repmis")

# Setting the commonly used working directory
possible_dir <- c('D:/Eigene Dokumente/!1 Vorlesungen/!! WS 2015/Introduction to Collaborative Social Science Data Analysis/Assignment3', 
                  '~/HSoG/DataAnalysis/GitHub/Assignment3')
set_valid_wd(possible_dir)
rm(possible_dir)

# Reading Religion 2011 csv file 
Religion <- read.csv(file="data/RawData/160-04-4_Religion_2011.csv", 
                           sep=";", 
                           na.strings = c("-","."),
                           nrows = 2100,
                           skip = 9,
                           header=FALSE,
                           col.names=c("district",
                                       "DistrictName", 
                                       "religion",
                                       "BelieversTotal",
                                       "BelieversMale",
                                       "BelieversFemale",
                                       "BelieversGermans",
                                       "BelieversForeigners")
                     )

# Converting Character Vectors between Encodings from latin1 to UTF-8
# More compatibility with German characters
Religion$DistrictName <- iconv(Religion$DistrictName, from ="latin1", to = "UTF-8")
Religion$religion <- iconv(Religion$religion, from ="latin1", to = "UTF-8")

# Removing observation for Germany as a whole
Religion <- Religion[-c(1:4),]

# Removing variables
Religion <- Religion[,-c(2,5:8)]

# Changing the class of Variables 
Religion[,1] <- as.numeric(as.character(Religion[,1]))
Religion[,3] <- as.numeric(as.character(Religion[,3]))

# Spreading the data 
Religion <- spread(Religion, "religion", "BelieversTotal")

# Renaming the variables 
NameOfVariables <- c("district", 
                     "BelieversProtestant", 
                     "BelieversTotal", 
                     "BelieversRomanCatholic",
                     "BelieversOthersNoNoResponse")
names(Religion) <- NameOfVariables
rm(NameOfVariables)

# Removing higher political units (they are coded with numbers below 1000)
# district$Berlin = 11; district$Hamburg = 2; 
ReligionBerHam <- subset(Religion, Religion$district == 2 | Religion$district ==11, all(TRUE))
Religion <- Religion[Religion$district > 1000,]
Religion <- rbind(Religion, ReligionBerHam)
rm(ReligionBerHam)

# Removing redundant districts
# (We keep for district$Aachen=5334, district$Hannover=3241, district$Saarbrücken=10041)
Religion <- subset(Religion, Religion$district < 17000, all(TRUE))

# Saving the data
write.csv(Religion, file = "data/Religion.csv")
