########################
# Lars Mehwald and Daniel Salgado Moreno
# 13 November 2015
# Assignment 3
# Data analysis
########################

# Voting data frame expands district number from 402 to 408

# We need a better measure for (non) education: 
# Graduates Without Degree has too little variation
# Alternatively, use an aggregated measure for Proportion of graduates with 
# Hochschulreife vs Proportion without Hauptschulabschluss 

# Loading required packages 
Packages <- c("rio", "dplyr", "tidyr", "repmis", "httr", "knitr", "ggplot2",
              "xtable", "stargazer", "texreg", "lmtest", "sandwich", "Zelig",
              "ggmap", "rworldmap")
lapply(Packages, require, character.only = TRUE) 

# Setting the commonly used working directory
possible_dir <- c('D:/Eigene Dokumente/!1 Vorlesungen/!! WS 2015/Introduction to 
                  Collaborative Social Science Data Analysis/Assignment3', 
                  '~/HSoG/DataAnalysis/GitHub/Assignment3')
set_valid_wd(possible_dir)
rm(possible_dir)

# Citing R packages 
LoadandCite(Packages, file = 'References/RpackageCitations.bib')
rm(Packages)

# Loading data set from csv file
DistrictData <- read.csv(file="Analysis/data/DistrictData2013.csv")

# Removing ranking column (it was added in the saving process in DataMerging.R)
DistrictData <- DistrictData[,-1]

# Sourcing the merging file
# source("DataMerging.R")

########################
# Creation of relative measurements
########################

# Percentage of marraiged persons 
DistrictData$marriageRel <- 
  DistrictData$HusbandAndWifeTotal / 
  DistrictData$TotalPopulation * 100

# Percentage of male population
DistrictData$MalePopulationRel <- 
  DistrictData$MalePopulation / 
  DistrictData$TotalPopulation * 100

# Density per square km to 100 persons per square km
DistrictData$DensityPerSQRTkm100 <- 
  DistrictData$DensityPerSQRTkm / 100

# Relative conservative vote
DistrictData$VoteConservativesPercent <- 
  DistrictData$VoteConservativesTotal * 100 / 
  (DistrictData$TurnoutPercentage * DistrictData$EntitledVoteTotal / 100)
# TurnoutPercentage is coded in % between 0 and 100

# Share of young individuals
DistrictData$PopulationYoung <- 
  DistrictData$Pop0to17 + 
  DistrictData$Pop18to24

# Share of Protestants and Roman Catholics 
# Problematic: rates are significant lower in former East Germany 
DistrictData$BelieversPercent <- 
  (DistrictData$BelieversProtestant +
  DistrictData$BelieversRomanCatholic) * 100 /
  DistrictData$BelieversTotal

# Population flow
DistrictData$FlowPercent <- 
  (DistrictData$InfluxTotal +
  DistrictData$OutflowTotal) * 100 /
  DistrictData$TotalPopulation

########################
# Create composite dependent variable:
# (non-) violent and total crime 
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

# total crimes
DistrictData$CrimeTotalSum <- 
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

########################
# Linear regression
########################

# Getting rid of Berlin and Hamburg (outliers?)
# DistrictData <- DistrictData[-c(1,2),]

# Linear regression model 1
regression1 <- lm(CrimeViolentSum ~
                    marriageRel +
                    DensityPerSQRTkm100 +
                    PopulationYoung +
                    MalePopulationRel +
                    UnemployedPercentage,
                 data=DistrictData)
summary(regression1)

# Linear regression model 2
regression2 <- lm(CrimeNonViolentSum ~ 
                    marriageRel +
                    DensityPerSQRTkm100 +
                    PopulationYoung +
                    MalePopulationRel +
                    UnemployedPercentage,
                 data=DistrictData)
summary(regression2)

# Linear regression model 3
regression3 <- lm(CrimeTotalSum ~ 
                    marriageRel +
                    DensityPerSQRTkm100 +
                    PopulationYoung +
                    MalePopulationRel +
                    UnemployedPercentage,
                  data=DistrictData)
summary(regression3)

# Linear regression model 4
regression4 <- lm(CrimeViolentSum ~ 
                    BelieversPercent + 
                    DensityPerSQRTkm100 +
                    PopulationYoung +
                    MalePopulationRel +
                    UnemployedPercentage,
                 data=DistrictData)
summary(regression4)

# Linear regression model 5
regression5 <- lm(CrimeNonViolentSum ~ 
                    BelieversPercent + 
                    DensityPerSQRTkm100 +
                    PopulationYoung +
                    MalePopulationRel +
                    UnemployedPercentage,
                  data=DistrictData)
summary(regression5)

# Linear regression model 6
regression6 <- lm(CrimeTotalSum ~ 
                    BelieversPercent + 
                    DensityPerSQRTkm100 +
                    PopulationYoung +
                    MalePopulationRel +
                    UnemployedPercentage,
                  data=DistrictData)
summary(regression6)

# Linear regression model 7
regression7 <- lm(CrimeViolentSum ~ 
                    FlowPercent +
                    DensityPerSQRTkm100 +
                    PopulationYoung +
                    MalePopulationRel +
                    UnemployedPercentage,
                  data=DistrictData)
summary(regression7)

# Linear regression model 8
regression8 <- lm(CrimeNonViolentSum ~ 
                    FlowPercent + 
                    DensityPerSQRTkm100 +
                    PopulationYoung +
                    MalePopulationRel +
                    UnemployedPercentage,
                  data=DistrictData)
summary(regression8)

# Linear regression model 9
regression9 <- lm(CrimeTotalSum ~ 
                    FlowPercent + 
                    DensityPerSQRTkm100 +
                    PopulationYoung +
                    MalePopulationRel +
                    UnemployedPercentage,
                  data=DistrictData)
summary(regression9)

# Linear regression model 10
regression10 <- lm(CrimeViolentSum ~ 
                    TurnoutPercentage +
                    DensityPerSQRTkm100 +
                    PopulationYoung +
                    MalePopulationRel +
                    UnemployedPercentage,
                  data=DistrictData)
summary(regression10)

# Linear regression model 11
regression11 <- lm(CrimeNonViolentSum ~ 
                    TurnoutPercentage + 
                    DensityPerSQRTkm100 +
                    PopulationYoung +
                    MalePopulationRel +
                    UnemployedPercentage,
                  data=DistrictData)
summary(regression11)

# Linear regression model 12
regression12 <- lm(CrimeTotalSum ~ 
                    TurnoutPercentage + 
                    DensityPerSQRTkm100 +
                    PopulationYoung +
                    MalePopulationRel +
                    UnemployedPercentage,
                  data=DistrictData)
summary(regression12)

# Linear regression model 13
regression13 <- lm(CrimeViolentSum ~ 
                     FoundationsTotal + 
                     TurnoutPercentage +
                     BelieversPercent +
                     FlowPercent + 
                     DensityPerSQRTkm100 +
                     PopulationYoung +
                     MalePopulationRel +
                     UnemployedPercentage,
                   data=DistrictData)
summary(regression13)

# Linear regression model 14
regression14 <- lm(CrimeNonViolentSum ~ 
                     FoundationsTotal + 
                     TurnoutPercentage +
                     BelieversPercent +
                     FlowPercent + 
                     DensityPerSQRTkm100 +
                     PopulationYoung +
                     MalePopulationRel +
                     UnemployedPercentage,
                   data=DistrictData)
summary(regression14)

# Linear regression model 15
regression15 <- lm(CrimeTotalSum ~ 
                     FoundationsTotal + 
                     TurnoutPercentage +
                     BelieversPercent +
                     FlowPercent + 
                     DensityPerSQRTkm100 +
                     PopulationYoung +
                     MalePopulationRel +
                     UnemployedPercentage,
                   data=DistrictData)
summary(regression15)

# Linear regression model 16
regression16 <- lm(CrimeViolentSum ~ 
                     marriageRel + 
                     TurnoutPercentage +
                     BelieversPercent +
                     FlowPercent +
                     FoundationsTotal +
                     DensityPerSQRTkm100 +
                     PopulationYoung +
                     MalePopulationRel +
                     UnemployedPercentage,
                   data=DistrictData)
summary(regression16)

# Linear regression model 17
regression17 <- lm(CrimeNonViolentSum ~ 
                     marriageRel + 
                     TurnoutPercentage +
                     BelieversPercent +
                     FlowPercent + 
                     FoundationsTotal + 
                     DensityPerSQRTkm100 +
                     PopulationYoung +
                     MalePopulationRel +
                     UnemployedPercentage,
                   data=DistrictData)
summary(regression17)

# Linear regression model 18
regression18 <- lm(CrimeTotalSum ~ 
                     marriageRel + 
                     TurnoutPercentage +
                     BelieversPercent +
                     FlowPercent + 
                     FoundationsTotal + 
                     DensityPerSQRTkm100 +
                     PopulationYoung +
                     MalePopulationRel +
                     UnemployedPercentage,
                   data=DistrictData)
summary(regression18)

# After running regression
# regrobbery_hat <- fitted(regrobbery) #predicted values
# as.data.frame(regrobbery_hat)
# regrobbery_res <- residuals(regrobbery) #residuals 
# as.data.frame(regrobbery_res)

# Creating table output 
stargazer(regression1, regression2, regression3, 
          type = "latex",
          header = FALSE, # important not to have stargazer information in markdown file 
          title = "Regression analysis regarding (non-) violent 
          and total crimes and independent variable marriage",
          digits = 2,
          omit.stat = c("f", "ser"),
          notes = "This regression output shows the results using 3 different 
          dependent variables")

stargazer(regression4, regression5, regression6, 
          type = "latex",
          header = FALSE, # important not to have stargazer information in markdown file 
          title = "Regression analysis regarding (non-) violent and total crimes 
          and independent variable religion",
          digits = 2,
          omit.stat = c("f", "ser"),
          notes = "This regression output shows the results using 3 different 
          dependent variables")

stargazer(regression7, regression8, regression9, 
          type = "latex",
          header = FALSE, # important not to have stargazer information in markdown file 
          title = "Regression analysis regarding (non-) violent and total crimes 
          and independent variable in- and outflow",
          digits = 2,
          omit.stat = c("f", "ser"),
          notes = "This regression output shows the results using 3 different 
          dependent variables")

stargazer(regression10, regression11, regression12, 
          type = "latex",
          header = FALSE, # important not to have stargazer information in markdown file 
          title = "Regression analysis regarding (non-) violent and total crimes 
          and independent variable voter turnout",
          digits = 2,
          omit.stat = c("f", "ser"),
          notes = "This regression output shows the results using 3 different 
          dependent variables")

stargazer(regression13, regression14, regression15, 
          type = "latex",
          header = FALSE, # important not to have stargazer information in markdown file 
          title = "Regression analysis regarding (non-) violent and total crimes 
          and independent variable foundation",
          digits = 2,
          omit.stat = c("f", "ser"),
          notes = "This regression output shows the results using 3 different 
          dependent variables")

stargazer(regression16, regression17, regression18, 
          type = "latex",
          header = FALSE, # important not to have stargazer information in markdown file 
          title = "Regression analysis regarding (non-) violent and total crimes 
          and all independent variables at the same time",
          digits = 2,
          omit.stat = c("f", "ser"),
          notes = "This regression output shows the results using 3 different 
          dependent variables")

# Removing regression results 
rm(regression1, regression2, regression3, regression4, regression5, regression6, 
   regression7, regression8, regression9, regression10, regression11, regression12,
   regression13, regression14, regression15, regression16, regression17, regression18)
