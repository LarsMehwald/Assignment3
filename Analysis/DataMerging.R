########################
# Lars Mehwald and Daniel Salgado Moreno
# 13 November 2015
# Assignment 3
# Merging all data frames, creating new analysis variables.
########################

# Loading required packages 
Packages <- c("rio", "dplyr", "tidyr", "repmis", "httr", "knitr", "ggplot2",
              "xtable", "stargazer", "texreg", "lmtest", "sandwich", "Zelig",
              "ggmap", "rworldmap","car", "MASS", "PerformanceAnalytics", "pscl", "AER")
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
source("Analysis/data/PksKreise.R")
source("Analysis/data/Marriage.R")
#source("Analysis/data/Graduates.R")
source("Analysis/data/Graduates2.R")
source("Analysis/data/LaborMarket.R")
source("Analysis/data/Popdensity.R")
source("Analysis/data/PopAgeGroup.R")
source("Analysis/data/Migration.R")
source("Analysis/data/Religion.R")
source("Analysis/data/Election.R")
source("Analysis/data/Foundations2.R")
source("Analysis/data/Foreigners.R")

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
CrMaGrLaPoDPoAMiReElFo <- merge(CrMaGrLaPoDPoAMiReEl, Foundations, by="district")
CrMaGrLaPoDPoAMiReElFoFrg <- merge(CrMaGrLaPoDPoAMiReElFo, Foreigners, by="district")

# Removing generated new objects to avoid confusion 
rm(CrimesMarriages2013)
rm(CrimesMarriagesGraduates2013)
rm(CrimesMarriagesGraduatesLabor2013)
rm(CrimesMarriagesGraduatesLaborPopdensity2013)
rm(CrMaGrLaPoDPoA)
rm(CrMaGrLaPoDPoAMi)
rm(CrMaGrLaPoDPoAMiRe)
rm(CrMaGrLaPoDPoAMiReEl)
rm(CrMaGrLaPoDPoAMiReElFo)

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
rm(Foundations)
rm(Foreigners)

# Renaming data frame 
# Remember to change data frame whenever a new merged data frame is added to the list above 
DistrictData <- CrMaGrLaPoDPoAMiReElFoFrg
rm(CrMaGrLaPoDPoAMiReElFoFrg)

# Generating Crime rate variable for robberies: 
# Crimes / Total Population * 100,000
#CrimeRate <- DistrictData$robbery / DistrictData$TotalPopulation * 100000

# Adding new variable Robbery Crime Rate to District Data Frame
#DistrictData <- cbind(DistrictData, CrimeRate)
#rm(CrimeRate)

# Removing redundant variables (year variables)
DistrictData <- DistrictData[,-c(17,19,22,36,53)]

# Renaming year variable (from year.x)
names(DistrictData)[3] <- "year"

########################
# Creation of relative measurements
########################

# Marraig rate: Number of marriages per 100,000 inhabitants 
DistrictData$MarriageRate <- 
  (DistrictData$HusbandAndWifeTotal / 
     DistrictData$TotalPopulation) * 100000

# Proportion of male population
DistrictData$MaleRate <- 
  (DistrictData$MalePopulation / 
     DistrictData$TotalPopulation) * 100

# Density per square km to 100 persons per square km ## Not necesassry 
# DistrictData$DensityPerSQRTkm100 <- 
# DistrictData$DensityPerSQRTkm / 100

# Relative conservative vote  
### Not required, we can use TurnoutPercentage as a very solid measure of political participation
#DistrictData$VoteConservativesPercent <- 
# DistrictData$VoteConservativesTotal * 100 / 
# (DistrictData$TurnoutPercentage * DistrictData$EntitledVoteTotal / 100)
# TurnoutPercentage is coded in % between 0 and 100

# Share of young individuals # I don't think we should include 0-17. Very low probability of child comiting crimes. 
# Youth Rate is a better control variable
DistrictData$YouthRate <- 
  (DistrictData$Pop18to24 / 
     DistrictData$TotalPopulation) * 100000

# Share of Believers
# Problematic: rates are significant lower in former East Germany 
#DistrictData$BelieversRate <- 
 # (DistrictData$BelieversTotal / 
  #   DistrictData$TotalPopulation) * 100000

# Share of Foreigners per District
DistrictData$ForeignerRate <-
  (DistrictData$ForeignersTotal /
     DistrictData$TotalPopulation) * 100000

# Total Mobility rate 
DistrictData$FlowRate <- 
  ((DistrictData$InfluxTotal +
      DistrictData$OutflowTotal) /
     DistrictData$TotalPopulation) * 100000

########################
# Create composite dependent variable:
# (non-) violent and total crime 
########################

# rate of murder and manslaughter 
DistrictData$MurderRate <- 
  (DistrictData$murderAndManslaughter / 
     DistrictData$TotalPopulation) * 100000
# Showing the districts with a rate higher than 10
# DistrictData[DistrictData$MurderRate > 10,c(2,55)]

# violent crime
DistrictData$CrimeViolent <- 
# DistrictData$bodilyHarm + 
  DistrictData$dangerousBodilyHarm +
# DistrictData$violentCrime +
  DistrictData$murderAndManslaughter

# violent crime rate
DistrictData$ViolentCrimeRate <- 
  (DistrictData$CrimeViolent / 
     DistrictData$TotalPopulation) * 100000

# non-violent crime 
DistrictData$CrimeNonViolent <- 
  DistrictData$robberyFromOrOutOfCars + 
  DistrictData$robberyOfCars +
  DistrictData$vandalism +
  DistrictData$vandalismGraffiti +
  DistrictData$streetCrime +
  DistrictData$burglaryDaylight +
  DistrictData$burglary +
  DistrictData$robberyIncludingExtortionAndAttackOfCarDrivers

# Non-violent crime rate
DistrictData$NonViolentCrimeRate <- 
  (DistrictData$CrimeNonViolent / 
     DistrictData$TotalPopulation) * 100000

# total crimes
DistrictData$CrimeTotal <- 
  DistrictData$bodilyHarm + 
  DistrictData$dangerousBodilyHarm +
  DistrictData$violentCrime +
  DistrictData$murderAndManslaughter +
  DistrictData$robberyIncludingExtortionAndAttackOfCarDrivers +
  DistrictData$robberyFromOrOutOfCars + 
  DistrictData$robberyOfCars +
  DistrictData$vandalism +
  DistrictData$vandalismGraffiti +
  DistrictData$streetCrime +
  DistrictData$burglaryDaylight +
  DistrictData$burglary

# Total crime rate
DistrictData$CrimeRate <- 
  (DistrictData$CrimeTotal / 
     DistrictData$TotalPopulation) * 100000

########################
# log variables for IV
########################

# Foundations
DistrictData$FoundationsDensity100kLog <- 
  log(DistrictData$FoundationsDensity100k)

# Flow
DistrictData$FlowRateLog <- 
  log(DistrictData$FlowRate)

# Voter turnout
DistrictData$TurnoutPercentageLog <- 
  log(DistrictData$TurnoutPercentage)

########################
# Categorical variables for IV
########################



########################
# Omiting Observations with missing values
########################

DistrictData <- na.omit(DistrictData)

########################
# Saving the data
########################

write.csv(DistrictData, file = "Analysis/data/DistrictData2013.csv")

