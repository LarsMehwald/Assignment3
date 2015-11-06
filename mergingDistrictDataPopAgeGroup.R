########################
# Lars Mehwald and Daniel Salgado Moreno
# 13 November 2015
# Assignment 3
# Merging District socioeconomic and crime data with popultaion age groups
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

# Loading merged data
DistrictData <- read.csv (file="data/DistrictDataCrimeRate2013.csv")

# Loading PopAgeGroup Data 
popagegroup <- read.csv(file="data/PopAgeGroup.csv")

#Merging Data
mergedDistrictData <- merge(DistrictData, popagegroup, by="district")

#Removing some automatic generated columns: 
mergedDistrictData <- mergedDistrictData[,-c(2,26)]

# Saving Data Frame 
write.csv(mergedDistrictData, file="data/DistrictDataPopAgeGroup.csv")


