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
possible_dir <- c('D:/Eigene Dokumente/!1 Vorlesungen/!! WS 2015/Introduction to Collaborative Social Science Data Analysis/Assignment3', 
                  '~/HSoG/DataAnalysis/GitHub/Assignment3')
set_valid_wd(possible_dir)
rm(possible_dir)

# Loading data set from csv file
Graduates2 <- read.csv(file="Analysis/data/RawData/GraduatesProportionHochschulreifeHauptschulabschluss.csv",
                      sep=";", 
                      dec=",",
                      na.strings=c("-", "."), 
                      header = FALSE,
                      skip = 8,
                      nrows = 523, 
                      col.names = c("year",
                                    "district",
                                    "DistrictName",
                                    "PropwHochschulreife",
                                    "PropwoHauptschulabschluss"
                                    )
                      )

# Converting Character Vectors between Encodings from latin1 to UTF-8
# More compatibility with German characters
Graduates2$DistrictName <- iconv(Graduates2$DistrictName, from ="latin1", to = "UTF-8")

# Removing DistrictName
Graduates2 <- Graduates2[,-3]

# Changing the class of some variables to numeric 
Graduates2[,1] <- as.numeric(as.character(Graduates2[,1]))
Graduates2[,2] <- as.numeric(as.character(Graduates2[,2]))
Graduates2[,3] <- as.numeric(as.character(Graduates2[,3]))
Graduates2[,4] <- as.numeric(as.character(Graduates2[,4]))

# Removing higher political units, which are coded with numbers below 1000 (Länder) 
# Hamburg and Berlin problematic: they have no further subunits 
# Extract them first and then rbind them after all smaller units are removed 
# 16 (02) is Hamburg; 364 is Berlin (11)
# Attention: row numbers are not correctly counted as first row has been deleted 
Graduates2HamburgBerlin <- subset(Graduates2, Graduates2$district == 2 | Graduates2$district ==11, all(TRUE))
Graduates2 <- Graduates2[Graduates2$district > 1000,]
Graduates2 <- rbind(Graduates2, Graduates2HamburgBerlin)
rm(Graduates2HamburgBerlin)

# Removing redundant districts
# (We keep for district$Aachen=5334, district$Hannover=3241, district$Saarbrücken=10041)
Graduates2 <- subset(Graduates2, Graduates2$district < 17000, all(TRUE))

# Saving the data 
write.csv(Graduates2, file = "Analysis/data/Graduates2.csv")
