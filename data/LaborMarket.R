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
LaborMarket <- read.csv(file = "data/RawData/659-71-4_LaborMarketStatistic_2013_2014.csv", 
                      sep=";", 
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

# Removing some variables
LaborMarket <- LaborMarket[,-c(3,5,6,7,9,10,12:16)]

# Changing comma as seperator for values to points
LaborMarket$UnemployedPercentage <- gsub(",", ".", LaborMarket$UnemployedPercentage)

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
# 17 (02) is Hamburg; 365 is Berlin (11)
# Attention: row numbers are not correctly counted as first row has been deleted 
LaborMarketHamburgBerlin <- LaborMarket[c(17, 365),] 
LaborMarket <- LaborMarket[LaborMarket$district > 1000,]
LaborMarket <- rbind(LaborMarket, LaborMarketHamburgBerlin)
rm(LaborMarketHamburgBerlin)

# Saving the data 
write.csv(LaborMarket, file = "data/LaborMarket.csv")
