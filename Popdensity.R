########################
# Lars Mehwald and Daniel Salgado Moreno
# 13 November 2015
# Assignment 3
# Population Density and District Area
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

Popdensity <- read.csv(file = "data/Bevoelkerung.csv", 
                        sep=",", 
                        na.strings=c("-", "."), 
                        header = FALSE,
                        skip=2,
                        nrows = 404, 
                        col.names = c("district", 
                                      "typofdistrict", 
                                      "DistrictName", 
                                      "TotalArea", 
                                      "TotalPopulation", 
                                      "MalePopulation", 
                                      "FemalePopulation", 
                                      "DensityPerSQRTkm"
                        )
)

#Removing name variables
Popdensity <- Popdensity[,-c(2:3)]

# Encoding as numeric for district number and total area
Popdensity[,1]<-as.numeric(as.character(Popdensity[,1]))
Popdensity[,2]<-as.numeric(as.character(Popdensity[,2]))
Popdensity[,3]<-as.numeric(as.character(Popdensity[,3]))
Popdensity[,4]<-as.numeric(as.character(Popdensity[,4]))
Popdensity[,5]<-as.numeric(as.character(Popdensity[,5]))
Popdensity[,6]<-as.numeric(as.character(Popdensity[,6]))

# Problem with Hamburg and Berlin: 
# recoding to matched other data frames, where Berlin$district=11 and Hamburg$district=2
# Berlin is in row 326 and Hamburg is in row 16
Popdensity[326,1]=11
Popdensity[16,1]=2

#Saveing Population denisty data frame
write.csv(Popdensity, file = "data/Popdensity.csv")


