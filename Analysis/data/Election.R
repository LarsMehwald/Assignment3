########################
# Lars Mehwald and Daniel Salgado Moreno
# 11 December 2015
# German Elections 2013
########################

# Downloading of data
Election <- read.csv(file = "Analysis/data/RawData/GermanElections2013.csv", 
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
write.csv(Election, file = "Analysis/data/Election.csv")