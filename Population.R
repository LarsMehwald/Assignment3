########################
# Lars Mehwald and Daniel Salgado Moreno
# 13 November 2015
# Assignment 3
# Population size 
########################

# Setting the commonly used working directory
possible_dir <- c('D:/Eigene Dokumente/!1 Vorlesungen/!! WS 2015/Introduction to Collaborative Social Science Data Analysis/Assignment3', 
                  '~/HSoG/DataAnalysis/GitHub/Assignment3')
set_valid_wd(possible_dir)
rm(possible_dir)

# Loading data frame
Population <- read.csv(file = "data/173-01-4_SizeOfPopulation_2013.csv", 
                        sep=";", 
                        na.strings=c("-", "."), 
                        header = FALSE,
                        skip = 7,
                        nrows = 525, 
                        col.names = c("district", 
                                      "DistrictName", 
                                      "TimeOfMeasurement", 
                                      "PopulationTotal", 
                                      "PopulationMale", 
                                      "PopulationFemale")
                       )

# Removing some variables
Population <- Population[,-c(2,3,5,6)]

# Changing the class of both variables to numeric 
Population[,1] <- as.numeric(as.character(Population[,1]))
Population[,2] <- as.numeric(as.character(Population[,2]))

# Removing observation for Germany as a whole
Population <- Population[-1,]

# Removing higher political units (they are coded with numbers below 1000)
# Hamburg and Berlin problematic: they have no further subunits 
# Extract them first and then rbind them after all smaller units are removed 
# 17 (02) is Hamburg; 365 is Berlin (11)
# Attention: row numbers are not correctly counted as first row has been deleted 
PopulationHamburgBerlin <- Population[c(17, 365),] 
Population <- Population[Population$district > 1000,]
Population <- rbind(Population, PopulationHamburgBerlin)
rm(PopulationHamburgBerlin)

# Saving the data 
write.csv(Population, file = "data/Population2013.csv")
