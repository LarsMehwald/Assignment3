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

# Sourcing the merging file
# source("DataMerging.R")

########################
# Linear regression
########################

# 1st table: OLS
# 3 IV, 1 DV = 3 
# 2nd table: 
# 3 IV, 1 DV, 3 model

# Getting rid of Berlin and Hamburg (outliers?)
# DistrictData <- DistrictData[-c(1,2),]

# Linear regression model 1
OLSViolentFoundations <- lm(ViolentCrimeRate ~
                    FoundationsDensity100k +
                    ForeignerRate + MarriageRate + MaleRate + YouthRate + UnemployedPercentage,
                  data=DistrictData)
summary(OLSViolentFoundations)

# Linear regression model 2
OLSViolentFlow <- lm(ViolentCrimeRate ~
                              FlowRate +
                              ForeignerRate + MarriageRate + MaleRate + YouthRate + UnemployedPercentage,
                            data=DistrictData)
summary(OLSViolentFlow)

# Linear regression model 3
OLSViolentTurnout <- lm(ViolentCrimeRate ~
                       TurnoutPercentage +
                       ForeignerRate + MarriageRate + MaleRate + YouthRate + UnemployedPercentage,
                     data=DistrictData)
summary(OLSViolentFlow)

# Linear regression model 4
OLSMurderFoundations <- lm(MurderRate ~ 
                      FoundationsDensity100k + 
                      ForeignerRate + MarriageRate + MaleRate + YouthRate + UnemployedPercentage,
                    data=DistrictData)
summary(OLSMurderFoundations)

# Linear regression model 5
OLSMurderFlow <- lm(MurderRate ~ 
                      FlowRate +
                      ForeignerRate + MarriageRate + MaleRate + YouthRate + UnemployedPercentage,
                    data=DistrictData)
summary(OLSMurderFlow)

# Linear regression model 6
OLSMurderTurnout <- lm(MurderRate ~ 
                      TurnoutPercentage + 
                      ForeignerRate + MarriageRate + MaleRate + YouthRate + UnemployedPercentage,
                    data=DistrictData)
summary(OLSMurderTurnout)

# After running regression
# regrobbery_hat <- fitted(regrobbery) #predicted values
# as.data.frame(regrobbery_hat)
# regrobbery_res <- residuals(regrobbery) #residuals 
# as.data.frame(regrobbery_res)

####################################
# Declareing integre data for analysis
####################################

# Declaring distric Id as factor variablespo
DistrictData$district <- as.factor(DistrictData$district)
# Declaring all relevant variables for model integer
DistrictData$CrimeRate <- as.integer(DistrictData$CrimeRate)
DistrictData$FoundationsDensity100k <- as.integer(DistrictData$FoundationsDensity100k)
DistrictData$FlowRate <- as.integer(DistrictData$FlowRate)
DistrictData$TurnoutPercentage <- as.integer(DistrictData$TurnoutPercentage)
DistrictData$YouthRate <- as.integer(DistrictData$YouthRate)
DistrictData$MaleRate <- as.integer(DistrictData$MaleRate)
DistrictData$UnemployedPercentage <- as.integer(DistrictData$UnemployedPercentage)
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

# Creating a subset of variables from DistrictData data frame for analysis 
#subset1 <- DistrictData[,c(59,47,53,40,19,51,50,22,52,49)]

#########################################
# Poisson models
########################################

#Poission model 1
poisson.glm1 <- glm(MurderRate ~ 
                 FoundationsDensity100k +
                 ForeignerRate +
                 MarriageRate +
                 MaleRate +
                 YouthRate +
                 UnemployedPercentage, 
               DistrictData, 
               family = poisson())

#Dispersion Test
dispersiontest(poisson.glm1)
# p-values too small: therefore nb needed!
#mean=var: condition for Poisson model
#if mean < var: overdispersion
#use mle: correcting s.e.
#summary(poisson.glm): Residual deviance>degrees of freedom : if so = overdispersion

#Poission model 2
poisson.glm2 <- glm(MurderRate ~ 
                     FlowRate +
                     ForeignerRate +
                     MarriageRate +
                     MaleRate +
                     YouthRate +
                     UnemployedPercentage, 
                   DistrictData, 
                   family = poisson())
#Dispersion Test
dispersiontest(poisson.glm2)

#Poission model 3
poisson.glm3 <- glm(MurderRate ~ 
                     TurnoutPercentage +
                     ForeignerRate +
                     MarriageRate +
                     MaleRate +
                     YouthRate +
                     UnemployedPercentage, 
                   DistrictData, 
                   family = poisson())
#Dispersion Test
dispersiontest(poisson.glm3)

#Poission model 4
poisson.glm4 <- glm(MurderRate ~ 
                     FoundationsDensity100k +
                     FlowRate +
                     TurnoutPercentage +
                     ForeignerRate +
                     MarriageRate +
                     MaleRate +
                     YouthRate +
                     UnemployedPercentage, 
                   DistrictData, 
                   family = poisson())
#Dispersion Test
#The overdispersion test assess the "goodness of fit" for the poisson model
# p-values too small: therefore nominal binominal model needed!
# Basic Poisson model assumption: mean=var
# if mean < var: overdispersion
# use mle: correcting s.e.
# Visual assesment: summary(poisson1) if Residual deviance>degrees of freedom : if so = overdispersion
dispersiontest(poisson.glm4)
# This test confirms overdispersion
# In consecuence, it is better to use a Negative Binominal Model

# Extracting the estimated coefficents and confident intervals, then creating their exponential object
est1 <- cbind(Estimate = coef(poisson.glm4), confint(poisson.glm4))
incidentrate1 <- exp(est1)

############################################
# Correcting s.e. with QuasiPoisson
###########################################

#Quasi Poission model 1
quasipoisson.glm1 <- glm(MurderRate ~ 
                      FoundationsDensity100k +
                      ForeignerRate +
                      MarriageRate +
                      MaleRate +
                      YouthRate +
                      UnemployedPercentage, 
                    DistrictData, 
                    family = quasipoisson())

#Quasi Poission model 2
quasipoisson.glm2 <- glm(MurderRate ~ 
                          FlowRate +
                          ForeignerRate +
                          MarriageRate +
                          MaleRate +
                          YouthRate +
                          UnemployedPercentage, 
                        DistrictData, 
                        family = quasipoisson())

#Quasi Poission model 3
quasipoisson.glm3 <- glm(MurderRate ~ 
                          TurnoutPercentage +
                          ForeignerRate +
                          MarriageRate +
                          MaleRate +
                          YouthRate +
                          UnemployedPercentage, 
                        DistrictData, 
                        family = quasipoisson())

#Quasi Poission model 4
quasipoisson.glm4 <- glm(MurderRate ~ 
                          FoundationsDensity100k +
                          FlowRate +
                          TurnoutPercentage +
                          ForeignerRate +
                          MarriageRate +
                          MaleRate +
                          YouthRate +
                          UnemployedPercentage, 
                        DistrictData, 
                        family = quasipoisson())

# Extracting the estimated coefficents and confident intervals, then creating their exponential object
est.qpoisson <- cbind(Estimate = coef(quasipoisson.glm4), confint(quasipoisson.glm4))
incidentrate.qpoisson <- exp(est.qpoisson)

##############################################
# Negative Binomial Models
##############################################

# negative Binomial model 1
nb.glm1 <- glm.nb(MurderRate ~ 
               FoundationsDensity100k +
               ForeignerRate +
               MarriageRate +
               MaleRate +
               YouthRate +
               UnemployedPercentage,
             DistrictData)

# negative Binomial model 2
nb.glm2 <- glm.nb(MurderRate ~ 
               FlowRate +
               ForeignerRate +
               MarriageRate +
               MaleRate +
               YouthRate +
               UnemployedPercentage,
             DistrictData)

# negative Binomial model 3
nb.glm3 <- glm.nb(MurderRate ~ 
               TurnoutPercentage +
               ForeignerRate +
               MaleRate +
               YouthRate +
               UnemployedPercentage,
             DistrictData)

# negative Binomial model 4
nb.glm4 <- glm.nb(MurderRate ~ 
               FoundationsDensity100k +
               FlowRate +
               TurnoutPercentage +
               ForeignerRate +
               MarriageRate +
               MaleRate +
               YouthRate +
               UnemployedPercentage,
             DistrictData)

# Extracting the estimated coefficents and confident intervals, then creating their exponential object
#est.nb <- cbind(Estimate = coef(nb.glm4), confint(nb.glm4))
#incidentrate.nb <- exp(nb.glm4)


####################################################
# MC simulations
####################################################

# Poisson model with Zelig (MC simulation)
poisson <- zelig(MurderRate ~ 
                   FoundationsDensity100k +
                   FlowRate +
                   TurnoutPercentage +
                   ForeignerRate +
                   MarriageRate +
                   MaleRate +
                   YouthRate +
                   UnemployedPercentage, 
                 DistrictData,
                 model="poisson",
                 cite=FALSE)

# MC Simulation using 1st and 3rd Qu. 
xp.low <- setx(poisson, "FoundationsDensity100k" = 2.4340, "FlowRate" = 9.532, "TurnoutPercentage" = 4.224)
xp.high <- setx(poisson, "FoundationsDensity100k" = 3.2540, "FlowRate" = 9.208, "TurnoutPercentage" = 4.303)
s.poisson <- sim(poisson, x=xp.low, x1=xp.high)
#plot(s.poisson)

#negative Binomial regression model with Zelig (MC simulation)
nb.out <- zelig(MurderRate ~ 
                  FoundationsDensity100k +
                  FlowRate +
                  TurnoutPercentage +
                  ForeignerRate +
                  MarriageRate +
                  MaleRate +
                  YouthRate +
                  UnemployedPercentage, 
                 DistrictData, 
                 model="negbinom",
                 cite=FALSE)

 #MC Simulation using 1st and 3rd Qu.  
 xnb.low <- setx(nb.out, "FoundationsDensity100k" = 11, "FlowRate" = 9980, "TurnoutPercentage" = 68)
 xnb.high <- setx(nb.out, "FoundationsDensity100k" = 25,"FlowRate" = 13800, "TurnoutPercentage" = 73)
 snb.out <- sim(nb.out, x=xnb.low, x1=xnb.high)
 plot(snb.out)
 summary(DistrictData$TurnoutPercentage)

########################
# Creating table output
########################
 
# transferred to presentation 

# Removing regression results 
# rm(OLSViolentFoundations, OLSViolentFlow, OLSViolentTurnout, OLSMurderFoundations, OLSMurderFlow, OLSMurderTurnout)
# rm(z1, z2, z3, z4)
