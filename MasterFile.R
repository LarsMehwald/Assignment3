########################
# Lars Mehwald and Daniel Salgado Moreno
# 11 December 2015
# Master file 
########################

# Setting the commonly used working directory
library("repmis")
possible_dir <- c("D:/Eigene Dokumente/!1 Vorlesungen/!! WS 2015/Introduction to Collaborative Social Science Data Analysis/Assignment3", 
                  "~/HSoG/DataAnalysis/GitHub/Assignment3")
set_valid_wd(possible_dir)
rm(possible_dir)

# Loading required packages 
source("Analysis/RPackages.R")

# Citation of packages 
source("References/CiteRPackages.R")

# Loading the data set
source("Analysis/DataMerging.R")

# Performing the analyses
source("Analysis/DataAnalysis.R")

# Creating a map 

# creating graphs 
