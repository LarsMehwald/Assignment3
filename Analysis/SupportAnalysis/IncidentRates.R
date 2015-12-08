########################
# Lars Mehwald and Daniel Salgado Moreno
# 11 December 2015
# Incident rates
########################

# Extracting the estimated coefficents and confident intervals, then creating their exponential object
# est.nb <- cbind(Estimate = coef(nb.glm1), confint(nb.glm1))
# incidentrate.nb <- exp(est.nb)

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

# Creating a new variable that indicates the level of statistical significance
# 0=not significant, 1=at 90%level, 2=at 95% level, 3=at 99%level
est1 <- cbind(est1, 
              ifelse(est1[10] == 1, 3, 
                     ifelse(est1[9] == 1, 2,
                            ifelse(est1[8] == 1, 1, 0))))
est1 <- est1[,-c(2:10)]

# Creating incident rates by exponentiating the coefficients
est1 <- cbind(exp(est1[1]), est1[2])
est1 <- round(est1, 4)

# Creating new variable with stars * 
names(est1) <- c("Coefficient", "NumberStars")
est1$NumberStars <- as.factor(est1$NumberStars)
est1$Stars <- ifelse(est1$NumberStars == 3, "***", # &#9733; is HTML star, but didnt work, + works 
                     ifelse(est1$NumberStars == 2, "**",
                            ifelse(est1$NumberStars == 1, "*", "")))
est1 <- est1[c(1,3)]
names(est1) <- c("IncidentRate", "_")
# stargazer(est1, header = FALSE, summary= FALSE, type="html", digits = 4)