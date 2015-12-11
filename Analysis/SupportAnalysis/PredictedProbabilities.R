########################
# Lars Mehwald and Daniel Salgado Moreno
# 11 December 2015
# Predicted probabilities
########################

# Predicted probabilities: East West, all else set to the mean
nb.df1 <- data.frame(FoundationsDensity100k = mean(DistrictData$FoundationsDensity100k),
                     FlowPercentage = mean(DistrictData$FlowPercentage),
                     TurnoutPercentage = mean(DistrictData$TurnoutPercentage),
                     ForeignerPercentage = mean(DistrictData$ForeignerPercentage),
                     MarriagePercentage = mean(DistrictData$MarriagePercentage),
                     MalePercentage = mean(DistrictData$MalePercentage),
                     YouthPercentage = mean(DistrictData$YouthPercentage),
                     UnemployedPercentage = mean(DistrictData$UnemployedPercentage),
                     TotalPopulation = mean(DistrictData$TotalPopulation),
                     EastWest = factor(1:2, levels = 1:2))
class(nb.df1$EastWest) <- "integer"

nb.df1$Murder <- predict(nb.glm1, nb.df1, type = "response")

nb.df1 <- nb.df1[,c("EastWest", "Murder")]

nb.df1$EastWest <- ordered(nb.df1$EastWest,
                           levels = c(1,2),
                           labels = c("West", "East"))

names(nb.df1) <- c("EastWest", "Predicted Murders")

nb.df1

# Turnout
# Predicted probabilities: East West, with independent variable turnout varying 
nb.df2 <- data.frame(
  FoundationsDensity100k = mean(DistrictData$FoundationsDensity100k),
  FlowPercentage = mean(DistrictData$FlowPercentage),
  ForeignerPercentage = mean(DistrictData$ForeignerPercentage),
  MarriagePercentage = mean(DistrictData$MarriagePercentage),
  MalePercentage = mean(DistrictData$MalePercentage),
  YouthPercentage = mean(DistrictData$YouthPercentage),
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

nb.df2$EastWest <- ordered(nb.df2$EastWest,
                           levels = c(1,2),
                           labels = c("West", "East"))

ggplot(nb.df2, aes(TurnoutPercentage, Murder)) +
  geom_ribbon(aes(ymin = LL, ymax = UL, fill = EastWest), alpha = .25) +
  geom_line(aes(colour = EastWest), size = 2) +
  labs(x = "Voter Turnout", y = "Predicted Number of Murders") +
  theme(legend.title = element_blank())

# Flow
# Predicted probabilities: East West, with independent variable flow varying
# it is not significant as we would like it to be, but reverse causality
nb.df3 <- data.frame(
  FoundationsDensity100k = mean(DistrictData$FoundationsDensity100k),
  TurnoutPercentage = mean(DistrictData$TurnoutPercentage),
  ForeignerPercentage = mean(DistrictData$ForeignerPercentage),
  MarriagePercentage = mean(DistrictData$MarriagePercentage),
  MalePercentage = mean(DistrictData$MalePercentage),
  YouthPercentage = mean(DistrictData$YouthPercentage),
  UnemployedPercentage = mean(DistrictData$UnemployedPercentage),
  TotalPopulation = mean(DistrictData$TotalPopulation),
  FlowPercentage = rep(seq(from = min(DistrictData$FlowPercentage), to = max(DistrictData$FlowPercentage), length.out = 100), 2),
  EastWest = factor(rep(1:2, each = 100), levels = 1:2))

class(nb.df3$EastWest) <- "integer"
nb.df3 <- cbind(nb.df3, predict(nb.glm1, nb.df3, type = "link", se.fit=TRUE))
nb.df3 <- within(nb.df3, {
  Murder <- exp(fit)
  LL <- exp(fit - 1.96 * se.fit)
  UL <- exp(fit + 1.96 * se.fit)})

class(nb.df3$EastWest) <- "factor"

nb.df3$EastWest <- ordered(nb.df3$EastWest,
                           levels = c(1,2),
                           labels = c("West", "East"))

ggplot(nb.df3, aes(FlowPercentage, Murder)) +
  geom_ribbon(aes(ymin = LL, ymax = UL, fill = EastWest), alpha = .25) +
  geom_line(aes(colour = EastWest), size = 2) +
  labs(x = "In and Outflow", y = "Predicted Number of Murders") +
  theme(legend.title = element_blank())

# Youth
# Predicted probabilities: East West, with control variable youth Percentage varying
nb.df4 <- data.frame(
  FoundationsDensity100k = mean(DistrictData$FoundationsDensity100k),
  TurnoutPercentage = mean(DistrictData$TurnoutPercentage),
  ForeignerPercentage = mean(DistrictData$ForeignerPercentage),
  MarriagePercentage = mean(DistrictData$MarriagePercentage),
  MalePercentage = mean(DistrictData$MalePercentage),
  FlowPercentage = mean(DistrictData$FlowPercentage),
  UnemployedPercentage = mean(DistrictData$UnemployedPercentage),
  TotalPopulation = mean(DistrictData$TotalPopulation),
  YouthPercentage = rep(seq(from = min(DistrictData$YouthPercentage), to = max(DistrictData$YouthPercentage), length.out = 100), 2),
  EastWest = factor(rep(1:2, each = 100), levels = 1:2))

class(nb.df4$EastWest) <- "integer"
nb.df4 <- cbind(nb.df4, predict(nb.glm1, nb.df4, type = "link", se.fit=TRUE))
nb.df4 <- within(nb.df4, {
  Murder <- exp(fit)
  LL <- exp(fit - 1.96 * se.fit)
  UL <- exp(fit + 1.96 * se.fit)})

class(nb.df4$EastWest) <- "factor"

nb.df4$EastWest <- ordered(nb.df4$EastWest,
                           levels = c(1,2),
                           labels = c("West", "East"))

ggplot(nb.df4, aes(YouthPercentage, Murder)) +
  geom_ribbon(aes(ymin = LL, ymax = UL, fill = EastWest), alpha = .25) +
  geom_line(aes(colour = EastWest), size = 2) +
  labs(x = "Youth Percentage", y = "Predicted Number of Murders") +
  theme(legend.title = element_blank())

# Male
# Predicted probabilities: East West, with control variable male Percentage varying
nb.df5 <- data.frame(
  FoundationsDensity100k = mean(DistrictData$FoundationsDensity100k),
  TurnoutPercentage = mean(DistrictData$TurnoutPercentage),
  ForeignerPercentage = mean(DistrictData$ForeignerPercentage),
  MarriagePercentage = mean(DistrictData$MarriagePercentage),
  YouthPercentage = mean(DistrictData$YouthPercentage),
  FlowPercentage = mean(DistrictData$FlowPercentage),
  UnemployedPercentage = mean(DistrictData$UnemployedPercentage),
  TotalPopulation = mean(DistrictData$TotalPopulation),
  MalePercentage = rep(seq(from = min(DistrictData$MalePercentage), to = max(DistrictData$MalePercentage), length.out = 100), 2),
  EastWest = factor(rep(1:2, each = 100), levels = 1:2))

class(nb.df5$EastWest) <- "integer"
nb.df5 <- cbind(nb.df5, predict(nb.glm1, nb.df5, type = "link", se.fit=TRUE))
nb.df5 <- within(nb.df5, {
  Murder <- exp(fit)
  LL <- exp(fit - 1.96 * se.fit)
  UL <- exp(fit + 1.96 * se.fit)})

class(nb.df5$EastWest) <- "factor"

nb.df5$EastWest <- ordered(nb.df5$EastWest,
                           levels = c(1,2),
                           labels = c("West", "East"))

ggplot(nb.df5, aes(MalePercentage, Murder)) +
  geom_ribbon(aes(ymin = LL, ymax = UL, fill = EastWest), alpha = .25) +
  geom_line(aes(colour = EastWest), size = 2) +
  labs(x = "Male Percentage", y = "Predicted Number of Murders") +
  theme(legend.title = element_blank())

# Marriage
# Predicted probabilities: East West, with control variable marriage percentage varying
nb.df6 <- data.frame(
  FoundationsDensity100k = mean(DistrictData$FoundationsDensity100k),
  TurnoutPercentage = mean(DistrictData$TurnoutPercentage),
  ForeignerPercentage = mean(DistrictData$ForeignerPercentage),
  MalePercentage = mean(DistrictData$MalePercentage),
  YouthPercentage = mean(DistrictData$YouthPercentage),
  FlowPercentage = mean(DistrictData$FlowPercentage),
  UnemployedPercentage = mean(DistrictData$UnemployedPercentage),
  TotalPopulation = mean(DistrictData$TotalPopulation),
  MarriagePercentage = rep(seq(from = min(DistrictData$MarriagePercentage), to = max(DistrictData$MarriagePercentage), length.out = 100), 2),
  EastWest = factor(rep(1:2, each = 100), levels = 1:2))

class(nb.df6$EastWest) <- "integer"
nb.df6 <- cbind(nb.df6, predict(nb.glm1, nb.df6, type = "link", se.fit=TRUE))
nb.df6 <- within(nb.df6, {
  Murder <- exp(fit)
  LL <- exp(fit - 1.96 * se.fit)
  UL <- exp(fit + 1.96 * se.fit)})

class(nb.df6$EastWest) <- "factor"

nb.df6$EastWest <- ordered(nb.df6$EastWest,
                           levels = c(1,2),
                           labels = c("West", "East"))

ggplot(nb.df6, aes(MarriagePercentage, Murder)) +
  geom_ribbon(aes(ymin = LL, ymax = UL, fill = EastWest), alpha = .25) +
  geom_line(aes(colour = EastWest), size = 2) +
  labs(x = "Marriage Percentage", y = "Predicted Number of Murders") +
  theme(legend.title = element_blank())
