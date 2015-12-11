########################
# Lars Mehwald and Daniel Salgado Moreno
# 11 December 2015
# Data analysis
########################

########################
# Manipulating data
########################

# Creating categorical variables from continous independent variables 
# Selection of categories based on quantiles
DistrictData$Foundations_cat <- cut(DistrictData$FoundationsTotal,
                                    breaks= c(0,15,26,44,1194), 
                                    labels= c('1stQu', '2ndQu', '3rdQu', '4thQu'))

names(DistrictData)[names(DistrictData) == 'murderAndManslaughter'] <- 'Murder'

# Changing total population into a measure for 100,000
DistrictData$TotalPopulation <- DistrictData$TotalPopulation / 100000

# Omiting Observations with missing values
DistrictData <- na.omit(DistrictData)

########################
# Discriptive statistics
########################

# Summary statistics of independent variables 
summary(DistrictData$FoundationsDensity100k)
summary(DistrictData$FlowPercentage)
summary(DistrictData$TurnoutPercentage)

# Summary statistics of control variables 
summary(DistrictData$ForeignerPercentage)
summary(DistrictData$MarriagePercentage)
summary(DistrictData$MalePercentage)
summary(DistrictData$YouthPercentage)
summary(DistrictData$UnemployedPercentage)
summary(DistrictData$TotalPopulation)
summary(DistrictData$EastWest)

# Murder Rate Histogram
histMurder <- ggplot(DistrictData, aes(MurderRate)) + 
  geom_histogram(binwidth=1, colour="black", fill="white")
# plot(histMurder) # commented out so it does not appear in final document 

# We can observe that the homicide count is right skewed
# OLS regression models are inappropiate when small number of events
# Poisson models offer a good alternative

########################
# Linear regression
########################

# Linear regression model 1
OLSNonViolent <- lm(NonViolentCrimeRate ~
                   FoundationsDensity100k + FlowPercentage + TurnoutPercentage + 
                   ForeignerPercentage + MarriagePercentage + MalePercentage + YouthPercentage + UnemployedPercentage + EastWest,
                 data=DistrictData)
summary(OLSNonViolent)

# Linear regression model 2
OLSViolent <- lm(ViolentCrimeRate ~
                    FoundationsDensity100k + FlowPercentage + TurnoutPercentage + 
                    ForeignerPercentage + MarriagePercentage + MalePercentage + YouthPercentage + UnemployedPercentage + EastWest,
                  data=DistrictData)
summary(OLSViolent)

# Linear regression model 3
OLSMurderRate <- lm(MurderRate ~
                  FoundationsDensity100k + FlowPercentage + TurnoutPercentage + 
                  ForeignerPercentage + MarriagePercentage + MalePercentage + YouthPercentage + UnemployedPercentage + EastWest,
                data=DistrictData)
summary(OLSMurderRate)

# Linear regression model 4
OLSMurder <- lm(Murder ~
                      FoundationsDensity100k + FlowPercentage + TurnoutPercentage + 
                      ForeignerPercentage + MarriagePercentage + MalePercentage + YouthPercentage + UnemployedPercentage + TotalPopulation + EastWest,
                    data=DistrictData)
summary(OLSMurder)

########################
# Declaring integer data for analysis
########################

# Declaring distric Id as factor variablespo
DistrictData$district <- as.factor(DistrictData$district)

# Declaring all relevant variables for model integer
DistrictData$Murder <- as.integer(DistrictData$Murder)
DistrictData$EastWest <- as.integer(DistrictData$EastWest)

########################
# Poisson models
########################

# Poission model 1
poisson.glm1 <- glm(Murder ~ 
                      FoundationsDensity100k + FlowPercentage + TurnoutPercentage + 
                      ForeignerPercentage + MarriagePercentage + MalePercentage + YouthPercentage + UnemployedPercentage + TotalPopulation + EastWest,
                    data=DistrictData, 
               family = poisson())

# Dispersion Test
# The overdispersion test assess the "goodness of fit" for the poisson model
disp.test <- dispersiontest(poisson.glm1)
# p-values too small: therefore negative binomial model needed
# mean=var: condition for Poisson model (basic poisson model assumption)
# if mean < var: overdispersion
# use mle: correcting s.e.
# summary(poisson.glm): Residual deviance>degrees of freedom : if so = overdispersion

# Extracting three values from dispersion test
disp.test.z <- disp.test[1]
disp.test.z <- as.numeric(disp.test.z)

disp.test.p <- disp.test[2]
disp.test.p <- as.numeric(disp.test.p)

disp.test.est <- disp.test[3]
disp.test.est <- as.numeric(disp.test.est)

# Visual assesment
summary(poisson.glm1) # if Residual deviance>degrees of freedom : if so = overdispersion
# This test confirms overdispersion
# In consecuence, it is better to use a Negative Binominal Model

# Extracting the estimated coefficents and confident intervals, 
# then creating their exponential object (interpreted as incident rates)
poisson.est1 <- cbind(Estimate = coef(poisson.glm1), confint(poisson.glm1))
incidentrate1 <- exp(poisson.est1)

########################
# Correcting s.e. with QuasiPoisson
########################

# Quasi Poission model 1
quasipoisson.glm1 <- glm(Murder ~ 
                           FoundationsDensity100k + FlowPercentage + TurnoutPercentage + 
                           ForeignerPercentage + MarriagePercentage + MalePercentage + YouthPercentage + UnemployedPercentage + TotalPopulation + EastWest,
                         data=DistrictData, 
                    family = quasipoisson())

# Extracting the estimated coefficents and confident intervals, then creating their exponential object
est.qpoisson <- cbind(Estimate = coef(quasipoisson.glm1), confint(quasipoisson.glm1))
incidentrate.qpoisson <- exp(est.qpoisson)

########################
# Negative Binomial Models
########################

# negative Binomial model 1
nb.glm1 <- glm.nb(Murder ~ 
                    FoundationsDensity100k + FlowPercentage + TurnoutPercentage + 
                    ForeignerPercentage + MarriagePercentage + MalePercentage + YouthPercentage + UnemployedPercentage + TotalPopulation + EastWest,
                  data=DistrictData)
summary(nb.glm1)

# Incident rates
# source("Analysis/SupportAnalysis/IncidentRates.R")

# Predicted probabilities
source("Analysis/SupportAnalysis/PredictedProbabilities.R")

# Goodness of fit
# Computating the cross-validation for this model
# It is the sum of the squared differenced between model predictions
# for different subsets of the data.
# This is a reasonable approach, since we are interested in how good/stable is 
# the model inferring from specific data to generalizable data 
CV.glm <- cv.glm(data=DistrictData, glmfit=nb.glm1, K=4) # was suggested as a good value 
CV.glm <- c(CV.glm$delta) # the first value is no corrected for larger data 
# other ideas for goodness of fit
# http://www.biomedcentral.com/content/supplementary/1748-5908-6-55-s2.pdf

########################
# Further code 
########################

# source("Analysis/SupportAnalysis/DataAnalysisBackupZelig.R")
