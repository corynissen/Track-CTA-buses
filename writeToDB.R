
require(RODBC)

# setup connect to CTA, a unixODBC data source on my computer
con <- odbcConnect("CTA")

# append mileage df to tablename
# can only write out 4000 or so characters before R has issues, so we have to break
# the write up into several pieces...
n <- 200  # the number of rows written per write
for(i in 1:ceiling(dim(mileage)[1] / n)){
  min <- i*n-(n-1)
  print(min)
  max <- min(dim(mileage)[1], i*n)
  print(max)
  df <- mileage[min:max,]
  # reformat dataframe to make it semi-colon delimited clob
  clob1 <- paste(df$id, df$route, df$miles, sep=",", collapse=";")
  clob2 <- paste(df$id, df$route, df$idle, df$move, sep=",", collapse=";")
  print(dim(df))
  response1 <- sqlQuery(con, paste("call pg_cta.WriteAllBusRouteMileage('", ydate, "', '", clob1, "')", sep=""))
  response2 <- sqlQuery(con, paste("call pg_cta.WriteAllBusUtilization('", ydate, "', '", clob2, "')", sep=""))
  print(response1) # "No Data" is a success in my case
  print(response2)
  }

# close the connection to avoid warnings at shutdown of R
odbcClose(con)


