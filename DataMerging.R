########################
# Lars Mehwald and Daniel Salgado Moreno
# 13 November 2015
# Assignment 3
# Loading data, merging, 
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

# Sourcing the R files that load and prepare data
source("PksKreise.R")
source("Marriage.R")
source("Graduates.R")
source("LaborMarket.R")
source("Popdensity.R")
source("PopAgeGroup.R")
source("Migration.R")
source("Religion.R")
source("Election.R")

# Merging the data frames by district
# Districts that are not matched with a corresponding district are dropped
# Only mathched observations are kept. 
CrimesMarriages2013 <- merge(PKS_Kreise_13, Marriages_2013, by="district")
CrimesMarriagesGraduates2013 <- merge(CrimesMarriages2013, Graduates, by="district")
CrimesMarriagesGraduatesLabor2013 <- merge(CrimesMarriagesGraduates2013, LaborMarket, by="district")
CrimesMarriagesGraduatesLaborPopdensity2013 <- merge(CrimesMarriagesGraduatesLabor2013, Popdensity, by="district")
CrMaGrLaPoDPoA <- merge(CrimesMarriagesGraduatesLaborPopdensity2013, PopAgeGroup, by="district")
CrMaGrLaPoDPoAMi <- merge(CrMaGrLaPoDPoA, Migration, by="district")
CrMaGrLaPoDPoAMiRe <- merge(CrMaGrLaPoDPoAMi, Religion, by="district")
CrMaGrLaPoDPoAMiReEl <- merge(CrMaGrLaPoDPoAMiRe, Election, by="district")

#Removing generated new objects to avoid confusion 
rm(CrimesMarriages2013)
rm(CrimesMarriagesGraduates2013)
rm(CrimesMarriagesGraduatesLabor2013)
rm(CrimesMarriagesGraduatesLaborPopdensity2013)
rm(CrMaGrLaPoDPoA)
rm(CrMaGrLaPoDPoAMi)
rm(CrMaGrLaPoDPoAMiRe)

# Removing individual data frames
rm(PKS_Kreise_13)
rm(Marriages_2013)
rm(Graduates)
rm(LaborMarket)
rm(Popdensity)
rm(PopAgeGroup)
rm(Migration)
rm(Religion)
rm(Election)

#Renaming Data Frame 
# ++--->> Remember to change data frame whenever a new merged data frame is added to the list above 
DistrictData <- CrMaGrLaPoDPoAMiReEl
rm(CrMaGrLaPoDPoAMiReEl)

# Generating Crime rate variable for robberies: 
# #Crimes / Total Population * 100,000
CrimeRate <- DistrictData$robbery / DistrictData$TotalPopulation * 100000

# Adding new variable Robbery Crime Rate to District Data Frame
DistrictData <- cbind(DistrictData, CrimeRate)

# Removing redundant variables (year variables)
DistrictData <- DistrictData[,-c(4,10,12,19)]

# Rearranging variable order: bringin Year to the 2 position
# +++++++ ---->>>> Remember to add new columns dependening on the number of new variables added. 
DistrictData <- DistrictData[,c(1,29,2:28,30:44)]

# Saving the data
write.csv(DistrictData, file = "data/DistrictData2013.csv")

