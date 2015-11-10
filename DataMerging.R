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
source("data/Foundations.R")

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

# Merging the District Data with the Foundation Data
# Both variables need to be character variables 
dist.name <- 
  adist(DistrictData$DistrictName, 
        Foundations$district, 
        partial = TRUE, 
        ignore.case = TRUE)

min.name <- 
  apply(dist.name, 1, min)
# apply(X, MARGIN, FUN, ...)
# Margin = 1 in a data frame means that function is apllied over rows

match.s1.s2 <- NULL  
for(i in 1:nrow(dist.name))
{
  s2.i <- match(min.name[i],dist.name[i,])
  s1.i <- i
  match.s1.s2 <- 
    rbind(data.frame(s2.i=s2.i, 
                     s1.i=s1.i, 
                     s2name=Foundations[s2.i,]$district, 
                     s1name=DistrictData[s1.i,]$DistrictName, 
                     adist=min.name[i]), 
          match.s1.s2)
}

rm("i", "min.name", "s1.i", "s2.i")

# Creation of ranks within data frames: DistrictData = s1, Foundations = s2
DistrictData$Rank <- 1:401
DistrictData <- DistrictData[,c(47,1:46)]

Foundations$Rank <- 1:402
Foundations <- Foundations[,c(4,1:3)]

# Merging the two data frames
MergedWithFoundations <- 
  merge(match.s1.s2, 
        Foundations, 
        by.x=c("s2.i"), 
        by.y=c("Rank")
        )

MergedWithFoundationsAndDistrictData <- 
  merge(MergedWithFoundations, 
        DistrictData, 
        by.x=c("s1.i"), 
        by.y=c("Rank")
  )

# Updating the DistrictData frame
DistrictData <- MergedWithFoundationsAndDistrictData
DistrictData <- DistrictData[,-c(1:6)]

# Removing redundant data frames
rm(MergedWithFoundations, MergedWithFoundationsAndDistrictData)
rm(Foundations)
rm(dist.name, match.s1.s2)

# Saving the data
write.csv(DistrictData, file = "data/DistrictData2013.csv")

