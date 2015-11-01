########################
# Lars Mehwald and Daniel Salgado Moreno
# 13 November 2015
# Assignment 3
# Loading Marriage data from the SBA
########################

# Reading Marriages 2013 csv file 
Marriages_2013 <- read.csv(file="data/177-31-4_Marriages_2013.csv", 
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
Marriages_2013 <- Marriages_2013[-1,]

# Removing variables
Marriages_2013 <- Marriages_2013[,-c(3,5:12)]

# Changing the class of Variables 
Marriages_2013[,1] <- as.numeric(as.character(Marriages_2013[,1]))
Marriages_2013[,2] <- as.numeric(as.character(Marriages_2013[,2]))
Marriages_2013[,3] <- as.numeric(as.character(Marriages_2013[,3]))

# Problem with Hamburg and Berlin: recoding
MarriageBerHam <- Marriages_2013[c(17, 365),]
Marriages_2013 <- Marriages_2013[Marriages_2013$district > 1000,]
Marriages_2013 <- rbind(Marriages_2013, MarriageBerHam)
rm(MarriageBerHam)

# Saving the data
write.csv(Marriages_2013, file = "data/Marriages2013.csv")