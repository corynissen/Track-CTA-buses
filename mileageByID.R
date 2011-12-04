
# code to return a list of IDs (buses) and their daily mileage

require(geosphere)
require(plyr)

# run readData.R to create data/fixdata.rdata file
# load data created in readData.R
#load("data/fixdata.rdata")

getMileage <- function(data){
  # data:  dataframe with longitude and latitude columns in numeric format
  # output:  Sum of distances between lat-long pairs
  # make sure data is still sorted by request time
  data <- data[order(data$requesttime),]
  # create a pair of lagged lat and long variables.
  data$lag_long <- c(NA, data$longitude[1:dim(data)[1]-1])
  data$lag_lat <- c(NA, data$latitude[1:dim(data)[1]-1])
  # use distVincentyEllipsoid function to calculate the distances between
  # each lat long pair and it's lagged lat long pair  
  result <- distVincentyEllipsoid(cbind(data$latitude, data$longitude), cbind(data$lag_lat, data$lag_long))
  # sum and convert meters to miles
  result <- round(sum(result, na.rm=T) / 1609.344,1)
  return(result)
}

mileage <- ddply(fixdf, c("id", "route"), getMileage)
names(mileage) <- c("id", "route", "miles")
#write.csv(mileage, "output/distance_by_id.csv", row.names=F)

