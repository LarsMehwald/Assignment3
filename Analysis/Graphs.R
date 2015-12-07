########################
# Lars Mehwald and Daniel Salgado Moreno
# 11 December 2015
# Additional variables (crime and socio economic rates)
########################

#################################
# Historgrams
#################################

# Changing class of Crime Rate
#DistrictData$CrimeRate <- as.integer(as.character(DistrictData$CrimeRate))

# Crime Rate hist
#histCrimeRate <- ggplot(DistrictData, aes(CrimeRate)) + 
#  geom_histogram(binwidth=500, colour="black", fill="white") 
#plot(histCrimeRate)

# Non-Violent Crime histogram
#histNonViolentCrimeRate <- ggplot(DistrictData, aes(NonViolentCrimeRate)) + 
 # geom_histogram(binwidth=400, colour="black", fill="white")
#plot(histNonViolentCrimeRate)

# Violent Crime histogram
histViolentCrimeRate <- ggplot(DistrictData, aes(ViolentCrimeRate)) + 
  geom_histogram(binwidth=10, colour="black", fill="white")
#plot(histViolentCrimeRate)

# Murder Rate Histogram
histMurderRate <- ggplot(DistrictData, aes(MurderRate)) + 
  geom_histogram(binwidth=1, colour="black", fill="red") +
  xlab("Murder Rate per district") +
  ylab("District count") +
  ggtitle("District count for Murder Rates: right skewed")
#plot(histMurderRate)

# Murder Rate Histogram
histMurder <- ggplot(DistrictData, aes(murderAndManslaughter)) + 
  geom_histogram(binwidth=1, colour="black", fill="red") + 
  xlab("Murders") +
  ylab("Counts per district") +
  ggtitle("District count for Murder count: right skewed")
#plot(histMurder) 
# We can observe that the Murders count is right skewed
# OLS regression models are inappropiate when small number of events
# Poisson models offer a good alternative

#################################
# Correlation Matrix
#################################

# Correlation Plot using R package: "PerformanceAnalytics"
correlation.matrix <- DistrictData[, c(47,54,53,40,22,50,51,52)]
#chart.Correlation(correlation.matrix, historgram=T)

#################################
# Top 10 tables
#################################

DistrictData$MurderRate <- as.numeric(DistrictData$MurderRate)
top10Murder <- arrange(DistrictData, desc(MurderRate))

head(top10Murder)[1:10,1:64]

top10Murder <- top10Murder[,c(1:2,55,10,40,47,54,50,51,53,22)]

top10Murder <- top10Murder[,c(1:4)]

top10Murder <- top10Murder[1:10,c(1:4)]

names(top10Murder)[names(top10Murder) == 'murderAndManslaughter'] <- 'Murders in 2013'
names(top10Murder)[names(top10Murder) == 'district'] <- 'District ID'
names(top10Murder)[names(top10Murder) == 'DistrictName'] <- 'District Name'
names(top10Murder)[names(top10Murder) == 'MurderRate'] <- 'Murder Rate'
