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

# Citing R packages 
LoadandCite(Packages, file = 'References/RpackageCitations.bib')
rm(Packages)

# Sourcing the R files that load and prepare data
source("data/PksKreise.R")
source("data/Marriage.R")
#source("data/Graduates.R")
source("data/Graduates2.R")
source("data/LaborMarket.R")
source("data/Popdensity.R")
source("data/PopAgeGroup.R")
source("data/Migration.R")
source("data/Religion.R")
source("data/Election.R")

# Merging the data frames by district
# Districts that are not matched with a corresponding district are dropped
# Only mathched observations are kept. 
CrimesMarriages2013 <- merge(PKS_Kreise_13, Marriages, by="district")
#CrimesMarriagesGraduates2013 <- merge(CrimesMarriages2013, Graduates, by="district")
CrimesMarriagesGraduates2013 <- merge(CrimesMarriages2013, Graduates2, by="district")
CrimesMarriagesGraduatesLabor2013 <- merge(CrimesMarriagesGraduates2013, LaborMarket, by="district")
CrimesMarriagesGraduatesLaborPopdensity2013 <- merge(CrimesMarriagesGraduatesLabor2013, Popdensity, by="district")
CrMaGrLaPoDPoA <- merge(CrimesMarriagesGraduatesLaborPopdensity2013, PopAgeGroup, by="district")
CrMaGrLaPoDPoAMi <- merge(CrMaGrLaPoDPoA, Migration, by="district")
CrMaGrLaPoDPoAMiRe <- merge(CrMaGrLaPoDPoAMi, Religion, by="district")
CrMaGrLaPoDPoAMiReEl <- merge(CrMaGrLaPoDPoAMiRe, Election, by="district")

# Removing generated new objects to avoid confusion 
rm(CrimesMarriages2013)
rm(CrimesMarriagesGraduates2013)
rm(CrimesMarriagesGraduatesLabor2013)
rm(CrimesMarriagesGraduatesLaborPopdensity2013)
rm(CrMaGrLaPoDPoA)
rm(CrMaGrLaPoDPoAMi)
rm(CrMaGrLaPoDPoAMiRe)

# Removing individual data frames
rm(PKS_Kreise_13)
rm(Marriages)
#rm(Graduates)
rm(Graduates2)
rm(LaborMarket)
rm(Popdensity)
rm(PopAgeGroup)
rm(Migration)
rm(Religion)
rm(Election)

# Renaming data frame 
# Remember to change data frame whenever a new merged data frame is added to the list above 
DistrictData <- CrMaGrLaPoDPoAMiReEl
rm(CrMaGrLaPoDPoAMiReEl)

# Generating Crime rate variable for robberies: 
# Crimes / Total Population * 100,000
#CrimeRate <- DistrictData$robbery / DistrictData$TotalPopulation * 100000

# Adding new variable Robbery Crime Rate to District Data Frame
#DistrictData <- cbind(DistrictData, CrimeRate)
#rm(CrimeRate)

# Removing redundant variables (year variables)
DistrictData <- DistrictData[,-c(17,19,22,36)]

# Renaming year variable (from year.x)
names(DistrictData)[3] <- "year"

# Saving the data
write.csv(DistrictData, file = "data/DistrictData2013.csv")

