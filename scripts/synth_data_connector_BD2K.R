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

#source("connect.R")
install.packages("RPostgreSQL")
install.packages("DBI")

library(RPostgreSQL)
library(dbi)
drv <- dbDriver("PostgreSQL")

#conDetails <- DatabaseConnector::createConnectionDetails(dbms = dbms, user = user, password=password,
#                                                         server = server, schema = schema, port = port)

#library(RMySQL)
mydb = dbConnect(PostgreSQL(), user="DBAdmin", password="OMOP!2017", port=5432, dbname="ohdsi_omop", host="cmp03.acc.research.computing")

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

connectionDetails <- createConnectionDetails(dbms="postgresql", server="cmp03.acc.research.computing",user = "DBAdmin",
                                             password = "OMOP!2017",schema="postgres")


/* *** Pull Cohorts and the codes associated with it. *** */
  select 
'<--CD-->', cd.* 
  , '<--CA-->', ca.*
  , '<--CS-->', cs.*
  from cohort_definition?? cd
join cohort_attribute ca on ca.cohort_definition_id = cd.cohort_definition_id
join concept????????? cs on ca.value_as_concept_id? = cs.concept_id
where cd.cohort_definition_name = 'Diabetes - ICD9CM'
;

/* *** Pulls Condition Occurances with this Cohort *** */
  select 
'<--CD-->', cd.* 
  , '<--CA-->', ca.*
  , '<--CS-->', cs.*
  , '<--CO-->', co.*
  from cohort_definition????????????? cd
join cohort_attribute??????????? ca on ca.cohort_definition_id = cd.cohort_definition_id
join concept???????????????????? cs on ca.value_as_concept_id? = cs.concept_id
left join condition_occurrence?? co on co.condition_concept_id = cs.concept_id
where cd.cohort_definition_name = 'Diabetes - ICD9CM'
;

/* *** Pulls condition occurances with person information*** */
  select 
'<--CD-->', cd.* 
  , '<--CA-->', ca.*
  , '<--CS-->', cs.*
  , '<--CO-->', co.*
  , '<--PR-->', pr.*
  from cohort_definition????????????? cd
join cohort_attribute??????????? ca on ca.cohort_definition_id = cd.cohort_definition_id
join concept???????????????????? cs on ca.value_as_concept_id? = cs.concept_id
left join condition_occurrence?? co on co.condition_concept_id = cs.concept_id
left join person???????????????? pr on pr.person_id??????????? = co.person_id
where cd.cohort_definition_name = 'Diabetes - ICD9CM'
;


#Define a particular cohort for retrieval multiple times
/* *** Build the Cohort_Definition Record *** */
  INSERT INTO `ohdsi_omop`.`cohort_definition`
(`cohort_definition_id`,
  `cohort_definition_name`,
  `cohort_definition_description`,
  `definition_type_concept_id`,
  `cohort_definition_syntax`,
  `subject_concept_id`,
  `cohort_initiation_date`)
VALUES
(
  2,????????????????????????????????????????????? /* <cohort_definition_id>?????????? ????? Unique Idenitifier for this observation definition */
    'Diabetes - ICD9CM',????????????????????????? /* <cohort_definition_name>???????? ????? Cohort Name */
    'OID:2.16.840.1.113883.3.464.1003.103.11.1001', /* <cohort_definition_description>? ????? Cohort Definition */
    44819127,?????????????????????????????????????? /* <definition_type_concept_id>???? ????? Condition Type Vocabulary ID: select * from concept where concept_id = '44819127' */
    '<{cohort_definition_syntax: }>',?????????????? /* <cohort_definition_syntax>?????? ?? */
    19,???????????????????????????????????????????? /* <subject_concept_id>???????????? ????? select * from domain where domain_id = 'Condition'*/
    '2017-02-16'??????????????????????????????????? /* <cohort_initiation_date>???????? ?? */
);

#Code to define a cohort attribute
/* *** Build the Cohort_Attribute table *** */
  insert into cohort_attribute
select 
2?????????? as Cohort_Definition_id
, '2017-02-16' as Cohort_Start_Date
, '2017-12-31'???????? as Cohort_End_Date
, 44819127???? as subject_id
, 1??????????? as attribute_definition_id
, null??????? as value_as_number
, c.concept_id as Value_as_Concept_ID
from concept c
where vocabulary_id = 'ICD9CM'
AND domain_id = 'Condition'
AND Concept_Code in 
( /* *** ICD9 Codes pulled from the Value Set Authority for Diabetes OID:2.16.840.1.113883.3.464.1003.103.11.1001 *** */
    '250.00','250.01','250.02','250.03','250.10','250.11','250.12','250.13','250.20','250.21','250.22','250.23','250.30','250.31','250.32','250.33','250.40',
  '250.41','250.42','250.43','250.50','250.51','250.52','250.53','250.60','250.61','250.62','250.63','250.70','250.71','250.72','250.73','250.80','250.81',
  '250.82','250.83','250.90','250.91','250.92','250.93','357.2' ,'362.01','362.02','362.03','362.04','362.05','362.06','362.07','366.41','648.00','648.01',
  '648.02','648.03','648.04'
)
;??? 

###Put Data processing steps here

#load dataset redcap

dataset <- read.csv("C:/Users/davedorr/Downloads/redcap_extract_1.4.17 (1).csv",row.names = 1)

head(dataset)


#uncomment this line to load dataset B

#dataset <- read.csv("data/datasetB.csv", row.names= 1)





##Don't modify anything below here, or app won't work properly.



#get the variable types

varClass <- sapply(dataset, class)



#separate the variables into each type

categoricalVars <- names(varClass[varClass == "factor"])

numericVars <- names(varClass[varClass %in% c("numeric", "integer")])

#Code to process dataset A

library(dplyr)



##Research Question: Did treatment groups lose more weight than the control group for both centers?

##Tasks: How will we compare the two centers? What do we need to do to compare the centers?



#Materials Needed for Workshop:

#DatasetA

#Data Dictionary A

#DatasetB

#Data Dictionary B



##Tools to use

#Shiny App for Visualization

##Summary Statistics

##Histogram Visualization for single covariates

##Boxplot Visualization

#Rmarkdown document for final report



#Basic Approach: I encode differences within a patient population (for example, gender), 

#and then base our endWeight off an Effect Size that varies per patient

#and then add a noise term to make the data more noisy



#sample size for dataset A

studySize <- 107

#half of dataset are controls

percentControls <- 0.5



#add gender Effect (base weights for patients)

averageWeightMen <- 170

averageWeightWomen <- 140



#gender percentage

percentMale <- 0.4

assigns <- 1:studySize



#pick rows in data set to assign to male patients

malePatients <- sample(assigns, floor(percentMale*studySize))

#female patients are the patients that are not male patients (obviously)

femalePatients <- assigns[-malePatients]



#assign gender

gender <- rep("NA", nrow(patientData))

gender[malePatients] <- "male"

gender[femalePatients] <- "female"



#10 percent of patients have missing gender

percentMissing <- 0.1

missingGender <- sample(assigns, floor(percentMissing * nrow(patientData)))

gender[missingGender] <- "NA"



#set a base weight

startWeights <- rep(NA,length(assigns))

startWeights[malePatients] <- rnorm(length(malePatients),mean=averageWeightMen, sd=30)

startWeights[femalePatients] <- rnorm(length(femalePatients), mean=averageWeightWomen, sd=25)



#find number of patients who received treatment

numTreat <- floor(studySize * (1-percentControls))

#randomly assign rows of patients to treatment

treatPatientInd <- sample(1:length(startWeights),size = numTreat)



#control patients are the patients who don't receive treatment (obviously)

controlPatientInd <- assigns[-treatPatientInd]

timeElapsed <- sample(x=c(10:60),size=length(startWeights),replace = TRUE)





#effect size for Dataset A has same mean across all patients (0.02)

CenterA <- 0.02

effectSizeTreat <- rnorm(numTreat, mean=CenterA, sd=0.02) 



effectSize <- rep(0, length(startWeights))

effectSize[treatPatientInd] <- effectSizeTreat

weightLoss <- startWeights * (effectSize * (timeElapsed/30))

endWeights <- startWeights - weightLoss





###Build our treatment variable

treatment <- rep(NA, length(startWeights))

treatment[treatPatientInd] <- "Treatment"

treatment[controlPatientInd] <- "Control"



#treatPatients <- data.frame(startWeights, endWeights, treatment=identTreat, timeElapsed = timeElapsed)



patientData <- data.frame(startWeights, endWeights, treatment=treatment, timeElapsed = timeElapsed)





#add noise to our signal (just to the final end weight)

noise1 <- rnorm(nrow(patientData), mean = 0, sd=2)

patientData$endWeights <- patientData$endWeights + noise1



patientData$startWeights <- signif(patientData$startWeights, 4)

patientData$endWeights <- signif(patientData$endWeights,4)





##assignNurses equally to each cohort

assigns <- 1:nrow(patientData)



staffNames <- c("N1","N2","N3")

staff <- sample(staffNames, size=studySize, replace = TRUE)



#generate a unique patient id for dataset A

patientID <- sample(0:50000, nrow(patientData))

patientID <- as.character(patientID)

patientID <- sapply(patientID, function(x){
  
  numZeros <- 6 - nchar(x)
  
  zeroPad <- paste0(as.character(rep(0,numZeros)), collapse="")
  
  paste0("PSUID", zeroPad,x, collapse = "")
  
})



staff2 <- staff[sample(assigns, size=studySize)]



patientData <- data.frame(patientID, patientData, staffID1 = staff, staffID2=staff2)





##Screw the data up

##10% of the data will have value 9999 (error code for scale)

messedUp <- sample(1:nrow(patientData), floor(0.05*nrow(patientData)))

patientData$startWeights[messedUp] <- 9999

messedUp <- sample(1:nrow(patientData), floor(0.05*nrow(patientData)))

patientData$endWeights[messedUp] <- 9999





#distribute age from 20-30



age <- sample(20:30,size=nrow(patientData), replace = TRUE)



#glue dataset together

patientData <- data.frame(patientData, gender=gender, age=age)



#write dataset A

write.table(patientData, "~/Code/shinyEDA/data/datasetA.txt",sep="\t", quote=FALSE, row.names = FALSE)





###Code to Generate Dataset B

studySizeB <- 72



#I changed this to an actual number (compared to dataset A) for no good reason

numControls <- 30



assigns <- 1:studySizeB



#units for center B are in kg and months just to make it 

#difficult to compare datasets

age <- sample(64:88, size=studySizeB, replace=TRUE)

gender <- sample(c("Male","Female"),size=studySizeB,replace=TRUE)

controlInd <- sample(assigns, size = numControls)

treatment <- rep(NA, studySizeB)

treatment[controlInd] <- "Control"

treatment[-controlInd] <- "Treatment"



##effectSize is smaller for women than men for dataset B

averageWeightWomen <- 150

averageWeightMen <- 190

startWeight <- rep(0, studySizeB) 

femaleInd <- which(gender=="Female")

maleInd <- which(gender == "Male")

startWeight[femaleInd] <- rnorm(n=length(femaleInd),mean = averageWeightMen, sd=10)

startWeight[maleInd] <- rnorm(n=length(maleInd),mean = averageWeightMen, sd=30)



#effect size (% weight lost per day) is different for each patient, 

#but is 0.02 +/- a noise term for females

#and 0.04 +/- noise for males

effectSize <- rep(0,studySizeB)



sizeFemaleTreat <- length(which(gender=="Female" & treatment == "Treatment"))

effectSize[gender=="Female" & treatment == "Treatment"] <- rnorm(n=sizeFemaleTreat,mean=0.02,sd=0.02)

sizeMaleTreat <- length(which(gender=="Male" & treatment == "Treatment"))

effectSize[gender=="Male" & treatment == "Treatment"] <- rnorm(n=sizeMaleTreat,mean=0.04,sd=0.02)



timeElapsed <- sample(30:80, size=studySizeB, replace=TRUE)



#effect size is used to calculate weight loss

#end weight is obviously the start weight minus weight loss

weightLoss <- startWeight * effectSize * (timeElapsed/30)

endWeight <- startWeight - weightLoss



#convert lbs to kg

startWeight <- startWeight / 2.2

endWeight <- endWeight / 2.2



#20% dropout Rate

dropoutRate <- 0.2



#dropouts are notated as NAs for the endWeight

dropouts <- sample(assigns, size=floor(dropoutRate*studySizeB))

endWeight[dropouts] <- NA



#generate patient IDs as unique number

patientID <- sample(0:2000, studySizeB)

patientID <- as.character(patientID)

patientID <- sapply(patientID, function(x){
  
  numZeros <- 4 - nchar(x)
  
  zeroPad <- paste0(as.character(rep(0,numZeros)), collapse="")
  
  paste0("TPID", zeroPad,x, collapse = "")
  
})





#nurseID for initial set of weight measurements

staffID <- c("S1","S2", "S3","S4")

staffAssignments <- sample(staffID, size=studySizeB, replace = TRUE)



#nurse3 for some reason recorded all the same values for startWeight!

staff3 <- which(staffAssignments=="S3")

startWeight[staff3] <- 51



#Nurse 3 is missing from second set of measurements

staffID2 <- c("S1","S2", "S4")

staffAssignments2 <- sample(staffID2, size=studySizeB, replace = TRUE)



patientDataB <- data.frame(subject=patientID, age, gender, treatment, startWeight, endWeight, timeElapsed,
                           
                           staffID1=staffAssignments, staffID2=staffAssignments2)



#mess up signal with noise

noise1 <- rnorm(nrow(patientDataB), mean = 0, sd=2.0)

patientDataB$endWeight <- patientDataB$endWeight + noise1



#change significant digits 

patientDataB$startWeight <- signif(patientDataB$startWeight, 3)

patientDataB$endWeight <- signif(patientDataB$endWeight,3)



#save Dataset B (as csv)

write.csv(patientDataB, "~/Code/shinyEDA/data/datasetB.csv",quote = FALSE,row.names = FALSE)

#load dataset A



datasetA <- read.delim("data/datasetA.txt",row.names = 1)

datasetA <- datasetA %>% filter(startWeights != 9999 & endWeights != 9999)

datasetA <- datasetA %>% mutate(weightLoss = startWeights - endWeights, weightLossPerDay = weightLoss / timeElapsed)

datasetA <- na.omit(datasetA)

dataset <- datasetA



#Code to process dataset B



datasetB <- read.csv("data/datasetB.csv", row.names = 1)

datasetB <- datasetB %>% filter(staffID1 != "S3")

datasetB <- na.omit(datasetB)

datasetB <- datasetB %>% mutate(weightLoss = (startWeight - endWeight) * 2.2, 
                                
                                weightLossPerDay = weightLoss / timeElapsed)

dataset <- datasetB



#Code to combine the two datasets

#Here we select columns for each dataset (treatment and weight)

#in order to make the two datasets comparable, we make both genders lowercase 

#(coverting it to a character), but then we have to recast it as a 

#factor (categorical variable)

datasetAselect <- datasetA %>% mutate(site="A", gender=factor(tolower(gender))) %>% 
  
  select(treatment, weightLossPerDay, site, gender)



datasetBselect <- datasetB %>% mutate(site="B", gender=factor(tolower(gender))) %>% 
  
  select(treatment, weightLossPerDay, site, gender)



dataset <- rbind(datasetAselect, datasetBselect)



#have to recast site as a factor because it's a character

dataset$site <- factor(dataset$site)