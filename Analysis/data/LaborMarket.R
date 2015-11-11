########################
# Lars Mehwald and Daniel Salgado Moreno
# 13 November 2015
# Assignment 3
# Labor market 
########################

# Loading required package
library("repmis")

# Setting the commonly used working directory
possible_dir <- c('D:/Eigene Dokumente/!1 Vorlesungen/!! WS 2015/Introduction to Collaborative Social Science Data Analysis/Assignment3', 
                  '~/HSoG/DataAnalysis/GitHub/Assignment3')
set_valid_wd(possible_dir)
rm(possible_dir)

# Loading the data frame 
LaborMarket <- read.csv(file = "Analysis/data/RawData/659-71-4_LaborMarketStatistic_2013_2014.csv", 
                      sep=";", 
                      dec = ",",
                      na.strings=c("-", "."), 
                      header = FALSE,
                      skip = 8,
                      nrows = 1050, 
                      col.names = c("year", 
                                    "district", 
                                    "DistrictName", 
                                    "UnemployedTotal", 
                                    "UnemployedTotalForeigner", 
                                    "UnemployedTotalHandicapped", 
                                    "UnemployedTotal15to20", 
                                    "UnemployedTotal15to25", 
                                    "UnemployedTotal55to65",
                                    "UnemployedTotalLongtermUnemployed",
                                    "UnemployedPercentage",
                                    "UnemployedPercentageRegardingEntireWorkforce",
                                    "UnemployedPercentageMen",
                                    "UnemployedPercentageWomen",
                                    "UnemployedPercentageForeigner",
                                    "UnemployedPercentageForeigner15to25"
                      )
)

# Converting Character Vectors between Encodings from latin1 to UTF-8
# More compatibility with German characters
LaborMarket$DistrictName <- iconv(LaborMarket$DistrictName, from ="latin1", to = "UTF-8")

# Removing some variables
LaborMarket <- LaborMarket[,-c(3,5,6,7,9,10,12:16)]

# Changing the class of some variables to numeric 
LaborMarket[,1] <- as.numeric(as.character(LaborMarket[,1]))
LaborMarket[,2] <- as.numeric(as.character(LaborMarket[,2]))
LaborMarket[,3] <- as.numeric(as.character(LaborMarket[,3]))
LaborMarket[,4] <- as.numeric(as.character(LaborMarket[,4]))
LaborMarket[,5] <- as.numeric(as.character(LaborMarket[,5]))

# Removing observations for 2014
LaborMarket <- LaborMarket[LaborMarket$year == 2013,]

# Removing observation for Germany as a whole
LaborMarket <- LaborMarket[-1,]

# Removing higher political units (they are coded with numbers below 1000)
# Hamburg and Berlin problematic: they have no further subunits 
# Extract them first and then rbind them after all smaller units are removed
# district$Berlin = 11; district$Hamburg = 2;
LaborMarketHamburgBerlin <- subset(LaborMarket, LaborMarket$district == 2 | LaborMarket$district ==11, all(TRUE))
LaborMarket <- LaborMarket[LaborMarket$district > 1000,]
LaborMarket <- rbind(LaborMarket, LaborMarketHamburgBerlin)
rm(LaborMarketHamburgBerlin)

# Removing redundant districts
# (We keep for district$Aachen=5334, district$Hannover=3241, district$Saarbrücken=10041)
LaborMarket <- subset(LaborMarket, LaborMarket$district < 17000, all(TRUE))

# Saving the data 
write.csv(LaborMarket, file = "Analysis/data/LaborMarket.csv")
