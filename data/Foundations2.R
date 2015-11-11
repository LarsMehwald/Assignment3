########################
# Lars Mehwald and Daniel Salgado Moreno
# 13 November 2015
# Assignment 3
# Total number of Fundations per DistrictName and it density = #Foundations/100,000inahbitants
########################

# Loading required packages 
library("repmis")

# Setting the commonly used working directory
possible_dir <- c('D:/Eigene Dokumente/!1 Vorlesungen/!! WS 2015/Introduction to Collaborative Social Science Data Analysis/Assignment3', 
                  '~/HSoG/DataAnalysis/GitHub/Assignment3')
set_valid_wd(possible_dir)
rm(possible_dir)

# Loading data set from csv file
Foundations <- read.csv(file="data/RawData/Stiftungsdichte2013.csv",
                        sep=";", 
                        dec=",",
                        na.strings=c("-", "."), 
                        header = FALSE,
                        skip = 2,
                        nrows = 403, 
                        encoding = "UTF-8",
                        col.names = c("Rank",
                                      "DistrictName",
                                      "State",
                                      "FoundationsDensity100k",
                                      "FoundationsTotal")
)

pattern <- c(", Stadt", ", Kreisfreie Stadt", ", Universitätsstadt", ", Landkreis", ", Hansestadt, Kreisfreie Stadt")
Foundations$DistrictName <- gsub

Foundations$DistrictName <- gsub('\u009f', '?', Foundations$DistrictName)
Foundations$DistrictName <- gsub(pattern = '\u008a', replacement = '?', x = Foundations$DistrictName)
Foundations$DistrictName <- gsub(pattern = '\u009a', replacement = '?', x = Foundations$DistrictName)
Foundations$DistrictName <- gsub(pattern = '?', replacement = '?', x = Foundations$DistrictName)

# Changing the class of numbers
Foundations[,4] <- as.numeric(as.character(Foundations[,4]))
Foundations[,5] <- as.numeric(as.character(Foundations[,5]))

# Getting rid of redundant variables
Foundations <- Foundations[,-c(1,3)]

# Saving the data 
write.csv(Foundations, file = "data/Foundations.csv")
