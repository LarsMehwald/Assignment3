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

# Setting the commonly used working directory
possible_dir <- c('D:/Eigene Dokumente/!1 Vorlesungen/!! WS 2015/Introduction to Collaborative Social Science Data Analysis/Assignment3', 
                  '~/HSoG/DataAnalysis/GitHub/Assignment3')
set_valid_wd(possible_dir)
rm(possible_dir)
# setwd("D:/Eigene Dokumente/!1 Vorlesungen/!! WS 2015/Introduction to Collaborative Social Science Data Analysis/Assignment3")

# Citing R packages 
LoadandCite(Packages, file = 'References/RpackageCitations.bib')
rm(Packages)

# Downloading of data
GermanElection <- read.csv(file = "data/GermanElections2013.csv", 
                           sep=";", 
                           na.strings = "-",
                           nrows = 535,
                           skip = 10,
                           header=FALSE,
                           col.names=c("year",
                                       "district",
                                       "name", 
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

# Removing observation for Germany as a whole
GermanElection <- GermanElection[-1,]

# Removing some variables
GermanElection <- GermanElection[,-c(1,3,6)]

# Changing comma as seperator for values to points
GermanElection$TurnoutPercentage <- gsub(",", ".", GermanElection$TurnoutPercentage)

# Changing the class of variables
GermanElection[,1] <- as.numeric(as.character(GermanElection[,1]))
GermanElection[,2] <- as.numeric(as.character(GermanElection[,2]))
GermanElection[,3] <- as.numeric(as.character(GermanElection[,3]))
GermanElection[,4] <- as.numeric(as.character(GermanElection[,4]))
GermanElection[,5] <- as.numeric(as.character(GermanElection[,5]))
GermanElection[,6] <- as.numeric(as.character(GermanElection[,6]))
GermanElection[,7] <- as.numeric(as.character(GermanElection[,7]))
GermanElection[,8] <- as.numeric(as.character(GermanElection[,8]))
GermanElection[,9] <- as.numeric(as.character(GermanElection[,9]))

# Removing higher political units (they are coded with numbers below 1000)
GermanElectionHamburgBerlin <- GermanElection[c(17, 365),] 
GermanElection <- GermanElection[GermanElection$district > 1000,]
GermanElection <- rbind(GermanElection, GermanElectionHamburgBerlin)
rm(GermanElectionHamburgBerlin)

# Saving the data 
write.csv(GermanElection, file = "data/GermanElection.csv")