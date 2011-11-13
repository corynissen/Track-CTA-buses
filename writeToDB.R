
require(RODBC)

# setup connect to XE, a unixODBC data source on my computer
con <- odbcConnect("CTA")

# append mileage df to tablename
# will save response message to response variable
response <- sqlSave(con, mileage, tablename=tablename, append=TRUE)

# close the connection to avoid warnings at shutdown of R
odbcClose(con)

# do something with response
