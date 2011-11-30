
# This packages up the separate procedures to run in command line
# R CMD BATCH --vanilla go.R
system("export TWO_TASK=//184.73.249.62:1521/XE")
system("echo $TWO_TASK")
system("export ORACLE_HOME=/usr/lib/oracle/11.2/client64/lib")
system("echo $ORACLE_HOME")
system("export LD_LIBRARY_PATH=/usr/lib/oracle/11.2/client64/lib:/usr/lib")
system("echo $LD_LIBRARY_PATH")
source("/src/git/Track-CTA-buses/readData.R") #fetch yesterday's data, make fixdf data frame
source("/src/git/Track-CTA-buses/mileageByID.R") #calculate mileage by bus, make mileage data frame
source("/src/git/Track-CTA-buses/writeToDB.R") #write mileage to database

# this runs on an EC2 instance...  This line will call a shutdown routine
system("sudo /sbin/shutdown -h now")
