########################
# Lars Mehwald and Daniel Salgado Moreno
# 13 November 2015
# Assignment 3
# Population Age as percentage of total population
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

popagegroup <- read.csv(file="data/PopAge.csv",
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
                                        "Pop_over_65"
                          ))

# Removing not relevant rows
popagegroup <- popagegroup[-c(524:530),]

# Saving Berlin and Hamburg and removing all regional observations
#Berlin 364 and Hamburg 16
popagegroupBerHam <- popagegroup[c(16,364),]
popagegroup <- popagegroup[popagegroup$district > 1000,]
popagegroup <- rbind(popagegroup, popagegroupBerHam)
rm(popagegroupBerHam)

# Preparing for merging: deleting some columns 
popagegroup <- popagegroup[,-c(1,3)]

#saving population groups data frame 
write.csv(popagegroup, file = "data/PopAgeGroup.csv")

