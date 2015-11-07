########################
# Lars Mehwald and Daniel Salgado Moreno
# 13 November 2015
# Assignment 3
# Population Age as percentage of total population
########################

# Loading required packages 
library("repmis")

# Setting the commonly used working directory
possible_dir <- c('D:/Eigene Dokumente/!1 Vorlesungen/!! WS 2015/Introduction to Collaborative Social Science Data Analysis/Assignment3', 
                  '~/HSoG/DataAnalysis/GitHub/Assignment3')
set_valid_wd(possible_dir)
rm(possible_dir)

# Loading the data
PopAgeGroup <- read.csv(file="data/RawData/PopAgeRawData.csv",
                          sep=",", 
                          dec=",",
                          na.strings=c("."), 
                          header = FALSE,
                          skip=7,
                          nrows = 530, 
                          col.names = c("year", 
                                        "district", 
                                        "DistrictName", 
                                        "Pop_0_17", 
                                        "Pop_18_24", 
                                        "Pop_25_44", 
                                        "Pop_45_64", 
                                        "Pop_over_65")
                          )

# Removing not relevant rows
PopAgeGroup <- PopAgeGroup[-c(524:530),]

# Saving Berlin and Hamburg and removing all regional observations
#Berlin 364 and Hamburg 16
PopAgeGroupBerHam <- PopAgeGroup[c(16,364),]
PopAgeGroup <- PopAgeGroup[PopAgeGroup$district > 1000,]
PopAgeGroup <- rbind(PopAgeGroup, PopAgeGroupBerHam)
rm(PopAgeGroupBerHam)

# Preparing for merging: deleting some columns 
PopAgeGroup <- PopAgeGroup[,-c(1,3)]

# Changing the class of Variables 
PopAgeGroup[,1] <- as.numeric(as.character(PopAgeGroup[,1]))
PopAgeGroup[,2] <- as.numeric(as.character(PopAgeGroup[,2]))
PopAgeGroup[,3] <- as.numeric(as.character(PopAgeGroup[,3]))
PopAgeGroup[,4] <- as.numeric(as.character(PopAgeGroup[,4]))
PopAgeGroup[,5] <- as.numeric(as.character(PopAgeGroup[,5]))
PopAgeGroup[,6] <- as.numeric(as.character(PopAgeGroup[,6]))

#saving population groups data frame 
write.csv(PopAgeGroup, file = "data/PopAgeGroup.csv")

