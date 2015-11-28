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
# negative binomial models
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

#########################################
# Negative Binomial models
########################################

# Declaring distric Id as factor variables
DistrictData$district <- as.factor(DistrictData$district)

# Declaring all relevant variables for model integer
DistrictData$CrimeRate <- as.integer(DistrictData$CrimeRate)
DistrictData$FoundationsDensity100k <- as.integer(DistrictData$FoundationsDensity100k)
DistrictData$FlowRate <- as.integer(DistrictData$FlowRate)
DistrictData$TurnoutPercentage <- as.integer(DistrictData$TurnoutPercentage)
DistrictData$PropwoHauptschulabschluss <- as.integer(DistrictData$PropwoHauptschulabschluss)
DistrictData$YouthRate <- as.integer(DistrictData$YouthRate)
DistrictData$MaleRate <- as.integer(DistrictData$MaleRate)
DistrictData$UnemployedPercentage <- as.integer(DistrictData$UnemployedPercentage)
DistrictData$BelieversRate <- as.integer(DistrictData$BelieversRate)
DistrictData$MarriageRate <- as.integer(DistrictData$MarriageRate)
DistrictData$MurderRate <- as.integer(DistrictData$MurderRate)

# Creating a subset of variables from DistrictData data frame for analysis 
#subset1 <- DistrictData[,c(59,47,53,40,19,51,50,22,52,49)]

# Poisson model with Zelig (MC simulation)
zp.out <- zelig(CrimeRate ~ 
                 FoundationsDensity100k +
                 BelieversRate +
                 MarriageRate +
                 MaleRate +
                 YouthRate +
                 UnemployedPercentage, DistrictData, model="poisson")
# MC Simulation # DOES NOT WORK YET!
#xp.out <- setx(zp.out)
xp.low <- setx(zp.out, "FoundationsDensity100k" = 11)
xp.high <- setx(zp.out, "FoundationsDensity100k" = 25)
sp.out <- sim(zp.out, x=xp.low, x1=xp.high)
#sp.out <- sim(zp.out, x=xp.out)
plot(sp.out)

# negative Binomial regression model 0 with Zelig (MC simulation)
z.out <- zelig(CrimeRate ~ 
                 FoundationsDensity100k +
                 BelieversRate +
                 MarriageRate +
                 MaleRate +
                 YouthRate +
                 UnemployedPercentage, DistrictData, model="negbinom")
# MC Simulation
x.out <- setx(z.out)
s.out <- sim(z.out, x=x.out)
plot(s.out)

#Poission model 1
poisson <- glm(CrimeRate ~ 
                 FoundationsDensity100kLog +
                 BelieversRate +
                 MarriageRate +
                 MaleRate +
                 YouthRate +
                 UnemployedPercentage, 
               DistrictData, 
               family = poisson())

#Dispersion Test
dispersiontest(poisson)
# p-values too small: therefore nb needed!
#mean=var: condition for Poisson model
#if mean < var: overdispersion
#use mle: correcting s.e. 

#Quasi Poission model 1
quasipoisson <- glm(CrimeRate ~ 
                 FoundationsDensity100kLog +
                 BelieversRate +
                 MarriageRate +
                 MaleRate +
                 YouthRate +
                 UnemployedPercentage, 
               DistrictData, 
               family = quasipoisson())

#zero inflated !!! Doesn't Work due to: invalid dependent variable, minimum count is not zero 
zi1 <- zeroinfl(CrimeRate ~ 
             FoundationsDensity100kLog +
             BelieversRate +
             MarriageRate +
             MaleRate +
             YouthRate +
             UnemployedPercentage | 1, 
           DistrictData)

# negative Binomial regression model 1
z1 <- glm.nb(CrimeRate ~ 
               FoundationsDensity100kLog +
               BelieversRate +
               MarriageRate +
               MaleRate +
               YouthRate +
               UnemployedPercentage,
             DistrictData)

# negative Binomial regression model 2
z2 <- glm.nb(CrimeRate ~ 
               FlowRate +
               BelieversRate +
               MarriageRate +
               MaleRate +
               YouthRate +
               UnemployedPercentage,
             DistrictData)

# negative Binomial regression model 3
z3 <- glm.nb(CrimeRate ~ 
               TurnoutPercentage +
               BelieversRate +
               MarriageRate +
               MaleRate +
               YouthRate +
               UnemployedPercentage,
             DistrictData)

# negative Binomial regression model 4
z4 <- glm.nb(CrimeRate ~ 
               FoundationsDensity100k +
               FlowRate +
               TurnoutPercentage +
               BelieversRate +
               MarriageRate +
               MaleRate +
               YouthRate +
               UnemployedPercentage,
             DistrictData)

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
