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
Foundations <- read.csv(file="Analysis/data/RawData/Stiftungsdichte2013.csv",
                        sep=";", 
                        dec=",",
                        na.strings=c("-", "."), 
                        header = FALSE,
                        skip = 1,
                        nrows = 403, 
                        encoding = "UTF-8",
                        col.names = c("district",
                                      "DistrictName",
                                      "State",
                                      "FoundationsDensity100k",
                                      "FoundationsTotal")
)

#Foundations$DistrictName <- gsub(",","",Foundations$DistrictName)
#Foundations$DistrictName <- gsub("Stadt","",Foundations$DistrictName)
#Foundations$DistrictName <- gsub("Universitätsstadt","",Foundations$DistrictName)
#Foundations$DistrictName <- gsub("Kreisfreie","",Foundations$DistrictName)
#Foundations$DistrictName <- gsub("Hansestadt","",Foundations$DistrictName)
#Foundations$DistrictName <- gsub("krsfr.","",Foundations$DistrictName)
#Foundations$DistrictName <- gsub(" Kreis","",Foundations$DistrictName)
#Foundations$DistrictName <- gsub("Städteregion","",Foundations$DistrictName)
#Foundations$DistrictName <- gsub("^\\s+|\\s+$", "", Foundations$DistrictName) #Removes whitespaces before and after string
#Foundations$DistrictName <- gsub("(einschl. Aachen)", "", Foundations$DistrictName)
#Foundations$DistrictName <- gsub(" Landkreis","",Foundations$DistrictName)
#Foundations$DistrictName <- gsub("Soltau-Fallingbostel", "Landkreis HeideKreis", Foundations$DistrictName) #Change of name in 2011

# Changing the class of numbers
Foundations[,1] <- as.numeric(as.character(Foundations[,1]))
Foundations[,4] <- as.numeric(as.character(Foundations[,4]))
Foundations[,5] <- as.numeric(as.character(Foundations[,5]))

# Getting rid of redundant variables
Foundations <- Foundations[,-c(2,3)]

# Saving the data 
write.csv(Foundations, file = "Analysis/data/Foundations2.csv")
