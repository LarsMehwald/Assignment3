########################
# Lars Mehwald and Daniel Salgado Moreno
# 20 November 2015
# Assignment 3
# Loading Marriage data from the SBA
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
pkgs <- c('dplyr', 'ggplot2', 'rio', 'tidyr', 'repmis', 'httr')
LoadandCite(pkgs, file = 'References/RpackageCitations.bib')
rm(pkgs)

#Reading Marriages 2013 csv file. 
Marriages_2013 <- read.csv(file="data/177-31-4_Marriages_2013.csv", 
                           sep=";", 
                           na.strings = c("-","."),
                           nrows = 525,
                           skip = 9,
                           header=FALSE,
                           col.names=c("Year",
                                       "district",
                                       "name", 
                                       "EhemannesTotal/EhefrauTotal",
                                       "EhemannesTotal/EhefrauDeutsche",
                                       "EhemannesTotal/EhefrauAuslaenderin",
                                       "EhemannesDeutscher/EhefrauTotal",
                                       "EhemannesDeutscher/EhefrauDeutsche",
                                       "EhemannesDeutscher/EhefrauAuslaenderin",
                                       "EhemannesAuslaender/EhefrauTotal",
                                       "EhemannesAuslaender/EhefrauDeutsche",
                                       "EhemannesAuslaender/EhefrauAuslaender")
                           )
# Saving the data
write.csv(Marriages_2013, file = "data/Marriages2013.csv")

# Removing observation for Germany as a whole
Marriages_2013 <- Marriages_2013[-1,]

# Changing the class of Variables 
Marriages_2013[,2] <- as.numeric(as.character(Marriages_2013[,2]))
Marriages_2013[,3] <- as.character(Marriages_2013[,3])
Marriages_2013[,4] <- as.numeric(as.character(Marriages_2013[,4]))
Marriages_2013[,5] <- as.numeric(as.character(Marriages_2013[,5]))
Marriages_2013[,6] <- as.numeric(as.character(Marriages_2013[,6]))
Marriages_2013[,7] <- as.numeric(as.character(Marriages_2013[,7]))
Marriages_2013[,8] <- as.numeric(as.character(Marriages_2013[,8]))
Marriages_2013[,9] <- as.numeric(as.character(Marriages_2013[,9]))
Marriages_2013[,10] <- as.numeric(as.character(Marriages_2013[,10]))
Marriages_2013[,11] <- as.numeric(as.character(Marriages_2013[,11]))
Marriages_2013[,12] <- as.numeric(as.character(Marriages_2013[,12]))

# Problem with Hamburg and Berlin: recoding
MarriageBerHam <- Marriages_2013[c(17, 365),]
Marriages_2013 <- Marriages_2013[Marriages_2013$district > 1000,]
Marriages_2013 <- rbind(Marriages_2013, MarriageBerHam)
rm(MarriageBerHam)

# Merging with Merged Graduates and Crime
# GraduatesCrime <- read.csv(file="data/MergedGraduatesCrime.csv")
GraduatesCrime[,2] <- as.numeric(as.character(GraduatesCrime[,2]))
MarriagesGraduatesCrimes2013 <- merge(GraduatesCrime, Marriages_2013, by="district")

# Linear regression model 
names(MarriagesGraduatesCrimes2013)
fit <- lm(robbery ~ GraduatesWithHouthDegreeTotal + EhemannesTotal.EhefrauTotal, data=MarriagesGraduatesCrimes2013)
summary(fit)
rm(fit)


# Removing everything from workspace
rm(list=ls()) 
