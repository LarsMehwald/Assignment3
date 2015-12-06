########################
# Lars Mehwald and Daniel Salgado Moreno
# December 2015
# Final Project
# Data analysis
########################

######### Structure of this script
# Loading packages 
# Loading Data frame
# Data setup
# Poisson models
# Quassi Poisson
# Negative Binominal model

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
# Data setup
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

# New name to Murder
DistrictData$Murder <- DistrictData$murderAndManslaughter

# New name to Couples: 
DistrictData$Couples <- DistrictData$HusbandAndWifeTotal

# FlowTotal
DistrictData$FlowTotal <- (DistrictData$OutflowTotal + DistrictData$InfluxTotal)

# Creating categorical variables from contoinous independent variables 
# Selection of cathegories based on quantiles
DistrictData$Foundations_cat <- cut(DistrictData$FoundationsTotal,
                                    breaks= c(0,15,26,44,1194), 
                                    labels= c('1stQu', '2ndQu', '3rdQu', '4thQu'))

#########################################
# Discriptive statistics
########################################

summary(DistrictData$FoundationsTotal)
summary(DistrictData$FlowTotal)
summary(DistrictData$TurnoutPercentage)

# Murder Rate Histogram
histMurder <- ggplot(DistrictData, aes(Murder)) + 
  geom_histogram(binwidth=1, colour="black", fill="white")
plot(histMurder) 
# We can observe that the Homicide count is right skewed
# OLS regression models are inappropiate when small number of events
# Poisson models offer a good alternative

#########################################
# Poisson models
########################################

# Poisson-based regression model 1: "counts"
poisson1 <- glm(Murder ~ 
                  FoundationsTotal +
                  OutflowTotal +
                  TurnoutPercentage +
                  ForeignersTotal +
                  MalePopulation +
                  Couples +
                  Pop18to24 +
                  UnemployedPercentage,
                DistrictData, family = poisson())

#est1 <- cbind(Estimate = coef(poisson1), confint(poisson1))
#incidentrate1 <- exp(est1)

# Poisson-based regression model 2: "rates" # We now have included an offset (TotalPopulation) \\ 
# to control for population density // It includes a fixed coefficient of 1. 
# This control for population size is necessary so that the regression will //
# be a model of per capita crime rates rather than a model of counts of crimes.
poisson2 <- glm(Murder ~ 
                    FoundationsTotal +
                    OutflowTotal +
                    TurnoutPercentage +
                    ForeignersTotal +
                    MalePopulation +
                    Couples +
                    Pop18to24 +
                    UnemployedPercentage,
                  DistrictData, offset=log(DistrictData$TotalPopulation), family = poisson())

# est2 <- cbind(Estimate = coef(poisson2), confint(poisson2))
# incidentrate2 <- exp(est2)

#Dispersion Test
#The overdispersion test assess the "goodness of fit" for the poisson model
# p-values too small: therefore nominal binominal model needed!
# Basic Poisson model assumption: mean=var
# if mean < var: overdispersion
# use mle: correcting s.e.
# Visual assesment: summary(poisson1) if Residual deviance>degrees of freedom : if so = overdispersion
dispersiontest(poisson1) 
dispersiontest(poisson2)
# Both cases confirm overdispersion
# In consecuence, it is better to use a Negative Binominal Model

############################################
# Correcting s.e. due to overdispersion with QuasiPoisson
###########################################

#Quasi Poission model 1
quasipoisson1 <- glm(Murder ~ 
                       FoundationsTotal +
                       OutflowTotal +
                       TurnoutPercentage +
                       ForeignersTotal +
                       MalePopulation +
                       Pop18to24 + 
                       UnemployedPercentage, 
                      DistrictData, 
                      family = quasipoisson())

#Quasi Poission model 2
quasipoisson2 <- glm(Murder ~ 
                       FoundationsTotal +
                       OutflowTotal +
                       TurnoutPercentage +
                       ForeignersTotal +
                       MalePopulation +
                       Pop18to24 + 
                       UnemployedPercentage, 
                     DistrictData,
                     offset=log(DistrictData$TotalPopulation),
                     family = quasipoisson())

##############################################
# Negative Binomial Model 
##############################################

# negative Binomial model 1: a better alternative to correct for overdispersion
nb.glm1 <- glm.nb(Murder ~ 
                    FoundationsTotal +
                    FlowTotal +
                    TurnoutPercentage +
                    ForeignersTotal +
                    Couples +
                    MalePopulation +
                    Pop18to24 +
                    UnemployedPercentage +
                    offset(log(TotalPopulation)), # Offset tunrs counts into per capita rates
                  DistrictData)

# Incident rates and statistical significance
# Adding coefficients and confident intervals into new data frame 

# Extract coefficients and create confidence intervals for three levels of significance
est1 <- cbind(Estimate = coef(nb.glm1), 
              confint(nb.glm1, level=0.90),
              confint(nb.glm1, level=0.95),
              confint(nb.glm1, level=0.99))
est1 <- data.frame(est1)

# Adding three variables (1=TRUE) describing whether coefficient is significant at 
# a given level of statistical significance 
est1 <- cbind(est1, 
              ifelse(sign(est1[2]) == sign(est1[3]), 1, 0),
              ifelse(sign(est1[4]) == sign(est1[5]), 1, 0),
              ifelse(sign(est1[6]) == sign(est1[7]), 1, 0))
est1 <- round(est1, 4)

# Creating a new variable that indicates the level of statistical significance
# 0=not significant, 1=at 90%level, 2=at 95% level, 3=at 99%level
est1 <- cbind(est1, 
              ifelse(est1[10] == 1, 3, 
              ifelse(est1[9] == 1, 2,
              ifelse(est1[8] == 1, 1, 0))))
est1 <- est1[,-c(2:10)]

# Creating indicrnt rates by exponentiating the coefficients
est1 <- cbind(exp(est1[1]), est1[2])

# Creating new variable with stars * 
names(est1) <- c("Coefficient", "NumberStars")
est1 <- round(est1, 4)
est1$NumberStars <- as.factor(est1$NumberStars)
est1$Stars <- ifelse(est1$NumberStars == 3, "***", 
                            ifelse(est1$NumberStars == 2, "**",
                                   ifelse(est1$NumberStars == 1, "*", "")))
est1 <- est1[c(1,3)]

# Computating the cross-validation for this model
# It is the sum of the squared differenced between model predictions
# for different subsets of the data.
# This is a reasonable approach, since we are interested in how good/stable is 
# the model inferring from specific data to generalizable data 
CVglm <- cv.glm(data=DistrictData, glmfit=nb.glm1, K=4) # was suggested as a good value 
CVglm <- c(CVglm$delta) # the first value is no corrected for larger data 
# other ideas for goodness of fit
# http://www.biomedcentral.com/content/supplementary/1748-5908-6-55-s2.pdf

# negative Binomial model 5
nb.glm5 <- glm.nb(MurderRate ~ 
                    TurnoutPercentage +
                    ForeignerRate,
                  DistrictData)
# negative Binomial model 6
nb.glm6 <- glm.nb(MurderRate ~ 
                    TurnoutPercentage +
                    ForeignerRate +
                    MaleRate,
                  DistrictData)
# negative Binomial model 7
nb.glm7 <- glm.nb(MurderRate ~ 
                    TurnoutPercentage +
                    ForeignerRate +
                    MaleRate +
                    YouthRate,
                  DistrictData)

# When compareing Poisson vs NegBinomial: compare full and basline models
# Compare models with and without explainatory variables

newdata <- data.frame(FoundationsTotal=mean(DistrictData$FoundationsTotal), 
                       FlowTotal=mean(DistrictData$FlowTotal),
                       TurnoutPercentage=mean(DistrictData$FlowTotal),
                       ForeignersTotal=mean(DistrictData$ForeignersTotal),
                       Couples=mean(DistrictData$Couples),
                       MalePopulation=mean(DistrictData$MalePopulation),
                       Pop18to24=mean(DistrictData$Pop18to24),
                       UnemployedPercentage=mean(DistrictData$UnemployedPercentage),
                       TotalPopulation=1) #TotalPopulation has to be equal 1 due to its offset characteristic, accounting for population

# Using following algorithm: http://statistics.ats.ucla.edu/stat/r/dae/nbreg.htm
# This doesn't work for us, since we don't have any cathegorical variables to compare
newdata$phat <- predict(nb.glm1, newdata, type = "response")
newdata <- cbind(newdata, predict(nb.glm1, newdata, type="response", se.fit = TRUE))
newdata <- within(newdata, {
  Homicides <- exp(fit)
  LL <- exp(fit - 1.96 * se.fit)
  UL <- exp(fit + 1.96 * se.fit)
})

#### Not working
plot1 <- ggplot(newdata, aes(TurnoutPercentage, Homicides)) + 
  geom_ribbon(aes(ymin=LL, ymax=UL), fill="blue", alpha=0.25) +
  geom_line(aes(colour="blue", size=)) +
  labs(x="Turnout", y="Predicted Homicides")
plot1

newdata <- data.frame(seq(from=min(DistrictData$FoundationsTotal), to = max(DistrictData$FoundationsTotal), length.out = 1000),
                      FlowTotal=mean(DistrictData$FlowTotal),
                      TurnoutPercentage=mean(DistrictData$FlowTotal),
                      ForeignersTotal=mean(DistrictData$ForeignersTotal),
                      Couples=mean(DistrictData$Couples),
                      MalePopulation=mean(DistrictData$MalePopulation),
                      Pop18to24=mean(DistrictData$Pop18to24),
                      UnemployedPercentage=mean(DistrictData$UnemployedPercentage),
                      TotalPopulation=1) #TotalPopulation has to be equal 1 due to its offset characteristic, accounting for population

###############################################################
# Zelig

#negative Binomial regression model with Zelig (MC simulation)
nb.out1 <- zelig(MurderRate ~ 
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

x.out <- setx(nb.out1)
s.out <- sim(nb.out1, x=x.out)
summary(s.out)
plot(s.out)

#MC Simulation with min and max values for IV
xnb.low1 <- setx(nb.out1, "FoundationsDensity100k" = 2,"FlowRate" = 3171, "TurnoutPercentage" = 57 )
xnb.high1 <- setx(nb.out1, "FoundationsDensity100k" = 89,"FlowRate" = 12850, "TurnoutPercentage" = 79)
snb.out1 <- sim(nb.out1, x=xnb.low1, x1=xnb.high1)
plot(snb.out1)

est <- cbind(Estimate = coef(nb.out1), confint(nb.out1))
incidet <- exp(est)
print(incidet)

#MC Simulation with min and max values for IV with 1st and 3rd Qu.
xnb.low2 <- setx(nb.out1, "FoundationsDensity100k" = 11)
xnb.high2 <- setx(nb.out1, "FoundationsDensity100k" = 25)
snb.out2 <- sim(nb.out1, x=xnb.low2, x1=xnb.high2)
plot(snb.out2)

#MC Simulation with min and max values for IV with 1st and 3rd Qu.
xnb.low3 <- setx(nb.out1, "FlowRate" = 9980)
xnb.high3 <- setx(nb.out1, "FlowRate" = 13800)
snb.out3 <- sim(nb.out1, x=xnb.low1, x1=xnb.high1)
plot(snb.out3)

#MC Simulation with min and max values for IV with 1st and 3rd Qu.
xnb.low4 <- setx(nb.out1, "TurnoutPercentage" = 57)
xnb.high4 <- setx(nb.out1, "TurnoutPercentage" = 79)
snb.out4 <- sim(nb.out1, x=xnb.low1, x1=xnb.high1)
plot(snb.out4)

plot.ci(snb.out1, qi="pv") #not working ??? -> http://rstudio-pubs-static.s3.amazonaws.com/11500_029de8d38b2c48fc9f0ae9313771a5fa.html


