# Merging the District Data with the Foundation Data
# Both variables need to be character variables 
# http://www.r-bloggers.com/fuzzy-string-matching-a-survival-skill-
# to-tackle-unstructured-information/
dist.name <- adist(DistrictData$DistrictName, 
                   Foundations$DistrictName, 
                   partial = TRUE, 
                   ignore.case = TRUE)

min.name <- 
  apply(dist.name, 1, min)
# apply(X, MARGIN, FUN, ...)
# Margin = 1 in a data frame means that function is apllied over rows

match.s1.s2 <- NULL  
for(i in 1:nrow(dist.name))
{
  s2.i <- match(min.name[i],dist.name[i,])
  s1.i <- i
  match.s1.s2 <- 
    rbind(data.frame(s2.i=s2.i, 
                     s1.i=s1.i, 
                     s2name=Foundations[s2.i,]$DistrictName, 
                     s1name=DistrictData[s1.i,]$DistrictName, 
                     adist=min.name[i]), 
          match.s1.s2)
}

rm("i", "min.name", "s1.i", "s2.i")

# Creation of ranks within data frames: DistrictData = s1, Foundations = s2
DistrictData$ID <- 1:401
DistrictData <- DistrictData[,c(47,1:46)]

Foundations$ID <- 1:402
Foundations <- Foundations[,c(4,1:3)]

# Merging the two data frames
MergedWithFoundations <- 
  merge(match.s1.s2, 
        Foundations, 
        by.x=c("s2.i"), 
        by.y=c("ID")
  )

MergedWithFoundationsAndDistrictData <- 
  merge(MergedWithFoundations, 
        DistrictData, 
        by.x=c("s1.i"), 
        by.y=c("ID")
  )

# Updating the DistrictData frame
DistrictData <- MergedWithFoundationsAndDistrictData
DistrictData <- DistrictData[,-c(1:6)]
DistrictData <- DistrictData[,c(3:48,1,2)]
names(DistrictData)[1] <- "district"

# Removing redundant data frames
rm(MergedWithFoundations, MergedWithFoundationsAndDistrictData)
rm(Foundations)
rm(dist.name, match.s1.s2)