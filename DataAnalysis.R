########################
# Lars Mehwald and Daniel Salgado Moreno
# 13 November 2015
# Assignment 3
# Data analysis
########################

# Voting data frame expands district number from 402 to 408

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

# Loading data set from csv file
DistrictData <- read.csv(file="data/DistrictData2013.csv")

# Removing ranking column (it was added in the saving process in DataMerging.R)
DistrictData <- DistrictData[,-1]

# Sourcing the merging file
# source("DataMerging.R")

########################
# Creation of relative measurements
########################

# Percentage of graduates without degree
DistrictData$GraduatesWithHouthDegreeRel <- DistrictData$GraduatesWithHouthDegreeTotal / DistrictData$TotalPopulation * 100

# Percentage of marraiged persons 
DistrictData$marriageRel <- DistrictData$HusbandAndWifeTotal / DistrictData$TotalPopulation * 100

# Percentage of male population
DistrictData$MalePopulationRel <- DistrictData$MalePopulation / DistrictData$TotalPopulation * 100

# Density per square km to 100 persons per square km
DistrictData$DensityPerSQRTkm100 <- DistrictData$DensityPerSQRTkm / 100

# Relative conservative vote
DistrictData$VoteConservativesPercent <- DistrictData$VoteConservativesTotal * 100 / 
  (DistrictData$TurnoutPercentage * DistrictData$EntitledVoteTotal / 100)
# TurnoutPercentage is coded in % between 0 and 100

# Share of young individuals
DistrictData$PopulationYoung <- 
  DistrictData$Pop0to17 + 
  DistrictData$Pop18to24

########################
# Create dependent variable:
# (non-) violent crime 
########################

# violent crime
DistrictData$CrimeViolentSum <- 
  DistrictData$bodilyHarm + 
  DistrictData$dangerousBodilyHarm +
  DistrictData$violentCrime +
  DistrictData$murderAndManslaughter +
  DistrictData$robberyIncludingExtortionAndAttackOfCarDrivers

# non-violent crime 
DistrictData$CrimeNonViolentSum <- 
  DistrictData$robberyFromOrOutOfCars + 
  DistrictData$robberyOfCars +
  DistrictData$vandalism +
  DistrictData$vandalismGraffiti +
  DistrictData$streetCrime +
  DistrictData$burglaryDaylight +
  DistrictData$burglary

########################
# Linear regression
########################

# Linear regression model 1
regression1 <- lm(CrimeViolentSum ~
                    marriageRel +
                    DensityPerSQRTkm100 +
                    PopulationYoung +
                    MalePopulationRel +
                    GraduatesWithHouthDegreeRel,
                 data=DistrictData)
summary(regression1)

# Linear regression model 2
regression2 <- lm(CrimeNonViolentSum ~ 
                    marriageRel +
                    DensityPerSQRTkm100 +
                    PopulationYoung +
                    MalePopulationRel +
                    GraduatesWithHouthDegreeRel,
                 data=DistrictData)
summary(regression2)

# Linear regression model 3
regression3 <- lm(CrimeViolentSum ~ 
                    marriageRel +
                    DensityPerSQRTkm100 +
                    PopulationYoung +
                    MalePopulationRel +
                    GraduatesWithHouthDegreeRel +
                    UnemployedPercentage,
                 data=DistrictData)
summary(regression3)

# Linear regression model 4
regression4 <- lm(CrimeNonViolentSum ~ 
                    marriageRel +
                    DensityPerSQRTkm100 +
                    PopulationYoung +
                    MalePopulationRel +
                    GraduatesWithHouthDegreeRel +
                    UnemployedPercentage,
                  data=DistrictData)
summary(regression4)

# After running regression
# regrobbery_hat <- fitted(regrobbery) #predicted values
# as.data.frame(regrobbery_hat)
# regrobbery_res <- residuals(regrobbery) #residuals 
# as.data.frame(regrobbery_res)

# Creating table output 
stargazer(regression1, regression2, regression3, regression4, 
          type = "latex",
          header = FALSE, # important not to have stargazer information in markdown file 
          title = "Regression analysis regarding (non-) violent crimes",
          digits = 2,
#          single.row = TRUE,
          omit.stat = c("f", "ser"),
          notes = "This regression output shows the results using 4 different specifications.")

rm(regression1, regression2, regression3, regression4)