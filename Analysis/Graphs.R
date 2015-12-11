########################
# Lars Mehwald and Daniel Salgado Moreno
# 11 December 2015
# Additional variables (crime and socio economic rates)
########################

#################################
# Descriptive statistics 
#################################

# Removing some variables
DistrictDataReduced <- DistrictData[,c(56,58,48,55,54,41,23,51,52,53)]

# Renaming variables
names(DistrictDataReduced)[names(DistrictDataReduced) == 'UnemployedPercentage'] <- 'UnemployedPerc'
names(DistrictDataReduced)[names(DistrictDataReduced) == 'FoundationsDensity100k'] <- 'FoundationsDens'
names(DistrictDataReduced)[names(DistrictDataReduced) == 'TurnoutPercentage'] <- 'TurnoutPerc'
# Creation of summary statistics
# stargazer(DistrictDataReduced, nobs = FALSE, header = FALSE, digits=1, type = "html")

#################################
# Historgrams
#################################

# Crime Rate histogram 
# Changing class of Crime Rate
DistrictData$CrimeRate <- as.integer(as.character(DistrictData$CrimeRate))

# Crime Rate hist
histCrimeRate <- ggplot(DistrictData, aes(CrimeRate)) + 
 geom_histogram(binwidth=500, colour="black", fill="white") 
#plot(histCrimeRate)

# Non-Violent Crime histogram
histNonViolentCrimeRate <- ggplot(DistrictData, aes(NonViolentCrimeRate)) + 
 geom_histogram(binwidth=400, colour="black", fill="white")
#plot(histNonViolentCrimeRate)

# Violent Crime histogram
histViolentCrimeRate <- ggplot(DistrictData, aes(ViolentCrimeRate)) + 
  geom_histogram(binwidth=10, colour="black", fill="white")
# plot(histViolentCrimeRate)

# Murder Rate Histogram
histMurderRate <- ggplot(DistrictData, aes(MurderRate)) + 
  geom_histogram(binwidth=1, colour="black", fill="red") +
  xlab("Murder Rate per district") +
  ylab("District count") +
  ggtitle("District count for Murder Rates: right skewed")
#plot(histMurderRate)

# Murder Histogram
histMurder <- ggplot(DistrictData, aes(Murder)) + 
  geom_histogram(binwidth=1, colour="black", fill="red") + 
  xlab("Murder count per district") +
  ylab("District count") +
  ggtitle("Murder count distribution across districts: right skewed")
#plot(histMurder) 

# We can observe that the Murders count is right skewed
# OLS regression models are inappropiate when small number of events
# Poisson models offer a good alternative

#################################
# Correlation Matrix
#################################

# Correlation Plot using R package: "PerformanceAnalytics"
# Needs to 
correlation.matrix <- DistrictData[, c(48,55,41,54,23,51,52,53,17)]
#chart.Correlation(correlation.matrix, historgram=T)

#################################
# Top 10 tables
#################################

# Extracting the districts with the highest murder rates 
DistrictData$MurderRate <- as.numeric(DistrictData$MurderRate)
top10Murder <- arrange(DistrictData, desc(MurderRate))
top10Murder <- top10Murder[1:10,c(1:2,56,10)]

# Renaming the variable names 
names(top10Murder)[names(top10Murder) == 'murderAndManslaughter'] <- 'Murders in 2013'
names(top10Murder)[names(top10Murder) == 'district'] <- 'District ID'
names(top10Murder)[names(top10Murder) == 'DistrictName'] <- 'District Name'
names(top10Murder)[names(top10Murder) == 'MurderRate'] <- 'Murder Rate'

# Creating table output 
top10MurderMatrix <- as.matrix(top10Murder)
# stargazer(top10MurderMatrix, header = FALSE, type="html", digits = 2)
