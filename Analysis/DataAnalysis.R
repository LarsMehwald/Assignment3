########################
# Lars Mehwald and Daniel Salgado Moreno
# 11 December 2015
# Data analysis
########################

# Loading data set from csv file
# DistrictData <- read.csv(file="Analysis/data/DistrictData2013.csv")
# Removing ranking column (it was added in the saving process in DataMerging.R)
# DistrictData <- DistrictData[,-1]

# Sourcing the merging file
# source("DataMerging.R")

########################
# Manipulating data
########################

# Creating categorical variables from continous independent variables 
# Selection of categories based on quantiles
DistrictData$Foundations_cat <- cut(DistrictData$FoundationsTotal,
                                    breaks= c(0,15,26,44,1194), 
                                    labels= c('1stQu', '2ndQu', '3rdQu', '4thQu'))

########################
# Discriptive statistics
########################

# Summary statistics of independent variables 
summary(DistrictData$FoundationsTotal)
summary(DistrictData$FlowTotal)
summary(DistrictData$TurnoutPercentage)

# Murder Rate Histogram
histMurder <- ggplot(DistrictData, aes(MurderRate)) + 
  geom_histogram(binwidth=1, colour="black", fill="white")
plot(histMurder) 
# We can observe that the homicide count is right skewed
# OLS regression models are inappropiate when small number of events
# Poisson models offer a good alternative

########################
# Linear regression
########################

# Linear regression model 1
OLSViolent <- lm(ViolentCrimeRate ~
                    FoundationsDensity100k + FlowRate + TurnoutPercentage + 
                    ForeignerRate + MarriageRate + MaleRate + YouthRate + UnemployedPercentage + EastWest,
                  data=DistrictData)
summary(OLSViolent)

# Linear regression model 2
OLSMurder <- lm(MurderRate ~
                  FoundationsDensity100k + FlowRate + TurnoutPercentage + 
                  ForeignerRate + MarriageRate + MaleRate + YouthRate + UnemployedPercentage + EastWest,
                data=DistrictData)
summary(OLSMurder)

########################
# Declaring integer data for analysis
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
# The overdispersion test assess the "goodness of fit" for the poisson model
dispersiontest(poisson.glm1)
# p-values too small: therefore negative binomial model needed
# mean=var: condition for Poisson model (basic poisson model assumption)
# if mean < var: overdispersion
# use mle: correcting s.e.
# summary(poisson.glm): Residual deviance>degrees of freedom : if so = overdispersion

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
quasipoisson.glm1 <- glm(MurderRate ~ 
                           FoundationsDensity100k + FlowRate + TurnoutPercentage + 
                           ForeignerRate + MarriageRate + MaleRate + YouthRate + UnemployedPercentage + EastWest,
                         data=DistrictData, 
                    family = quasipoisson())

# Extracting the estimated coefficents and confident intervals, then creating their exponential object
est.qpoisson <- cbind(Estimate = coef(quasipoisson.glm1), confint(quasipoisson.glm1))
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
est.nb <- cbind(Estimate = coef(nb.glm1), confint(nb.glm1))
incidentrate.nb <- exp(est.nb)

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

# Goodness of fit: Computating the cross-validation for this model
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

# source("Analysis/DataAnalysisBackupZelig.R")
