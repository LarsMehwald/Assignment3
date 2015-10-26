# Setting the working directory
setwd("~/HSoG/DataAnalysis/GitHub/Assignment3")

# Loading required packages 
library("rio")
library("dplyr")
library("tidyr")
library("repmis")

# Citing R packages 
pkgs <- c('dplyr', 'ggplot2', 'rio', 'tidyr', 'repmis')
LoadandCite(pkgs, file = 'References/RpackageCitations.bib')
rm(pkgs)

# varclass <- c("Date",
              "numeric",
              "character",
              "numeric",
              "numeric",
              "numeric",
              "numeric",
              "numeric",
              "numeric",
              "numeric",
              "numeric",
              "numeric"
)

Marriages_2013 <- read.csv(file="data/177-31-4_Marriages_2013.csv", 
                           sep=";", 
                           na.strings = c("-","."),
                           nrows = 525,
                           skip = 9,
                           header=FALSE,
                           col.names=c("Year",
                                       "District",
                                       "Name", 
                                       "EhemannesTotal/EhefrauTotal",
                                       "EhemannesTotal/EhefrauDeutsche",
                                       "EhemannesTotal/EhefrauAuslaenderin",
                                       "EhemannesDeutscher/EhefrauTotal",
                                       "EhemannesDeutscher/EhefrauDeutsche",
                                       "EhemannesDeutscher/EhefrauAuslaenderin",
                                       "EhemannesAuslaender/EhefrauTotal",
                                       "EhemannesAuslaender/EhefrauDeutsche",
                                       "EhemannesAuslaender/EhefrauAuslaender"),
                           )
summary(Marriages_2013)
