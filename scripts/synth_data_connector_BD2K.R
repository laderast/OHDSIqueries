#load all packages
##sql
##ggplot for evaluation
#set environmental variables
#

install.packages("ggplot2")
install.packages("dplyr")
library(ggplot2)

library(dplyr)
##Load Connection Information (not saved to git)
#jsonObject <- fromJSON()

source("scripts/connect.R")
install.packages("RPostgreSQL")
install.packages("DBI")

library(RPostgreSQL)
library(DBI)
drv <- dbDriver("PostgreSQL")

#conDetails <- DatabaseConnector::createConnectionDetails(dbms = dbms, user = user, password=password,
#                                                         server = server, schema = schema, port = port)

#library(RMySQL)
mydb = dbConnect(PostgreSQL(), user=user, password=password, port=5432, dbname="postgres", host=server)

dbListTables(mydb)
?dbFetch

#step 1: pull every person
sqlStatementall <- "
select 
pr.person_id, pr.year_of_birth, pr.month_of_birth, pr.day_of_birth, pr.race_source_value as race, 
   pr.ethnicity_source_value 
  from person pr


"
rs <- dbSendQuery(mydb,sqlStatementall)
fetch(rs, n=-1)
dbClearResult(rs)
#step 1.b : query cohorts - groups of patients predefined
sqlStatementcoh <- "
select 
cd.* 

from cohort_definition cd
"
rs <- dbSendQuery(mydb,sqlStatementcoh)
fetch(rs, n=-1)
dbClearResult(rs)
#step 2 : select outcomes

sqlStatementout <- "
select 
cd.* 
  ,   ca.*
  ,   cs.*
  ,   co.*
  ,   pr.person_id, pr.year_of_birth, pr.month_of_birth, pr.day_of_birth, pr.race_source_value as race, 
pr.ethnicity_source_value 
from cohort_definition cd
join cohort_attribute ca on ca.cohort_definition_id = cd.cohort_definition_id
join concept cs on ca.value_as_concept_id = cs.concept_id
left join condition_occurrence co on co.condition_concept_id = cs.concept_id
left join person pr on pr.person_id = co.person_id
where cd.cohort_definition_name='ASCVD'
"
rs <- dbSendQuery(mydb,sqlStatementout)
fetch(rs, n=-1)
dbClearResult(rs)


#step 2 : select various potential predictors

sqlStatementpreds <- "
select 
cd.* 
,   ca.*
,   cs.*
,   co.*
,   pr.person_id, pr.year_of_birth, pr.month_of_birth, pr.day_of_birth, pr.race_source_value as race, 
pr.ethnicity_source_value 
from cohort_definition cd
join cohort_attribute ca on ca.cohort_definition_id = cd.cohort_definition_id
join concept cs on ca.value_as_concept_id = cs.concept_id
left join condition_occurrence co on co.condition_concept_id = cs.concept_id
left join person pr on pr.person_id = co.person_id
where cd.cohort_definition_name in ('Diabetes - ICD10CM','Hypertension - ICD10CM',' Anti-Hypertensive Pharmacologic Therapy - RxNORM')
"
rs <- dbSendQuery(mydb,sqlStatementpreds)
ptdiag <- fetch(rs, n=-1)
summary(ptdiag)
dbClearResult(rs)

#step 3 : create unique dataset with dummy variables and case statements + retain original codes

sqlStatementdata <- "
select 
pr.person_id, pr.year_of_birth, pr.month_of_birth, pr.day_of_birth, pr.race_source_value as race, 
pr.ethnicity_source_value,
case when o.person_ID is not null then 1 else 0 END as outcome, o.OUTCOME_NAME, o.ASCVD_code,
case when 
from person pr
LEFT JOIN (select 
co.person_id, cd.cohort_definition_name as OUTCOME_NAME, cs.concept_code as ASCVD_code 
from cohort_definition cd
join cohort_attribute ca on ca.cohort_definition_id = cd.cohort_definition_id
join concept cs on ca.value_as_concept_id = cs.concept_id
left join condition_occurrence co on co.condition_concept_id = cs.concept_id
where cd.cohort_definition_name='ASCVD' and pr.person_ID ne .) out o on o.person_ID=pr.person_ID
LEFT JOIN (select 
 
from cohort_definition cd
join cohort_attribute ca on ca.cohort_definition_id = cd.cohort_definition_id
join concept cs on ca.value_as_concept_id = cs.concept_id
left join condition_occurrence co on co.condition_concept_id = cs.concept_id
where cd.cohort_definition_name in ('Diabetes - ICD10CM','Hypertension - ICD10CM',' Anti-Hypertensive Pharmacologic Therapy - RxNORM'))

"

rs <- dbSendQuery(mydb,sqlStatementdata)
fetch(rs, n=-1)
dbClearResult(rs)


