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
DATA <- read.csv(file="data/DistrictDataCrimeRate2013.csv")

########################
# Creation of relative measurements
########################

# Percentage of robbery (could be more than 100%)
DATA$robberyRel <- DATA$robbery / DATA$TotalPopulation * 100

# Percentage of graduates without degree
DATA$GraduatesWithHouthDegreeRel <- DATA$GraduatesWithHouthDegreeTotal / DATA$TotalPopulation * 100

# Percentage of marraiged persons 
DATA$marriageRel <- DATA$HusbandAndWifeTotal / DATA$TotalPopulation * 100

# Percentage of male population
DATA$MalePopulationRel <- DATA$MalePopulation / DATA$TotalPopulation * 100

########################
# Linear regression
########################

# Linear regression model 1
regrobbery1 <- lm(robberyRel ~ 
                   GraduatesWithHouthDegreeRel + 
                   marriageRel,
                 data=DATA)
summary(regrobbery1)

# Linear regression model 2
regrobbery2 <- lm(robberyRel ~ 
                   GraduatesWithHouthDegreeRel + 
                   marriageRel +
                   UnemployedPercentage,
                 data=DATA)
summary(regrobbery2)

# Linear regression model 3
regrobbery3 <- lm(robberyRel ~ 
                   GraduatesWithHouthDegreeRel + 
                   marriageRel +
                   UnemployedPercentage +
                   DensityPerSQRTkm,
                 data=DATA)
summary(regrobbery3)

# Linear regression model 4
regrobbery4 <- lm(robberyRel ~ 
                    GraduatesWithHouthDegreeRel + 
                    marriageRel +
                    UnemployedPercentage +
                    DensityPerSQRTkm +
                    MalePopulationRel,
                  data=DATA)
summary(regrobbery4)

# After running regression
# regrobbery_hat <- fitted(regrobbery) #predicted values
# as.data.frame(regrobbery_hat)
# regrobbery_res <- residuals(regrobbery) #residuals 
# as.data.frame(regrobbery_res)

# Creating table output 
stargazer(regrobbery1, regrobbery2, regrobbery3, regrobbery4,
          type = "latex",
          header = FALSE, # important not to have stargazer information in markdown file 
          title = "Regression analysis regarding robbery",
          digits = 2)

rm(regrobbery1, regrobbery2, regrobbery3, regrobbery4)