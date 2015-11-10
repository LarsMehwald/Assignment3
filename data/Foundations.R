########################
# Lars Mehwald and Daniel Salgado Moreno
# 13 November 2015
# Assignment 3
# Graduates Proportion of population with Hochschulreife and Hochschulabschluss
########################

# Loading required packages 
Packages <- c("rio", "dplyr", "tidyr", "repmis", "httr", "knitr", "ggplot2",
              "xtable", "stargazer", "texreg", "lmtest", "sandwich", "Zelig",
              "ggmap", "rworldmap")
lapply(Packages, require, character.only = TRUE) 

# Setting the commonly used working directory
possible_dir <- c('D:/Eigene Dokumente/!1 Vorlesungen/!! WS 2015/Introduction to 
                  Collaborative Social Science Data Analysis/Assignment3', 
                  '~/HSoG/DataAnalysis/GitHub/Assignment3')
set_valid_wd(possible_dir)
rm(possible_dir)

# Loading data set from csv file
Foundations <- read.csv(file="data/RawData/Stiftungsdichte2013.csv",
                       sep=";", 
                       dec=",",
                       na.strings=c("-", "."), 
                       header = FALSE,
                       skip = 3,
                       nrows = 402, 
                       col.names = c("Rank",
                                     "DistrictName",
                                     "State",
                                     "Density100k",
                                     "FoundationsTotal"
                       )
)

# Converting Character Vectors between Encodings from latin1 to UTF-8
# More compatibility with German characters
Foundations$DistrictName <- iconv(Foundations$DistrictName, from ="latin1", to = "UTF-8")
Foundations$State <- iconv(Foundations$State, from ="latin1", to = "UTF-8")

# Saving the data 
write.csv(Foundations, file = "data/Foundations.csv")
