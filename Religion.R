########################
# Lars Mehwald and Daniel Salgado Moreno
# 13 November 2015
# Assignment 3
# Loading Religion data
########################

# Setting the commonly used working directory
possible_dir <- c('D:/Eigene Dokumente/!1 Vorlesungen/!! WS 2015/Introduction to Collaborative Social Science Data Analysis/Assignment3', 
                  '~/HSoG/DataAnalysis/GitHub/Assignment3')
set_valid_wd(possible_dir)
rm(possible_dir)

# Loading requires packages 
library("tidyr")

# Reading Religion 2011 csv file 
Religion <- read.csv(file="data/160-04-4_Religion_2011.csv", 
                           sep=";", 
                           na.strings = c("-","."),
                           nrows = 2100,
                           skip = 9,
                           header=FALSE,
                           col.names=c("district",
                                       "name", 
                                       "religion",
                                       "BelieversTotal",
                                       "BelieversMale",
                                       "BelieversFemale",
                                       "BelieversGermans",
                                       "BelieversForeigners")
                     )

# Removing observation for Germany as a whole
Religion <- Religion[-c(1:4),]

# Removing variables
Religion <- Religion[,-c(2,5:8)]

# Changing the class of Variables 
Religion[,1] <- as.numeric(as.character(Religion[,1]))
Religion[,3] <- as.numeric(as.character(Religion[,3]))

# Spreading the data 
Religion <- spread(Religion, "religion", "BelieversTotal")

# Problem with Hamburg and Berlin: recoding
ReligionBerHam <- Religion[c(2, 11),]
Religion <- Religion[Religion$district > 1000,]
Religion <- rbind(Religion, ReligionBerHam)
rm(ReligionBerHam)

# Saving the data
write.csv(Religion, file = "data/Religion.csv")
