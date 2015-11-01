########################
# Lars and Daniel 
# 13 November 2015
# Assignment 3
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