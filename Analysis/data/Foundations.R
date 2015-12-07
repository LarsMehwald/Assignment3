########################
# Lars Mehwald and Daniel Salgado Moreno
# 11 December 2015
# Total number of Fundations per District 
# and it density = #Foundations/100,000inahbitants
########################

# Loading data set from csv file
Foundations <- read.csv(file="Analysis/data/RawData/Stiftungsdichte2013.csv",
                       sep=";", 
                       dec=",",
                       na.strings=c("-", "."), 
                       header = FALSE,
                       skip = 2,
                       nrows = 403, 
                       encoding = "UTF-8",
                       col.names = c("Rank",
                                     "district",
                                     "State",
                                     "FoundationsDensity100k",
                                     "FoundationsTotal"))

Foundations$district <- gsub('\u009f', '?', Foundations$district)
Foundations$district <- gsub(pattern = '\u008a', replacement = '?', x = Foundations$district)
Foundations$district <- gsub(pattern = '\u009a', replacement = '?', x = Foundations$district)
Foundations$district <- gsub(pattern = '?', replacement = '?', x = Foundations$district)

# Changing the class of numbers
Foundations[,4] <- as.numeric(as.character(Foundations[,4]))
Foundations[,5] <- as.numeric(as.character(Foundations[,5]))

# Getting rid of redundant variables
Foundations <- Foundations[,-c(1,3)]

# Saving the data 
write.csv(Foundations, file = "Analysis/data/Foundations.csv")
