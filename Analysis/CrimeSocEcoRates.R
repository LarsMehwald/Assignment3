########################
# Lars Mehwald and Daniel Salgado Moreno
# 13 November 2015
# Assignment 3
# Additional variables (crime and socio economic rates)
########################

# Loading required packages 
Packages <- c("rio", "dplyr", "tidyr", "repmis", "httr", "knitr", "ggplot2",
              "xtable", "stargazer", "texreg", "lmtest", "sandwich", "Zelig",
              "ggmap", "rworldmap", "car", "PerformanceAnalytics")
lapply(Packages, require, character.only = TRUE) 

# Setting the commonly used working directory
possible_dir <- c('D:/Eigene Dokumente/!1 Vorlesungen/!! WS 2015/Introduction to 
                  Collaborative Social Science Data Analysis/Assignment3', 
                  '~/HSoG/DataAnalysis/GitHub/Assignment3')
set_valid_wd(possible_dir)
rm(possible_dir)

# Citing R packages 
LoadandCite(Packages, file = 'References/RpackageCitations.bib')
rm(Packages)

# Loading data set from csv file
DistrictData <- read.csv(file="Analysis/data/DistrictData2013.csv")

# Removing ranking column (it was added in the saving process in DataMerging.R)
DistrictData <- DistrictData[,-1]

########################
# Creation of relative measurements
########################

# Marraig rate: Number of marriages per 100,000 inhabitants 
DistrictData$MarriageRate <- 
  (DistrictData$HusbandAndWifeTotal / 
  DistrictData$TotalPopulation) * 100000

# Proportion of male population
DistrictData$MaleRate <- 
  (DistrictData$MalePopulation / 
  DistrictData$TotalPopulation) * 100

# Density per square km to 100 persons per square km ## Not necesassry 
# DistrictData$DensityPerSQRTkm100 <- 
  # DistrictData$DensityPerSQRTkm / 100

# Relative conservative vote  
### Not required, we can use TurnoutPercentage as a very solid measure of political participation
#DistrictData$VoteConservativesPercent <- 
 # DistrictData$VoteConservativesTotal * 100 / 
  # (DistrictData$TurnoutPercentage * DistrictData$EntitledVoteTotal / 100)
# TurnoutPercentage is coded in % between 0 and 100

# Share of young individuals # I don't think we should include 0-17. Very low probability of child comiting crimes. 
# Youth Rate is a better control variable
DistrictData$YouthRate <- 
  (DistrictData$Pop18to24 / 
  DistrictData$TotalPopulation) * 100000

# Share of Believers
# Problematic: rates are significant lower in former East Germany 
DistrictData$BelieversRate <- 
  (DistrictData$BelieversTotal / 
  DistrictData$TotalPopulation) * 100000

# Net Mobility rate 
DistrictData$NetFlowRate <- 
  ((DistrictData$InfluxTotal -
     DistrictData$OutflowTotal) /
  DistrictData$TotalPopulation) * 100000


########################
# Create composite dependent variable:
# (non-) violent and total crime 
########################

# violent crime
DistrictData$CrimeViolent <- 
  DistrictData$bodilyHarm + 
  DistrictData$dangerousBodilyHarm +
  DistrictData$violentCrime +
  DistrictData$murderAndManslaughter +
  DistrictData$robberyIncludingExtortionAndAttackOfCarDrivers

#Violent crime rate
# Non-violent crime rate
DistrictData$ViolentCrimeRate <- 
  (DistrictData$CrimeViolent / 
     DistrictData$TotalPopulation) * 100000

# non-violent crime 
DistrictData$CrimeNonViolent <- 
  DistrictData$robberyFromOrOutOfCars + 
  DistrictData$robberyOfCars +
  DistrictData$vandalism +
  DistrictData$vandalismGraffiti +
  DistrictData$streetCrime +
  DistrictData$burglaryDaylight +
  DistrictData$burglary

# Non-violent crime rate
DistrictData$NonViolentCrimeRate <- 
  (DistrictData$CrimeNonViolent / 
     DistrictData$TotalPopulation) * 100000

# total crimes
DistrictData$CrimeTotal <- 
  DistrictData$bodilyHarm + 
  DistrictData$dangerousBodilyHarm +
  DistrictData$violentCrime +
  DistrictData$murderAndManslaughter +
  DistrictData$robberyIncludingExtortionAndAttackOfCarDrivers +
  DistrictData$robberyFromOrOutOfCars + 
  DistrictData$robberyOfCars +
  DistrictData$vandalism +
  DistrictData$vandalismGraffiti +
  DistrictData$streetCrime +
  DistrictData$burglaryDaylight +
  DistrictData$burglary

# Total crime rate
DistrictData$CrimeRate <- 
  (DistrictData$CrimeTotal / 
     DistrictData$TotalPopulation) * 100000

#################################
# Historgrams
################################
DistrictData$CrimeRate <- as.numeric(as.character(DistrictData$CrimeRate))
# Crime Rate count
histCrimeRate <- ggplot(DistrictData, aes(CrimeRate)) + 
  geom_histogram(binwidth=500, colour="black", fill="white")

# Violent Crime histogram
histViolentCrimeRate <- ggplot(DistrictData, aes(ViolentCrimeRate)) + 
  geom_histogram(binwidth=50, colour="black", fill="white")

# Non-Violent Crime histogram
histNonViolentCrimeRate <- ggplot(DistrictData, aes(NonViolentCrimeRate)) + 
  geom_histogram(binwidth=400, colour="black", fill="white")

##########
# Correlation
######
datacor <- DistrictData[, c(19,22,40,47,49,50,51,52,53)]
chartCor <- chart.Correlation(datacor, historgram=T)

#Saving DistrictDataAdd
write.csv(DistrictData, file = "Analysis/DistrictDataAdd.csv")