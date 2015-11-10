########################
# Lars Mehwald and Daniel Salgado Moreno
# 13 November 2015
# Assignment 3
# Total number of Fundations per District and it density = #Foundations/100,000inahbitants
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
                       col.names = c("Rank",
                                     "district",
                                     "State",
                                     "FoundationsDensity100k",
                                     "FoundationsTotal")
                       )

# Converting Character Vectors between Encodings from latin1 to UTF-8
# More compatibility with German characters
Foundations$district <- iconv(Foundations$district, from ="latin1", to = "UTF-8")

Foundations$district <- gsub('\u009f', 'ü', Foundations$district)
Foundations$district <- gsub(pattern = '\u008a', replacement = 'ä', x = Foundations$district)
Foundations$district <- gsub(pattern = '\u009a', replacement = 'ö', x = Foundations$district)
Foundations$district <- gsub(pattern = '§', replacement = 'ß', x = Foundations$district)

# Changing the class of numbers
Foundations[,4] <- as.numeric(as.character(Foundations[,4]))
Foundations[,5] <- as.numeric(as.character(Foundations[,5]))

# Resolving problem with Hamburg
Foundations[7,5] = 1194

# Getting rid of redundant variables
Foundations <- Foundations[,-c(1,3)]

# Saving the data 
write.csv(Foundations, file = "data/Foundations.csv")
