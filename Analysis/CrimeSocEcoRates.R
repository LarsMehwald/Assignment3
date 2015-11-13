########################
# Lars Mehwald and Daniel Salgado Moreno
# 13 November 2015
# Assignment 3
# Additional variables (crime and socio economic rates)
########################

# Loading required packages 
Packages <- c("rio", "dplyr", "tidyr", "repmis", "httr", "knitr", "ggplot2",
              "xtable", "stargazer", "texreg", "lmtest", "sandwich", "Zelig",
              "ggmap", "rworldmap", "car", "PerformanceAnalytics", "MASS")
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

#################################
# Historgrams
################################

# Changing class of Crime Rate
DistrictData$CrimeRate <- as.integer(as.character(DistrictData$CrimeRate))

# Crime Rate hist
histCrimeRate <- ggplot(DistrictData, aes(CrimeRate)) + 
  geom_histogram(binwidth=500, colour="black", fill="white") 
ggsave()

# Violent Crime histogram
histViolentCrimeRate <- ggplot(DistrictData, aes(ViolentCrimeRate)) + 
  geom_histogram(binwidth=50, colour="black", fill="white")

# Non-Violent Crime histogram
histNonViolentCrimeRate <- ggplot(DistrictData, aes(NonViolentCrimeRate)) + 
  geom_histogram(binwidth=400, colour="black", fill="white")

##########
# Correlation
######

# Correlation Plot using R package: "PerformanceAnalytics"
datacor <- DistrictData[, c(19,22,40,47,49,50,51,52,53)]
chart.Correlation(datacor, historgram=T)
rm(datacor)

#########
# Negative Binomial Regression for Event Count Dependent Variables
#########

#creating a subset for data analysis
modelVCR <- DistrictData[c("district","ViolentCrimeRate","FoundationsDensity100K","NetFlowRate", 
                           "TurnoutPercentage","PropwoHauptschulabschluss","YouthRate",
                           "MaleRate","BeliversRate","UnemployedPercentage","MarriageRate")] 
# Asigning variables to subset data frame

# Declaring distric Id as factor variables
DistrictData$district <- as.factor(DistrictData$district)
DistrictData$ViolentCrimeRate <- as.integer(DistrictData$ViolentCrimeRate)
DistrictData$FoundationsDensity100k <- as.integer(DistrictData$FoundationsDensity100k)
DistrictData$NetFlowRate <- as.integer(DistrictData$NetFlowRate)
DistrictData$TurnoutPercentage <- as.integer(DistrictData$TurnoutPercentage)
DistrictData$PropwoHauptschulabschluss <- as.integer(DistrictData$PropwoHauptschulabschluss)
DistrictData$YouthRate <- as.integer(DistrictData$YouthRate)
DistrictData$MaleRate <- as.integer(DistrictData$MaleRate)
DistrictData$UnemployedPercentage <- as.integer(DistrictData$UnemployedPercentage)
DistrictData$BelieversRate <- as.integer(DistrictData$BelieversRate)
DistrictData$MarriageRate <- as.integer(DistrictData$MarriageRate)

#Removing District Name Year and district_year variables
#DistrictData <- DistrictData[,-c(1,2,3,4)]
DistrictData <- DistrictData[,c(1,55,47,53,40,19,51,50,22,52,49)]
DistrictData <- DistrictData[,c(1,55,47)]

z.out <- zelig(ViolentCrimeRate ~ FoundationsDensity100k + NetFlowRate + TurnoutPercentage + PropwoHauptschulabschluss + YouthRate + MaleRate + UnemployedPercentage + MarriageRate, model="negbinom", DistrictData)

z.out <- zelig(ViolentCrimeRate ~ FoundationsDensity100k, model="negbinom", DistrictData)

x.out <- setx(z.out)
s.out <- sim(z.out, x = x.out)
plot(s.out)

z1 <- glm.nb(ViolentCrimeRate ~ FoundationsDensity100k + NetFlowRate + TurnoutPercentage + PropwoHauptschulabschluss + YouthRate + MaleRate + UnemployedPercentage + MarriageRate, DistrictData, warnings())

z1 <- glm.nb(ViolentCrimeRate ~ FoundationsDensity100k , DistrictData, warnings())

z1 <- glm.nb(ViolentCrimeRate ~., DistrictData)

z.out <- zelig(ViolentCrimeRate ~., model="negbinom", DistrictData, cite=F)

x.out <- setx(z.out)
s.out <- sim(z.out, x = x.out)
plot(s.out)

# Linear regression model 1
regression1 <- lm(ViolentCrimeRate ~ 
                    FoundationsDensity100k +
                    NetFlowRate +
                    TurnoutPercentage +
                    PropwoHauptschulabschluss +
                    BelieversRate +
                    MarriageRate +
                    MaleRate +
                    YouthRate +
                    UnemployedPercentage,
                  data=DistrictData)
summary(regression1)

#Saving DistrictDataAdd
write.csv(DistrictData, file = "Analysis/DistrictDataAdd.csv")