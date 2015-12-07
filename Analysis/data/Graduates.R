########################
# Lars Mehwald and Daniel Salgado Moreno
# 11 December 2015
# Graduates 
########################

#Loading the data frame 
Graduates <- read.csv(file = "Analysis/data/RawData/192-71-4_GraduatesFromDifferentHighSchool.csv", 
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

# Converting Character Vectors between Encodings from latin1 to UTF-8
# More compatibility with German characters
Graduates$DistrictName <- iconv(Graduates$DistrictName, from ="latin1", to = "UTF-8")

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

# Removing higher political units, which are coded with numbers below 1000 (Länder) 
# Hamburg and Berlin problematic: they have no further subunits 
# Extract them first and then rbind them after all smaller units are removed 
# 17 (02) is Hamburg; 365 is Berlin (11)
# Attention: row numbers are not correctly counted as first row has been deleted 
GraduatesHamburgBerlin <- subset(Graduates, Graduates$district == 2 | Graduates$district ==11, all(TRUE))
Graduates <- Graduates[Graduates$district > 1000,]
Graduates <- rbind(Graduates, GraduatesHamburgBerlin)
rm(GraduatesHamburgBerlin)

# Removing redundant districts
# (We keep for district$Aachen=5334, district$Hannover=3241, district$Saarbrücken=10041)
Graduates <- subset(Graduates, Graduates$district < 17000, all(TRUE))

# Saving the data 
write.csv(Graduates, file = "Analysis/data/Graduates.csv")