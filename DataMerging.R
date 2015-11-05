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

# Sourcing the R files that load and prepare data
source("PksKreise.R")
source("Marriage.R")
source("Graduates.R")
source("LaborMarket.R")

# Merging the data frames by district
# Districts that have no corresponding district are dropped
CrimesMarriages2013 <- merge(PKS_Kreise_13, Marriages_2013, by="district")
CrimesMarriagesGraduates2013 <- merge(CrimesMarriages2013, Graduates, by="district")
CrimesMarriagesGraduatesLabor2013 <- merge(CrimesMarriagesGraduates2013, LaborMarket, by="district")
rm(CrimesMarriages2013)
rm(CrimesMarriagesGraduates2013)

# Removing individual data frames
rm(PKS_Kreise_13)
rm(Marriages_2013)
rm(Graduates)
rm(LaborMarket)

# Removing redundant variables (year variables)
CrimesMarriagesGraduatesLabor2013 <- CrimesMarriagesGraduatesLabor2013[,-c(4,10,12,19)]

# Saving the data
write.csv(CrimesMarriagesGraduatesLabor2013, file = "data/CrimesMarriagesGraduatesLabor2013.csv")

