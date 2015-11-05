########################
# Lars Mehwald and Daniel Salgado Moreno
# 13 November 2015
# Assignment 3
# Labor market 
########################

LaborMarket <- read.csv(file = "Bevoelkerung.cvs", 
                        sep=",", 
                        na.strings=c("-", "."), 
                        header = FALSE,
                        nrows = 403, 
                        col.names = c("district", 
                                      "typofdistrict", 
                                      "DistrictName", 
                                      "TotlaArea", 
                                      "TotalPopulation", 
                                      "MalePopulation", 
                                      "FemalePopulation", 
                                      "DensityPerSQRTkm"
                        )
)
