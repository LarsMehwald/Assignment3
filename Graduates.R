########################
# Lars Mehwald and Daniel Salgado Moreno
# 13 November 2015
# Assignment 3
# Graduates 
########################

# Setting the commonly used working directory
possible_dir <- c('D:/Eigene Dokumente/!1 Vorlesungen/!! WS 2015/Introduction to Collaborative Social Science Data Analysis/Assignment3', 
                  '~/HSoG/DataAnalysis/GitHub/Assignment3')
set_valid_wd(possible_dir)
rm(possible_dir)

#Loading the data frame 
Graduates <- read.csv(file = "data/192-71-4_GraduatesFromDifferentHighSchool.csv", 
               sep=";", 
               na.strings=c("-", "."), 
               header = FALSE,
               skip = 10,
               nrows = 524, 
               col.names = c("year", 
                             "district", 
                             "DistrictName", 
                             "GraduatesTotal", 
                             "GraduatesTotalFemale", 
                             "GraduatesWithHouthDegreeTotal", 
                             "GraduatesWithouthDegreeFemale", 
                             "GraduatesWithHauptschulDegreeTotal", 
                             "GraduatesWithHauptschulDegreeFemale",
                             "GraduatesWithRealschulDegreeTotal",
                             "GraduatesWithRealschulDegreeFemale",
                             "GraduatesWithFachhochschulDegreeTotal",
                             "GraduatesWithFachhochschulDegreeFemale",
                             "GraduatesWithHochschulreifeDegreeTotal",
                             "GraduatesWithHochschulreifeDegreeFemale"
                             )
               )

# Alternative: read data in as vector
# df <- readLines("data/192-71-4_GraduatesFromDifferentHighSchool.csv") # Important: Capital Letter L 

# Removing observation for Germany as a whole
Graduates <- Graduates[-1,]

# Removing some variables
Graduates <- Graduates[,-c(3,5,7,9,11,13,15)]

# Changing the class of some variables to numeric 
Graduates[,1] <- as.numeric(as.character(Graduates[,1]))
Graduates[,2] <- as.numeric(as.character(Graduates[,2]))
Graduates[,4] <- as.numeric(as.character(Graduates[,4]))
Graduates[,5] <- as.numeric(as.character(Graduates[,5]))
Graduates[,6] <- as.numeric(as.character(Graduates[,6]))
Graduates[,7] <- as.numeric(as.character(Graduates[,7]))
Graduates[,8] <- as.numeric(as.character(Graduates[,8]))

# Removing higher political units (they are coded with numbers below 1000)
# Hamburg and Berlin problematic: they have no further subunits 
# Extract them first and then rbind them after all smaller units are removed 
# 17 (02) is Hamburg; 365 is Berlin (11)
# Attention: row numbers are not correctly counted as first row has been deleted 
GraduatesHamburgBerlin <- Graduates[c(17, 365),] 
Graduates <- Graduates[Graduates$district > 1000,]
Graduates <- rbind(Graduates, GraduatesHamburgBerlin)
rm(GraduatesHamburgBerlin)

# Saving the data 
write.csv(Graduates, file = "data/Graduates2013.csv")