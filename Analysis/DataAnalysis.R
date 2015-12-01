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

# Creating a subset of variables from DistrictData data frame for analysis 
#subset1 <- DistrictData[,c(59,47,53,40,19,51,50,22,52,49)]

#########################################
# Poisson models
########################################

#Poission model 1
poisson.glm1 <- glm(MurderRate ~ 
                 FoundationsDensity100kLog +
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
                     FlowRateLog +
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
                     TurnoutPercentageLog +
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
                     FoundationsDensity100kLog +
                     FlowRateLog +
                     TurnoutPercentageLog +
                     ForeignerRate +
                     MarriageRate +
                     MaleRate +
                     YouthRate +
                     UnemployedPercentage, 
                   DistrictData, 
                   family = poisson())
#Dispersion Test
dispersiontest(poisson.glm4)

############################################
# Correcting s.e. with QuasiPoisson
###########################################

#Quasi Poission model 1
quasipoisson.glm1 <- glm(MurderRate ~ 
                      FoundationsDensity100kLog +
                      ForeignerRate +
                      MarriageRate +
                      MaleRate +
                      YouthRate +
                      UnemployedPercentage, 
                    DistrictData, 
                    family = quasipoisson())

#Quasi Poission model 2
quasipoisson.glm2 <- glm(MurderRate ~ 
                          FlowRateLog +
                          ForeignerRate +
                          MarriageRate +
                          MaleRate +
                          YouthRate +
                          UnemployedPercentage, 
                        DistrictData, 
                        family = quasipoisson())

#Quasi Poission model 3
quasipoisson.glm3 <- glm(MurderRate ~ 
                          TurnoutPercentageLog +
                          ForeignerRate +
                          MarriageRate +
                          MaleRate +
                          YouthRate +
                          UnemployedPercentage, 
                        DistrictData, 
                        family = quasipoisson())

#Quasi Poission model 4
quasipoisson.glm4 <- glm(MurderRate ~ 
                          FoundationsDensity100kLog +
                          FlowRateLog +
                          TurnoutPercentageLog +
                          ForeignerRate +
                          MarriageRate +
                          MaleRate +
                          YouthRate +
                          UnemployedPercentage, 
                        DistrictData, 
                        family = quasipoisson())

##############################################
# Negative Binomial Models
##############################################

# negative Binomial model 1
nb.glm1 <- glm.nb(MurderRate ~ 
               FoundationsDensity100kLog +
               ForeignerRate +
               MarriageRate +
               MaleRate +
               YouthRate +
               UnemployedPercentage,
             DistrictData)

# negative Binomial model 2
nb.glm2 <- glm.nb(MurderRate ~ 
               FlowRateLog +
               ForeignerRate +
               MarriageRate +
               MaleRate +
               YouthRate +
               UnemployedPercentage,
             DistrictData)

# negative Binomial model 3
nb.glm3 <- glm.nb(MurderRate ~ 
               TurnoutPercentageLog +
               ForeignerRate +
               MaleRate +
               YouthRate +
               UnemployedPercentage,
             DistrictData)

# negative Binomial model 4
nb.glm4 <- glm.nb(MurderRate ~ 
               FoundationsDensity100kLog +
               FlowRateLog +
               TurnoutPercentageLog +
               ForeignerRate +
               MarriageRate +
               MaleRate +
               YouthRate +
               UnemployedPercentage,
             DistrictData)

# negative Binomial model 5
nb.glm5 <- glm.nb(MurderRate ~ 
                    TurnoutPercentageLog +
                    ForeignerRate,
                  DistrictData)
# negative Binomial model 6
nb.glm6 <- glm.nb(MurderRate ~ 
                    TurnoutPercentageLog +
                    ForeignerRate +
                    MaleRate,
                  DistrictData)
# negative Binomial model 7
nb.glm7 <- glm.nb(MurderRate ~ 
                    TurnoutPercentageLog +
                    ForeignerRate +
                    MaleRate +
                    YouthRate,
                  DistrictData)

# negative Binomial model 8
nb.glm8 <- glm.nb(murderAndManslaughter ~ 
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

####################################################
# MC simulations
####################################################

# Poisson model with Zelig (MC simulation)
poisson <- zelig(MurderRate ~ 
                   FoundationsDensity100kLog +
                   FlowRateLog +
                   TurnoutPercentageLog +
                   ForeignerRate +
                   MarriageRate +
                   MaleRate +
                   YouthRate +
                   UnemployedPercentage, 
                 DistrictData,
                 model="poisson",
                 cite=FALSE)

# MC Simulation using 1st and 3rd Qu. 
xp.low <- setx(poisson, "FoundationsDensity100kLog" = 2.4340, "FlowRateLog" = 9.532, "TurnoutPercentageLog" = 4.224)
xp.high <- setx(poisson, "FoundationsDensity100kLog" = 3.2540, "FlowRateLog" = 9.208, "TurnoutPercentageLog" = 4.303)
s.poisson <- sim(poisson, x=xp.low, x1=xp.high)
#plot(s.poisson)

#negative Binomial regression model with Zelig (MC simulation)
nb.out <- zelig(MurderRate ~ 
                  FoundationsDensity100kLog +
                  FlowRateLog +
                  TurnoutPercentageLog +
                  ForeignerRate +
                  MarriageRate +
                  MaleRate +
                  YouthRate +
                  UnemployedPercentage, 
                 DistrictData, 
                 model="negbinom",
                 cite=FALSE)

 #MC Simulation
 xnb.low <- setx(nb.out, "FoundationsDensity100kLog" = 2.4340, "FlowRateLog" = 9.532, "TurnoutPercentageLog" = 4.224)
 xnb.high <- setx(nb.out, "FoundationsDensity100kLog" = 3.2540,"FlowRateLog" = 9.208, "TurnoutPercentageLog" = 4.303)
 snb.out <- sim(nb.out, x=xnb.low, x1=xnb.high)
 #plot(snb.out)

########################
# Creating table output
########################
 
# transferred to presentation 

# Removing regression results 
# rm(OLSViolentFoundations, OLSViolentFlow, OLSViolentTurnout, OLSMurderFoundations, OLSMurderFlow, OLSMurderTurnout)
# rm(z1, z2, z3, z4)
