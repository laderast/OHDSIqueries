##Load Connection Information (not saved to git)
jsonObject <- fromJSON()

source("connect.R")
library(Achilles)
library(RPostgreSQL)
drv <- dbDriver("PostgreSQL")

#conDetails <- DatabaseConnector::createConnectionDetails(dbms = dbms, user = user, password=password,
#                                                         server = server, schema = schema, port = port)

#library(RMySQL)

mydb = dbConnect(drv, user=user, password=password, dbname=schema, host=server)

dbListTables(mydb)

sqlStatement <- "
  SELECT
  condition_era_id,
  person_id,
  condition_concept_id,
  condition_era_start_date,
  condition_era_end_date,
  condition_occurrence_count
  FROM
  condition_era

"


connectionDetails <- createConnectionDetails(dbms="postgresql", server=server,user = user,
                                             password = password,schema=schema)

rs <- dbSendQuery(mydb,sqlStatement)
fetch(rs, n=10)

?fetch

library(Achilles)

 achillesHeel(connectionDetails, cdmDatabaseSchema=schema,
             resultsDatabaseSchema = schema, cdmVersion = "5",
              vocabDatabaseSchema = schema)
# 
achilles(connectionDetails, cdmDatabaseSchema=schema,
          resultsDatabaseSchema = schema, sourceName = schema, 
          createTable = TRUE, smallcellcount = 5, cdmVersion = "5",
          runHeel = FALSE, validateSchema = FALSE,
          vocabDatabaseSchema = schema, runCostAnalysis = FALSE,
          sqlOnly = FALSE)

fetchAchillesAnalysisResults(connectionDetails, "public", 106)
exportToJson(connectionDetails, "public", "public")


