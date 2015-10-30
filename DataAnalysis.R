########################
# Lars and Daniel 
# 13 November 2015
# Assignment 3
# Loading PKS data and control variables
# conducting statistical analyses 
########################

# Loading required packages 
library("rio")
library("dplyr")
library("tidyr")
library("repmis")
library("httr")

# Setting the commonly used working directory
possible_dir <- c('D:/Eigene Dokumente/!1 Vorlesungen/!! WS 2015/Introduction to Collaborative Social Science Data Analysis/Assignment3', '~/HSoG/DataAnalysis/GitHub/Assignment3')

# Set to first valid directory in the possible_dir vector
repmis::set_valid_wd(possible_dir)

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
NameofVariables <- c("Straftat", "Gemeindeschluessel", "2014 - erfasste Faelle", "2013 - erfasste Faelle")
names(PKS_Kreise_13_14) <- NameofVariables 
rm(NameofVariables)

# Delete the first row (before name of variable)
PKS_Kreise_13_14 <- PKS_Kreise_13_14[-c(1),]

# Rearranging data
PKS_Kreise_13_14 <- PKS_Kreise_13_14[c(2,1,4,3)]

# Splitting the data
PKS_Kreise_13 <- PKS_Kreise_13_14[,c(1,2,3)]
# PKS_Kreise_14 <- PKS_Kreise_13_14[,c(1,2,4)]
rm(PKS_Kreise_13_14)

# Spread data from wide to long format
PKS_Kreise_13_spread <- spread(PKS_Kreise_13, "Straftat", "2013 - erfasste Faelle")
# PKS_Kreise_14_spread <- spread(PKS_Kreise_14, "Straftat", "2014 - erfasste Faelle")
rm(PKS_Kreise_13)
# rm(PKS_Kreise_14)

# Removing variables (crimes) not relevant to analysis
PKS_Kreise_13_spread <- PKS_Kreise_13_spread[,-c(3,4,5,6,11:18)]
# PKS_Kreise_14_spread <- PKS_Kreise_14_spread[,-c(3,4,5,6,11:18)]

# Translation of variable names into English
NameofVariables <- c("district", "bodily harm", "dangerous bodily harm", "violent crime", "murder and manslaughter", "robbery")
names(PKS_Kreise_13_spread) <- NameofVariables 
# names(PKS_Kreise_14_spread) <- NameofVariables 
rm(NameofVariables)

# Adding a time variable: year
PKS_Kreise_13_spread$year <- 2013
# PKS_Kreise_14_spread$year <- 2014

# Correcting problem with Hamburg and Berlin. 
PKS_Kreise_13_spread[,1] <- as.numeric(as.character(PKS_Kreise_13_spread[,1]))
PKS_Kreise_13_spread[22,1]=11
PKS_Kreise_13_spread[99,1]=2  

# Combining district variable with year and rearranging
PKS_Kreise_13_spread$district_year <- paste(PKS_Kreise_13_spread$district, "2013", sep = "y")
PKS_Kreise_13 <- PKS_Kreise_13_spread[,c(8,1,7,2,3,4,5,6)]
rm(PKS_Kreise_13_spread)
# PKS_Kreise_14_spread$district_year <- paste(PKS_Kreise_14_spread$district, "2014", sep = "y")
# PKS_Kreise_14 <- PKS_Kreise_14_spread[,c(8,1,2,3,4,5,6,7)]
# rm(PKS_Kreise_14_spread)

# Combining the data frames 
# PKS_Kreise <- rbind(PKS_Kreise_13, PKS_Kreise_14)
# rm(PKS_Kreise_13)
# rm(PKS_Kreise_14)

# Changing the class of variables
PKS_Kreise_13[,2] <- as.numeric(as.character(PKS_Kreise_13[,2]))
PKS_Kreise_13[,3] <- as.numeric(as.character(PKS_Kreise_13[,3]))
PKS_Kreise_13[,4] <- as.numeric(as.character(PKS_Kreise_13[,4]))
PKS_Kreise_13[,5] <- as.numeric(as.character(PKS_Kreise_13[,5]))
PKS_Kreise_13[,6] <- as.numeric(as.character(PKS_Kreise_13[,6]))
PKS_Kreise_13[,7] <- as.numeric(as.character(PKS_Kreise_13[,7]))
PKS_Kreise_13[,8] <- as.numeric(as.character(PKS_Kreise_13[,8]))

# Summary statistics
# Problem: treated (again) as factor variable
title1 <- "These are the summary statistics for the year 2013"
print(title1)
summary(PKS_Kreise_13[,c(4:8)])  # look for a if option
rm(title1)
# title2 <- "These are the summary statistics for the year 2014"
# print(title2)
# PKS_Kreise_14 <- PKS_Kreise[PKS_Kreise$year == 2014,]
# summary(PKS_Kreise_14[,c(3:7)])
# rm(title2)

# Saving the data 
write.csv(PKS_Kreise_13, file = "data/PKS_Kreise.csv")

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
# Loading new data: 
# Regionalstatistik
########################

Graduates <- read.csv(file = "data/192-71-4_GraduatesFromDifferentHighSchool.csv", 
               sep=";", 
               na.strings=c("-", "."), 
               header = FALSE,
               skip = 10,
               nrows = 524, 
               col.names = c("Year", 
                             "district", 
                             "DistrictName", 
                             "GraduatesTotal", 
                             "GraduatesTotalFemale", 
                             "GraduatesWithHouthDegreeTotal", 
                             "GraduatesWithouthDegreeFemale", 
                             "GraduatesWithHauptschulDegreeTotal", 
                             "GraduatesWithHauptschulDegreeFemale",
                             "GraduatesWithRealschulDegreeTotal",
                             "GraduatesWithRealschulDegreeFemale",
                             "GraduatesWithFachhochschulDegreeTotal",
                             "GraduatesWithFachhochschulDegreeFemale",
                             "GraduatesWithHochschulreifeDegreeTotal",
                             "GraduatesWithHochschulreifeDegreeFemale"
                             )
               )

# Alternative: read data in as vector
# df <- readLines("data/192-71-4_GraduatesFromDifferentHighSchool.csv") # Important: Capital Letter L 

# Saving the data 
write.csv(Graduates, file = "data/Graduates2013.csv")

# Removing observation for Germany as a whole
Graduates <- Graduates[-1,]

# Checking the class of variables 
class(Graduates$Year) # integer
class(Graduates$DistrictNumber) # integer
class(Graduates$DistrictName) # factor
class(Graduates$GraduatesTotal) # integer 

# Changing the class of some variables to numeric 
Graduates[,1] <- as.numeric(as.character(Graduates[,1]))
Graduates[,2] <- as.numeric(as.character(Graduates[,2]))
Graduates[,4] <- as.numeric(as.character(Graduates[,4]))
Graduates[,5] <- as.numeric(as.character(Graduates[,5]))
Graduates[,6] <- as.numeric(as.character(Graduates[,6]))
Graduates[,7] <- as.numeric(as.character(Graduates[,7]))
Graduates[,8] <- as.numeric(as.character(Graduates[,8]))
Graduates[,9] <- as.numeric(as.character(Graduates[,9]))
Graduates[,10] <- as.numeric(as.character(Graduates[,10]))
Graduates[,11] <- as.numeric(as.character(Graduates[,11]))
Graduates[,12] <- as.numeric(as.character(Graduates[,12]))
Graduates[,13] <- as.numeric(as.character(Graduates[,13]))
Graduates[,14] <- as.numeric(as.character(Graduates[,14]))
Graduates[,15] <- as.numeric(as.character(Graduates[,15]))

# Removing higher political units (they are coded with numbers below 1000)
# Hamburg and Berlin problematic: they have no further subunits 
# Extract them first and then rbind them after all smaller units are removed 
# 17 (02) is Hamburg; 365 is Berlin (11)
# Attention: row numbers are not correctly counted as first row has been deleted 

GraduatesHamburgBerlin <- Graduates[c(17, 365),] 
Graduates <- Graduates[Graduates$district > 1000,]
Graduates <- rbind(Graduates, GraduatesHamburgBerlin)
rm(GraduatesHamburgBerlin)

########################
# Merging Kreise 2013 
# with Graduation 2013
########################

# Chechking whether both data frames are actually data frames
class(Graduates)
class(PKS_Kreise_13)

# Merging the data frames by the variable district
# Districts that have no corresponding district are dropped
GraduatesCrime <- merge(Graduates, PKS_Kreise_13, by="district")

# Saving the merged data frame
write.csv(GraduatesCrime, file = "data/MergedGraduatesCrime.csv")

# Linear regression model 
fit <- lm(robbery ~ GraduatesWithHouthDegreeTotal, data=GraduatesCrime)
summary(fit)
rm(fit)

# Removing everything from workspace
rm(list=ls()) 
