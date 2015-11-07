########################
# Lars Mehwald and Daniel Salgado Moreno
# 13 November 2015
# Assignment 3
# Loading Marriage data from the SBA
########################

# Loading required package
library("repmis")

# Setting the commonly used working directory
possible_dir <- c('D:/Eigene Dokumente/!1 Vorlesungen/!! WS 2015/Introduction to Collaborative Social Science Data Analysis/Assignment3', 
                  '~/HSoG/DataAnalysis/GitHub/Assignment3')
set_valid_wd(possible_dir)
rm(possible_dir)

# Reading Marriages 2013 csv file 
Marriages <- read.csv(file="data/RawData/177-31-4_Marriages_2013.csv", 
                           sep=";", 
                           na.strings = c("-","."),
                           nrows = 525,
                           skip = 9,
                           header=FALSE,
                           col.names=c("year",
                                       "district",
                                       "name", 
                                       "HusbandAndWifeTotal",
                                       "EhemannesTotal/EhefrauDeutsche",
                                       "EhemannesTotal/EhefrauAuslaenderin",
                                       "EhemannesDeutscher/EhefrauTotal",
                                       "EhemannesDeutscher/EhefrauDeutsche",
                                       "EhemannesDeutscher/EhefrauAuslaenderin",
                                       "EhemannesAuslaender/EhefrauTotal",
                                       "EhemannesAuslaender/EhefrauDeutsche",
                                       "EhemannesAuslaender/EhefrauAuslaender")
                           )

# Removing observation for Germany as a whole
Marriages <- Marriages[-1,]

# Removing variables
Marriages <- Marriages[,-c(3,5:12)]

# Changing the class of Variables 
Marriages[,1] <- as.numeric(as.character(Marriages[,1]))
Marriages[,2] <- as.numeric(as.character(Marriages[,2]))
Marriages[,3] <- as.numeric(as.character(Marriages[,3]))

# Problem with Hamburg and Berlin: recoding
MarriageBerHam <- Marriages[c(17, 365),]
Marriages <- Marriages[Marriages$district > 1000,]
Marriages <- rbind(Marriages, MarriageBerHam)
rm(MarriageBerHam)

# Saving the data
write.csv(Marriages, file = "data/Marriages.csv")
