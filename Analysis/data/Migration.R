########################
# Lars Mehwald and Daniel Salgado Moreno
# 13 November 2015
# Assignment 3
# Loading Migration data
########################

# Loading required packages
library("repmis")

# Setting the commonly used working directory
possible_dir <- c('D:/Eigene Dokumente/!1 Vorlesungen/!! WS 2015/Introduction to Collaborative Social Science Data Analysis/Assignment3', 
                  '~/HSoG/DataAnalysis/GitHub/Assignment3')
set_valid_wd(possible_dir)
rm(possible_dir)

# Reading Migration 2013 csv file 
Migration <- read.csv(file="Analysis/data/RawData/182-20-4_MigrationStatistic_2013.csv", 
                           sep=";", 
                           na.strings = c("-","."),
                           nrows = 525,
                           skip = 8,
                           header=FALSE,
                           col.names=c("year",
                                       "district",
                                       "DistrictName", 
                                       "InfluxTotal",
                                       "InfluxMale",
                                       "InfluxFemale",
                                       "OutflowTotal",
                                       "OutflowMale",
                                       "OutflowFemale")
                           )

# Converting Character Vectors between Encodings from latin1 to UTF-8
# More compatibility with German characters
Migration$DistrictName <- iconv(Migration$DistrictName, from ="latin1", to = "UTF-8")

# Removing observation for Germany as a whole
Migration <- Migration[-1,]

# Removing variables
Migration <- Migration[,-c(3,5,6,8,9)]

# Changing the class of Variables 
Migration[,1] <- as.numeric(as.character(Migration[,1]))
Migration[,2] <- as.numeric(as.character(Migration[,2]))
Migration[,3] <- as.numeric(as.character(Migration[,3]))
Migration[,4] <- as.numeric(as.character(Migration[,4]))

# Removing higher political units (they are coded with numbers below 1000)
# district$Berlin = 11; district$Hamburg = 2; 
MigrationBerHam <- subset(Migration, Migration$district == 2 | Migration$district ==11, all(TRUE))
Migration <- Migration[Migration$district > 1000,]
Migration <- rbind(Migration, MigrationBerHam)
rm(MigrationBerHam)

# Removing redundant districts
# (We keep for district$Aachen=5334, district$Hannover=3241, district$Saarbrücken=10041)
Migration <- subset(Migration, Migration$district < 17000, all(TRUE))

# Saving the data
write.csv(Migration, file = "Analysis/data/Migration.csv")
