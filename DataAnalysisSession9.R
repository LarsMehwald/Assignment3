########################
# Lars Mehwald and Daniel Salgado Moreno
# 30 November 2015
# Session 9
# Model function and GLM
########################

# Loading required packages 
library("rio")
library("dplyr")
library("tidyr")
library("repmis")
library("httr")

# Setting the commonly used working directory
possible_dir <- c('D:/Eigene Dokumente/!1 Vorlesungen/!! WS 2015/Introduction to Collaborative Social Science Data Analysis/Assignment3', '~/HSoG/DataAnalysis/GitHub/Assignment3')

# Set to first valid directory in the possible_dir vector
repmis::set_valid_wd(possible_dir)

# Citing R packages 
pkgs <- c('dplyr', 'ggplot2', 'rio', 'tidyr', 'repmis', 'httr')
LoadandCite(pkgs, file = 'References/RpackageCitations.bib')
rm(pkgs)