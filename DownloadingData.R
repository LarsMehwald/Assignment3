########################
# Lars and Daniel 
# 13 November 2015
# Assignment 3
# Downloading data
########################

# Loading required packages 
library("rio")
library("dplyr")
library("tidyr")
library("repmis")
library("httr")

# Retrieving the URL
# 1) Inspecting the CSV image
# 2) Manually extract the URL that is contained in <form>
# 3) Manually insert the URL into the browser
# 4) Wait until the browser redirected to another URL in order to retrieve the file
# and displays the SAVE AS option
# 5) Again, extract manually this new (redirected) URL from the browser


URL <- "https://www.regionalstatistik.de/genesis/online/data/192-71-4.csv;jsessionid=F6E2A21FB2889C1DE113F215F1833BCA?operation=ergebnistabelleDownload&levelindex=3&levelid=1445954463494&option=csv&doDownload=csv&contenttype=csv"

Graduates <- read.csv(file = URL, 
                      sep=";", 
                      na.strings=c("-", "."), 
                      header = FALSE,
                      skip = 10,
                      nrows = 524, 
                      col.names = c("Year", 
                                    "district", 
                                    "DistrictName", 
                                    "GraduatesTotal", 
                                    "GraduatesTotalFemale", 
                                    "GraduatesWithHouthDegreeTotal", 
                                    "GraduatesWithouthDegreeFemale", 
                                    "GraduatesWithHauptschulDegreeTotal", 
                                    "GraduatesWithHauptschulDegreeFemale",
                                    "GraduatesWithRealschulDegreeTotal",
                                    "GraduatesWithRealschulDegreeFemale",
                                    "GraduatesWithFachhochschulDegreeTotal",
                                    "GraduatesWithFachhochschulDegreeFemale",
                                    "GraduatesWithHochschulreifeDegreeTotal",
                                    "GraduatesWithHochschulreifeDegreeFemale")
                      )

rm(Graduates)
