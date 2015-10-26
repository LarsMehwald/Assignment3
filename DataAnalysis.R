########################
# Lars and Daniel 
# 13 November 2015
# Assignment 3
# Loading PKS data and control variables
# conducting statistical analyses 
########################

# Setting the working directory
# setwd("D:/Eigene Dokumente/!1 Vorlesungen/!! WS 2015/Introduction to Collaborative Social Science Data Analysis/Assignment3")
# setwd("~/HSoG/DataAnalysis/GitHub/Assignment3")

# Loading required packages 
library("rio")
library("dplyr")
library("tidyr")
library("repmis")

# Citing R packages 
pkgs <- c('dplyr', 'ggplot2', 'rio', 'tidyr', 'repmis')
LoadandCite(pkgs, file = 'RpackageCitations.bib')
rm(pkgs)

########################
# PKS data: Kreise 2013 2014
########################

# Scrapping the data
URL_PKS_Kreise_13_14 <- "http://www.bka.de/SharedDocs/Downloads/DE/Publikationen/PolizeilicheKriminalstatistik/2014/BKATabellen/FaelleLaenderKreiseStaedte/tb01__FaelleGrundtabelleKreiseFallentwicklung__csv,templateId=raw,property=publicationFile.csv/tb01__FaelleGrundtabelleKreiseFallentwicklung__csv.csv"
PKS_Kreise_13_14 <- read.csv(URL_PKS_Kreise_13_14, sep=";")
rm(URL_PKS_Kreise_13_14)

# Delete (for now) unimportant variables
PKS_Kreise_13_14 <- PKS_Kreise_13_14[,-c(1, 4, 7:15)]

# Renaming manually 
NameofVariables <- c("Straftat", "Gemeindeschl?ssel", "2014 - erfasste F?lle", "2013 - erfasste F?lle")
names(PKS_Kreise_13_14) <- NameofVariables 
rm(NameofVariables)

# Delete the first row (before name of variable)
PKS_Kreise_13_14 <- PKS_Kreise_13_14[-c(1),]

# Rearranging data
PKS_Kreise_13_14 <- PKS_Kreise_13_14[c(2,1,4,3)]

# Splitting the data
PKS_Kreise_13_14[1,]
PKS_Kreise_13 <- PKS_Kreise_13_14[,c(1,2,3)]
PKS_Kreise_14 <- PKS_Kreise_13_14[,c(1,2,4)]
rm(PKS_Kreise_13_14)

# Spread data from width to long format
PKS_Kreise_13_spread <- spread(PKS_Kreise_13, "Straftat", "2013 - erfasste F?lle")
PKS_Kreise_14_spread <- spread(PKS_Kreise_14, "Straftat", "2014 - erfasste F?lle")
rm(PKS_Kreise_13)
rm(PKS_Kreise_14)

# Removing variables (crimes) not relevant to analysis
PKS_Kreise_13_spread <- PKS_Kreise_13_spread[,-c(3,4,5,6,11:18)]
PKS_Kreise_14_spread <- PKS_Kreise_14_spread[,-c(3,4,5,6,11:18)]

# Translation of variable names into English
names(PKS_Kreise_13_spread)
NameofVariables <- c("district", "bodily harm", "dangerous bodily harm", "violent crime", "murder and manslaughter", "robbery")
names(PKS_Kreise_13_spread) <- NameofVariables 
names(PKS_Kreise_14_spread) <- NameofVariables 
rm(NameofVariables)

# Adding a time variable: year
PKS_Kreise_13_spread$year <- 2013
PKS_Kreise_14_spread$year <- 2014

# Combining district variable with year and rearranging
PKS_Kreise_13_spread$district_year <- paste(PKS_Kreise_13_spread$district, "2013", sep = "y")
PKS_Kreise_13 <- PKS_Kreise_13_spread[,c(8,1,2,3,4,5,6,7)]
rm(PKS_Kreise_13_spread)

PKS_Kreise_14_spread$district_year <- paste(PKS_Kreise_14_spread$district, "2014", sep = "y")
PKS_Kreise_14 <- PKS_Kreise_14_spread[,c(8,1,2,3,4,5,6,7)]
rm(PKS_Kreise_14_spread)

# Combining the data frames 
PKS_Kreise <- rbind(PKS_Kreise_13, PKS_Kreise_14)
rm(PKS_Kreise_13)
rm(PKS_Kreise_14)

# Changing the class of variables
PKS_Kreise[,2] <- as.numeric(as.character(PKS_Kreise[,2]))
PKS_Kreise[,3] <- as.numeric(as.character(PKS_Kreise[,3]))
PKS_Kreise[,4] <- as.numeric(as.character(PKS_Kreise[,4]))
PKS_Kreise[,5] <- as.numeric(as.character(PKS_Kreise[,5]))
PKS_Kreise[,6] <- as.numeric(as.character(PKS_Kreise[,6]))
PKS_Kreise[,7] <- as.numeric(as.character(PKS_Kreise[,7]))
PKS_Kreise[,8] <- as.numeric(as.character(PKS_Kreise[,8]))

# Problem: treated (again) as factor variable

title1 <- "These are the summary statistics for the year 2013"
print(title1)
PKS_Kreise_13 <- PKS_Kreise[PKS_Kreise$year == 2013,]
summary(PKS_Kreise_13[,c(3:7)])  #look for a if option
rm(title1)
rm(PKS_Kreise_13)

title2 <- "These are the summary statistics for the year 2014"
print(title2)
PKS_Kreise_14 <- PKS_Kreise[PKS_Kreise$year == 2014,]
summary(PKS_Kreise_14[,c(3:7)])
rm(title2)
rm(PKS_Kreise_14)

# Saving the data 
write.csv(PKS_Kreise, file = "data/PKS_Kreise.csv", append = "TRUE")

########################
# German Elections 2013
########################

# Downloading of data
# Problem: unstable link
# Data is badly formatted, hence modified manually using Excel
# Column names added and condensed, some rows in the header deleted

GermanElections <- read.csv(file = "data/GermanElections2013_ManuallyModified.csv", sep=";", na.strings = "-")

# Removing previous elections
GermanElection2013 <- GermanElections[c(1:525),]
rm(GermanElections)

# Why about 100 more observations than before in crime data frame? 

# Removing observation for Germany as a whole
GermanElection2013 <- GermanElection2013[-1,]

# Removing higher political units (they are coded with numbers below 1000)
GermanElection2013$district <- as.numeric(as.character(GermanElection2013$Gemeindeschluessel))
GermanElection2013 <- GermanElection2013[,c(13,4:12)]

summary(GermanElection2013$district)

GermanElection2013 <- GermanElection2013[GermanElection2013$district > 1000,]
summary(GermanElection2013$district)

########################
# Merging Kreise 2013 with 
# German Elections 2013
########################

# Creating a PKS data frame only for 2013

# Problem with factors? 

PKS_Kreise_13 <- PKS_Kreise[PKS_Kreise$year == 2013,]

# Chechking whether both data frames are actually data frames
class (GermanElection2013)
class(PKS_Kreise_13)

# Merging the data frames by the variable district
# Districts that have no corresponding district are dropped
ElectionCrime <- merge(GermanElection2013, PKS_Kreise_13, by="district")

# Linear regression model 
fit <- lm(robbery ~ G?ltige.Zweitstimmen.CDU.CSU, data=ElectionCrime)
summary(fit)

rm(fit)
?lm
names(total)

# Somehow it doesnt work 

# Removing everything from workspace
rm(list=ls()) 
