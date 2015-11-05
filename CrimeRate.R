########################
# Lars Mehwald and Daniel Salgado Moreno
# 13 November 2015
# Assignment 3
# Crime rates 
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

# Loading the merged data frame
DistrictData <- read.csv (file = "data/mergedDistrictCrime2013.csv")

# Remove automatic generated "x" variable in the first column.
DistrictData <- DistrictData[,-c(1)]

# Generating Crime rate variable: 
# #Crimes / Total Population * 100,000
CrimeRate <- DistrictData$robbery / DistrictData$TotalPopulation * 100000

# Adding new variable Crime Rate to District Data Frame
DistrictData <- cbind(DistrictData, CrimeRate)

# Saving data
write.csv(DistrictData, file= "data/DistrictDataCrimeRate2013.csv")

