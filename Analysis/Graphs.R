########################
# Lars Mehwald and Daniel Salgado Moreno
# 13 November 2015
# Assignment 3
# Additional variables (crime and socio economic rates)
########################

# Loading required packages 
Packages <- c("rio", "dplyr", "tidyr", "repmis", "httr", "knitr", "ggplot2",
              "xtable", "stargazer", "texreg", "lmtest", "sandwich", "Zelig",
              "ggmap", "rworldmap","car", "MASS", "PerformanceAnalytics", "pscl", "AER")
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
#DistrictData$CrimeRate <- as.integer(as.character(DistrictData$CrimeRate))

# Crime Rate hist
#histCrimeRate <- ggplot(DistrictData, aes(CrimeRate)) + 
#  geom_histogram(binwidth=500, colour="black", fill="white") 
#plot(histCrimeRate)

# Non-Violent Crime histogram
#histNonViolentCrimeRate <- ggplot(DistrictData, aes(NonViolentCrimeRate)) + 
 # geom_histogram(binwidth=400, colour="black", fill="white")
#plot(histNonViolentCrimeRate)

# Violent Crime histogram
histViolentCrimeRate <- ggplot(DistrictData, aes(ViolentCrimeRate)) + 
  geom_histogram(binwidth=10, colour="black", fill="white")
#plot(histViolentCrimeRate)

# Murder Rate Histogram
histMurderRate <- ggplot(DistrictData, aes(MurderRate)) + 
  geom_histogram(binwidth=1, colour="black", fill="white")
#plot(histMurderRate)

# Murder Rate Histogram
histMurder <- ggplot(DistrictData, aes(murderAndManslaughter)) + 
  geom_histogram(binwidth=1, colour="black", fill="white") + 
  xlab("Homicides") +
  ylab("Counts per district") +
  ggtitle("Homicide count per district: right skewed")
#plot(histMurder) 
# We can observe that the Homicide count is right skewed
# OLS regression models are inappropiate when small number of events
# Poisson models offer a good alternative

#################################
# Correlation Matrix
#################################

# Correlation Plot using R package: "PerformanceAnalytics"
correlation.matrix <- DistrictData[, c(47,54,53,40,22,50,51,52)]
#chart.Correlation(correlation.matrix, historgram=T)
