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

# Problem with Hamburg and Berlin
MarriageBerHam <- Marriages_2013[c(17, 365),]
Marriages_2013 <- Marriages_2013[Marriages_2013$District > 1000,]
Marriages_2013 <- rbind(Marriages_2013, MarriageBerHam)


