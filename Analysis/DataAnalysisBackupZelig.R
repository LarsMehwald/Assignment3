########################
# Lars Mehwald and Daniel Salgado Moreno
# 11 December 2015
# Backup analysis using Zelig
########################

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
# Comparison Poisson vs Negegative Binomial model 
########################

# When comparison Poisson vs NegBinomial: compare full and basline models
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
