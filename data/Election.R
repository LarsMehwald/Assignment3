########################
# Lars Mehwald and Daniel Salgado Moreno
# 13 November 2015
# Assignment 3
# German Elections 2013
########################

# Loading required packages 
Packages <- c("rio", "dplyr", "tidyr", "repmis", "httr", "knitr", "ggplot2",
            "xtable", "stargazer", "texreg", "lmtest", "sandwich", "Zelig",
            "ggmap", "rworldmap")
lapply(Packages, require, character.only = TRUE)
rm(Packages)

# Setting the commonly used working directory
possible_dir <- c('D:/Eigene Dokumente/!1 Vorlesungen/!! WS 2015/Introduction to Collaborative Social Science Data Analysis/Assignment3', 
                  '~/HSoG/DataAnalysis/GitHub/Assignment3')
set_valid_wd(possible_dir)
rm(possible_dir)

# Downloading of data
Election <- read.csv(file = "data/RawData/GermanElections2013.csv", 
                           sep= ";",
                           dec = ",",
                           na.strings = "-",
                           nrows = 522,
                           skip = 12,
                           header=FALSE,
                           col.names=c("year",
                                       "district",
                                       "DistrictName", 
                                       "EntitledVoteTotal",
                                       "TurnoutPercentage",
                                       "TurnoutSecondVoteTotal",
                                       "VoteConservativesTotal",
                                       "VoteSocialDemocratsTotal",
                                       "VoteGreensTotal",
                                       "VoteLiberalsTotal",
                                       "VoteLeftTotal",
                                       "VoteOthersTotal")
)

# Converting Character Vectors between Encodings from latin1 to UTF-8
# More compatibility with German characters
Election$DistrictName <- iconv(Election$DistrictName, from ="latin1", to = "UTF-8")

# Removing some variables
Election <- Election[,-c(1,3,6)]

# Changing the class of variables
Election[,1] <- as.numeric(as.character(Election[,1]))
Election[,2] <- as.numeric(as.character(Election[,2]))
Election[,3] <- as.numeric(as.character(Election[,3]))
Election[,4] <- as.numeric(as.character(Election[,4]))
Election[,5] <- as.numeric(as.character(Election[,5]))
Election[,6] <- as.numeric(as.character(Election[,6]))
Election[,7] <- as.numeric(as.character(Election[,7]))
Election[,8] <- as.numeric(as.character(Election[,8]))
Election[,9] <- as.numeric(as.character(Election[,9]))

# Removing higher political units (they are coded with numbers below 1000)
# district$Berlin = 11; district$Hamburg = 2; 
ElectionHamburgBerlin <- subset(Election, Election$district == 2 | Election$district ==11, all(TRUE))
Election <- Election[Election$district > 1000,]
Election <- rbind(Election, ElectionHamburgBerlin)
rm(ElectionHamburgBerlin)

# Removing redundant districts
# (We keep for district$Aachen=5334, district$Hannover=3241, district$Saarbrücken=10041)
Election <- subset(Election, Election$district < 17000, all(TRUE))

# Saving the data 
write.csv(Election, file = "data/Election.csv")