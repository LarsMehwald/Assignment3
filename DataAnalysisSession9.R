########################
# Lars Mehwald and Daniel Salgado Moreno
# 13 November 2015
# Assignment 3
# Loading data, merging, 
# analyses
########################

# Loading required packages 
library("rio")
library("dplyr")
library("tidyr")
library("repmis")
library("httr")
library("knitr")
library("ggplot2")
library("xtable")
library("stargazer")
library("texreg")
library("lmtest")
library("sandwich")
library("Zelig") # capital letter Z

# Setting the commonly used working directory
possible_dir <- c('D:/Eigene Dokumente/!1 Vorlesungen/!! WS 2015/Introduction to Collaborative Social Science Data Analysis/Assignment3', 
                  '~/HSoG/DataAnalysis/GitHub/Assignment3')
set_valid_wd(possible_dir)
rm(possible_dir)
# setwd("D:/Eigene Dokumente/!1 Vorlesungen/!! WS 2015/Introduction to Collaborative Social Science Data Analysis/Assignment3")

# Citing R packages 
pkgs <- c('dplyr', 
          'ggplot2', 
          'rio', 
          'tidyr', 
          'repmis', 
          'httr',
          'knitr',
          'xtable',
          'stargazer',
          'texreg',
          'lmtest',
          'sandwich',
          'Zelig')
LoadandCite(pkgs, file = 'References/RpackageCitations.bib')
rm(pkgs)

# Sourcing the R files that load and prepare data
source("PksKreise.R")
source("Marriage.R")
source("Graduates.R")

# Merging the data frames by district
# Districts that have no corresponding district are dropped
CrimesMarriages2013 <- merge(PKS_Kreise_13, Marriages_2013, by="district")
CrimesMarriagesGraduates2013 <- merge(CrimesMarriages2013, Graduates, by="district")
rm(CrimesMarriages2013)

# Removing individual data frames
rm(Graduates)
rm(Marriages_2013)
rm(PKS_Kreise_13)

# Removing redundant variables
CrimesMarriagesGraduates2013 <- CrimesMarriagesGraduates2013[,-c(3,9)]

# Saving the data
write.csv(CrimesMarriagesGraduates2013, file = "data/CrimesMarriagesGraduates2013.csv")

# Linear regression model 
regrobbery <- lm(robbery ~ GraduatesWithHouthDegreeTotal + HusbandAndWifeTotal, data=CrimesMarriagesGraduates2013)
summary(regrobbery)

# After running regression
# regrobbery_hat <- fitted(regrobbery) #predicted values
# as.data.frame(regrobbery_hat)
# regrobbery_res <- residuals(regrobbery) #residuals 
# as.data.frame(regrobbery_res)

# Creating table output 
stargazer(regrobbery, 
          title = 'Logistic Regression Estimates of Grad School Acceptance',
          digits = 2)