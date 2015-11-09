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
Graduates2 <- read.csv(file="data/RawData/GraduatesProportionHochschulreifeHauptschulabschluss.csv",
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
                                    "PropwHauptschulabschluss"
                                    )
                      )

# Converting Character Vectors between Encodings from latin1 to UTF-8
# More compatibility with German characters
Graduates2$DistrictName <- iconv(Graduates2$DistrictName, from ="latin1", to = "UTF-8")

# Removing 
