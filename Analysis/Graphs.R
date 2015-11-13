########################
# Lars Mehwald and Daniel Salgado Moreno
# 13 November 2015
# Assignment 3
# Additional variables (crime and socio economic rates)
########################

# Loading required packages 
Packages <- c("rio", "dplyr", "tidyr", "repmis", "httr", "knitr", "ggplot2",
              "xtable", "stargazer", "texreg", "lmtest", "sandwich", "Zelig",
              "ggmap", "rworldmap", "car", "PerformanceAnalytics", "MASS")
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

#################################
# Historgrams
#################################

# Changing class of Crime Rate
DistrictData$CrimeRate <- as.integer(as.character(DistrictData$CrimeRate))

# Crime Rate hist
histCrimeRate <- ggplot(DistrictData, aes(CrimeRate)) + 
  geom_histogram(binwidth=500, colour="black", fill="white") 

# Violent Crime histogram
histViolentCrimeRate <- ggplot(DistrictData, aes(ViolentCrimeRate)) + 
  geom_histogram(binwidth=50, colour="black", fill="white")

# Non-Violent Crime histogram
histNonViolentCrimeRate <- ggplot(DistrictData, aes(NonViolentCrimeRate)) + 
  geom_histogram(binwidth=400, colour="black", fill="white")

#################################
# Correlation Matrix
#################################

# Correlation Plot using R package: "PerformanceAnalytics"
datacor <- DistrictData[, c(22,40,47,49,50,51,52,53)]
chart.Correlation(datacor, historgram=T)
