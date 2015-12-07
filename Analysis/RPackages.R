########################
# Lars Mehwald and Daniel Salgado Moreno
# 11 December 2015
# Load required R packages
########################

Packages <- c("rio", "dplyr", "tidyr", "repmis", "httr", "knitr", "ggplot2",
              "xtable", "stargazer", "texreg", "lmtest", "sandwich", "Zelig",
              "car", "MASS", "PerformanceAnalytics", "pscl", "AER", "ggmap",
              "rworldmap")
lapply(Packages, require, character.only = TRUE)