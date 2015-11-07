########################
# Lars Mehwald and Daniel Salgado Moreno
# 13 November 2015
# Assignment 3
# Data analysis
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

# Loading data set from csv file
DistrictData <- read.csv(file="data/DistrictData2013.csv")

# Sourcing the merging file
# source("DataMerging.R")

########################
# Creation of relative measurements
########################

# Percentage of robbery (could be more than 100%)
DistrictData$robberyRel <- DistrictData$robbery / DistrictData$TotalPopulation * 100

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

########################
# Linear regression
########################

# Linear regression model 1
regrobbery1 <- lm(robbery ~ 
                   GraduatesWithHouthDegreeRel + 
                   marriageRel,
                 data=DistrictData)
summary(regrobbery1)

# Linear regression model 2
regrobbery2 <- lm(robbery ~ 
                   GraduatesWithHouthDegreeRel + 
                   marriageRel +
                   UnemployedPercentage,
                 data=DistrictData)
summary(regrobbery2)

# Linear regression model 3
regrobbery3 <- lm(robbery ~ 
                   GraduatesWithHouthDegreeRel + 
                   marriageRel +
                   UnemployedPercentage +
                   DensityPerSQRTkm100,
                 data=DistrictData)
summary(regrobbery3)

# Linear regression model 4
regrobbery4 <- lm(robbery ~ 
                    GraduatesWithHouthDegreeRel + 
                    marriageRel +
                    UnemployedPercentage +
                    DensityPerSQRTkm100 +
                    MalePopulationRel,
                  data=DistrictData)
summary(regrobbery4)

# Linear regression model 5
regrobbery5 <- lm(robbery ~ 
                    GraduatesWithHouthDegreeRel + 
                    marriageRel +
                    UnemployedPercentage +
                    DensityPerSQRTkm100 +
                    MalePopulationRel + 
                    VoteConservativesPercent,
                  data=DistrictData)
summary(regrobbery4)

# After running regression
# regrobbery_hat <- fitted(regrobbery) #predicted values
# as.data.frame(regrobbery_hat)
# regrobbery_res <- residuals(regrobbery) #residuals 
# as.data.frame(regrobbery_res)

# Creating table output 
stargazer(regrobbery1, regrobbery2, regrobbery3, regrobbery4, regrobbery5, 
          type = "latex",
          header = FALSE, # important not to have stargazer information in markdown file 
          title = "Regression analysis regarding robbery",
          digits = 2,
#          single.row = TRUE,
          omit.stat = c("f", "ser"),
          notes = "This regression output shows the results using 5 different specifications.")

rm(regrobbery1, regrobbery2, regrobbery3, regrobbery4, regrobbery5)