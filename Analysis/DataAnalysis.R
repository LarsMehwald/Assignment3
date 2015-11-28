########################
# Lars Mehwald and Daniel Salgado Moreno
# 13 November 2015
# Assignment 3
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
              "ggmap", "rworldmap","car", "MASS", "PerformanceAnalytics", "pscl", "AER")
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
                    BelieversRate + MarriageRate + MaleRate + YouthRate + UnemployedPercentage,
                  data=DistrictData)
summary(OLSViolentFoundations)

# Linear regression model 2
OLSViolentFlow <- lm(ViolentCrimeRate ~
                              FlowRate +
                              BelieversRate + MarriageRate + MaleRate + YouthRate + UnemployedPercentage,
                            data=DistrictData)
summary(OLSViolentFlow)

# Linear regression model 3
OLSViolentTurnout <- lm(ViolentCrimeRate ~
                       TurnoutPercentage +
                       BelieversRate + MarriageRate + MaleRate + YouthRate + UnemployedPercentage,
                     data=DistrictData)
summary(OLSViolentFlow)

# Linear regression model 4
OLSMurderFoundations <- lm(MurderRate ~ 
                      FoundationsDensity100k + 
                      BelieversRate + MarriageRate + MaleRate + YouthRate + UnemployedPercentage,
                    data=DistrictData)
summary(OLSMurderFoundations)

# Linear regression model 5
OLSMurderFlow <- lm(MurderRate ~ 
                      FlowRate +
                      BelieversRate + MarriageRate + MaleRate + YouthRate + UnemployedPercentage,
                    data=DistrictData)
summary(OLSMurderFlow)

# Linear regression model 6
OLSMurderTurnout <- lm(MurderRate ~ 
                      TurnoutPercentage + 
                      BelieversRate + MarriageRate + MaleRate + YouthRate + UnemployedPercentage,
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

# Declaring distric Id as factor variables
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
DistrictData$BelieversRate <- as.integer(DistrictData$BelieversRate)
DistrictData$MarriageRate <- as.integer(DistrictData$MarriageRate)
DistrictData$MurderRate <- as.integer(DistrictData$MurderRate)

# Creating a subset of variables from DistrictData data frame for analysis 
#subset1 <- DistrictData[,c(59,47,53,40,19,51,50,22,52,49)]

#########################################
# Poisson models
########################################

# Poisson model with Zelig (MC simulation)
poisson <- zelig(MurderRate ~ 
                  FoundationsDensity100kLog +
                  FlowRateLog +
                  TurnoutPercentageLog +
                  BelieversRate +
                  MarriageRate +
                  MaleRate +
                  YouthRate +
                  UnemployedPercentage, 
                 DistrictData, 
                 model="poisson")
# MC Simulation using 1st and 3rd Qu. 
xp.low <- setx(poisson, "FoundationsDensity100kLog" = 2.4340, "FlowRateLog" = 9.532, "TurnoutPercentageLog" = 4.224)
xp.high <- setx(poisson, "FoundationsDensity100kLog" = 3.2540, "FlowRateLog" = 9.208, "TurnoutPercentageLog" = 4.303)
s.poisson <- sim(poisson, x=xp.low, x1=xp.high)
plot(s.poisson)

#Poission model 1
poisson.glm <- glm(MurderRate ~ 
                 FoundationsDensity100kLog +
                 BelieversRate +
                 MarriageRate +
                 MaleRate +
                 YouthRate +
                 UnemployedPercentage, 
               DistrictData, 
               family = poisson())

#Dispersion Test
dispersiontest(poisson.glm)
# p-values too small: therefore nb needed!
#mean=var: condition for Poisson model
#if mean < var: overdispersion
#use mle: correcting s.e.
#summary(poisson.glm): Residual deviance>degrees of freedom : if so = overdispersion

#Quasi Poission model 1
quasipoisson.glm <- glm(CrimeRate ~ 
                      FoundationsDensity100kLog +
                      BelieversRate +
                      MarriageRate +
                      MaleRate +
                      YouthRate +
                      UnemployedPercentage, 
                    DistrictData, 
                    family = quasipoisson())

# negative Binomial regression model 1
nb.glm1 <- glm.nb(MurderRate ~ 
               FoundationsDensity100kLog +
               BelieversRate +
               MarriageRate +
               MaleRate +
               YouthRate +
               UnemployedPercentage,
             DistrictData)

# negative Binomial regression model 2
nb.glm2 <- glm.nb(MurderRate ~ 
               FlowRateLog +
               BelieversRate +
               MarriageRate +
               MaleRate +
               YouthRate +
               UnemployedPercentage,
             DistrictData)

# negative Binomial regression model 3
ng.glm3 <- glm.nb(MurderRate ~ 
               TurnoutPercentageLog +
               BelieversRate +
               MarriageRate +
               MaleRate +
               YouthRate +
               UnemployedPercentage,
             DistrictData)

# negative Binomial regression model 4
nb.glm4 <- glm.nb(MurderRate ~ 
               FoundationsDensity100kLog +
               FlowRateLog +
               TurnoutPercentageLog +
               BelieversRate +
               MarriageRate +
               MaleRate +
               YouthRate +
               UnemployedPercentage,
             DistrictData)

# negative Binomial regression model with Zelig (MC simulation)
nb.out <- zelig(MurderRate ~ 
                 FoundationsDensity100kLog +
                 FlowRateLog +
                 TurnoutPercentageLog +
                 BelieversRate +
                 MarriageRate +
                 MaleRate +
                 YouthRate +
                 UnemployedPercentage, DistrictData, model="negbinom")
# MC Simulation
xnb.low <- setx(nb.out, "FoundationsDensity100kLog" = 2.4340, "FlowRateLog" = 9.532, "TurnoutPercentageLog" = 4.224)
xnb.high <- setx(nb.out, "FoundationsDensity100kLog" = 3.2540,"FlowRateLog" = 9.208, "TurnoutPercentageLog" = 4.303)
snb.out <- sim(nb.out, x=xnb.low, x1=xnb.high)
plot(snb.out)

########################
# Creating table output
########################
 
stargazer(OLSViolentFoundations, OLSViolentFlow, OLSViolentTurnout,
          type = "latex",
          header = FALSE, # important not to have stargazer information in markdown file 
          title = "Regression analysis regarding (non-) violent 
          and total crimes and independent variable FoundationsDensity100k
          with OLS regressions and negative binominal regression",
          digits = 2,
#          no.space = TRUE, # single.row = TRUE
          omit.stat = c("f", "ser"),
          notes = "This regression output shows the results using 3 different 
          dependent variables and two models")

print("\newpage", quote = FALSE)

stargazer(OLSMurderFoundations, OLSMurderFlow, OLSMurderTurnout, 
          type = "latex",
          header = FALSE, # important not to have stargazer information in markdown file 
          title = "Regression analysis regarding (non-) violent and total crimes 
          and independent variable FlowRate
          with OLS regressions and negative binominal regression",
          digits = 2,
#          no.space = TRUE, # single.row = TRUE
          omit.stat = c("f", "ser"),
          notes = "This regression output shows the results using 3 different 
          dependent variables and two models")

print("\newpage", quote = FALSE)

# Removing regression results 
rm(OLSViolentFoundations, OLSViolentFlow, OLSViolentTurnout, 
   OLSMurderFoundations, OLSMurderFlow, OLSMurderTurnout)
rm(z1, z2, z3, z4)
