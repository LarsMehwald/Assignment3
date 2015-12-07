########################
# Lars Mehwald and Daniel Salgado Moreno
# 11 December 2015
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

# Loading data set from csv file
DistrictData <- read.csv(file="Analysis/data/DistrictData2013.csv")

# Removing ranking column (it was added in the saving process in DataMerging.R)
DistrictData <- DistrictData[,-1]

# Sourcing the merging file
# source("DataMerging.R")

########################
# Linear regression
########################

# Linear regression model 1
OLSViolent <- lm(ViolentCrimeRate ~
                    FoundationsDensity100k + FlowRate + TurnoutPercentage + 
                    ForeignerRate + MarriageRate + MaleRate + YouthRate + UnemployedPercentage + EastWest,
                  data=DistrictData)
summary(OLSViolentFoundations)

# Linear regression model 2
OLSMurder <- lm(MurderRate ~
                  FoundationsDensity100k + FlowRate + TurnoutPercentage + 
                  ForeignerRate + MarriageRate + MaleRate + YouthRate + UnemployedPercentage + EastWest,
                data=DistrictData)
summary(OLSMurder)

########################
# Declareing integer data for analysis
########################

# Declaring distric Id as factor variablespo
DistrictData$district <- as.factor(DistrictData$district)

# Declaring all relevant variables for model integer
DistrictData$MurderRate <- as.integer(DistrictData$MurderRate)

DistrictData$FoundationsDensity100k <- as.integer(DistrictData$FoundationsDensity100k)
DistrictData$FlowRate <- as.integer(DistrictData$FlowRate)
DistrictData$TurnoutPercentage <- as.integer(DistrictData$TurnoutPercentage)

DistrictData$ForeignerRate <- as.integer(DistrictData$ForeignerRate)
DistrictData$MarriageRate <- as.integer(DistrictData$MarriageRate)
DistrictData$MaleRate <- as.integer(DistrictData$MaleRate)
DistrictData$YouthRate <- as.integer(DistrictData$YouthRate)
DistrictData$UnemployedPercentage <- as.integer(DistrictData$UnemployedPercentage)
DistrictData$EastWest <- as.integer(DistrictData$EastWest)

########################
# Poisson models
########################

# Poission model 1
poisson.glm1 <- glm(MurderRate ~ 
                      FoundationsDensity100k + FlowRate + TurnoutPercentage + 
                      ForeignerRate + MarriageRate + MaleRate + YouthRate + UnemployedPercentage + EastWest,
                    data=DistrictData, 
               family = poisson())

# Dispersion Test
dispersiontest(poisson.glm1)
# p-values too small: therefore nb needed!
# mean=var: condition for Poisson model
# if mean < var: overdispersion
# use mle: correcting s.e.
# summary(poisson.glm): Residual deviance>degrees of freedom : if so = overdispersion

# Dispersion Test
# The overdispersion test assess the "goodness of fit" for the poisson model
# p-values too small: therefore nominal binominal model needed!
# Basic Poisson model assumption: mean=var
# if mean < var: overdispersion
# use mle: correcting s.e.
# Visual assesment: summary(poisson1) if Residual deviance>degrees of freedom : if so = overdispersion
dispersiontest(poisson.glm1)
# This test confirms overdispersion
# In consecuence, it is better to use a Negative Binominal Model

# Extracting the estimated coefficents and confident intervals, then creating their exponential object
est1 <- cbind(Estimate = coef(poisson.glm1), confint(poisson.glm1))
incidentrate1 <- exp(est1)

########################
# Correcting s.e. with QuasiPoisson
########################

# Quasi Poission model 1
quasipoisson.glm1 <- glm(MurderRate ~ 
                           FoundationsDensity100k + FlowRate + TurnoutPercentage + 
                           ForeignerRate + MarriageRate + MaleRate + YouthRate + UnemployedPercentage + EastWest,
                         data=DistrictData, 
                    family = quasipoisson())

# Extracting the estimated coefficents and confident intervals, then creating their exponential object
est.qpoisson <- cbind(Estimate = coef(quasipoisson.glm4), confint(quasipoisson.glm4))
incidentrate.qpoisson <- exp(est.qpoisson)

########################
# Negative Binomial Models
########################

# negative Binomial model 1
nb.glm1 <- glm.nb(MurderRate ~ 
                    FoundationsDensity100k + FlowRate + TurnoutPercentage + 
                    ForeignerRate + MarriageRate + MaleRate + YouthRate + UnemployedPercentage + EastWest,
                  data=DistrictData)

# Extracting the estimated coefficents and confident intervals, then creating their exponential object
# est.nb <- cbind(Estimate = coef(nb.glm4), confint(nb.glm4))
# incidentrate.nb <- exp(nb.glm4)

########################
# MC simulations
########################

# Poisson model with Zelig (MC simulation)
poisson <- zelig(MurderRate ~ 
                   FoundationsDensity100k + FlowRate + TurnoutPercentage + 
                   ForeignerRate + MarriageRate + MaleRate + YouthRate + UnemployedPercentage + EastWest,
                 data=DistrictData,
                 model="poisson",
                 cite=FALSE)

# MC Simulation using 1st and 3rd Qu. 
xp.low <- setx(poisson, "FoundationsDensity100k" = 11, "FlowRate" = 9980, "TurnoutPercentage" = 68)
xp.high <- setx(poisson,  "FoundationsDensity100k" = 25,"FlowRate" = 13800, "TurnoutPercentage" = 73)
s.poisson <- sim(poisson, x=xp.low, x1=xp.high)
# plot(s.poisson)

# negative Binomial regression model with Zelig (MC simulation)
nb.out <- zelig(MurderRate ~ 
                  FoundationsDensity100k + FlowRate + TurnoutPercentage + 
                  ForeignerRate + MarriageRate + MaleRate + YouthRate + UnemployedPercentage + EastWest,
                 data=DistrictData, 
                 model="negbinom",
                 cite=FALSE)

# MC Simulation using 1st and 3rd Qu.  
xnb.low <- setx(nb.out, "FoundationsDensity100k" = 11, "FlowRate" = 9980, "TurnoutPercentage" = 68)
xnb.high <- setx(nb.out, "FoundationsDensity100k" = 25,"FlowRate" = 13800, "TurnoutPercentage" = 73)
snb.out <- sim(nb.out, x=xnb.low, x1=xnb.high)
# plot(snb.out)

########################
# Creating table output
########################
 
# transferred to presentation 

# Removing regression results 
# rm(OLSViolentFoundations, OLSViolentFlow, OLSViolentTurnout, OLSMurderFoundations, OLSMurderFlow, OLSMurderTurnout)
# rm(z1, z2, z3, z4)
