########################
# Lars Mehwald and Daniel Salgado Moreno
# 11 December 2015
# Population Density and District Area
########################

# Loading data
Popdensity <- read.csv(file = "Analysis/data/RawData/BevoelkerungRawData.csv", 
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
                                      "DensityPerSQRTkm"))

# Converting Character Vectors between Encodings from latin1 to UTF-8
# More compatibility with German characters
Popdensity$DistrictName <- iconv(Popdensity$DistrictName, from ="latin1", to = "UTF-8")

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
write.csv(Popdensity, file = "Analysis/data/Popdensity.csv")
