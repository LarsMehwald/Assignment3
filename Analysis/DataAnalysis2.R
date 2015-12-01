########################
# Lars Mehwald and Daniel Salgado Moreno
# December 2015
# Final Project
# Data analysis
########################

######### Structure of this script
# Loading packages 
# Loading Data frame
# OLS models
# Poisson models
# Tables generation with stargazer

# Loading required packages 
Packages <- c("rio", "dplyr", "tidyr", "repmis", "httr", "knitr", "ggplot2",
              "xtable", "stargazer", "texreg", "lmtest", "sandwich", "Zelig",
              "car", "MASS", "PerformanceAnalytics", "pscl", "AER")
lapply(Packages, require, character.only = TRUE) 

# Setting the commonly used working directory
possible_dir <- c('D:/Eigene Dokumente/!1 Vorlesungen/!! WS 2015/Introduction to Collaborative Social Science Data Analysis/Assignment3', 
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

####################################
# Declareing integre data for analysis
####################################

# Declaring distric Id as factor variablespo
DistrictData$district <- as.factor(DistrictData$district)
# Declaring all relevant variables for model integer
DistrictData$CrimeRate <- as.integer(DistrictData$CrimeRate)
DistrictData$FoundationsDensity100k <- as.integer(DistrictData$FoundationsDensity100k)
#DistrictData$FoundationsDensity100kLog <- as.integer(DistrictData$FoundationsDensity100kLog)
DistrictData$FlowRate <- as.integer(DistrictData$FlowRate)
#DistrictData$FlowRateLog <- as.integer(DistrictData$FlowRateLog)
DistrictData$TurnoutPercentage <- as.integer(DistrictData$TurnoutPercentage)
#DistrictData$TurnoutPercentageLog <- as.integer(DistrictData$TurnoutPercentageLog)
#DistrictData$PropwoHauptschulabschluss <- as.integer(DistrictData$PropwoHauptschulabschluss)
DistrictData$YouthRate <- as.integer(DistrictData$YouthRate)
DistrictData$MaleRate <- as.integer(DistrictData$MaleRate)
DistrictData$UnemployedPercentage <- as.integer(DistrictData$UnemployedPercentage)
#DistrictData$BelieversRate <- as.integer(DistrictData$BelieversRate)
DistrictData$MarriageRate <- as.integer(DistrictData$MarriageRate)
DistrictData$MurderRate <- as.integer(DistrictData$MurderRate)
DistrictData$ForeignerRate <- as.integer(DistrictData$ForeignerRate)
DistrictData$TotalPopulation <- as.integer(DistrictData$TotalPopulation)
DistrictData$murderAndManslaughter <- as.integer(DistrictData$murderAndManslaughter)
DistrictData$FoundationsTotal <- as.integer(DistrictData$FoundationsTotal)
DistrictData$OutflowTotal <- as.integer(DistrictData$OutflowTotal)
DistrictData$TurnoutPercentage <- as.integer(DistrictData$TurnoutPercentage)
DistrictData$ForeignersTotal <- as.integer(DistrictData$ForeignersTotal)
DistrictData$MalePopulation <- as.integer(DistrictData$MalePopulation)
DistrictData$Pop0to17 <- as.integer(DistrictData$Pop0to17)
DistrictData$Pop18to24 <- as.integer(DistrictData$Pop18to24)
DistrictData$Pop25to44 <- as.integer(DistrictData$Pop25to44)
DistrictData$PopOver65 <- as.integer(DistrictData$PopOver65)

DistrictData$Murder <- DistrictData$murderAndManslaughter

#########################################
# Poisson models
########################################

# Poisson-based regression model 1 counts
poisson1 <- glm(Murder ~ 
                  FoundationsTotal +
                  OutflowTotal +
                  TurnoutPercentage +
                  ForeignersTotal +
                  MalePopulation +
                  Pop0to17 + 
                  Pop18to24 +
                  Pop25to44 +
                  Pop45to64 + 
                  PopOver65,
                DistrictData, family = poisson())

est1 <- cbind(Estimate = coef(poisson1), confint(poisson1))
incidentrate1 <- exp(est1)

# Poisson-based regression model 2 rates
poisson2 <- glm(Murder ~ 
                    FoundationsTotal +
                    OutflowTotal +
                    TurnoutPercentage +
                    ForeignersTotal +
                    MalePopulation +
                    Pop0to17 + 
                    Pop18to24 +
                    Pop25to44 +
                    Pop45to64 + 
                    PopOver65,
                  DistrictData, offset=log(DistrictData$TotalPopulation), family = poisson())

est2 <- cbind(Estimate = coef(poisson2), confint(poisson2))
incidentrate2 <- exp(est2)

# Murder Rate Histogram
histMurder <- ggplot(DistrictData, aes(Murder)) + 
  geom_histogram(binwidth=1, colour="black", fill="white")
plot(histMurder)

##############################################
# Negative Binomial Model
##############################################

# negative Binomial model 1
nb.glm1 <- glm.nb(Murder ~ 
                    FoundationsTotal +
                    OutflowTotal +
                    TurnoutPercentage +
                    ForeignersTotal +
                    MalePopulation +
                    Pop0to17 + 
                    Pop18to24 +
                    Pop25to44 +
                    Pop45to64 + 
                    PopOver65 +
                    offset(log(TotalPopulation)),
                  DistrictData)

est3 <- cbind(Estimate = coef(nb.glm1), confint(nb.glm1))
incidentrate3 <- exp(est3)

print(incidentrate3)

##############################################
# Zero Inflated Poisson models due to underdispersion (districts with 0 Murders)
##############################################

# Zero Inflated Model 1
zi1 <- zeroinfl(Murder ~ 
                  FoundationsTotal +
                  OutflowTotal +
                  TurnoutPercentage +
                  ForeignersTotal +
                  MalePopulation +
                  Pop0to17 + 
                  Pop18to24 +
                  Pop25to44 +
                  Pop45to64 + 
                  PopOver65 +
                  offset(log(TotalPopulation)) 
                | 1, 
                DistrictData, dist = "negbin")
est4 <- cbind(Estimate = coef(zi1), confint(zi1))
incidentrate4 <- exp(est4)

# Zero Inflated Model 2
zi2 <- zeroinfl(Murder ~ 
                  FoundationsTotal +
                  OutflowTotal +
                  TurnoutPercentage +
                  ForeignersTotal +
                  MalePopulation +
                  Pop0to17 + 
                  Pop18to24 +
                  Pop25to44 +
                  Pop45to64 + 
                  PopOver65 +
                  offset(log(TotalPopulation)) 
                | 
                  FoundationsTotal +
                  OutflowTotal +
                  TurnoutPercentage +
                  ForeignersTotal +
                  MalePopulation +
                  Pop0to17 + 
                  Pop18to24 +
                  Pop25to44 +
                  Pop45to64 + 
                  PopOver65 +
                  offset(log(TotalPopulation)), 
                DistrictData, dist = "negbin")

est5 <- cbind(Estimate = coef(zi2), confint(zi2))
incidentrate5 <- exp(est5)

incidentrates <- cbind(incidentrate1,incidentrate2,incidentrate3)
print(incidentrates)

xtable(poisson2)