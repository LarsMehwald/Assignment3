########################
# Lars Mehwald and Daniel Salgado Moreno
# 11 December 2015
# Predicted probabilities
########################


# Predicted probabilities: East West, all else set to the mean
nb.df1 <- data.frame(FoundationsDensity100k = mean(DistrictData$FoundationsDensity100k),
                     FlowRate = mean(DistrictData$FlowRate),
                     TurnoutPercentage = mean(DistrictData$TurnoutPercentage),
                     ForeignerRate = mean(DistrictData$ForeignerRate),
                     MarriageRate = mean(DistrictData$MarriageRate),
                     MaleRate = mean(DistrictData$MaleRate),
                     YouthRate = mean(DistrictData$YouthRate),
                     UnemployedPercentage = mean(DistrictData$UnemployedPercentage),
                     TotalPopulation = mean(DistrictData$TotalPopulation),
                     EastWest = factor(1:2, levels = 1:2))
class(nb.df1$EastWest) <- "integer"
nb.df1$Murder <- predict(nb.glm1, nb.df1, type = "response")
nb.df1

# Predicted probabilities: East West, with independent variable turnout varying 
nb.df2 <- data.frame(
  FoundationsDensity100k = mean(DistrictData$FoundationsDensity100k),
  FlowRate = mean(DistrictData$FlowRate),
  ForeignerRate = mean(DistrictData$ForeignerRate),
  MarriageRate = mean(DistrictData$MarriageRate),
  MaleRate = mean(DistrictData$MaleRate),
  YouthRate = mean(DistrictData$YouthRate),
  UnemployedPercentage = mean(DistrictData$UnemployedPercentage),
  TotalPopulation = mean(DistrictData$TotalPopulation),
  TurnoutPercentage = rep(seq(from = min(DistrictData$TurnoutPercentage), to = max(DistrictData$TurnoutPercentage), length.out = 100), 2),
  EastWest = factor(rep(1:2, each = 100), levels = 1:2))

class(nb.df2$EastWest) <- "integer"
nb.df2 <- cbind(nb.df2, predict(nb.glm1, nb.df2, type = "link", se.fit=TRUE))
nb.df2 <- within(nb.df2, {
  Murder <- exp(fit)
  LL <- exp(fit - 1.96 * se.fit)
  UL <- exp(fit + 1.96 * se.fit)})

class(nb.df2$EastWest) <- "factor"

ggplot(nb.df2, aes(TurnoutPercentage, Murder)) +
  geom_ribbon(aes(ymin = LL, ymax = UL, fill = EastWest), alpha = .25) +
  geom_line(aes(colour = EastWest), size = 2) +
  labs(x = "Voter Turnout", y = "Predicted Number of Murders")
