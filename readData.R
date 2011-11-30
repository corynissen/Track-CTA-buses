

library(utils)

# maybe a good idea to bump up your memory limit.
#memory.limit(6000) # or bigger as needed

# in windows, I use this option to route through a proxy
# setInternet2(TRUE)

# set a working directory
setwd("/src/git/Track-CTA-buses")

# URL can be as follows... http://tracklytics.com:8080/resourcetracker2/services/cta/historical?date=DD-MON-YY
# get yesterday's date
ydate <- toupper(format(Sys.Date()-3, "%d-%b-%y"))
url <- paste("http://tracklytics.com:8080/resourcetracker2/services/cta/historical?date=", ydate, sep="")
download.file(url, destfile = paste(getwd(),"data/datafile.zip", sep="/"))

# extract zip file into "data" folder
#unzip("datafile.zip", exdir=paste(getwd(), "data", sep="/"))
system(paste("unzip ", "data/datafile.zip", sep=""))

# read the data, it's in XML sytle, but not a valid XML file
fname <- paste("mnt/resources/cta/aggregate/", ydate, ".dat", sep="")
fixscan <- scan(fname, what="character", sep="\n")
# I run out of memory on my laptop, make the data smaller...
# fixscan <- fixscan[1:1500000]

# data not a "real" xml file, so use a custom parser
# will get data for these labels
labels <- c("id", "fixdate", "resourcename", "latitude", "longitude", "route", "heading", "destination", "patternid", "pdist", "requesttime", "intervaltime")

# function to regex the data out of the XML style string
parseString <- function(label, vector){
  substring(vector, regexpr(label, vector) + nchar(label) + 1, regexpr(paste("/",label,sep=""), vector) - 2)
}

# loop over the labels and create the dataframe with the data parsed from
# this won't run, out of memory, but if I break it up, it will run...
# so an explicit loop it is...
#fixdf <- data.frame(sapply(labels, function(x)parseString(x,fixscan)))
for(i in labels){assign(i, parseString(i, fixscan))}

# don't need original XML style data, let's get rid of it and gc
rm(fixscan); gc()

# combine all of the vectors together into a dataframe
fixdf <- data.frame(sapply(labels, get), stringsAsFactors=F)

# get rid of individual vectors now...
rm(list=labels); gc()

# some data cleanup
fixdf$latitude <- as.numeric(fixdf$latitude)
fixdf$longitude <- as.numeric(fixdf$longitude)
fixdf$fixdate <- as.Date(fixdf$fixdate, "%d-%b-%y %H:%M:%S %p")
fixdf$intervaltime <- as.Date(fixdf$intervaltime, "%d-%b-%y %H:%M:%S %p")
fixdf$requesttime <- as.Date(fixdf$requesttime, "%d-%b-%y %H:%M:%S %p")

# optional step...
# save to file, it takes a couple minutes to do the previous steps
#save.image("data/fixdata.rdata")
