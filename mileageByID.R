
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
  data$lag_time <- c(NA, data$intervaltime[1:dim(data)[1]-1])
  data$lag_time <- strptime(data$lag_time, "%d-%b-%y %H:%M:%S %p")
  data$intervaltime <- strptime(data$intervaltime, "%d-%b-%y %H:%M:%S %p")
  # use distVincentyEllipsoid function to calculate the distances between
  # each lat long pair and it's lagged lat long pair  
  dist <- distVincentyEllipsoid(cbind(data$latitude, data$longitude), cbind(data$lag_lat, data$lag_long))
  timediff <- data$interval - data$lag_time  
  # sum and convert meters to miles
  sumdist <- round(sum(dist, na.rm=T) / 1609.344,1)
  distThreshold <- 20 # meters, I think
  sumidle <- round(sum(timediff[dist>= distThreshold], na.rm=T) / 60, 1)
  summove <- round(sum(timediff[dist< distThreshold], na.rm=T) / 60, 1)
  # paste together results so I don't have to drop them in a list
  result <- paste(sumdist, sumidle, summove, sep="|")
  return(result)
}

mileage <- ddply(fixdf, c("id", "route"), getMileage)
tmp <- strsplit(mileage$V1, "|", fixed=T)
mileage$miles <- as.numeric(sapply(tmp, "[", 1))
mileage$idle <- as.numeric(sapply(tmp, "[", 2))
mileage$move <- as.numeric(sapply(tmp, "[", 3))
rm(tmp)
mileage$V1 <- NULL
#write.csv(mileage, "output/distance_by_id.csv", row.names=F)

