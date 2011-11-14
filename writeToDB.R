
require(RODBC)

# reformat dataframe to make it semi-colon delimited clob
clob <- paste(mileage$id, mileage$miles, sep=",", collapse=";")

# setup connect to XE, a unixODBC data source on my computer
con <- odbcConnect("CTA")

# append mileage df to tablename
# will save response message to response variable
response <- sqlQuery(con, call pg_cta.WriteAllBusMileage(ydate, clob))

# close the connection to avoid warnings at shutdown of R
odbcClose(con)

# do something with response
