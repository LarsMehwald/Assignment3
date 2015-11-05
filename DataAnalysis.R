########################
# Lars Mehwald and Daniel Salgado Moreno
# 13 November 2015
# Assignment 3
# Creating maps with geocoding and geolocation
########################

# Loading required packages 
Packages <- c("rio", "dplyr", "tidyr", "repmis", "httr", "knitr", "ggplot2",
              "xtable", "stargazer", "texreg", "lmtest", "sandwich", "Zelig",
              "ggmap", "rworldmap")
lapply(Packages, require, character.only = TRUE, suppressPackageStartupMessages)

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
CrimesMarriagesGraduatesLabor2013 <- read.csv(file="data/CrimesMarriagesGraduatesLabor2013.csv")

########################
# Linear regression
########################

# Linear regression model 
regrobbery <- lm(robbery ~ 
                   GraduatesWithHouthDegreeTotal + 
                   HusbandAndWifeTotal +
                   UnemployedPercentage, 
                 data=CrimesMarriagesGraduatesLabor2013)
summary(regrobbery)

# After running regression
# regrobbery_hat <- fitted(regrobbery) #predicted values
# as.data.frame(regrobbery_hat)
# regrobbery_res <- residuals(regrobbery) #residuals 
# as.data.frame(regrobbery_res)

# Creating table output 
stargazer(regrobbery, 
          type = "latex",
          title = "",
          digits = 2)

rm(regrobbery)