
# This packages up the separate procedures to run in command line
# R CMD BATCH --vanilla go.R

source("readData.R") #fetch yesterday's data, make fixdf data frame
source("mileageByID.R") #calculate mileage by bus, make mileage data frame
source("writeToDB.R") #write mileage to database

