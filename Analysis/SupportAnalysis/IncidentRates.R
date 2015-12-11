########################
# Lars Mehwald and Daniel Salgado Moreno
# 11 December 2015
# Incident rates
########################

########################
# Incident rates: poisson
########################

# Extracting the estimated coefficents and confident intervals, then creating their exponential object

# Incident rates and statistical significance
# Adding coefficients and confident intervals into new data frame 

# Extract coefficients and create confidence intervals for three levels of significance
est1 <- cbind(Estimate = coef(poisson.glm1), 
              confint(poisson.glm1, level=0.90),
              confint(poisson.glm1, level=0.95),
              confint(poisson.glm1, level=0.99))
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
names(est1) <- c("Poisson", "_")

########################
# Incident rates: quasi-poisson
########################

# Extract coefficients and create confidence intervals for three levels of significance
est2 <- cbind(Estimate = coef(quasipoisson.glm1), 
              confint(quasipoisson.glm1, level=0.90),
              confint(quasipoisson.glm1, level=0.95),
              confint(quasipoisson.glm1, level=0.99))
est2 <- data.frame(est2)

# Adding three variables (1=TRUE) describing whether coefficient is significant at 
# a given level of statistical significance 
est2 <- cbind(est2, 
              ifelse(sign(est2[2]) == sign(est2[3]), 1, 0),
              ifelse(sign(est2[4]) == sign(est2[5]), 1, 0),
              ifelse(sign(est2[6]) == sign(est2[7]), 1, 0))

# Creating a new variable that indicates the level of statistical significance
# 0=not significant, 1=at 90%level, 2=at 95% level, 3=at 99%level
est2 <- cbind(est2, 
              ifelse(est2[10] == 1, 3, 
                     ifelse(est2[9] == 1, 2,
                            ifelse(est2[8] == 1, 1, 0))))
est2 <- est2[,-c(2:10)]

# Creating incident rates by exponentiating the coefficients
est2 <- cbind(exp(est2[1]), est2[2])
est2 <- round(est2, 4)

# Creating new variable with stars * 
names(est2) <- c("Coefficient", "NumberStars")
est2$NumberStars <- as.factor(est2$NumberStars)
est2$Stars <- ifelse(est2$NumberStars == 3, "***",
                     ifelse(est2$NumberStars == 2, "**",
                            ifelse(est2$NumberStars == 1, "*", "")))
est2 <- est2[c(1,3)]
names(est2) <- c("Quasi-Poisson", "_ ")

########################
# Incident rates: negative binomial 
########################

# Extract coefficients and create confidence intervals for three levels of significance
est3 <- cbind(Estimate = coef(nb.glm1), 
              confint(nb.glm1, level=0.90),
              confint(nb.glm1, level=0.95),
              confint(nb.glm1, level=0.99))
est3 <- data.frame(est3)

# Adding three variables (1=TRUE) describing whether coefficient is significant at 
# a given level of statistical significance 
est3 <- cbind(est3, 
              ifelse(sign(est3[2]) == sign(est3[3]), 1, 0),
              ifelse(sign(est3[4]) == sign(est3[5]), 1, 0),
              ifelse(sign(est3[6]) == sign(est3[7]), 1, 0))

# Creating a new variable that indicates the level of statistical significance
# 0=not significant, 1=at 90%level, 2=at 95% level, 3=at 99%level
est3 <- cbind(est3, 
              ifelse(est3[10] == 1, 3, 
                     ifelse(est3[9] == 1, 2,
                            ifelse(est3[8] == 1, 1, 0))))
est3 <- est3[,-c(2:10)]

# Creating incident rates by exponentiating the coefficients
est3 <- cbind(exp(est3[1]), est3[2])
est3 <- round(est3, 4)

# Creating new variable with stars * 
names(est3) <- c("Coefficient", "NumberStars")
est3$NumberStars <- as.factor(est3$NumberStars)
est3$Stars <- ifelse(est3$NumberStars == 3, "***",
                     ifelse(est3$NumberStars == 2, "**",
                            ifelse(est3$NumberStars == 1, "*", "")))
est3 <- est3[c(1,3)]
names(est3) <- c("Negative Binomial", "_  ")

########################
# Incident rates: summary table
########################

# combine all data frames
est4 <- cbind(est1, est2, est3)

# delete intercept
est4 <- est4[-1,]

est4
