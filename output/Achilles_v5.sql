/******************************************************************

# @file ACHILLES_v5.SQL
#
# Copyright 2014 Observational Health Data Sciences and Informatics
#
# This file is part of ACHILLES
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# @author Observational Health Data Sciences and Informatics




*******************************************************************/


/*******************************************************************

Achilles - database profiling summary statistics generation

SQL for OMOP CDM v5


*******************************************************************/










  /****
    developer comment about general ACHILLES calculation process:  
		you could drive # of persons by age decile, from # of persons by age decile by gender
		as a general rule:  do full stratification once, and then aggregate across strata to avoid re-calculation
		works for all prevalence calculations...does not work for any distribution statistics
	*****/

--


--

DROP TABLE IF EXISTS  ohdsi_omop.ACHILLES_analysis;

create table ohdsi_omop.ACHILLES_analysis
(
	analysis_id int,
	analysis_name varchar(255),
	stratum_1_name varchar(255),
	stratum_2_name varchar(255),
	stratum_3_name varchar(255),
	stratum_4_name varchar(255),
	stratum_5_name varchar(255)
);


DROP TABLE IF EXISTS  ohdsi_omop.ACHILLES_results;

create table ohdsi_omop.ACHILLES_results
(
	analysis_id int,
	stratum_1 varchar(255),
	stratum_2 varchar(255),
	stratum_3 varchar(255),
	stratum_4 varchar(255),
	stratum_5 varchar(255),
	count_value bigint
);


DROP TABLE IF EXISTS  ohdsi_omop.ACHILLES_results_dist;

create table ohdsi_omop.ACHILLES_results_dist
(
	analysis_id int,
	stratum_1 varchar(255),
	stratum_2 varchar(255),
	stratum_3 varchar(255),
	stratum_4 varchar(255),
	stratum_5 varchar(255),
	count_value bigint,
	min_value NUMERIC,
	max_value NUMERIC,
	avg_value NUMERIC,
	stdev_value NUMERIC,
	median_value NUMERIC,
	p10_value NUMERIC,
	p25_value NUMERIC,
	p75_value NUMERIC,
	p90_value NUMERIC
);



--end of creating tables


--populate the tables with names of analyses

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (0, 'Source name');

--000. PERSON statistics

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (1, 'Number of persons');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (2, 'Number of persons by gender', 'gender_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (3, 'Number of persons by year of birth', 'year_of_birth');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (4, 'Number of persons by race', 'race_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (5, 'Number of persons by ethnicity', 'ethnicity_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (7, 'Number of persons with invalid provider_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (8, 'Number of persons with invalid location_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (9, 'Number of persons with invalid care_site_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name, stratum_2_name)
	values (10, 'Number of all persons by year of birth by gender', 'year_of_birth', 'gender_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name, stratum_2_name)
	values (11, 'Number of non-deceased persons by year of birth by gender', 'year_of_birth', 'gender_concept_id');
	
insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name, stratum_2_name)
  values (12, 'Number of persons by race and ethnicity','race_concept_id','ethnicity_concept_id');


--100. OBSERVATION_PERIOD (joined to PERSON)

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (101, 'Number of persons by age, with age at first observation period', 'age');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name, stratum_2_name)
	values (102, 'Number of persons by gender by age, with age at first observation period', 'gender_concept_id', 'age');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (103, 'Distribution of age at first observation period');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (104, 'Distribution of age at first observation period by gender', 'gender_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (105, 'Length of observation (days) of first observation period');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (106, 'Length of observation (days) of first observation period by gender', 'gender_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (107, 'Length of observation (days) of first observation period by age decile', 'age decile');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (108, 'Number of persons by length of observation period, in 30d increments', 'Observation period length 30d increments');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (109, 'Number of persons with continuous observation in each year', 'calendar year');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (110, 'Number of persons with continuous observation in each month', 'calendar month');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (111, 'Number of persons by observation period start month', 'calendar month');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (112, 'Number of persons by observation period end month', 'calendar month');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (113, 'Number of persons by number of observation periods', 'number of observation periods');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (114, 'Number of persons with observation period before year-of-birth');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (115, 'Number of persons with observation period end < observation period start');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name, stratum_2_name, stratum_3_name)
	values (116, 'Number of persons with at least one day of observation in each year by gender and age decile', 'calendar year', 'gender_concept_id', 'age decile');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (117, 'Number of persons with at least one day of observation in each month', 'calendar month');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
  values (118, 'Number of observation periods with invalid person_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
  values (119, 'Number of observation period records by period_type_concept_id','period_type_concept_id');




--200- VISIT_OCCURRENCE


insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (200, 'Number of persons with at least one visit occurrence, by visit_concept_id', 'visit_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (201, 'Number of visit occurrence records, by visit_concept_id', 'visit_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name, stratum_2_name)
	values (202, 'Number of persons by visit occurrence start month, by visit_concept_id', 'visit_concept_id', 'calendar month');	

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (203, 'Number of distinct visit occurrence concepts per person');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name, stratum_2_name, stratum_3_name, stratum_4_name)
	values (204, 'Number of persons with at least one visit occurrence, by visit_concept_id by calendar year by gender by age decile', 'visit_concept_id', 'calendar year', 'gender_concept_id', 'age decile');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name, stratum_2_name)
	values (206, 'Distribution of age by visit_concept_id', 'visit_concept_id', 'gender_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (207, 'Number of visit records with invalid person_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (208, 'Number of visit records outside valid observation period');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (209, 'Number of visit records with end date < start date');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (210, 'Number of visit records with invalid care_site_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (211, 'Distribution of length of stay by visit_concept_id', 'visit_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name, stratum_2_name, stratum_3_name )
	values (212, 'Number of persons with at least one visit occurrence, by calendar year by gender by age decile', 'calendar year', 'gender_concept_id', 'age decile');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (220, 'Number of visit occurrence records by visit occurrence start month', 'calendar month');



--300- PROVIDER
insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (300, 'Number of providers');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (301, 'Number of providers by specialty concept_id', 'specialty_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (302, 'Number of providers with invalid care site id');



--400- CONDITION_OCCURRENCE

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (400, 'Number of persons with at least one condition occurrence, by condition_concept_id', 'condition_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (401, 'Number of condition occurrence records, by condition_concept_id', 'condition_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name, stratum_2_name)
	values (402, 'Number of persons by condition occurrence start month, by condition_concept_id', 'condition_concept_id', 'calendar month');	

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (403, 'Number of distinct condition occurrence concepts per person');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name, stratum_2_name, stratum_3_name, stratum_4_name)
	values (404, 'Number of persons with at least one condition occurrence, by condition_concept_id by calendar year by gender by age decile', 'condition_concept_id', 'calendar year', 'gender_concept_id', 'age decile');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name, stratum_2_name)
	values (405, 'Number of condition occurrence records, by condition_concept_id by condition_type_concept_id', 'condition_concept_id', 'condition_type_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name, stratum_2_name)
	values (406, 'Distribution of age by condition_concept_id', 'condition_concept_id', 'gender_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (409, 'Number of condition occurrence records with invalid person_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (410, 'Number of condition occurrence records outside valid observation period');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (411, 'Number of condition occurrence records with end date < start date');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (412, 'Number of condition occurrence records with invalid provider_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (413, 'Number of condition occurrence records with invalid visit_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (420, 'Number of condition occurrence records by condition occurrence start month', 'calendar month');	

--500- DEATH

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (500, 'Number of persons with death, by cause_concept_id', 'cause_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (501, 'Number of records of death, by cause_concept_id', 'cause_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (502, 'Number of persons by death month', 'calendar month');	

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name, stratum_2_name, stratum_3_name)
	values (504, 'Number of persons with a death, by calendar year by gender by age decile', 'calendar year', 'gender_concept_id', 'age decile');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (505, 'Number of death records, by death_type_concept_id', 'death_type_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (506, 'Distribution of age at death by gender', 'gender_concept_id');


insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (509, 'Number of death records with invalid person_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (510, 'Number of death records outside valid observation period');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (511, 'Distribution of time from death to last condition');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (512, 'Distribution of time from death to last drug');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (513, 'Distribution of time from death to last visit');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (514, 'Distribution of time from death to last procedure');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (515, 'Distribution of time from death to last observation');


--600- PROCEDURE_OCCURRENCE



insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (600, 'Number of persons with at least one procedure occurrence, by procedure_concept_id', 'procedure_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (601, 'Number of procedure occurrence records, by procedure_concept_id', 'procedure_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name, stratum_2_name)
	values (602, 'Number of persons by procedure occurrence start month, by procedure_concept_id', 'procedure_concept_id', 'calendar month');	

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (603, 'Number of distinct procedure occurrence concepts per person');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name, stratum_2_name, stratum_3_name, stratum_4_name)
	values (604, 'Number of persons with at least one procedure occurrence, by procedure_concept_id by calendar year by gender by age decile', 'procedure_concept_id', 'calendar year', 'gender_concept_id', 'age decile');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name, stratum_2_name)
	values (605, 'Number of procedure occurrence records, by procedure_concept_id by procedure_type_concept_id', 'procedure_concept_id', 'procedure_type_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name, stratum_2_name)
	values (606, 'Distribution of age by procedure_concept_id', 'procedure_concept_id', 'gender_concept_id');



insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (609, 'Number of procedure occurrence records with invalid person_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (610, 'Number of procedure occurrence records outside valid observation period');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (612, 'Number of procedure occurrence records with invalid provider_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (613, 'Number of procedure occurrence records with invalid visit_id');


insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (620, 'Number of procedure occurrence records  by procedure occurrence start month', 'calendar month');


--700- DRUG_EXPOSURE


insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (700, 'Number of persons with at least one drug exposure, by drug_concept_id', 'drug_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (701, 'Number of drug exposure records, by drug_concept_id', 'drug_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name, stratum_2_name)
	values (702, 'Number of persons by drug exposure start month, by drug_concept_id', 'drug_concept_id', 'calendar month');	

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (703, 'Number of distinct drug exposure concepts per person');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name, stratum_2_name, stratum_3_name, stratum_4_name)
	values (704, 'Number of persons with at least one drug exposure, by drug_concept_id by calendar year by gender by age decile', 'drug_concept_id', 'calendar year', 'gender_concept_id', 'age decile');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name, stratum_2_name)
	values (705, 'Number of drug exposure records, by drug_concept_id by drug_type_concept_id', 'drug_concept_id', 'drug_type_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name, stratum_2_name)
	values (706, 'Distribution of age by drug_concept_id', 'drug_concept_id', 'gender_concept_id');



insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (709, 'Number of drug exposure records with invalid person_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (710, 'Number of drug exposure records outside valid observation period');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (711, 'Number of drug exposure records with end date < start date');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (712, 'Number of drug exposure records with invalid provider_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (713, 'Number of drug exposure records with invalid visit_id');



insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (715, 'Distribution of days_supply by drug_concept_id', 'drug_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (716, 'Distribution of refills by drug_concept_id', 'drug_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (717, 'Distribution of quantity by drug_concept_id', 'drug_concept_id');


insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (720, 'Number of drug exposure records  by drug exposure start month', 'calendar month');


--800- OBSERVATION


insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (800, 'Number of persons with at least one observation occurrence, by observation_concept_id', 'observation_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (801, 'Number of observation occurrence records, by observation_concept_id', 'observation_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name, stratum_2_name)
	values (802, 'Number of persons by observation occurrence start month, by observation_concept_id', 'observation_concept_id', 'calendar month');	

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (803, 'Number of distinct observation occurrence concepts per person');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name, stratum_2_name, stratum_3_name, stratum_4_name)
	values (804, 'Number of persons with at least one observation occurrence, by observation_concept_id by calendar year by gender by age decile', 'observation_concept_id', 'calendar year', 'gender_concept_id', 'age decile');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name, stratum_2_name)
	values (805, 'Number of observation occurrence records, by observation_concept_id by observation_type_concept_id', 'observation_concept_id', 'observation_type_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name, stratum_2_name)
	values (806, 'Distribution of age by observation_concept_id', 'observation_concept_id', 'gender_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name, stratum_2_name)
	values (807, 'Number of observation occurrence records, by observation_concept_id and unit_concept_id', 'observation_concept_id', 'unit_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (809, 'Number of observation records with invalid person_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (810, 'Number of observation records outside valid observation period');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (812, 'Number of observation records with invalid provider_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (813, 'Number of observation records with invalid visit_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (814, 'Number of observation records with no value (numeric, string, or concept)');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (815, 'Distribution of numeric values, by observation_concept_id and unit_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (820, 'Number of observation records  by observation start month', 'calendar month');


--900- DRUG_ERA


insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (900, 'Number of persons with at least one drug era, by drug_concept_id', 'drug_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (901, 'Number of drug era records, by drug_concept_id', 'drug_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name, stratum_2_name)
	values (902, 'Number of persons by drug era start month, by drug_concept_id', 'drug_concept_id', 'calendar month');	

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (903, 'Number of distinct drug era concepts per person');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name, stratum_2_name, stratum_3_name, stratum_4_name)
	values (904, 'Number of persons with at least one drug era, by drug_concept_id by calendar year by gender by age decile', 'drug_concept_id', 'calendar year', 'gender_concept_id', 'age decile');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name, stratum_2_name)
	values (906, 'Distribution of age by drug_concept_id', 'drug_concept_id', 'gender_concept_id');
	
insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (907, 'Distribution of drug era length, by drug_concept_id', 'drug_concept_id');	

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (908, 'Number of drug eras without valid person');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (909, 'Number of drug eras outside valid observation period');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (910, 'Number of drug eras with end date < start date');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (920, 'Number of drug era records  by drug era start month', 'calendar month');

--1000- CONDITION_ERA


insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (1000, 'Number of persons with at least one condition era, by condition_concept_id', 'condition_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (1001, 'Number of condition era records, by condition_concept_id', 'condition_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name, stratum_2_name)
	values (1002, 'Number of persons by condition era start month, by condition_concept_id', 'condition_concept_id', 'calendar month');	

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (1003, 'Number of distinct condition era concepts per person');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name, stratum_2_name, stratum_3_name, stratum_4_name)
	values (1004, 'Number of persons with at least one condition era, by condition_concept_id by calendar year by gender by age decile', 'condition_concept_id', 'calendar year', 'gender_concept_id', 'age decile');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name, stratum_2_name)
	values (1006, 'Distribution of age by condition_concept_id', 'condition_concept_id', 'gender_concept_id');
	
insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (1007, 'Distribution of condition era length, by condition_concept_id', 'condition_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (1008, 'Number of condition eras without valid person');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (1009, 'Number of condition eras outside valid observation period');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (1010, 'Number of condition eras with end date < start date');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (1020, 'Number of condition era records by condition era start month', 'calendar month');



--1100- LOCATION


insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (1100, 'Number of persons by location 3-digit zip', '3-digit zip');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (1101, 'Number of persons by location state', 'state');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (1102, 'Number of care sites by location 3-digit zip', '3-digit zip');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (1103, 'Number of care sites by location state', 'state');


--1200- CARE_SITE

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (1200, 'Number of persons by place of service', 'place_of_service_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (1201, 'Number of visits by place of service', 'place_of_service_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (1202, 'Number of care sites by place of service', 'place_of_service_concept_id');


--1300- ORGANIZATION

--NOT APPLICABLE IN CDMV5
--insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
--	values (1300, 'Number of organizations by place of service', 'place_of_service_concept_id');


--1400- PAYOR_PLAN_PERIOD

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (1406, 'Length of payer plan (days) of first payer plan period by gender', 'gender_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (1407, 'Length of payer plan (days) of first payer plan period by age decile', 'age_decile');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (1408, 'Number of persons by length of payer plan period, in 30d increments', 'payer plan period length 30d increments');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (1409, 'Number of persons with continuous payer plan in each year', 'calendar year');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (1410, 'Number of persons with continuous payer plan in each month', 'calendar month');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (1411, 'Number of persons by payer plan period start month', 'calendar month');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (1412, 'Number of persons by payer plan period end month', 'calendar month');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (1413, 'Number of persons by number of payer plan periods', 'number of payer plan periods');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (1414, 'Number of persons with payer plan period before year-of-birth');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (1415, 'Number of persons with payer plan period end < payer plan period start');

--1500- DRUG_COST



insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (1500, 'Number of drug cost records with invalid drug exposure id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (1501, 'Number of drug cost records with invalid payer plan period id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (1502, 'Distribution of paid copay, by drug_concept_id', 'drug_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (1503, 'Distribution of paid coinsurance, by drug_concept_id', 'drug_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (1504, 'Distribution of paid toward deductible, by drug_concept_id', 'drug_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (1505, 'Distribution of paid by payer, by drug_concept_id', 'drug_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (1506, 'Distribution of paid by coordination of benefit, by drug_concept_id', 'drug_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (1507, 'Distribution of total out-of-pocket, by drug_concept_id', 'drug_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (1508, 'Distribution of total paid, by drug_concept_id', 'drug_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (1509, 'Distribution of ingredient_cost, by drug_concept_id', 'drug_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (1510, 'Distribution of dispensing fee, by drug_concept_id', 'drug_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (1511, 'Distribution of average wholesale price, by drug_concept_id', 'drug_concept_id');


--1600- PROCEDURE_COST



insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (1600, 'Number of procedure cost records with invalid procedure occurrence id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (1601, 'Number of procedure cost records with invalid payer plan period id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (1602, 'Distribution of paid copay, by procedure_concept_id', 'procedure_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (1603, 'Distribution of paid coinsurance, by procedure_concept_id', 'procedure_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (1604, 'Distribution of paid toward deductible, by procedure_concept_id', 'procedure_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (1605, 'Distribution of paid by payer, by procedure_concept_id', 'procedure_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (1606, 'Distribution of paid by coordination of benefit, by procedure_concept_id', 'procedure_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (1607, 'Distribution of total out-of-pocket, by procedure_concept_id', 'procedure_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (1608, 'Distribution of total paid, by procedure_concept_id', 'procedure_concept_id');

--NOT APPLICABLE FOR OMOP CDM v5
--insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
--	values (1609, 'Number of records by disease_class_concept_id', 'disease_class_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (1610, 'Number of records by revenue_code_concept_id', 'revenue_code_concept_id');


--1700- COHORT

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (1700, 'Number of records by cohort_concept_id', 'cohort_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (1701, 'Number of records with cohort end date < cohort start date');

--1800- MEASUREMENT


insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (1800, 'Number of persons with at least one measurement occurrence, by measurement_concept_id', 'measurement_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (1801, 'Number of measurement occurrence records, by observation_concept_id', 'measurement_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name, stratum_2_name)
	values (1802, 'Number of persons by measurement occurrence start month, by observation_concept_id', 'measurement_concept_id', 'calendar month');	

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (1803, 'Number of distinct observation occurrence concepts per person');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name, stratum_2_name, stratum_3_name, stratum_4_name)
	values (1804, 'Number of persons with at least one observation occurrence, by observation_concept_id by calendar year by gender by age decile', 'measurement_concept_id', 'calendar year', 'gender_concept_id', 'age decile');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name, stratum_2_name)
	values (1805, 'Number of observation occurrence records, by measurement_concept_id by measurement_type_concept_id', 'measurement_concept_id', 'measurement_type_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name, stratum_2_name)
	values (1806, 'Distribution of age by observation_concept_id', 'observation_concept_id', 'gender_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name, stratum_2_name)
	values (1807, 'Number of measurement occurrence records, by measurement_concept_id and unit_concept_id', 'measurement_concept_id', 'unit_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (1809, 'Number of measurement records with invalid person_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (1810, 'Number of measurement records outside valid observation period');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (1812, 'Number of measurement records with invalid provider_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (1813, 'Number of measurement records with invalid visit_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (1814, 'Number of measurement records with no value (numeric, string, or concept)');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (1815, 'Distribution of numeric values, by measurement_concept_id and unit_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (1816, 'Distribution of low range, by measurement_concept_id and unit_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (1817, 'Distribution of high range, by observation_concept_id and unit_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (1818, 'Number of measurement records below/within/above normal range, by measurement_concept_id and unit_concept_id');


insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (1820, 'Number of measurement records  by measurement start month', 'calendar month');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (1821, 'Number of measurement records with no numeric value');

--1900 REPORTS

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name, stratum_2_name)
	values (1900, 'Source values mapped to concept_id 0 by table, by source_value', 'table_name', 'source_value');


--2000 Iris (and possibly other new measures) integrated into Achilles

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (2000, 'Number of patients with at least 1 Dx and 1 Rx');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (2001, 'Number of patients with at least 1 Dx and 1 Proc');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (2002, 'Number of patients with at least 1 Meas, 1 Dx and 1 Rx');
	
insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name)
	values (2003, 'Number of patients with at least 1 Visit');


--2100- DEVICE_EXPOSURE


insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (2100, 'Number of persons with at least one device exposure, by device_concept_id', 'device_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (2101, 'Number of device exposure records, by device_concept_id', 'device_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name, stratum_2_name)
	values (2102, 'Number of persons by device records  start month, by device_concept_id', 'device_concept_id', 'calendar month');	

--2103 was not implemented at this point

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name, stratum_2_name, stratum_3_name, stratum_4_name)
	values (2104, 'Number of persons with at least one device exposure, by device_concept_id by calendar year by gender by age decile', 'device_concept_id', 'calendar year', 'gender_concept_id', 'age decile');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name, stratum_2_name)
	values (2105, 'Number of device exposure records, by device_concept_id by device_type_concept_id', 'device_concept_id', 'device_type_concept_id');



--2200- NOTE


insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (2200, 'Number of persons with at least one note by  note_type_concept_id', 'note_type_concept_id');

insert into ohdsi_omop.ACHILLES_analysis (analysis_id, analysis_name, stratum_1_name)
	values (2201, 'Number of note records, by note_type_concept_id', 'note_type_concept_id');




--end of importing values into analysis lookup table

--

/****
7. generate results for analysis_results


****/

--
-- 0	cdm name, version of Achilles and date when pre-computations were executed
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, stratum_2, stratum_3,count_value)
select 0 as analysis_id,  'ohdsi_omop' as stratum_1, '1.4.5' as stratum_2, CURRENT_DATE as stratum_3,COUNT(distinct person_id) as count_value
from ohdsi_omop.PERSON;

insert into ohdsi_omop.ACHILLES_results_dist (analysis_id, stratum_1, count_value)
select 0 as analysis_id, 'ohdsi_omop' as stratum_1, COUNT(distinct person_id) as count_value
from ohdsi_omop.PERSON;

--


/********************************************

ACHILLES Analyses on PERSON table

*********************************************/



--
-- 1	Number of persons
insert into ohdsi_omop.ACHILLES_results (analysis_id, count_value)
select 1 as analysis_id,  COUNT(distinct person_id) as count_value
from ohdsi_omop.PERSON;
--


--
-- 2	Number of persons by gender
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
select 2 as analysis_id,  gender_concept_id as stratum_1, COUNT(distinct person_id) as count_value
from ohdsi_omop.PERSON
group by GENDER_CONCEPT_ID;
--



--
-- 3	Number of persons by year of birth
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
select 3 as analysis_id,  year_of_birth as stratum_1, COUNT(distinct person_id) as count_value
from ohdsi_omop.PERSON
group by YEAR_OF_BIRTH;
--


--
-- 4	Number of persons by race
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
select 4 as analysis_id,  RACE_CONCEPT_ID as stratum_1, COUNT(distinct person_id) as count_value
from ohdsi_omop.PERSON
group by RACE_CONCEPT_ID;
--



--
-- 5	Number of persons by ethnicity
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
select 5 as analysis_id,  ETHNICITY_CONCEPT_ID as stratum_1, COUNT(distinct person_id) as count_value
from ohdsi_omop.PERSON
group by ETHNICITY_CONCEPT_ID;
--





--
-- 7	Number of persons with invalid provider_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, count_value)
select 7 as analysis_id,  COUNT(p1.person_id) as count_value
from ohdsi_omop.PERSON p1
	left join ohdsi_omop.provider pr1
	on p1.provider_id = pr1.provider_id
where p1.provider_id is not null
	and pr1.provider_id is null
;
--



--
-- 8	Number of persons with invalid location_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, count_value)
select 8 as analysis_id,  COUNT(p1.person_id) as count_value
from ohdsi_omop.PERSON p1
	left join ohdsi_omop.location l1
	on p1.location_id = l1.location_id
where p1.location_id is not null
	and l1.location_id is null
;
--


--
-- 9	Number of persons with invalid care_site_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, count_value)
select 9 as analysis_id,  COUNT(p1.person_id) as count_value
from ohdsi_omop.PERSON p1
	left join ohdsi_omop.care_site cs1
	on p1.care_site_id = cs1.care_site_id
where p1.care_site_id is not null
	and cs1.care_site_id is null
;
--



--
-- 10	Number of all persons by year of birth and by gender
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, stratum_2, count_value)
select 10 as analysis_id,  year_of_birth as stratum_1, 
  gender_concept_id as stratum_2,
  COUNT(distinct person_id) as count_value
from ohdsi_omop.PERSON
group by YEAR_OF_BIRTH, gender_concept_id;
--


--
-- 11	Number of non-deceased persons by year of birth and by gender
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, stratum_2, count_value)
select 11 as analysis_id,  year_of_birth as stratum_1, 
  gender_concept_id as stratum_2,
  COUNT(distinct person_id) as count_value
from ohdsi_omop.PERSON
where person_id not in (select person_id from ohdsi_omop.DEATH)
group by YEAR_OF_BIRTH, gender_concept_id;
--



--
-- 12	Number of persons by race and ethnicity
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, stratum_2, count_value)
select 12 as analysis_id, RACE_CONCEPT_ID as stratum_1, ETHNICITY_CONCEPT_ID as stratum_2, COUNT(distinct person_id) as count_value
from ohdsi_omop.PERSON
group by RACE_CONCEPT_ID,ETHNICITY_CONCEPT_ID;
--

/********************************************

ACHILLES Analyses on OBSERVATION_PERIOD table

*********************************************/

--
-- 101	Number of persons by age, with age at first observation period
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
select 101 as analysis_id,   EXTRACT(YEAR FROM op1.index_date) - p1.YEAR_OF_BIRTH as stratum_1, COUNT(p1.person_id) as count_value
from ohdsi_omop.PERSON p1
	inner join (select person_id, MIN(observation_period_start_date) as index_date from ohdsi_omop.OBSERVATION_PERIOD group by PERSON_ID) op1
	on p1.PERSON_ID = op1.PERSON_ID
group by EXTRACT(YEAR FROM op1.index_date) - p1.YEAR_OF_BIRTH;
--



--
-- 102	Number of persons by gender by age, with age at first observation period
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, stratum_2, count_value)
select 102 as analysis_id,  p1.gender_concept_id as stratum_1, EXTRACT(YEAR FROM op1.index_date) - p1.YEAR_OF_BIRTH as stratum_2, COUNT(p1.person_id) as count_value
from ohdsi_omop.PERSON p1
	inner join (select person_id, MIN(observation_period_start_date) as index_date from ohdsi_omop.OBSERVATION_PERIOD group by PERSON_ID) op1
	on p1.PERSON_ID = op1.PERSON_ID
group by p1.gender_concept_id, EXTRACT(YEAR FROM op1.index_date) - p1.YEAR_OF_BIRTH;
--


--
-- 103	Distribution of age at first observation period
CREATE TEMP TABLE tempResults

AS
WITH  rawData (person_id, age_value)  AS 
(
select p.person_id, 
  MIN(EXTRACT(YEAR FROM observation_period_start_date)) - P.YEAR_OF_BIRTH as age_value
  from ohdsi_omop.PERSON p
  JOIN ohdsi_omop.OBSERVATION_PERIOD op on p.person_id = op.person_id
  group by p.person_id, p.year_of_birth
),
overallStats (avg_value, stdev_value, min_value, max_value, total) as
(
  select avg(1.0 * age_value) as avg_value,
  STDDEV(age_value) as stdev_value,
  min(age_value) as min_value,
  max(age_value) as max_value,
  COUNT(*) as total
  FROM rawData
),
ageStats (age_value, total, rn) as
(
  select age_value, COUNT(*) as total, row_number() over (order by age_value) as rn
  from rawData
  group by age_value
),
ageStatsPrior (age_value, total, accumulated) as
(
  select s.age_value, s.total, sum(p.total) as accumulated
  from ageStats s
  join ageStats p on p.rn <= s.rn
  group by s.age_value, s.total, s.rn
)
 SELECT
 103 as analysis_id,
  o.total as count_value,
	o.min_value,
	o.max_value,
	o.avg_value,
	o.stdev_value,
	MIN(case when p.accumulated >= .50 * o.total then age_value end) as median_value,
	MIN(case when p.accumulated >= .10 * o.total then age_value end) as p10_value,
	MIN(case when p.accumulated >= .25 * o.total then age_value end) as p25_value,
	MIN(case when p.accumulated >= .75 * o.total then age_value end) as p75_value,
	MIN(case when p.accumulated >= .90 * o.total then age_value end) as p90_value

FROM
 ageStatsPrior p
CROSS JOIN overallStats o
GROUP BY o.total, o.min_value, o.max_value, o.avg_value, o.stdev_value
;

insert into ohdsi_omop.ACHILLES_results_dist (analysis_id, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value)
select analysis_id, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value
from tempResults
;

truncate table tempResults;
drop table tempResults;
--



--
-- 104	Distribution of age at first observation period by gender
CREATE TEMP TABLE tempResults

AS
WITH  rawData (gender_concept_id, age_value)  AS 
(
  select p.gender_concept_id, MIN(EXTRACT(YEAR FROM observation_period_start_date)) - P.YEAR_OF_BIRTH as age_value
	from ohdsi_omop.PERSON p
	JOIN ohdsi_omop.OBSERVATION_PERIOD op on p.person_id = op.person_id
	group by p.person_id,p.gender_concept_id, p.year_of_birth
),
overallStats (gender_concept_id, avg_value, stdev_value, min_value, max_value, total) as
(
  select gender_concept_id,
  avg(1.0 *age_value) as avg_value,
  STDDEV(age_value) as stdev_value,
  min(age_value) as min_value,
  max(age_value) as max_value,
  COUNT(*) as total
  FROM rawData
  group by gender_concept_id
),
ageStats (gender_concept_id, age_value, total, rn) as
(
  select gender_concept_id, age_value, COUNT(*) as total, row_number() over (order by age_value) as rn
  FROM rawData
  group by gender_concept_id, age_value
),
ageStatsPrior (gender_concept_id, age_value, total, accumulated) as
(
  select s.gender_concept_id, s.age_value, s.total, sum(p.total) as accumulated
  from ageStats s
  join ageStats p on s.gender_concept_id = p.gender_concept_id and p.rn <= s.rn
  group by s.gender_concept_id, s.age_value, s.total, s.rn
)
 SELECT
 104 as analysis_id,
  o.gender_concept_id as stratum_1,
  o.total as count_value,
  o.min_value,
	o.max_value,
	o.avg_value,
	o.stdev_value,
	MIN(case when p.accumulated >= .50 * o.total then age_value end) as median_value,
	MIN(case when p.accumulated >= .10 * o.total then age_value end) as p10_value,
	MIN(case when p.accumulated >= .25 * o.total then age_value end) as p25_value,
	MIN(case when p.accumulated >= .75 * o.total then age_value end) as p75_value,
	MIN(case when p.accumulated >= .90 * o.total then age_value end) as p90_value

FROM
 ageStatsPrior p
join overallStats o on p.gender_concept_id = o.gender_concept_id
GROUP BY o.gender_concept_id, o.total, o.min_value, o.max_value, o.avg_value, o.stdev_value
;

insert into ohdsi_omop.ACHILLES_results_dist (analysis_id, stratum_1, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value)
select analysis_id, stratum_1, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value
from tempResults
;

truncate table tempResults;
drop table tempResults;
--

--
-- 105	Length of observation (days) of first observation period
CREATE TEMP TABLE tempResults

AS
WITH  rawData (count_value)  AS 
(
  select count_value
  FROM
  (
    select (CAST( op.observation_period_end_date AS DATE) - CAST(op.observation_period_start_date AS DATE)) as count_value,
  	  ROW_NUMBER() over (PARTITION by op.person_id order by op.observation_period_start_date asc) as rn
    from ohdsi_omop.OBSERVATION_PERIOD op
	) op
	where op.rn = 1
),
overallStats (avg_value, stdev_value, min_value, max_value, total) as
(
  select avg(1.0 * count_value) as avg_value,
  STDDEV(count_value) as stdev_value,
  min(count_value) as min_value,
  max(count_value) as max_value,
  COUNT(*) as total
  from rawData
),
stats (count_value, total, rn) as
(
  select count_value, COUNT(*) as total, row_number() over (order by count_value) as rn
  FROM
  (
    select (CAST( op.observation_period_end_date AS DATE) - CAST(op.observation_period_start_date AS DATE)) as count_value,
  	  ROW_NUMBER() over (PARTITION by op.person_id order by op.observation_period_start_date asc) as rn
    from ohdsi_omop.OBSERVATION_PERIOD op
	) op
  where op.rn = 1
  group by count_value
),
priorStats (count_value, total, accumulated) as
(
  select s.count_value, s.total, sum(p.total) as accumulated
  from stats s
  join stats p on p.rn <= s.rn
  group by s.count_value, s.total, s.rn
)
 SELECT
 105 as analysis_id,
  o.total as count_value,
  o.min_value,
	o.max_value,
	o.avg_value,
	o.stdev_value,
	MIN(case when p.accumulated >= .50 * o.total then count_value end) as median_value,
	MIN(case when p.accumulated >= .10 * o.total then count_value end) as p10_value,
	MIN(case when p.accumulated >= .25 * o.total then count_value end) as p25_value,
	MIN(case when p.accumulated >= .75 * o.total then count_value end) as p75_value,
	MIN(case when p.accumulated >= .90 * o.total then count_value end) as p90_value

FROM
 priorStats p
CROSS JOIN overallStats o
GROUP BY o.total, o.min_value, o.max_value, o.avg_value, o.stdev_value
;

insert into ohdsi_omop.ACHILLES_results_dist (analysis_id, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value)
select analysis_id, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value
from tempResults
;

truncate table tempResults;
drop table tempResults;
--


--
-- 106	Length of observation (days) of first observation period by gender
CREATE TEMP TABLE tempResults

AS
WITH  rawData(gender_concept_id, count_value)  AS 
(
  select p.gender_concept_id, op.count_value
  FROM
  (
    select person_id, (CAST( op.observation_period_end_date AS DATE) - CAST(op.observation_period_start_date AS DATE)) as count_value,
      ROW_NUMBER() over (PARTITION by op.person_id order by op.observation_period_start_date asc) as rn
    from ohdsi_omop.OBSERVATION_PERIOD op
	) op
  JOIN ohdsi_omop.PERSON p on op.person_id = p.person_id
	where op.rn = 1
),
overallStats (gender_concept_id, avg_value, stdev_value, min_value, max_value, total) as
(
  select gender_concept_id,
    avg(1.0 * count_value) as avg_value,
    STDDEV(count_value) as stdev_value,
    min(count_value) as min_value,
    max(count_value) as max_value,
    COUNT(*) as total
  FROM rawData
  group by gender_concept_id
),
stats (gender_concept_id, count_value, total, rn) as
(
  select gender_concept_id, count_value, COUNT(*) as total, row_number() over (order by count_value) as rn
  FROM rawData
  group by gender_concept_id, count_value
),
priorStats (gender_concept_id,count_value, total, accumulated) as
(
  select s.gender_concept_id, s.count_value, s.total, sum(p.total) as accumulated
  from stats s
  join stats p on s.gender_concept_id = p.gender_concept_id and p.rn <= s.rn
  group by s.gender_concept_id, s.count_value, s.total, s.rn
)
 SELECT
 106 as analysis_id,
  o.gender_concept_id,
  o.total as count_value,
  o.min_value,
	o.max_value,
	o.avg_value,
	o.stdev_value,
	MIN(case when p.accumulated >= .50 * o.total then count_value end) as median_value,
	MIN(case when p.accumulated >= .10 * o.total then count_value end) as p10_value,
	MIN(case when p.accumulated >= .25 * o.total then count_value end) as p25_value,
	MIN(case when p.accumulated >= .75 * o.total then count_value end) as p75_value,
	MIN(case when p.accumulated >= .90 * o.total then count_value end) as p90_value

FROM
 priorStats p
join overallStats o on p.gender_concept_id = o.gender_concept_id
GROUP BY o.gender_concept_id, o.total, o.min_value, o.max_value, o.avg_value, o.stdev_value
;

insert into ohdsi_omop.ACHILLES_results_dist (analysis_id, stratum_1, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value)
select analysis_id, gender_concept_id, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value
FROM tempResults
;

truncate table tempResults;
drop table tempResults;

--

--
-- 107	Length of observation (days) of first observation period by age decile

CREATE TEMP TABLE tempResults

AS
WITH  rawData (age_decile, count_value)  AS 
(
  select floor((EXTRACT(YEAR FROM op.OBSERVATION_PERIOD_START_DATE) - p.YEAR_OF_BIRTH)/10) as age_decile,
    (CAST( op.observation_period_end_date AS DATE) - CAST(op.observation_period_start_date AS DATE)) as count_value
  FROM
  (
    select person_id, 
  		op.observation_period_start_date,
  		op.observation_period_end_date,
      ROW_NUMBER() over (PARTITION by op.person_id order by op.observation_period_start_date asc) as rn
    from ohdsi_omop.OBSERVATION_PERIOD op
  ) op
  JOIN ohdsi_omop.PERSON p on op.person_id = p.person_id
  where op.rn = 1
),
overallStats (age_decile, avg_value, stdev_value, min_value, max_value, total) as
(
  select age_decile,
    avg(1.0 * count_value) as avg_value,
    STDDEV(count_value) as stdev_value,
    min(count_value) as min_value,
    max(count_value) as max_value,
    COUNT(*) as total
  from rawData
  group by age_decile
),
stats (age_decile, count_value, total, rn) as
(
  select age_decile,
    count_value, 
		COUNT(*) as total, 
		row_number() over (order by count_value) as rn
  FROM rawData
  group by age_decile, count_value
),
priorStats (age_decile,count_value, total, accumulated) as
(
  select s.age_decile, s.count_value, s.total, sum(p.total) as accumulated
  from stats s
  join stats p on s.age_decile = p.age_decile and p.rn <= s.rn
  group by s.age_decile, s.count_value, s.total, s.rn
)
 SELECT
 107 as analysis_id,
  o.age_decile,
  o.total as count_value,
  o.min_value,
	o.max_value,
	o.avg_value,
	o.stdev_value,
	MIN(case when p.accumulated >= .50 * o.total then count_value else o.max_value end) as median_value,
	MIN(case when p.accumulated >= .10 * o.total then count_value else o.max_value end) as p10_value,
	MIN(case when p.accumulated >= .25 * o.total then count_value else o.max_value end) as p25_value,
	MIN(case when p.accumulated >= .75 * o.total then count_value else o.max_value end) as p75_value,
	MIN(case when p.accumulated >= .90 * o.total then count_value else o.max_value end) as p90_value

FROM
 priorStats p
join overallStats o on p.age_decile = o.age_decile
GROUP BY o.age_decile, o.total, o.min_value, o.max_value, o.avg_value, o.stdev_value
;

insert into ohdsi_omop.ACHILLES_results_dist (analysis_id, stratum_1, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value)
select analysis_id, age_decile, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value
FROM tempResults
;

truncate table tempResults;
drop table tempResults;

--


--
-- 108	Number of persons by length of observation period, in 30d increments
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
select 108 as analysis_id,  floor((CAST( op1.observation_period_end_date AS DATE) - CAST( op1.observation_period_start_date AS DATE))/30) as stratum_1, COUNT(distinct p1.person_id) as count_value
from ohdsi_omop.PERSON p1
	inner join 
	(select person_id, 
		OBSERVATION_PERIOD_START_DATE, 
		OBSERVATION_PERIOD_END_DATE, 
		ROW_NUMBER() over (PARTITION by person_id order by observation_period_start_date asc) as rn1
		 from ohdsi_omop.OBSERVATION_PERIOD
	) op1
	on p1.PERSON_ID = op1.PERSON_ID
	where op1.rn1 = 1
group by floor((CAST( op1.observation_period_end_date AS DATE) - CAST( op1.observation_period_start_date AS DATE))/30)
;
--




--
-- 109	Number of persons with continuous observation in each year
-- Note: using temp table instead of nested query because this gives vastly improved performance in Oracle

DROP TABLE IF EXISTS  temp_dates;

CREATE TEMP TABLE temp_dates

AS
SELECT
 DISTINCT 
  EXTRACT(YEAR FROM observation_period_start_date) AS obs_year,
  TO_DATE(CAST(EXTRACT(YEAR FROM observation_period_start_date) AS VARCHAR(4)) || '01' || '01' , 'yyyymmdd') AS obs_year_start,	
  TO_DATE(CAST(EXTRACT(YEAR FROM observation_period_start_date) AS VARCHAR(4)) || '12' || '31' , 'yyyymmdd') AS obs_year_end

FROM
 ohdsi_omop.observation_period
;

INSERT INTO ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
SELECT 
  109 AS analysis_id,  
	obs_year AS stratum_1, 
	COUNT(DISTINCT person_id) AS count_value
FROM ohdsi_omop.observation_period,
	temp_dates
WHERE  
		observation_period_start_date <= obs_year_start
	AND 
		observation_period_end_date >= obs_year_end
GROUP BY 
	obs_year
;

TRUNCATE TABLE temp_dates;
DROP TABLE temp_dates;
--


--
-- 110	Number of persons with continuous observation in each month
-- Note: using temp table instead of nested query because this gives vastly improved performance in Oracle

DROP TABLE IF EXISTS  temp_dates;

CREATE TEMP TABLE temp_dates

AS
SELECT
 DISTINCT 
  EXTRACT(YEAR FROM observation_period_start_date)*100 + EXTRACT(MONTH FROM observation_period_start_date) AS obs_month,
  TO_DATE(CAST(EXTRACT(YEAR FROM observation_period_start_date)  AS varchar(4)) ||  RIGHT('0' || CAST(EXTRACT(MONTH FROM OBSERVATION_PERIOD_START_DATE) AS VARCHAR(2)), 2) || '01' , 'yyyymmdd') AS obs_month_start,  
  (CAST((TO_DATE(CAST(EXTRACT(YEAR FROM observation_period_start_date)  AS varchar(4)) ||  RIGHT('0' || CAST(EXTRACT(MONTH FROM OBSERVATION_PERIOD_START_DATE) AS VARCHAR(2)), 2) || '01' , 'yyyymmdd') + 1*INTERVAL'1 month') AS DATE) + -1) AS obs_month_end

FROM
 ohdsi_omop.observation_period
;


INSERT INTO ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
SELECT 
  110 AS analysis_id, 
	obs_month AS stratum_1, 
	COUNT(DISTINCT person_id) AS count_value
FROM
	ohdsi_omop.observation_period,
	temp_Dates
WHERE 
		observation_period_start_date <= obs_month_start
	AND 
		observation_period_end_date >= obs_month_end
GROUP BY 
	obs_month
;

TRUNCATE TABLE temp_dates;
DROP TABLE temp_dates;
--



--
-- 111	Number of persons by observation period start month
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
select 111 as analysis_id, 
	EXTRACT(YEAR FROM observation_period_start_date)*100 + EXTRACT(MONTH FROM OBSERVATION_PERIOD_START_DATE) as stratum_1, 
	COUNT(distinct op1.PERSON_ID) as count_value
from
	ohdsi_omop.observation_period op1
group by EXTRACT(YEAR FROM observation_period_start_date)*100 + EXTRACT(MONTH FROM OBSERVATION_PERIOD_START_DATE)
;
--



--
-- 112	Number of persons by observation period end month
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
select 112 as analysis_id,  
	EXTRACT(YEAR FROM observation_period_end_date)*100 + EXTRACT(MONTH FROM observation_period_end_date) as stratum_1, 
	COUNT(distinct op1.PERSON_ID) as count_value
from
	ohdsi_omop.observation_period op1
group by EXTRACT(YEAR FROM observation_period_end_date)*100 + EXTRACT(MONTH FROM observation_period_end_date)
;
--


--
-- 113	Number of persons by number of observation periods
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
select 113 as analysis_id,  
	op1.num_periods as stratum_1, COUNT(distinct op1.PERSON_ID) as count_value
from
	(select person_id, COUNT(OBSERVATION_period_start_date) as num_periods from ohdsi_omop.OBSERVATION_PERIOD group by PERSON_ID) op1
group by op1.num_periods
;
--

--
-- 114	Number of persons with observation period before year-of-birth
insert into ohdsi_omop.ACHILLES_results (analysis_id, count_value)
select 114 as analysis_id,  
	COUNT(distinct p1.PERSON_ID) as count_value
from
	ohdsi_omop.PERSON p1
	inner join (select person_id, MIN(EXTRACT(YEAR FROM OBSERVATION_period_start_date)) as first_obs_year from ohdsi_omop.OBSERVATION_PERIOD group by PERSON_ID) op1
	on p1.person_id = op1.person_id
where p1.year_of_birth > op1.first_obs_year
;
--

--
-- 115	Number of persons with observation period end < start
insert into ohdsi_omop.ACHILLES_results (analysis_id, count_value)
select 115 as analysis_id,  
	COUNT(op1.PERSON_ID) as count_value
from
	ohdsi_omop.observation_period op1
where op1.observation_period_end_date < op1.observation_period_start_date
;
--



--
-- 116	Number of persons with at least one day of observation in each year by gender and age decile
-- Note: using temp table instead of nested query because this gives vastly improved performance in Oracle

DROP TABLE IF EXISTS  temp_dates;

CREATE TEMP TABLE temp_dates

AS
SELECT
 distinct 
  EXTRACT(YEAR FROM observation_period_start_date) as obs_year 

FROM
 
  ohdsi_omop.OBSERVATION_PERIOD
;

insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, stratum_2, stratum_3, count_value)
select 116 as analysis_id,  
	t1.obs_year as stratum_1, 
	p1.gender_concept_id as stratum_2,
	floor((t1.obs_year - p1.year_of_birth)/10) as stratum_3,
	COUNT(distinct p1.PERSON_ID) as count_value
from
	ohdsi_omop.PERSON p1
	inner join 
  ohdsi_omop.observation_period op1
	on p1.person_id = op1.person_id
	,
	temp_dates t1 
where EXTRACT(YEAR FROM op1.OBSERVATION_PERIOD_START_DATE) <= t1.obs_year
	and EXTRACT(YEAR FROM op1.OBSERVATION_PERIOD_END_DATE) >= t1.obs_year
group by t1.obs_year,
	p1.gender_concept_id,
	floor((t1.obs_year - p1.year_of_birth)/10)
;

TRUNCATE TABLE temp_dates;
DROP TABLE temp_dates;
--


--
-- 117	Number of persons with at least one day of observation in each year by gender and age decile
-- Note: using temp table instead of nested query because this gives vastly improved performance in Oracle

DROP TABLE IF EXISTS  temp_dates;

CREATE TEMP TABLE temp_dates

AS
SELECT
 distinct 
  EXTRACT(YEAR FROM observation_period_start_date)*100 + EXTRACT(MONTH FROM observation_period_start_date)  as obs_month

FROM
 
  ohdsi_omop.OBSERVATION_PERIOD
;

insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
select 117 as analysis_id,  
	t1.obs_month as stratum_1,
	COUNT(distinct op1.PERSON_ID) as count_value
from
	ohdsi_omop.observation_period op1,
	temp_dates t1 
where EXTRACT(YEAR FROM observation_period_start_date)*100 + EXTRACT(MONTH FROM observation_period_start_date) <= t1.obs_month
	and EXTRACT(YEAR FROM observation_period_end_date)*100 + EXTRACT(MONTH FROM observation_period_end_date) >= t1.obs_month
group by t1.obs_month
;

TRUNCATE TABLE temp_dates;
DROP TABLE temp_dates;
--


--
-- 118  Number of observation period records with invalid person_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, count_value)
select 118 as analysis_id,
  COUNT(op1.PERSON_ID) as count_value
from
  ohdsi_omop.observation_period op1
  left join ohdsi_omop.PERSON p1
  on p1.person_id = op1.person_id
where p1.person_id is null
;
--

--
-- 119  Number of observation period records by period_type_concept_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1,count_value)
select 119 as analysis_id,
  op1.period_type_concept_id as stratum_1,
  COUNT(*) as count_value
from
  ohdsi_omop.observation_period op1
group by op1.period_type_concept_id
;
--


/********************************************

ACHILLES Analyses on VISIT_OCCURRENCE table

*********************************************/


--
-- 200	Number of persons with at least one visit occurrence, by visit_concept_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
select 200 as analysis_id, 
	vo1.visit_concept_id as stratum_1,
	COUNT(distinct vo1.PERSON_ID) as count_value
from
	ohdsi_omop.visit_occurrence vo1
group by vo1.visit_concept_id
;
--


--
-- 201	Number of visit occurrence records, by visit_concept_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
select 201 as analysis_id, 
	vo1.visit_concept_id as stratum_1,
	COUNT(vo1.PERSON_ID) as count_value
from
	ohdsi_omop.visit_occurrence vo1
group by vo1.visit_concept_id
;
--



--
-- 202	Number of persons by visit occurrence start month, by visit_concept_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, stratum_2, count_value)
select 202 as analysis_id,   
	vo1.visit_concept_id as stratum_1,
	EXTRACT(YEAR FROM visit_start_date)*100 + EXTRACT(MONTH FROM visit_start_date) as stratum_2, 
	COUNT(distinct PERSON_ID) as count_value
from
ohdsi_omop.visit_occurrence vo1
group by vo1.visit_concept_id, 
	EXTRACT(YEAR FROM visit_start_date)*100 + EXTRACT(MONTH FROM visit_start_date)
;
--



--
-- 203	Number of distinct visit occurrence concepts per person

CREATE TEMP TABLE tempResults

AS
WITH  rawData(person_id, count_value)  AS 
(
    select vo1.person_id, COUNT(distinct vo1.visit_concept_id) as count_value
		from ohdsi_omop.visit_occurrence vo1
		group by vo1.person_id
),
overallStats (avg_value, stdev_value, min_value, max_value, total) as
(
  select avg(1.0 * count_value) as avg_value,
    STDDEV(count_value) as stdev_value,
    min(count_value) as min_value,
    max(count_value) as max_value,
    COUNT(*) as total
  from rawData
),
stats (count_value, total, rn) as
(
  select count_value, 
  	COUNT(*) as total, 
		row_number() over (order by count_value) as rn
  FROM rawData
  group by count_value
),
priorStats (count_value, total, accumulated) as
(
  select s.count_value, s.total, sum(p.total) as accumulated
  from stats s
  join stats p on p.rn <= s.rn
  group by s.count_value, s.total, s.rn
)
 SELECT
 203 as analysis_id,
  o.total as count_value,
  o.min_value,
	o.max_value,
	o.avg_value,
	o.stdev_value,
	MIN(case when p.accumulated >= .50 * o.total then count_value else o.max_value end) as median_value,
	MIN(case when p.accumulated >= .10 * o.total then count_value else o.max_value end) as p10_value,
	MIN(case when p.accumulated >= .25 * o.total then count_value else o.max_value end) as p25_value,
	MIN(case when p.accumulated >= .75 * o.total then count_value else o.max_value end) as p75_value,
	MIN(case when p.accumulated >= .90 * o.total then count_value else o.max_value end) as p90_value

FROM
 priorStats p
CROSS JOIN overallStats o
GROUP BY o.total, o.min_value, o.max_value, o.avg_value, o.stdev_value
;

insert into ohdsi_omop.ACHILLES_results_dist (analysis_id, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value)
select analysis_id, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value
FROM tempResults
;

truncate table tempResults;
drop table tempResults;

--



--
-- 204	Number of persons with at least one visit occurrence, by visit_concept_id by calendar year by gender by age decile
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, stratum_2, stratum_3, stratum_4, count_value)
select 204 as analysis_id,   
	vo1.visit_concept_id as stratum_1,
	EXTRACT(YEAR FROM visit_start_date) as stratum_2,
	p1.gender_concept_id as stratum_3,
	floor((EXTRACT(YEAR FROM visit_start_date) - p1.year_of_birth)/10) as stratum_4, 
	COUNT(distinct p1.PERSON_ID) as count_value
from ohdsi_omop.PERSON p1
inner join
ohdsi_omop.visit_occurrence vo1
on p1.person_id = vo1.person_id
group by vo1.visit_concept_id, 
	EXTRACT(YEAR FROM visit_start_date),
	p1.gender_concept_id,
	floor((EXTRACT(YEAR FROM visit_start_date) - p1.year_of_birth)/10)
;
--





--
-- 206	Distribution of age by visit_concept_id

CREATE TEMP TABLE tempResults

AS
WITH  rawData(stratum1_id, stratum2_id, count_value)  AS 
(
  select vo1.visit_concept_id,
  	p1.gender_concept_id,
		vo1.visit_start_year - p1.year_of_birth as count_value
	from ohdsi_omop.PERSON p1
	inner join 
  (
		select person_id, visit_concept_id, min(EXTRACT(YEAR FROM visit_start_date)) as visit_start_year
		from ohdsi_omop.visit_occurrence
		group by person_id, visit_concept_id
	) vo1 on p1.person_id = vo1.person_id
),
overallStats (stratum1_id, stratum2_id, avg_value, stdev_value, min_value, max_value, total) as
(
  select stratum1_id,
    stratum2_id,
    avg(1.0 * count_value) as avg_value,
    STDDEV(count_value) as stdev_value,
    min(count_value) as min_value,
    max(count_value) as max_value,
    COUNT(*) as total
  FROM rawData
	group by stratum1_id, stratum2_id
),
stats (stratum1_id, stratum2_id, count_value, total, rn) as
(
  select stratum1_id, stratum2_id, count_value, COUNT(*) as total, row_number() over (partition by stratum1_id, stratum2_id order by count_value) as rn
  FROM rawData
  group by stratum1_id, stratum2_id, count_value
),
priorStats (stratum1_id, stratum2_id, count_value, total, accumulated) as
(
  select s.stratum1_id, s.stratum2_id, s.count_value, s.total, sum(p.total) as accumulated
  from stats s
  join stats p on s.stratum1_id = p.stratum1_id and s.stratum2_id = p.stratum2_id and p.rn <= s.rn
  group by s.stratum1_id, s.stratum2_id, s.count_value, s.total, s.rn
)
 SELECT
 206 as analysis_id,
  o.stratum1_id,
  o.stratum2_id,
  o.total as count_value,
  o.min_value,
	o.max_value,
	o.avg_value,
	o.stdev_value,
	MIN(case when p.accumulated >= .50 * o.total then count_value else o.max_value end) as median_value,
	MIN(case when p.accumulated >= .10 * o.total then count_value else o.max_value end) as p10_value,
	MIN(case when p.accumulated >= .25 * o.total then count_value else o.max_value end) as p25_value,
	MIN(case when p.accumulated >= .75 * o.total then count_value else o.max_value end) as p75_value,
	MIN(case when p.accumulated >= .90 * o.total then count_value else o.max_value end) as p90_value

FROM
 priorStats p
join overallStats o on p.stratum1_id = o.stratum1_id and p.stratum2_id = o.stratum2_id 
GROUP BY o.stratum1_id, o.stratum2_id, o.total, o.min_value, o.max_value, o.avg_value, o.stdev_value
;

insert into ohdsi_omop.ACHILLES_results_dist (analysis_id, stratum_1, stratum_2, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value)
select analysis_id, stratum1_id, stratum2_id, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value
from tempResults
;

truncate table tempResults;
drop table tempResults;

--


--
--207	Number of visit records with invalid person_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, count_value)
select 207 as analysis_id,  
	COUNT(vo1.PERSON_ID) as count_value
from
	ohdsi_omop.visit_occurrence vo1
	left join ohdsi_omop.PERSON p1
	on p1.person_id = vo1.person_id
where p1.person_id is null
;
--


--
--208	Number of visit records outside valid observation period
insert into ohdsi_omop.ACHILLES_results (analysis_id, count_value)
select 208 as analysis_id,  
	COUNT(vo1.PERSON_ID) as count_value
from
	ohdsi_omop.visit_occurrence vo1
	left join ohdsi_omop.observation_period op1
	on op1.person_id = vo1.person_id
	and vo1.visit_start_date >= op1.observation_period_start_date
	and vo1.visit_start_date <= op1.observation_period_end_date
where op1.person_id is null
;
--

--
--209	Number of visit records with end date < start date
insert into ohdsi_omop.ACHILLES_results (analysis_id, count_value)
select 209 as analysis_id,  
	COUNT(vo1.PERSON_ID) as count_value
from
	ohdsi_omop.visit_occurrence vo1
where visit_end_date < visit_start_date
;
--

--
--210	Number of visit records with invalid care_site_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, count_value)
select 210 as analysis_id,  
	COUNT(vo1.PERSON_ID) as count_value
from
	ohdsi_omop.visit_occurrence vo1
	left join ohdsi_omop.care_site cs1
	on vo1.care_site_id = cs1.care_site_id
where vo1.care_site_id is not null
	and cs1.care_site_id is null
;
--


--
-- 211	Distribution of length of stay by visit_concept_id
CREATE TEMP TABLE tempResults

AS
WITH  rawData(stratum_id, count_value)  AS 
(
  select visit_concept_id, (CAST(visit_end_date AS DATE) - CAST(visit_start_date AS DATE)) as count_value
  from ohdsi_omop.visit_occurrence
),
overallStats (stratum_id, avg_value, stdev_value, min_value, max_value, total) as
(
  select stratum_id,
    avg(1.0 * count_value) as avg_value,
    STDDEV(count_value) as stdev_value,
    min(count_value) as min_value,
    max(count_value) as max_value,
    COUNT(*) as total
  FROM rawData
  group by stratum_id
),
stats (stratum_id, count_value, total, rn) as
(
  select stratum_id, count_value, COUNT(*) as total, row_number() over (order by count_value) as rn
  FROM rawData
  group by stratum_id, count_value
),
priorStats (stratum_id, count_value, total, accumulated) as
(
  select s.stratum_id, s.count_value, s.total, sum(p.total) as accumulated
  from stats s
  join stats p on s.stratum_id = p.stratum_id and p.rn <= s.rn
  group by s.stratum_id, s.count_value, s.total, s.rn
)
 SELECT
 211 as analysis_id,
  o.stratum_id,
  o.total as count_value,
  o.min_value,
	o.max_value,
	o.avg_value,
	o.stdev_value,
	MIN(case when p.accumulated >= .50 * o.total then count_value else o.max_value end) as median_value,
	MIN(case when p.accumulated >= .10 * o.total then count_value else o.max_value end) as p10_value,
	MIN(case when p.accumulated >= .25 * o.total then count_value else o.max_value end) as p25_value,
	MIN(case when p.accumulated >= .75 * o.total then count_value else o.max_value end) as p75_value,
	MIN(case when p.accumulated >= .90 * o.total then count_value else o.max_value end) as p90_value

FROM
 priorStats p
join overallStats o on p.stratum_id = o.stratum_id
GROUP BY o.stratum_id, o.total, o.min_value, o.max_value, o.avg_value, o.stdev_value
;

insert into ohdsi_omop.ACHILLES_results_dist (analysis_id, stratum_1, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value)
select analysis_id, stratum_id, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value
from tempResults
;

truncate table tempResults;
drop table tempResults;

--


--
-- 212	Number of persons with at least one visit occurrence by calendar year by gender by age decile
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, stratum_2, stratum_3, count_value)
select 212 as analysis_id,   
	EXTRACT(YEAR FROM visit_start_date) as stratum_1,
	p1.gender_concept_id as stratum_2,
	floor((EXTRACT(YEAR FROM visit_start_date) - p1.year_of_birth)/10) as stratum_3, 
	COUNT(distinct p1.PERSON_ID) as count_value
from ohdsi_omop.PERSON p1
inner join
ohdsi_omop.visit_occurrence vo1
on p1.person_id = vo1.person_id
group by 
	EXTRACT(YEAR FROM visit_start_date),
	p1.gender_concept_id,
	floor((EXTRACT(YEAR FROM visit_start_date) - p1.year_of_birth)/10)
;
--


--
-- 220	Number of visit occurrence records by condition occurrence start month
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
select 220 as analysis_id,   
	EXTRACT(YEAR FROM visit_start_date)*100 + EXTRACT(MONTH FROM visit_start_date) as stratum_1, 
	COUNT(PERSON_ID) as count_value
from
ohdsi_omop.visit_occurrence vo1
group by EXTRACT(YEAR FROM visit_start_date)*100 + EXTRACT(MONTH FROM visit_start_date)
;
--


--





/********************************************

ACHILLES Analyses on PROVIDER table

*********************************************/


--
-- 300	Number of providers
insert into ohdsi_omop.ACHILLES_results (analysis_id, count_value)
select 300 as analysis_id,  COUNT(distinct provider_id) as count_value
from ohdsi_omop.provider;
--


--
-- 301	Number of providers by specialty concept_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
select 301 as analysis_id,  specialty_concept_id as stratum_1, COUNT(distinct provider_id) as count_value
from ohdsi_omop.provider
group by specialty_CONCEPT_ID;
--

--
-- 302	Number of providers with invalid care site id
insert into ohdsi_omop.ACHILLES_results (analysis_id, count_value)
select 302 as analysis_id,  COUNT(provider_id) as count_value
from ohdsi_omop.provider p1
	left join ohdsi_omop.care_site cs1
	on p1.care_site_id = cs1.care_site_id
where p1.care_site_id is not null
	and cs1.care_site_id is null
;
--



/********************************************

ACHILLES Analyses on CONDITION_OCCURRENCE table

*********************************************/


--
-- 400	Number of persons with at least one condition occurrence, by condition_concept_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
select 400 as analysis_id, 
	co1.condition_CONCEPT_ID as stratum_1,
	COUNT(distinct co1.PERSON_ID) as count_value
from
	ohdsi_omop.condition_occurrence co1
group by co1.condition_CONCEPT_ID
;
--


--
-- 401	Number of condition occurrence records, by condition_concept_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
select 401 as analysis_id, 
	co1.condition_CONCEPT_ID as stratum_1,
	COUNT(co1.PERSON_ID) as count_value
from
	ohdsi_omop.condition_occurrence co1
group by co1.condition_CONCEPT_ID
;
--



--
-- 402	Number of persons by condition occurrence start month, by condition_concept_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, stratum_2, count_value)
select 402 as analysis_id,   
	co1.condition_concept_id as stratum_1,
	EXTRACT(YEAR FROM condition_start_date)*100 + EXTRACT(MONTH FROM condition_start_date) as stratum_2, 
	COUNT(distinct PERSON_ID) as count_value
from
ohdsi_omop.condition_occurrence co1
group by co1.condition_concept_id, 
	EXTRACT(YEAR FROM condition_start_date)*100 + EXTRACT(MONTH FROM condition_start_date)
;
--



--
-- 403	Number of distinct condition occurrence concepts per person
CREATE TEMP TABLE tempResults

AS
WITH  rawData(person_id, count_value)  AS 
(
  select person_id, COUNT(distinct condition_concept_id) as num_conditions
  from ohdsi_omop.condition_occurrence
	group by person_id
),
overallStats (avg_value, stdev_value, min_value, max_value, total) as
(
  select avg(1.0 * count_value) as avg_value,
    STDDEV(count_value) as stdev_value,
    min(count_value) as min_value,
    max(count_value) as max_value,
    COUNT(*) as total
  from rawData
),
stats (count_value, total, rn) as
(
  select count_value, 
  	COUNT(*) as total, 
		row_number() over (order by count_value) as rn
  FROM rawData
  group by count_value
),
priorStats (count_value, total, accumulated) as
(
  select s.count_value, s.total, sum(p.total) as accumulated
  from stats s
  join stats p on p.rn <= s.rn
  group by s.count_value, s.total, s.rn
)
 SELECT
 403 as analysis_id,
  o.total as count_value,
  o.min_value,
	o.max_value,
	o.avg_value,
	o.stdev_value,
	MIN(case when p.accumulated >= .50 * o.total then count_value else o.max_value end) as median_value,
	MIN(case when p.accumulated >= .10 * o.total then count_value else o.max_value end) as p10_value,
	MIN(case when p.accumulated >= .25 * o.total then count_value else o.max_value end) as p25_value,
	MIN(case when p.accumulated >= .75 * o.total then count_value else o.max_value end) as p75_value,
	MIN(case when p.accumulated >= .90 * o.total then count_value else o.max_value end) as p90_value

FROM
 priorStats p
CROSS JOIN overallStats o
GROUP BY o.total, o.min_value, o.max_value, o.avg_value, o.stdev_value
;

insert into ohdsi_omop.ACHILLES_results_dist (analysis_id, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value)
select analysis_id, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value
from tempResults
;

truncate table tempResults;
drop table tempResults;

--



--
-- 404	Number of persons with at least one condition occurrence, by condition_concept_id by calendar year by gender by age decile
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, stratum_2, stratum_3, stratum_4, count_value)
select 404 as analysis_id,   
	co1.condition_concept_id as stratum_1,
	EXTRACT(YEAR FROM condition_start_date) as stratum_2,
	p1.gender_concept_id as stratum_3,
	floor((EXTRACT(YEAR FROM condition_start_date) - p1.year_of_birth)/10) as stratum_4, 
	COUNT(distinct p1.PERSON_ID) as count_value
from ohdsi_omop.PERSON p1
inner join
ohdsi_omop.condition_occurrence co1
on p1.person_id = co1.person_id
group by co1.condition_concept_id, 
	EXTRACT(YEAR FROM condition_start_date),
	p1.gender_concept_id,
	floor((EXTRACT(YEAR FROM condition_start_date) - p1.year_of_birth)/10)
;
--

--
-- 405	Number of condition occurrence records, by condition_concept_id by condition_type_concept_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, stratum_2, count_value)
select 405 as analysis_id, 
	co1.condition_CONCEPT_ID as stratum_1,
	co1.condition_type_concept_id as stratum_2,
	COUNT(co1.PERSON_ID) as count_value
from
	ohdsi_omop.condition_occurrence co1
group by co1.condition_CONCEPT_ID,	
	co1.condition_type_concept_id
;
--



--
-- 406	Distribution of age by condition_concept_id
CREATE TEMP TABLE rawData_406

AS
SELECT
 co1.condition_concept_id as subject_id,
  p1.gender_concept_id,
	(co1.condition_start_year - p1.year_of_birth) as count_value

FROM
 ohdsi_omop.PERSON p1
inner join 
(
	select person_id, condition_concept_id, min(EXTRACT(YEAR FROM condition_start_date)) as condition_start_year
	from ohdsi_omop.condition_occurrence
	group by person_id, condition_concept_id
) co1 on p1.person_id = co1.person_id
;

CREATE TEMP TABLE tempResults

AS
WITH  overallStats (stratum1_id, stratum2_id, avg_value, stdev_value, min_value, max_value, total)  AS 
(
  select subject_id as stratum1_id,
    gender_concept_id as stratum2_id,
    avg(1.0 * count_value) as avg_value,
    STDDEV(count_value) as stdev_value,
    min(count_value) as min_value,
    max(count_value) as max_value,
    COUNT(*) as total
  FROM rawData_406
	group by subject_id, gender_concept_id
),
stats (stratum1_id, stratum2_id, count_value, total, rn) as
(
  select subject_id as stratum1_id, gender_concept_id as stratum2_id, count_value, COUNT(*) as total, row_number() over (partition by subject_id, gender_concept_id order by count_value) as rn
  FROM rawData_406
  group by subject_id, gender_concept_id, count_value
),
priorStats (stratum1_id, stratum2_id, count_value, total, accumulated) as
(
  select s.stratum1_id, s.stratum2_id, s.count_value, s.total, sum(p.total) as accumulated
  from stats s
  join stats p on s.stratum1_id = p.stratum1_id and s.stratum2_id = p.stratum2_id and p.rn <= s.rn
  group by s.stratum1_id, s.stratum2_id, s.count_value, s.total, s.rn
)
 SELECT
 406 as analysis_id,
  o.stratum1_id,
  o.stratum2_id,
  o.total as count_value,
  o.min_value,
	o.max_value,
	o.avg_value,
	o.stdev_value,
	MIN(case when p.accumulated >= .50 * o.total then count_value else o.max_value end) as median_value,
	MIN(case when p.accumulated >= .10 * o.total then count_value else o.max_value end) as p10_value,
	MIN(case when p.accumulated >= .25 * o.total then count_value else o.max_value end) as p25_value,
	MIN(case when p.accumulated >= .75 * o.total then count_value else o.max_value end) as p75_value,
	MIN(case when p.accumulated >= .90 * o.total then count_value else o.max_value end) as p90_value

FROM
 priorStats p
join overallStats o on p.stratum1_id = o.stratum1_id and p.stratum2_id = o.stratum2_id 
GROUP BY o.stratum1_id, o.stratum2_id, o.total, o.min_value, o.max_value, o.avg_value, o.stdev_value
;

insert into ohdsi_omop.ACHILLES_results_dist (analysis_id, stratum_1, stratum_2, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value)
select analysis_id, stratum1_id, stratum2_id, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value
from tempResults
;

truncate table tempResults;
drop table tempResults;

truncate Table rawData_406;
drop table rawData_406;

--


--
-- 409	Number of condition occurrence records with invalid person_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, count_value)
select 409 as analysis_id,  
	COUNT(co1.PERSON_ID) as count_value
from
	ohdsi_omop.condition_occurrence co1
	left join ohdsi_omop.PERSON p1
	on p1.person_id = co1.person_id
where p1.person_id is null
;
--


--
-- 410	Number of condition occurrence records outside valid observation period
insert into ohdsi_omop.ACHILLES_results (analysis_id, count_value)
select 410 as analysis_id,  
	COUNT(co1.PERSON_ID) as count_value
from
	ohdsi_omop.condition_occurrence co1
	left join ohdsi_omop.observation_period op1
	on op1.person_id = co1.person_id
	and co1.condition_start_date >= op1.observation_period_start_date
	and co1.condition_start_date <= op1.observation_period_end_date
where op1.person_id is null
;
--


--
-- 411	Number of condition occurrence records with end date < start date
insert into ohdsi_omop.ACHILLES_results (analysis_id, count_value)
select 411 as analysis_id,  
	COUNT(co1.PERSON_ID) as count_value
from
	ohdsi_omop.condition_occurrence co1
where co1.condition_end_date < co1.condition_start_date
;
--


--
-- 412	Number of condition occurrence records with invalid provider_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, count_value)
select 412 as analysis_id,  
	COUNT(co1.PERSON_ID) as count_value
from
	ohdsi_omop.condition_occurrence co1
	left join ohdsi_omop.provider p1
	on p1.provider_id = co1.provider_id
where co1.provider_id is not null
	and p1.provider_id is null
;
--

--
-- 413	Number of condition occurrence records with invalid visit_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, count_value)
select 413 as analysis_id,  
	COUNT(co1.PERSON_ID) as count_value
from
	ohdsi_omop.condition_occurrence co1
	left join ohdsi_omop.visit_occurrence vo1
	on co1.visit_occurrence_id = vo1.visit_occurrence_id
where co1.visit_occurrence_id is not null
	and vo1.visit_occurrence_id is null
;
--

--
-- 420	Number of condition occurrence records by condition occurrence start month
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
select 420 as analysis_id,   
	EXTRACT(YEAR FROM condition_start_date)*100 + EXTRACT(MONTH FROM condition_start_date) as stratum_1, 
	COUNT(PERSON_ID) as count_value
from
ohdsi_omop.condition_occurrence co1
group by EXTRACT(YEAR FROM condition_start_date)*100 + EXTRACT(MONTH FROM condition_start_date)
;
--



/********************************************

ACHILLES Analyses on DEATH table

*********************************************/



--
-- 500	Number of persons with death, by cause_concept_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
select 500 as analysis_id, 
	d1.cause_concept_id as stratum_1,
	COUNT(distinct d1.PERSON_ID) as count_value
from
	ohdsi_omop.death d1
group by d1.cause_concept_id
;
--


--
-- 501	Number of records of death, by cause_concept_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
select 501 as analysis_id, 
	d1.cause_concept_id as stratum_1,
	COUNT(d1.PERSON_ID) as count_value
from
	ohdsi_omop.death d1
group by d1.cause_concept_id
;
--



--
-- 502	Number of persons by condition occurrence start month
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
select 502 as analysis_id,   
	EXTRACT(YEAR FROM death_date)*100 + EXTRACT(MONTH FROM death_date) as stratum_1, 
	COUNT(distinct PERSON_ID) as count_value
from
ohdsi_omop.death d1
group by EXTRACT(YEAR FROM death_date)*100 + EXTRACT(MONTH FROM death_date)
;
--



--
-- 504	Number of persons with a death, by calendar year by gender by age decile
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, stratum_2, stratum_3, count_value)
select 504 as analysis_id,   
	EXTRACT(YEAR FROM death_date) as stratum_1,
	p1.gender_concept_id as stratum_2,
	floor((EXTRACT(YEAR FROM death_date) - p1.year_of_birth)/10) as stratum_3, 
	COUNT(distinct p1.PERSON_ID) as count_value
from ohdsi_omop.PERSON p1
inner join
ohdsi_omop.death d1
on p1.person_id = d1.person_id
group by EXTRACT(YEAR FROM death_date),
	p1.gender_concept_id,
	floor((EXTRACT(YEAR FROM death_date) - p1.year_of_birth)/10)
;
--

--
-- 505	Number of death records, by death_type_concept_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
select 505 as analysis_id, 
	death_type_concept_id as stratum_1,
	COUNT(PERSON_ID) as count_value
from
	ohdsi_omop.death d1
group by death_type_concept_id
;
--



--
-- 506	Distribution of age by condition_concept_id

CREATE TEMP TABLE tempResults

AS
WITH  rawData(stratum_id, count_value)  AS 
(
  select p1.gender_concept_id,
    d1.death_year - p1.year_of_birth as count_value
  from ohdsi_omop.PERSON p1
  inner join
  (select person_id, min(EXTRACT(YEAR FROM death_date)) as death_year
  from ohdsi_omop.death
  group by person_id
  ) d1
  on p1.person_id = d1.person_id
),
overallStats (stratum_id, avg_value, stdev_value, min_value, max_value, total) as
(
  select stratum_id,
    avg(1.0 * count_value) as avg_value,
    STDDEV(count_value) as stdev_value,
    min(count_value) as min_value,
    max(count_value) as max_value,
    COUNT(*) as total
  FROM rawData
  group by stratum_id
),
stats (stratum_id, count_value, total, rn) as
(
  select stratum_id, count_value, COUNT(*) as total, row_number() over (order by count_value) as rn
  FROM rawData
  group by stratum_id, count_value
),
priorStats (stratum_id, count_value, total, accumulated) as
(
  select s.stratum_id, s.count_value, s.total, sum(p.total) as accumulated
  from stats s
  join stats p on s.stratum_id = p.stratum_id and p.rn <= s.rn
  group by s.stratum_id, s.count_value, s.total, s.rn
)
 SELECT
 506 as analysis_id,
  o.stratum_id,
  o.total as count_value,
  o.min_value,
	o.max_value,
	o.avg_value,
	o.stdev_value,
	MIN(case when p.accumulated >= .50 * o.total then count_value else o.max_value end) as median_value,
	MIN(case when p.accumulated >= .10 * o.total then count_value else o.max_value end) as p10_value,
	MIN(case when p.accumulated >= .25 * o.total then count_value else o.max_value end) as p25_value,
	MIN(case when p.accumulated >= .75 * o.total then count_value else o.max_value end) as p75_value,
	MIN(case when p.accumulated >= .90 * o.total then count_value else o.max_value end) as p90_value

FROM
 priorStats p
join overallStats o on p.stratum_id = o.stratum_id
GROUP BY o.stratum_id, o.total, o.min_value, o.max_value, o.avg_value, o.stdev_value
;

insert into ohdsi_omop.ACHILLES_results_dist (analysis_id, stratum_1, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value)
select analysis_id, stratum_id, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value
from tempResults
;

truncate table tempResults;

drop table tempResults;
--



--
-- 509	Number of death records with invalid person_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, count_value)
select 509 as analysis_id, 
	COUNT(d1.PERSON_ID) as count_value
from
	ohdsi_omop.death d1
		left join ohdsi_omop.person p1
		on d1.person_id = p1.person_id
where p1.person_id is null
;
--



--
-- 510	Number of death records outside valid observation period
insert into ohdsi_omop.ACHILLES_results (analysis_id, count_value)
select 510 as analysis_id, 
	COUNT(d1.PERSON_ID) as count_value
from
	ohdsi_omop.death d1
		left join ohdsi_omop.observation_period op1
		on d1.person_id = op1.person_id
		and d1.death_date >= op1.observation_period_start_date
		and d1.death_date <= op1.observation_period_end_date
where op1.person_id is null
;
--


--
-- 511	Distribution of time from death to last condition
insert into ohdsi_omop.ACHILLES_results_dist (analysis_id, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value)
select 511 as analysis_id,
  COUNT(count_value) as count_value,
	min(count_value) as min_value,
	max(count_value) as max_value,
	avg(1.0*count_value) as avg_value,
	STDDEV(count_value) as stdev_value,
	max(case when p1<=0.50 then count_value else -9999 end) as median_value,
	max(case when p1<=0.10 then count_value else -9999 end) as p10_value,
	max(case when p1<=0.25 then count_value else -9999 end) as p25_value,
	max(case when p1<=0.75 then count_value else -9999 end) as p75_value,
	max(case when p1<=0.90 then count_value else -9999 end) as p90_value
from
(
select (CAST( t0.max_date AS DATE) - CAST(d1.death_date AS DATE)) as count_value,
	1.0*(row_number() over (order by (CAST( t0.max_date AS DATE) - CAST(d1.death_date AS DATE))))/(COUNT(*) over () + 1) as p1
from ohdsi_omop.death d1
	inner join
	(
		select person_id, max(condition_start_date) as max_date
		from ohdsi_omop.condition_occurrence
		group by person_id
	) t0 on d1.person_id = t0.person_id
) t1
;
--


--
-- 512	Distribution of time from death to last drug
CREATE TEMP TABLE tempResults

AS
WITH  rawData(count_value)  AS 
(
  select (CAST( t0.max_date AS DATE) - CAST(d1.death_date AS DATE)) as count_value
  from ohdsi_omop.death d1
  inner join
	(
		select person_id, max(drug_exposure_start_date) as max_date
		from ohdsi_omop.drug_exposure
		group by person_id
	) t0
	on d1.person_id = t0.person_id
),
overallStats (avg_value, stdev_value, min_value, max_value, total) as
(
  select avg(1.0 * count_value) as avg_value,
    STDDEV(count_value) as stdev_value,
    min(count_value) as min_value,
    max(count_value) as max_value,
    COUNT(*) as total
  from rawData
),
stats (count_value, total, rn) as
(
  select count_value, 
  	COUNT(*) as total, 
		row_number() over (order by count_value) as rn
  FROM rawData
  group by count_value
),
priorStats (count_value, total, accumulated) as
(
  select s.count_value, s.total, sum(p.total) as accumulated
  from stats s
  join stats p on p.rn <= s.rn
  group by s.count_value, s.total, s.rn
)
 SELECT
 512 as analysis_id,
  o.total as count_value,
  o.min_value,
	o.max_value,
	o.avg_value,
	o.stdev_value,
	MIN(case when p.accumulated >= .50 * o.total then count_value else o.max_value end) as median_value,
	MIN(case when p.accumulated >= .10 * o.total then count_value else o.max_value end) as p10_value,
	MIN(case when p.accumulated >= .25 * o.total then count_value else o.max_value end) as p25_value,
	MIN(case when p.accumulated >= .75 * o.total then count_value else o.max_value end) as p75_value,
	MIN(case when p.accumulated >= .90 * o.total then count_value else o.max_value end) as p90_value

FROM
 priorStats p
CROSS JOIN overallStats o
GROUP BY o.total, o.min_value, o.max_value, o.avg_value, o.stdev_value
;

insert into ohdsi_omop.ACHILLES_results_dist (analysis_id, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value)
select analysis_id, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value
FROM tempResults
;

truncate table tempResults;

drop table tempResults;


--


--
-- 513	Distribution of time from death to last visit
CREATE TEMP TABLE tempResults

AS
WITH  rawData(count_value)  AS 
(
  select (CAST( t0.max_date AS DATE) - CAST(d1.death_date AS DATE)) as count_value
  from ohdsi_omop.death d1
	inner join
	(
		select person_id, max(visit_start_date) as max_date
		from ohdsi_omop.visit_occurrence
		group by person_id
	) t0
	on d1.person_id = t0.person_id
),
overallStats (avg_value, stdev_value, min_value, max_value, total) as
(
  select avg(1.0 * count_value) as avg_value,
    STDDEV(count_value) as stdev_value,
    min(count_value) as min_value,
    max(count_value) as max_value,
    COUNT(*) as total
  from rawData
),
stats (count_value, total, rn) as
(
  select count_value, 
  	COUNT(*) as total, 
		row_number() over (order by count_value) as rn
  FROM rawData
  group by count_value
),
priorStats (count_value, total, accumulated) as
(
  select s.count_value, s.total, sum(p.total) as accumulated
  from stats s
  join stats p on p.rn <= s.rn
  group by s.count_value, s.total, s.rn
)
 SELECT
 513 as analysis_id,
  o.total as count_value,
  o.min_value,
	o.max_value,
	o.avg_value,
	o.stdev_value,
	MIN(case when p.accumulated >= .50 * o.total then count_value else o.max_value end) as median_value,
	MIN(case when p.accumulated >= .10 * o.total then count_value else o.max_value end) as p10_value,
	MIN(case when p.accumulated >= .25 * o.total then count_value else o.max_value end) as p25_value,
	MIN(case when p.accumulated >= .75 * o.total then count_value else o.max_value end) as p75_value,
	MIN(case when p.accumulated >= .90 * o.total then count_value else o.max_value end) as p90_value

FROM
 priorStats p
CROSS JOIN overallStats o
GROUP BY o.total, o.min_value, o.max_value, o.avg_value, o.stdev_value
;

insert into ohdsi_omop.ACHILLES_results_dist (analysis_id, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value)
select analysis_id, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value
from tempResults
;

truncate table tempResults;

drop table tempResults;

--


--
-- 514	Distribution of time from death to last procedure
CREATE TEMP TABLE tempResults

AS
WITH  rawData(count_value)  AS 
(
  select (CAST( t0.max_date AS DATE) - CAST(d1.death_date AS DATE)) as count_value
  from ohdsi_omop.death d1
	inner join
	(
		select person_id, max(procedure_date) as max_date
		from ohdsi_omop.procedure_occurrence
		group by person_id
	) t0
	on d1.person_id = t0.person_id
),
overallStats (avg_value, stdev_value, min_value, max_value, total) as
(
  select avg(1.0 * count_value) as avg_value,
    STDDEV(count_value) as stdev_value,
    min(count_value) as min_value,
    max(count_value) as max_value,
    COUNT(*) as total
  from rawData
),
stats (count_value, total, rn) as
(
  select count_value, 
  	COUNT(*) as total, 
		row_number() over (order by count_value) as rn
  FROM rawData
  group by count_value
),
priorStats (count_value, total, accumulated) as
(
  select s.count_value, s.total, sum(p.total) as accumulated
  from stats s
  join stats p on p.rn <= s.rn
  group by s.count_value, s.total, s.rn
)
 SELECT
 514 as analysis_id,
  o.total as count_value,
  o.min_value,
	o.max_value,
	o.avg_value,
	o.stdev_value,
	MIN(case when p.accumulated >= .50 * o.total then count_value else o.max_value end) as median_value,
	MIN(case when p.accumulated >= .10 * o.total then count_value else o.max_value end) as p10_value,
	MIN(case when p.accumulated >= .25 * o.total then count_value else o.max_value end) as p25_value,
	MIN(case when p.accumulated >= .75 * o.total then count_value else o.max_value end) as p75_value,
	MIN(case when p.accumulated >= .90 * o.total then count_value else o.max_value end) as p90_value

FROM
 priorStats p
CROSS JOIN overallStats o
GROUP BY o.total, o.min_value, o.max_value, o.avg_value, o.stdev_value
;

insert into ohdsi_omop.ACHILLES_results_dist (analysis_id, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value)
select analysis_id, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value
from tempResults
;

truncate table tempResults;

drop table tempResults;

--


--
-- 515	Distribution of time from death to last observation
CREATE TEMP TABLE tempResults

AS
WITH  rawData(count_value)  AS 
(
  select (CAST( t0.max_date AS DATE) - CAST(d1.death_date AS DATE)) as count_value
  from ohdsi_omop.death d1
	inner join
	(
		select person_id, max(observation_date) as max_date
		from ohdsi_omop.observation
		group by person_id
	) t0
	on d1.person_id = t0.person_id
),
overallStats (avg_value, stdev_value, min_value, max_value, total) as
(
  select avg(1.0 * count_value) as avg_value,
    STDDEV(count_value) as stdev_value,
    min(count_value) as min_value,
    max(count_value) as max_value,
    COUNT(*) as total
  from rawData
),
stats (count_value, total, rn) as
(
  select count_value, 
  	COUNT(*) as total, 
		row_number() over (order by count_value) as rn
  FROM rawData
  group by count_value
),
priorStats (count_value, total, accumulated) as
(
  select s.count_value, s.total, sum(p.total) as accumulated
  from stats s
  join stats p on p.rn <= s.rn
  group by s.count_value, s.total, s.rn
)
 SELECT
 515 as analysis_id,
  o.total as count_value,
  o.min_value,
	o.max_value,
	o.avg_value,
	o.stdev_value,
	MIN(case when p.accumulated >= .50 * o.total then count_value else o.max_value end) as median_value,
	MIN(case when p.accumulated >= .10 * o.total then count_value else o.max_value end) as p10_value,
	MIN(case when p.accumulated >= .25 * o.total then count_value else o.max_value end) as p25_value,
	MIN(case when p.accumulated >= .75 * o.total then count_value else o.max_value end) as p75_value,
	MIN(case when p.accumulated >= .90 * o.total then count_value else o.max_value end) as p90_value

FROM
 priorStats p
CROSS JOIN overallStats o
GROUP BY o.total, o.min_value, o.max_value, o.avg_value, o.stdev_value
;

insert into ohdsi_omop.ACHILLES_results_dist (analysis_id, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value)
select analysis_id, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value
from tempResults
;

truncate table tempResults;
drop table tempResults;


--



/********************************************

ACHILLES Analyses on PROCEDURE_OCCURRENCE table

*********************************************/



--
-- 600	Number of persons with at least one procedure occurrence, by procedure_concept_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
select 600 as analysis_id, 
	po1.procedure_CONCEPT_ID as stratum_1,
	COUNT(distinct po1.PERSON_ID) as count_value
from
	ohdsi_omop.procedure_occurrence po1
group by po1.procedure_CONCEPT_ID
;
--


--
-- 601	Number of procedure occurrence records, by procedure_concept_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
select 601 as analysis_id, 
	po1.procedure_CONCEPT_ID as stratum_1,
	COUNT(po1.PERSON_ID) as count_value
from
	ohdsi_omop.procedure_occurrence po1
group by po1.procedure_CONCEPT_ID
;
--



--
-- 602	Number of persons by procedure occurrence start month, by procedure_concept_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, stratum_2, count_value)
select 602 as analysis_id,   
	po1.procedure_concept_id as stratum_1,
	EXTRACT(YEAR FROM procedure_date)*100 + EXTRACT(MONTH FROM procedure_date) as stratum_2, 
	COUNT(distinct PERSON_ID) as count_value
from
ohdsi_omop.procedure_occurrence po1
group by po1.procedure_concept_id, 
	EXTRACT(YEAR FROM procedure_date)*100 + EXTRACT(MONTH FROM procedure_date)
;
--



--
-- 603	Number of distinct procedure occurrence concepts per person
CREATE TEMP TABLE tempResults

AS
WITH  rawData(count_value)  AS 
(
  select COUNT(distinct po.procedure_concept_id) as num_procedures
	from ohdsi_omop.procedure_occurrence po
	group by po.person_id
),
overallStats (avg_value, stdev_value, min_value, max_value, total) as
(
  select avg(1.0 * count_value) as avg_value,
    STDDEV(count_value) as stdev_value,
    min(count_value) as min_value,
    max(count_value) as max_value,
    COUNT(*) as total
  from rawData
),
stats (count_value, total, rn) as
(
  select count_value, 
  	COUNT(*) as total, 
		row_number() over (order by count_value) as rn
  FROM rawData
  group by count_value
),
priorStats (count_value, total, accumulated) as
(
  select s.count_value, s.total, sum(p.total) as accumulated
  from stats s
  join stats p on p.rn <= s.rn
  group by s.count_value, s.total, s.rn
)
 SELECT
 603 as analysis_id,
  o.total as count_value,
  o.min_value,
	o.max_value,
	o.avg_value,
	o.stdev_value,
	MIN(case when p.accumulated >= .50 * o.total then count_value else o.max_value end) as median_value,
	MIN(case when p.accumulated >= .10 * o.total then count_value else o.max_value end) as p10_value,
	MIN(case when p.accumulated >= .25 * o.total then count_value else o.max_value end) as p25_value,
	MIN(case when p.accumulated >= .75 * o.total then count_value else o.max_value end) as p75_value,
	MIN(case when p.accumulated >= .90 * o.total then count_value else o.max_value end) as p90_value

FROM
 priorStats p
CROSS JOIN overallStats o
GROUP BY o.total, o.min_value, o.max_value, o.avg_value, o.stdev_value
;

insert into ohdsi_omop.ACHILLES_results_dist (analysis_id, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value)
select analysis_id, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value
from tempResults
;

truncate table tempResults;
drop table tempResults;


--



--
-- 604	Number of persons with at least one procedure occurrence, by procedure_concept_id by calendar year by gender by age decile
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, stratum_2, stratum_3, stratum_4, count_value)
select 604 as analysis_id,   
	po1.procedure_concept_id as stratum_1,
	EXTRACT(YEAR FROM procedure_date) as stratum_2,
	p1.gender_concept_id as stratum_3,
	floor((EXTRACT(YEAR FROM procedure_date) - p1.year_of_birth)/10) as stratum_4, 
	COUNT(distinct p1.PERSON_ID) as count_value
from ohdsi_omop.PERSON p1
inner join
ohdsi_omop.procedure_occurrence po1
on p1.person_id = po1.person_id
group by po1.procedure_concept_id, 
	EXTRACT(YEAR FROM procedure_date),
	p1.gender_concept_id,
	floor((EXTRACT(YEAR FROM procedure_date) - p1.year_of_birth)/10)
;
--

--
-- 605	Number of procedure occurrence records, by procedure_concept_id by procedure_type_concept_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, stratum_2, count_value)
select 605 as analysis_id, 
	po1.procedure_CONCEPT_ID as stratum_1,
	po1.procedure_type_concept_id as stratum_2,
	COUNT(po1.PERSON_ID) as count_value
from
	ohdsi_omop.procedure_occurrence po1
group by po1.procedure_CONCEPT_ID,	
	po1.procedure_type_concept_id
;
--



--
-- 606	Distribution of age by procedure_concept_id
CREATE TEMP TABLE rawData_606

AS
SELECT
 po1.procedure_concept_id as subject_id,
  p1.gender_concept_id,
	po1.procedure_start_year - p1.year_of_birth as count_value

FROM
 ohdsi_omop.PERSON p1
inner join
(
	select person_id, procedure_concept_id, min(EXTRACT(YEAR FROM procedure_date)) as procedure_start_year
	from ohdsi_omop.procedure_occurrence
	group by person_id, procedure_concept_id
) po1 on p1.person_id = po1.person_id
;

CREATE TEMP TABLE tempResults

AS
WITH  overallStats (stratum1_id, stratum2_id, avg_value, stdev_value, min_value, max_value, total)  AS 
(
  select subject_id as stratum1_id,
    gender_concept_id as stratum2_id,
    avg(1.0 * count_value) as avg_value,
    STDDEV(count_value) as stdev_value,
    min(count_value) as min_value,
    max(count_value) as max_value,
    COUNT(*) as total
  FROM rawData_606
	group by subject_id, gender_concept_id
),
stats (stratum1_id, stratum2_id, count_value, total, rn) as
(
  select subject_id as stratum1_id, gender_concept_id as stratum2_id, count_value, COUNT(*) as total, row_number() over (partition by subject_id, gender_concept_id order by count_value) as rn
  FROM rawData_606
  group by subject_id, gender_concept_id, count_value
),
priorStats (stratum1_id, stratum2_id, count_value, total, accumulated) as
(
  select s.stratum1_id, s.stratum2_id, s.count_value, s.total, sum(p.total) as accumulated
  from stats s
  join stats p on s.stratum1_id = p.stratum1_id and s.stratum2_id = p.stratum2_id and p.rn <= s.rn
  group by s.stratum1_id, s.stratum2_id, s.count_value, s.total, s.rn
)
 SELECT
 606 as analysis_id,
  o.stratum1_id,
  o.stratum2_id,
  o.total as count_value,
  o.min_value,
	o.max_value,
	o.avg_value,
	o.stdev_value,
	MIN(case when p.accumulated >= .50 * o.total then count_value else o.max_value end) as median_value,
	MIN(case when p.accumulated >= .10 * o.total then count_value else o.max_value end) as p10_value,
	MIN(case when p.accumulated >= .25 * o.total then count_value else o.max_value end) as p25_value,
	MIN(case when p.accumulated >= .75 * o.total then count_value else o.max_value end) as p75_value,
	MIN(case when p.accumulated >= .90 * o.total then count_value else o.max_value end) as p90_value

FROM
 priorStats p
join overallStats o on p.stratum1_id = o.stratum1_id and p.stratum2_id = o.stratum2_id 
GROUP BY o.stratum1_id, o.stratum2_id, o.total, o.min_value, o.max_value, o.avg_value, o.stdev_value
;

insert into ohdsi_omop.ACHILLES_results_dist (analysis_id, stratum_1, stratum_2, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value)
select analysis_id, stratum1_id, stratum2_id, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value
from tempResults
;

truncate table tempResults;
drop table tempResults;
truncate table rawData_606;
drop table rawData_606;

--

--
-- 609	Number of procedure occurrence records with invalid person_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, count_value)
select 609 as analysis_id,  
	COUNT(po1.PERSON_ID) as count_value
from
	ohdsi_omop.procedure_occurrence po1
	left join ohdsi_omop.PERSON p1
	on p1.person_id = po1.person_id
where p1.person_id is null
;
--


--
-- 610	Number of procedure occurrence records outside valid observation period
insert into ohdsi_omop.ACHILLES_results (analysis_id, count_value)
select 610 as analysis_id,  
	COUNT(po1.PERSON_ID) as count_value
from
	ohdsi_omop.procedure_occurrence po1
	left join ohdsi_omop.observation_period op1
	on op1.person_id = po1.person_id
	and po1.procedure_date >= op1.observation_period_start_date
	and po1.procedure_date <= op1.observation_period_end_date
where op1.person_id is null
;
--



--
-- 612	Number of procedure occurrence records with invalid provider_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, count_value)
select 612 as analysis_id,  
	COUNT(po1.PERSON_ID) as count_value
from
	ohdsi_omop.procedure_occurrence po1
	left join ohdsi_omop.provider p1
	on p1.provider_id = po1.provider_id
where po1.provider_id is not null
	and p1.provider_id is null
;
--

--
-- 613	Number of procedure occurrence records with invalid visit_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, count_value)
select 613 as analysis_id,  
	COUNT(po1.PERSON_ID) as count_value
from
	ohdsi_omop.procedure_occurrence po1
	left join ohdsi_omop.visit_occurrence vo1
	on po1.visit_occurrence_id = vo1.visit_occurrence_id
where po1.visit_occurrence_id is not null
	and vo1.visit_occurrence_id is null
;
--


--
-- 620	Number of procedure occurrence records by condition occurrence start month
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
select 620 as analysis_id,   
	EXTRACT(YEAR FROM procedure_date)*100 + EXTRACT(MONTH FROM procedure_date) as stratum_1, 
	COUNT(PERSON_ID) as count_value
from
ohdsi_omop.procedure_occurrence po1
group by EXTRACT(YEAR FROM procedure_date)*100 + EXTRACT(MONTH FROM procedure_date)
;
--


/********************************************

ACHILLES Analyses on DRUG_EXPOSURE table

*********************************************/




--
-- 700	Number of persons with at least one drug occurrence, by drug_concept_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
select 700 as analysis_id, 
	de1.drug_CONCEPT_ID as stratum_1,
	COUNT(distinct de1.PERSON_ID) as count_value
from
	ohdsi_omop.drug_exposure de1
group by de1.drug_CONCEPT_ID
;
--


--
-- 701	Number of drug occurrence records, by drug_concept_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
select 701 as analysis_id, 
	de1.drug_CONCEPT_ID as stratum_1,
	COUNT(de1.PERSON_ID) as count_value
from
	ohdsi_omop.drug_exposure de1
group by de1.drug_CONCEPT_ID
;
--



--
-- 702	Number of persons by drug occurrence start month, by drug_concept_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, stratum_2, count_value)
select 702 as analysis_id,   
	de1.drug_concept_id as stratum_1,
	EXTRACT(YEAR FROM drug_exposure_start_date)*100 + EXTRACT(MONTH FROM drug_exposure_start_date) as stratum_2, 
	COUNT(distinct PERSON_ID) as count_value
from
ohdsi_omop.drug_exposure de1
group by de1.drug_concept_id, 
	EXTRACT(YEAR FROM drug_exposure_start_date)*100 + EXTRACT(MONTH FROM drug_exposure_start_date)
;
--



--
-- 703	Number of distinct drug exposure concepts per person
CREATE TEMP TABLE tempResults

AS
WITH  rawData(count_value)  AS 
(
  select num_drugs as count_value
	from
	(
		select de1.person_id, COUNT(distinct de1.drug_concept_id) as num_drugs
		from
		ohdsi_omop.drug_exposure de1
		group by de1.person_id
	) t0
),
overallStats (avg_value, stdev_value, min_value, max_value, total) as
(
  select avg(1.0 * count_value) as avg_value,
    STDDEV(count_value) as stdev_value,
    min(count_value) as min_value,
    max(count_value) as max_value,
    COUNT(*) as total
  from rawData
),
stats (count_value, total, rn) as
(
  select count_value, 
  	COUNT(*) as total, 
		row_number() over (order by count_value) as rn
  FROM rawData
  group by count_value
),
priorStats (count_value, total, accumulated) as
(
  select s.count_value, s.total, sum(p.total) as accumulated
  from stats s
  join stats p on p.rn <= s.rn
  group by s.count_value, s.total, s.rn
)
 SELECT
 703 as analysis_id,
  o.total as count_value,
  o.min_value,
	o.max_value,
	o.avg_value,
	o.stdev_value,
	MIN(case when p.accumulated >= .50 * o.total then count_value else o.max_value end) as median_value,
	MIN(case when p.accumulated >= .10 * o.total then count_value else o.max_value end) as p10_value,
	MIN(case when p.accumulated >= .25 * o.total then count_value else o.max_value end) as p25_value,
	MIN(case when p.accumulated >= .75 * o.total then count_value else o.max_value end) as p75_value,
	MIN(case when p.accumulated >= .90 * o.total then count_value else o.max_value end) as p90_value

FROM
 priorStats p
CROSS JOIN overallStats o
GROUP BY o.total, o.min_value, o.max_value, o.avg_value, o.stdev_value
;

insert into ohdsi_omop.ACHILLES_results_dist (analysis_id, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value)
select analysis_id, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value
from tempResults
;

truncate table tempResults;
drop table tempResults;

--



--
-- 704	Number of persons with at least one drug occurrence, by drug_concept_id by calendar year by gender by age decile
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, stratum_2, stratum_3, stratum_4, count_value)
select 704 as analysis_id,   
	de1.drug_concept_id as stratum_1,
	EXTRACT(YEAR FROM drug_exposure_start_date) as stratum_2,
	p1.gender_concept_id as stratum_3,
	floor((EXTRACT(YEAR FROM drug_exposure_start_date) - p1.year_of_birth)/10) as stratum_4, 
	COUNT(distinct p1.PERSON_ID) as count_value
from ohdsi_omop.PERSON p1
inner join
ohdsi_omop.drug_exposure de1
on p1.person_id = de1.person_id
group by de1.drug_concept_id, 
	EXTRACT(YEAR FROM drug_exposure_start_date),
	p1.gender_concept_id,
	floor((EXTRACT(YEAR FROM drug_exposure_start_date) - p1.year_of_birth)/10)
;
--

--
-- 705	Number of drug occurrence records, by drug_concept_id by drug_type_concept_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, stratum_2, count_value)
select 705 as analysis_id, 
	de1.drug_CONCEPT_ID as stratum_1,
	de1.drug_type_concept_id as stratum_2,
	COUNT(de1.PERSON_ID) as count_value
from
	ohdsi_omop.drug_exposure de1
group by de1.drug_CONCEPT_ID,	
	de1.drug_type_concept_id
;
--



--
-- 706	Distribution of age by drug_concept_id
CREATE TEMP TABLE rawData_706

AS
SELECT
 de1.drug_concept_id as subject_id,
  p1.gender_concept_id,
	de1.drug_start_year - p1.year_of_birth as count_value

FROM
 ohdsi_omop.PERSON p1
inner join
(
	select person_id, drug_concept_id, min(EXTRACT(YEAR FROM drug_exposure_start_date)) as drug_start_year
	from ohdsi_omop.drug_exposure
	group by person_id, drug_concept_id
) de1 on p1.person_id = de1.person_id
;

CREATE TEMP TABLE tempResults

AS
WITH  overallStats (stratum1_id, stratum2_id, avg_value, stdev_value, min_value, max_value, total)  AS 
(
  select subject_id as stratum1_id,
    gender_concept_id as stratum2_id,
    avg(1.0 * count_value) as avg_value,
    STDDEV(count_value) as stdev_value,
    min(count_value) as min_value,
    max(count_value) as max_value,
    COUNT(*) as total
  FROM rawData_706
	group by subject_id, gender_concept_id
),
stats (stratum1_id, stratum2_id, count_value, total, rn) as
(
  select subject_id as stratum1_id, gender_concept_id as stratum2_id, count_value, COUNT(*) as total, row_number() over (partition by subject_id, gender_concept_id order by count_value) as rn
  FROM rawData_706
  group by subject_id, gender_concept_id, count_value
),
priorStats (stratum1_id, stratum2_id, count_value, total, accumulated) as
(
  select s.stratum1_id, s.stratum2_id, s.count_value, s.total, sum(p.total) as accumulated
  from stats s
  join stats p on s.stratum1_id = p.stratum1_id and s.stratum2_id = p.stratum2_id and p.rn <= s.rn
  group by s.stratum1_id, s.stratum2_id, s.count_value, s.total, s.rn
)
 SELECT
 706 as analysis_id,
  o.stratum1_id,
  o.stratum2_id,
  o.total as count_value,
  o.min_value,
	o.max_value,
	o.avg_value,
	o.stdev_value,
	MIN(case when p.accumulated >= .50 * o.total then count_value else o.max_value end) as median_value,
	MIN(case when p.accumulated >= .10 * o.total then count_value else o.max_value end) as p10_value,
	MIN(case when p.accumulated >= .25 * o.total then count_value else o.max_value end) as p25_value,
	MIN(case when p.accumulated >= .75 * o.total then count_value else o.max_value end) as p75_value,
	MIN(case when p.accumulated >= .90 * o.total then count_value else o.max_value end) as p90_value

FROM
 priorStats p
join overallStats o on p.stratum1_id = o.stratum1_id and p.stratum2_id = o.stratum2_id 
GROUP BY o.stratum1_id, o.stratum2_id, o.total, o.min_value, o.max_value, o.avg_value, o.stdev_value
;

insert into ohdsi_omop.ACHILLES_results_dist (analysis_id, stratum_1, stratum_2, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value)
select analysis_id, stratum1_id, stratum2_id, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value
from tempResults
;


truncate table rawData_706;
drop table rawData_706;

truncate table tempResults;
drop table tempResults;

--



--
-- 709	Number of drug exposure records with invalid person_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, count_value)
select 709 as analysis_id,  
	COUNT(de1.PERSON_ID) as count_value
from
	ohdsi_omop.drug_exposure de1
	left join ohdsi_omop.PERSON p1
	on p1.person_id = de1.person_id
where p1.person_id is null
;
--


--
-- 710	Number of drug exposure records outside valid observation period
insert into ohdsi_omop.ACHILLES_results (analysis_id, count_value)
select 710 as analysis_id,  
	COUNT(de1.PERSON_ID) as count_value
from
	ohdsi_omop.drug_exposure de1
	left join ohdsi_omop.observation_period op1
	on op1.person_id = de1.person_id
	and de1.drug_exposure_start_date >= op1.observation_period_start_date
	and de1.drug_exposure_start_date <= op1.observation_period_end_date
where op1.person_id is null
;
--


--
-- 711	Number of drug exposure records with end date < start date
insert into ohdsi_omop.ACHILLES_results (analysis_id, count_value)
select 711 as analysis_id,  
	COUNT(de1.PERSON_ID) as count_value
from
	ohdsi_omop.drug_exposure de1
where de1.drug_exposure_end_date < de1.drug_exposure_start_date
;
--


--
-- 712	Number of drug exposure records with invalid provider_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, count_value)
select 712 as analysis_id,  
	COUNT(de1.PERSON_ID) as count_value
from
	ohdsi_omop.drug_exposure de1
	left join ohdsi_omop.provider p1
	on p1.provider_id = de1.provider_id
where de1.provider_id is not null
	and p1.provider_id is null
;
--

--
-- 713	Number of drug exposure records with invalid visit_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, count_value)
select 713 as analysis_id,  
	COUNT(de1.PERSON_ID) as count_value
from
	ohdsi_omop.drug_exposure de1
	left join ohdsi_omop.visit_occurrence vo1
	on de1.visit_occurrence_id = vo1.visit_occurrence_id
where de1.visit_occurrence_id is not null
	and vo1.visit_occurrence_id is null
;
--



--
-- 715	Distribution of days_supply by drug_concept_id
CREATE TEMP TABLE tempResults

AS
WITH  rawData(stratum_id, count_value)  AS 
(
  select drug_concept_id,
		days_supply as count_value
	from ohdsi_omop.drug_exposure 
	where days_supply is not null
),
overallStats (stratum_id, avg_value, stdev_value, min_value, max_value, total) as
(
  select stratum_id,
    avg(1.0 * count_value) as avg_value,
    STDDEV(count_value) as stdev_value,
    min(count_value) as min_value,
    max(count_value) as max_value,
    COUNT(*) as total
  FROM rawData
	group by stratum_id
),
stats (stratum_id, count_value, total, rn) as
(
  select stratum_id, count_value, COUNT(*) as total, row_number() over (order by count_value) as rn
  FROM rawData
  group by stratum_id, count_value
),
priorStats (stratum_id, count_value, total, accumulated) as
(
  select s.stratum_id, s.count_value, s.total, sum(p.total) as accumulated
  from stats s
  join stats p on s.stratum_id = p.stratum_id and p.rn <= s.rn
  group by s.stratum_id, s.count_value, s.total, s.rn
)
 SELECT
 715 as analysis_id,
  o.stratum_id,
  o.total as count_value,
  o.min_value,
	o.max_value,
	o.avg_value,
	o.stdev_value,
	MIN(case when p.accumulated >= .50 * o.total then count_value else o.max_value end) as median_value,
	MIN(case when p.accumulated >= .10 * o.total then count_value else o.max_value end) as p10_value,
	MIN(case when p.accumulated >= .25 * o.total then count_value else o.max_value end) as p25_value,
	MIN(case when p.accumulated >= .75 * o.total then count_value else o.max_value end) as p75_value,
	MIN(case when p.accumulated >= .90 * o.total then count_value else o.max_value end) as p90_value

FROM
 priorStats p
join overallStats o on p.stratum_id = o.stratum_id
GROUP BY o.stratum_id, o.total, o.min_value, o.max_value, o.avg_value, o.stdev_value
;

insert into ohdsi_omop.ACHILLES_results_dist (analysis_id, stratum_1, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value)
select analysis_id, stratum_id, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value
from tempResults
;

truncate table tempResults;
drop table tempResults;

--


--
-- 716	Distribution of refills by drug_concept_id
CREATE TEMP TABLE tempResults

AS
WITH  rawData(stratum_id, count_value)  AS 
(
  select drug_concept_id,
    refills as count_value
	from ohdsi_omop.drug_exposure 
	where refills is not null
),
overallStats (stratum_id, avg_value, stdev_value, min_value, max_value, total) as
(
  select stratum_id,
    avg(1.0 * count_value) as avg_value,
    STDDEV(count_value) as stdev_value,
    min(count_value) as min_value,
    max(count_value) as max_value,
    COUNT(*) as total
  FROM rawData
	group by stratum_id
),
stats (stratum_id, count_value, total, rn) as
(
  select stratum_id, count_value, COUNT(*) as total, row_number() over (order by count_value) as rn
  FROM rawData
  group by stratum_id, count_value
),
priorStats (stratum_id, count_value, total, accumulated) as
(
  select s.stratum_id, s.count_value, s.total, sum(p.total) as accumulated
  from stats s
  join stats p on s.stratum_id = p.stratum_id and p.rn <= s.rn
  group by s.stratum_id, s.count_value, s.total, s.rn
)
 SELECT
 716 as analysis_id,
  o.stratum_id,
  o.total as count_value,
  o.min_value,
	o.max_value,
	o.avg_value,
	o.stdev_value,
	MIN(case when p.accumulated >= .50 * o.total then count_value else o.max_value end) as median_value,
	MIN(case when p.accumulated >= .10 * o.total then count_value else o.max_value end) as p10_value,
	MIN(case when p.accumulated >= .25 * o.total then count_value else o.max_value end) as p25_value,
	MIN(case when p.accumulated >= .75 * o.total then count_value else o.max_value end) as p75_value,
	MIN(case when p.accumulated >= .90 * o.total then count_value else o.max_value end) as p90_value

FROM
 priorStats p
join overallStats o on p.stratum_id = o.stratum_id
GROUP BY o.stratum_id, o.total, o.min_value, o.max_value, o.avg_value, o.stdev_value
;

insert into ohdsi_omop.ACHILLES_results_dist (analysis_id, stratum_1, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value)
select analysis_id, stratum_id, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value
from tempResults
;

truncate table tempResults;
drop table tempResults;

--



--
-- 717	Distribution of quantity by drug_concept_id
CREATE TEMP TABLE tempResults

AS
WITH  rawData(stratum_id, count_value)  AS 
(
  select drug_concept_id,
    quantity as count_value
  from ohdsi_omop.drug_exposure 
	where quantity is not null
),
overallStats (stratum_id, avg_value, stdev_value, min_value, max_value, total) as
(
  select stratum_id,
    avg(1.0 * count_value) as avg_value,
    STDDEV(count_value) as stdev_value,
    min(count_value) as min_value,
    max(count_value) as max_value,
    COUNT(*) as total
  FROM rawData
	group by stratum_id
),
stats (stratum_id, count_value, total, rn) as
(
  select stratum_id, count_value, COUNT(*) as total, row_number() over (order by count_value) as rn
  FROM rawData
  group by stratum_id, count_value
),
priorStats (stratum_id, count_value, total, accumulated) as
(
  select s.stratum_id, s.count_value, s.total, sum(p.total) as accumulated
  from stats s
  join stats p on s.stratum_id = p.stratum_id and p.rn <= s.rn
  group by s.stratum_id, s.count_value, s.total, s.rn
)
 SELECT
 717 as analysis_id,
  o.stratum_id,
  o.total as count_value,
  o.min_value,
	o.max_value,
	o.avg_value,
	o.stdev_value,
	MIN(case when p.accumulated >= .50 * o.total then count_value else o.max_value end) as median_value,
	MIN(case when p.accumulated >= .10 * o.total then count_value else o.max_value end) as p10_value,
	MIN(case when p.accumulated >= .25 * o.total then count_value else o.max_value end) as p25_value,
	MIN(case when p.accumulated >= .75 * o.total then count_value else o.max_value end) as p75_value,
	MIN(case when p.accumulated >= .90 * o.total then count_value else o.max_value end) as p90_value

FROM
 priorStats p
join overallStats o on p.stratum_id = o.stratum_id
GROUP BY o.stratum_id, o.total, o.min_value, o.max_value, o.avg_value, o.stdev_value
;

insert into ohdsi_omop.ACHILLES_results_dist (analysis_id, stratum_1, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value)
select analysis_id, stratum_id, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value
from tempResults
;

truncate table tempResults;
drop table tempResults;


--


--
-- 720	Number of drug exposure records by condition occurrence start month
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
select 720 as analysis_id,   
	EXTRACT(YEAR FROM drug_exposure_start_date)*100 + EXTRACT(MONTH FROM drug_exposure_start_date) as stratum_1, 
	COUNT(PERSON_ID) as count_value
from
ohdsi_omop.drug_exposure de1
group by EXTRACT(YEAR FROM drug_exposure_start_date)*100 + EXTRACT(MONTH FROM drug_exposure_start_date)
;
--

/********************************************

ACHILLES Analyses on OBSERVATION table

*********************************************/



--
-- 800	Number of persons with at least one observation occurrence, by observation_concept_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
select 800 as analysis_id, 
	o1.observation_CONCEPT_ID as stratum_1,
	COUNT(distinct o1.PERSON_ID) as count_value
from
	ohdsi_omop.observation o1
group by o1.observation_CONCEPT_ID
;
--


--
-- 801	Number of observation occurrence records, by observation_concept_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
select 801 as analysis_id, 
	o1.observation_CONCEPT_ID as stratum_1,
	COUNT(o1.PERSON_ID) as count_value
from
	ohdsi_omop.observation o1
group by o1.observation_CONCEPT_ID
;
--



--
-- 802	Number of persons by observation occurrence start month, by observation_concept_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, stratum_2, count_value)
select 802 as analysis_id,   
	o1.observation_concept_id as stratum_1,
	EXTRACT(YEAR FROM observation_date)*100 + EXTRACT(MONTH FROM observation_date) as stratum_2, 
	COUNT(distinct PERSON_ID) as count_value
from
ohdsi_omop.observation o1
group by o1.observation_concept_id, 
	EXTRACT(YEAR FROM observation_date)*100 + EXTRACT(MONTH FROM observation_date)
;
--



--
-- 803	Number of distinct observation occurrence concepts per person
CREATE TEMP TABLE tempResults

AS
WITH  rawData(count_value)  AS 
(
  select num_observations as count_value
  from
	(
  	select o1.person_id, COUNT(distinct o1.observation_concept_id) as num_observations
  	from
  	ohdsi_omop.observation o1
  	group by o1.person_id
	) t0
),
overallStats (avg_value, stdev_value, min_value, max_value, total) as
(
  select avg(1.0 * count_value) as avg_value,
    STDDEV(count_value) as stdev_value,
    min(count_value) as min_value,
    max(count_value) as max_value,
    COUNT(*) as total
  from rawData
),
stats (count_value, total, rn) as
(
  select count_value, 
  	COUNT(*) as total, 
		row_number() over (order by count_value) as rn
  FROM rawData
  group by count_value
),
priorStats (count_value, total, accumulated) as
(
  select s.count_value, s.total, sum(p.total) as accumulated
  from stats s
  join stats p on p.rn <= s.rn
  group by s.count_value, s.total, s.rn
)
 SELECT
 803 as analysis_id,
  o.total as count_value,
  o.min_value,
	o.max_value,
	o.avg_value,
	o.stdev_value,
	MIN(case when p.accumulated >= .50 * o.total then count_value else o.max_value end) as median_value,
	MIN(case when p.accumulated >= .10 * o.total then count_value else o.max_value end) as p10_value,
	MIN(case when p.accumulated >= .25 * o.total then count_value else o.max_value end) as p25_value,
	MIN(case when p.accumulated >= .75 * o.total then count_value else o.max_value end) as p75_value,
	MIN(case when p.accumulated >= .90 * o.total then count_value else o.max_value end) as p90_value

FROM
 priorStats p
CROSS JOIN overallStats o
GROUP BY o.total, o.min_value, o.max_value, o.avg_value, o.stdev_value
;

insert into ohdsi_omop.ACHILLES_results_dist (analysis_id, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value)
select analysis_id, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value
from tempResults
;

truncate table tempResults;

drop table tempResults;


--



--
-- 804	Number of persons with at least one observation occurrence, by observation_concept_id by calendar year by gender by age decile
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, stratum_2, stratum_3, stratum_4, count_value)
select 804 as analysis_id,   
	o1.observation_concept_id as stratum_1,
	EXTRACT(YEAR FROM observation_date) as stratum_2,
	p1.gender_concept_id as stratum_3,
	floor((EXTRACT(YEAR FROM observation_date) - p1.year_of_birth)/10) as stratum_4, 
	COUNT(distinct p1.PERSON_ID) as count_value
from ohdsi_omop.PERSON p1
inner join
ohdsi_omop.observation o1
on p1.person_id = o1.person_id
group by o1.observation_concept_id, 
	EXTRACT(YEAR FROM observation_date),
	p1.gender_concept_id,
	floor((EXTRACT(YEAR FROM observation_date) - p1.year_of_birth)/10)
;
--

--
-- 805	Number of observation occurrence records, by observation_concept_id by observation_type_concept_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, stratum_2, count_value)
select 805 as analysis_id, 
	o1.observation_CONCEPT_ID as stratum_1,
	o1.observation_type_concept_id as stratum_2,
	COUNT(o1.PERSON_ID) as count_value
from
	ohdsi_omop.observation o1
group by o1.observation_CONCEPT_ID,	
	o1.observation_type_concept_id
;
--



--
-- 806	Distribution of age by observation_concept_id
CREATE TEMP TABLE rawData_806

AS
SELECT
 o1.observation_concept_id as subject_id,
  p1.gender_concept_id,
	o1.observation_start_year - p1.year_of_birth as count_value

FROM
 ohdsi_omop.PERSON p1
inner join
(
	select person_id, observation_concept_id, min(EXTRACT(YEAR FROM observation_date)) as observation_start_year
	from ohdsi_omop.observation
	group by person_id, observation_concept_id
) o1
on p1.person_id = o1.person_id
;

CREATE TEMP TABLE tempResults

AS
WITH  overallStats (stratum1_id, stratum2_id, avg_value, stdev_value, min_value, max_value, total)  AS 
(
  select subject_id as stratum1_id,
    gender_concept_id as stratum2_id,
    avg(1.0 * count_value) as avg_value,
    STDDEV(count_value) as stdev_value,
    min(count_value) as min_value,
    max(count_value) as max_value,
    COUNT(*) as total
  FROM rawData_806
	group by subject_id, gender_concept_id
),
stats (stratum1_id, stratum2_id, count_value, total, rn) as
(
  select subject_id as stratum1_id, gender_concept_id as stratum2_id, count_value, COUNT(*) as total, row_number() over (partition by subject_id, gender_concept_id order by count_value) as rn
  FROM rawData_806
  group by subject_id, gender_concept_id, count_value
),
priorStats (stratum1_id, stratum2_id, count_value, total, accumulated) as
(
  select s.stratum1_id, s.stratum2_id, s.count_value, s.total, sum(p.total) as accumulated
  from stats s
  join stats p on s.stratum1_id = p.stratum1_id and s.stratum2_id = p.stratum2_id and p.rn <= s.rn
  group by s.stratum1_id, s.stratum2_id, s.count_value, s.total, s.rn
)
 SELECT
 806 as analysis_id,
  o.stratum1_id,
  o.stratum2_id,
  o.total as count_value,
  o.min_value,
	o.max_value,
	o.avg_value,
	o.stdev_value,
	MIN(case when p.accumulated >= .50 * o.total then count_value else o.max_value end) as median_value,
	MIN(case when p.accumulated >= .10 * o.total then count_value else o.max_value end) as p10_value,
	MIN(case when p.accumulated >= .25 * o.total then count_value else o.max_value end) as p25_value,
	MIN(case when p.accumulated >= .75 * o.total then count_value else o.max_value end) as p75_value,
	MIN(case when p.accumulated >= .90 * o.total then count_value else o.max_value end) as p90_value

FROM
 priorStats p
join overallStats o on p.stratum1_id = o.stratum1_id and p.stratum2_id = o.stratum2_id 
GROUP BY o.stratum1_id, o.stratum2_id, o.total, o.min_value, o.max_value, o.avg_value, o.stdev_value
;

insert into ohdsi_omop.ACHILLES_results_dist (analysis_id, stratum_1, stratum_2, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value)
select analysis_id, stratum1_id, stratum2_id, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value
from tempResults
;

truncate table rawData_806;
drop table rawData_806;

truncate table tempResults;
drop table tempResults;


--

--
-- 807	Number of observation occurrence records, by observation_concept_id and unit_concept_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, stratum_2, count_value)
select 807 as analysis_id, 
	o1.observation_CONCEPT_ID as stratum_1,
	o1.unit_concept_id as stratum_2,
	COUNT(o1.PERSON_ID) as count_value
from
	ohdsi_omop.observation o1
group by o1.observation_CONCEPT_ID,
	o1.unit_concept_id
;
--





--
-- 809	Number of observation records with invalid person_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, count_value)
select 809 as analysis_id,  
	COUNT(o1.PERSON_ID) as count_value
from
	ohdsi_omop.observation o1
	left join ohdsi_omop.PERSON p1
	on p1.person_id = o1.person_id
where p1.person_id is null
;
--


--
-- 810	Number of observation records outside valid observation period
insert into ohdsi_omop.ACHILLES_results (analysis_id, count_value)
select 810 as analysis_id,  
	COUNT(o1.PERSON_ID) as count_value
from
	ohdsi_omop.observation o1
	left join ohdsi_omop.observation_period op1
	on op1.person_id = o1.person_id
	and o1.observation_date >= op1.observation_period_start_date
	and o1.observation_date <= op1.observation_period_end_date
where op1.person_id is null
;
--



--
-- 812	Number of observation records with invalid provider_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, count_value)
select 812 as analysis_id,  
	COUNT(o1.PERSON_ID) as count_value
from
	ohdsi_omop.observation o1
	left join ohdsi_omop.provider p1
	on p1.provider_id = o1.provider_id
where o1.provider_id is not null
	and p1.provider_id is null
;
--

--
-- 813	Number of observation records with invalid visit_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, count_value)
select 813 as analysis_id,  
	COUNT(o1.PERSON_ID) as count_value
from
	ohdsi_omop.observation o1
	left join ohdsi_omop.visit_occurrence vo1
	on o1.visit_occurrence_id = vo1.visit_occurrence_id
where o1.visit_occurrence_id is not null
	and vo1.visit_occurrence_id is null
;
--


--
-- 814	Number of observation records with no value (numeric, string, or concept)
insert into ohdsi_omop.ACHILLES_results (analysis_id, count_value)
select 814 as analysis_id,  
	COUNT(o1.PERSON_ID) as count_value
from
	ohdsi_omop.observation o1
where o1.value_as_number is null
	and o1.value_as_string is null
	and o1.value_as_concept_id is null
;
--


--
-- 815  Distribution of numeric values, by observation_concept_id and unit_concept_id
CREATE TEMP TABLE rawData_815

AS
SELECT
 observation_concept_id as subject_id, 
	unit_concept_id,
	value_as_number as count_value

FROM
 ohdsi_omop.observation o1
where o1.unit_concept_id is not null
	and o1.value_as_number is not null
;

CREATE TEMP TABLE tempResults

AS
WITH  overallStats (stratum1_id, stratum2_id, avg_value, stdev_value, min_value, max_value, total)  AS 
(
  select subject_id as stratum1_id,
    unit_concept_id as stratum2_id,
    avg(1.0 * count_value) as avg_value,
    STDDEV(count_value) as stdev_value,
    min(count_value) as min_value,
    max(count_value) as max_value,
    COUNT(*) as total
  FROM rawData_815
	group by subject_id, unit_concept_id
),
stats (stratum1_id, stratum2_id, count_value, total, rn) as
(
  select subject_id as stratum1_id, unit_concept_id as stratum2_id, count_value, COUNT(*) as total, row_number() over (partition by subject_id, unit_concept_id order by count_value) as rn
  FROM rawData_815
  group by subject_id, unit_concept_id, count_value
),
priorStats (stratum1_id, stratum2_id, count_value, total, accumulated) as
(
  select s.stratum1_id, s.stratum2_id, s.count_value, s.total, sum(p.total) as accumulated
  from stats s
  join stats p on s.stratum1_id = p.stratum1_id and s.stratum2_id = p.stratum2_id and p.rn <= s.rn
  group by s.stratum1_id, s.stratum2_id, s.count_value, s.total, s.rn
)
 SELECT
 815 as analysis_id,
  o.stratum1_id,
  o.stratum2_id,
  o.total as count_value,
  o.min_value,
	o.max_value,
	o.avg_value,
	o.stdev_value,
	MIN(case when p.accumulated >= .50 * o.total then count_value else o.max_value end) as median_value,
	MIN(case when p.accumulated >= .10 * o.total then count_value else o.max_value end) as p10_value,
	MIN(case when p.accumulated >= .25 * o.total then count_value else o.max_value end) as p25_value,
	MIN(case when p.accumulated >= .75 * o.total then count_value else o.max_value end) as p75_value,
	MIN(case when p.accumulated >= .90 * o.total then count_value else o.max_value end) as p90_value

FROM
 priorStats p
join overallStats o on p.stratum1_id = o.stratum1_id and p.stratum2_id = o.stratum2_id 
GROUP BY o.stratum1_id, o.stratum2_id, o.total, o.min_value, o.max_value, o.avg_value, o.stdev_value
;

insert into ohdsi_omop.ACHILLES_results_dist (analysis_id, stratum_1, stratum_2, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value)
select analysis_id, stratum1_id, stratum2_id, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value
from tempResults
;

truncate table rawData_815;
drop table rawData_815;

truncate table tempResults;
drop table tempResults;

--


--


--



--



--
-- 820	Number of observation records by condition occurrence start month
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
select 820 as analysis_id,   
	EXTRACT(YEAR FROM observation_date)*100 + EXTRACT(MONTH FROM observation_date) as stratum_1, 
	COUNT(PERSON_ID) as count_value
from
ohdsi_omop.observation o1
group by EXTRACT(YEAR FROM observation_date)*100 + EXTRACT(MONTH FROM observation_date)
;
--




/********************************************

ACHILLES Analyses on DRUG_ERA table

*********************************************/


--
-- 900	Number of persons with at least one drug occurrence, by drug_concept_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
select 900 as analysis_id, 
	de1.drug_CONCEPT_ID as stratum_1,
	COUNT(distinct de1.PERSON_ID) as count_value
from
	ohdsi_omop.drug_era de1
group by de1.drug_CONCEPT_ID
;
--


--
-- 901	Number of drug occurrence records, by drug_concept_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
select 901 as analysis_id, 
	de1.drug_CONCEPT_ID as stratum_1,
	COUNT(de1.PERSON_ID) as count_value
from
	ohdsi_omop.drug_era de1
group by de1.drug_CONCEPT_ID
;
--



--
-- 902	Number of persons by drug occurrence start month, by drug_concept_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, stratum_2, count_value)
select 902 as analysis_id,   
	de1.drug_concept_id as stratum_1,
	EXTRACT(YEAR FROM drug_era_start_date)*100 + EXTRACT(MONTH FROM drug_era_start_date) as stratum_2, 
	COUNT(distinct PERSON_ID) as count_value
from
ohdsi_omop.drug_era de1
group by de1.drug_concept_id, 
	EXTRACT(YEAR FROM drug_era_start_date)*100 + EXTRACT(MONTH FROM drug_era_start_date)
;
--



--
-- 903	Number of distinct drug era concepts per person
CREATE TEMP TABLE tempResults

AS
WITH  rawData(count_value)  AS 
(
  select COUNT(distinct de1.drug_concept_id) as count_value
	from ohdsi_omop.drug_era de1
	group by de1.person_id
),
overallStats (avg_value, stdev_value, min_value, max_value, total) as
(
  select avg(1.0 * count_value) as avg_value,
    STDDEV(count_value) as stdev_value,
    min(count_value) as min_value,
    max(count_value) as max_value,
    COUNT(*) as total
  from rawData
),
stats (count_value, total, rn) as
(
  select count_value, 
  	COUNT(*) as total, 
		row_number() over (order by count_value) as rn
  FROM rawData
  group by count_value
),
priorStats (count_value, total, accumulated) as
(
  select s.count_value, s.total, sum(p.total) as accumulated
  from stats s
  join stats p on p.rn <= s.rn
  group by s.count_value, s.total, s.rn
)
 SELECT
 903 as analysis_id,
  o.total as count_value,
  o.min_value,
	o.max_value,
	o.avg_value,
	o.stdev_value,
	MIN(case when p.accumulated >= .50 * o.total then count_value else o.max_value end) as median_value,
	MIN(case when p.accumulated >= .10 * o.total then count_value else o.max_value end) as p10_value,
	MIN(case when p.accumulated >= .25 * o.total then count_value else o.max_value end) as p25_value,
	MIN(case when p.accumulated >= .75 * o.total then count_value else o.max_value end) as p75_value,
	MIN(case when p.accumulated >= .90 * o.total then count_value else o.max_value end) as p90_value

FROM
 priorStats p
CROSS JOIN overallStats o
GROUP BY o.total, o.min_value, o.max_value, o.avg_value, o.stdev_value
;

insert into ohdsi_omop.ACHILLES_results_dist (analysis_id, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value)
select analysis_id, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value
from tempResults
;

truncate table tempResults;
drop table tempResults;


--



--
-- 904	Number of persons with at least one drug occurrence, by drug_concept_id by calendar year by gender by age decile
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, stratum_2, stratum_3, stratum_4, count_value)
select 904 as analysis_id,   
	de1.drug_concept_id as stratum_1,
	EXTRACT(YEAR FROM drug_era_start_date) as stratum_2,
	p1.gender_concept_id as stratum_3,
	floor((EXTRACT(YEAR FROM drug_era_start_date) - p1.year_of_birth)/10) as stratum_4, 
	COUNT(distinct p1.PERSON_ID) as count_value
from ohdsi_omop.PERSON p1
inner join
ohdsi_omop.drug_era de1
on p1.person_id = de1.person_id
group by de1.drug_concept_id, 
	EXTRACT(YEAR FROM drug_era_start_date),
	p1.gender_concept_id,
	floor((EXTRACT(YEAR FROM drug_era_start_date) - p1.year_of_birth)/10)
;
--




--
-- 906	Distribution of age by drug_concept_id
CREATE TEMP TABLE rawData_906

AS
SELECT
 de.drug_concept_id as subject_id,
  p1.gender_concept_id,
  de.drug_start_year - p1.year_of_birth as count_value

FROM
 ohdsi_omop.PERSON p1
inner join
(
	select person_id, drug_concept_id, min(EXTRACT(YEAR FROM drug_era_start_date)) as drug_start_year
	from ohdsi_omop.drug_era
	group by person_id, drug_concept_id
) de on p1.person_id =de.person_id
;

CREATE TEMP TABLE tempResults

AS
WITH  overallStats (stratum1_id, stratum2_id, avg_value, stdev_value, min_value, max_value, total)  AS 
(
  select subject_id as stratum1_id,
    gender_concept_id as stratum2_id,
    avg(1.0 * count_value) as avg_value,
    STDDEV(count_value) as stdev_value,
    min(count_value) as min_value,
    max(count_value) as max_value,
    COUNT(*) as total
  FROM rawData_906
	group by subject_id, gender_concept_id
),
stats (stratum1_id, stratum2_id, count_value, total, rn) as
(
  select subject_id as stratum1_id, gender_concept_id as stratum2_id, count_value, COUNT(*) as total, row_number() over (partition by subject_id, gender_concept_id order by count_value) as rn
  FROM rawData_906
  group by subject_id, gender_concept_id, count_value
),
priorStats (stratum1_id, stratum2_id, count_value, total, accumulated) as
(
  select s.stratum1_id, s.stratum2_id, s.count_value, s.total, sum(p.total) as accumulated
  from stats s
  join stats p on s.stratum1_id = p.stratum1_id and s.stratum2_id = p.stratum2_id and p.rn <= s.rn
  group by s.stratum1_id, s.stratum2_id, s.count_value, s.total, s.rn
)
 SELECT
 906 as analysis_id,
  o.stratum1_id,
  o.stratum2_id,
  o.total as count_value,
  o.min_value,
	o.max_value,
	o.avg_value,
	o.stdev_value,
	MIN(case when p.accumulated >= .50 * o.total then count_value else o.max_value end) as median_value,
	MIN(case when p.accumulated >= .10 * o.total then count_value else o.max_value end) as p10_value,
	MIN(case when p.accumulated >= .25 * o.total then count_value else o.max_value end) as p25_value,
	MIN(case when p.accumulated >= .75 * o.total then count_value else o.max_value end) as p75_value,
	MIN(case when p.accumulated >= .90 * o.total then count_value else o.max_value end) as p90_value

FROM
 priorStats p
join overallStats o on p.stratum1_id = o.stratum1_id and p.stratum2_id = o.stratum2_id 
GROUP BY o.stratum1_id, o.stratum2_id, o.total, o.min_value, o.max_value, o.avg_value, o.stdev_value
;

insert into ohdsi_omop.ACHILLES_results_dist (analysis_id, stratum_1, stratum_2, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value)
select analysis_id, stratum1_id, stratum2_id, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value
from tempResults
;


truncate table rawData_906;
drop table rawData_906;

truncate table tempResults;
drop table tempResults;
--


--
-- 907	Distribution of drug era length, by drug_concept_id
CREATE TEMP TABLE tempResults

AS
WITH  rawData(stratum1_id, count_value)  AS 
(
  select drug_concept_id,
    (CAST( drug_era_end_date AS DATE) - CAST(drug_era_start_date AS DATE)) as count_value
  from  ohdsi_omop.drug_era de1
),
overallStats (stratum1_id, avg_value, stdev_value, min_value, max_value, total) as
(
  select stratum1_id, 
  	avg(1.0 * count_value) as avg_value,
    STDDEV(count_value) as stdev_value,
    min(count_value) as min_value,
    max(count_value) as max_value,
    COUNT(*) as total
  from rawData
  group by stratum1_id
),
stats (stratum1_id, count_value, total, rn) as
(
  select stratum1_id, 
		count_value, 
  	COUNT(*) as total, 
		row_number() over (partition by stratum1_id order by count_value) as rn
  FROM rawData
  group by stratum1_id, count_value
),
priorStats (stratum1_id, count_value, total, accumulated) as
(
  select s.stratum1_id, s.count_value, s.total, sum(p.total) as accumulated
  from stats s
  join stats p on s.stratum1_id = p.stratum1_id and p.rn <= s.rn
  group by s.stratum1_id, s.count_value, s.total, s.rn
)
 SELECT
 907 as analysis_id,
  p.stratum1_id as stratum_1,
  o.total as count_value,
  o.min_value,
	o.max_value,
	o.avg_value,
	o.stdev_value,
	MIN(case when p.accumulated >= .50 * o.total then count_value else o.max_value end) as median_value,
	MIN(case when p.accumulated >= .10 * o.total then count_value else o.max_value end) as p10_value,
	MIN(case when p.accumulated >= .25 * o.total then count_value else o.max_value end) as p25_value,
	MIN(case when p.accumulated >= .75 * o.total then count_value else o.max_value end) as p75_value,
	MIN(case when p.accumulated >= .90 * o.total then count_value else o.max_value end) as p90_value

FROM
 priorStats p
join overallStats o on p.stratum1_id = o.stratum1_id
GROUP BY p.stratum1_id, o.total, o.min_value, o.max_value, o.avg_value, o.stdev_value
;

insert into ohdsi_omop.ACHILLES_results_dist (analysis_id, stratum_1, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value)
select analysis_id, stratum_1, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value
from tempResults
;

truncate table tempResults;
drop table tempResults;

--



--
-- 908	Number of drug eras with invalid person
insert into ohdsi_omop.ACHILLES_results (analysis_id, count_value)
select 908 as analysis_id,  
	COUNT(de1.PERSON_ID) as count_value
from
	ohdsi_omop.drug_era de1
	left join ohdsi_omop.PERSON p1
	on p1.person_id = de1.person_id
where p1.person_id is null
;
--


--
-- 909	Number of drug eras outside valid observation period
insert into ohdsi_omop.ACHILLES_results (analysis_id, count_value)
select 909 as analysis_id,  
	COUNT(de1.PERSON_ID) as count_value
from
	ohdsi_omop.drug_era de1
	left join ohdsi_omop.observation_period op1
	on op1.person_id = de1.person_id
	and de1.drug_era_start_date >= op1.observation_period_start_date
	and de1.drug_era_start_date <= op1.observation_period_end_date
where op1.person_id is null
;
--


--
-- 910	Number of drug eras with end date < start date
insert into ohdsi_omop.ACHILLES_results (analysis_id, count_value)
select 910 as analysis_id,  
	COUNT(de1.PERSON_ID) as count_value
from
	ohdsi_omop.drug_era de1
where de1.drug_era_end_date < de1.drug_era_start_date
;
--



--
-- 920	Number of drug era records by drug era start month
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
select 920 as analysis_id,   
	EXTRACT(YEAR FROM drug_era_start_date)*100 + EXTRACT(MONTH FROM drug_era_start_date) as stratum_1, 
	COUNT(PERSON_ID) as count_value
from
ohdsi_omop.drug_era de1
group by EXTRACT(YEAR FROM drug_era_start_date)*100 + EXTRACT(MONTH FROM drug_era_start_date)
;
--





/********************************************

ACHILLES Analyses on CONDITION_ERA table

*********************************************/


--
-- 1000	Number of persons with at least one condition occurrence, by condition_concept_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
select 1000 as analysis_id, 
	ce1.condition_CONCEPT_ID as stratum_1,
	COUNT(distinct ce1.PERSON_ID) as count_value
from
	ohdsi_omop.condition_era ce1
group by ce1.condition_CONCEPT_ID
;
--


--
-- 1001	Number of condition occurrence records, by condition_concept_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
select 1001 as analysis_id, 
	ce1.condition_CONCEPT_ID as stratum_1,
	COUNT(ce1.PERSON_ID) as count_value
from
	ohdsi_omop.condition_era ce1
group by ce1.condition_CONCEPT_ID
;
--



--
-- 1002	Number of persons by condition occurrence start month, by condition_concept_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, stratum_2, count_value)
select 1002 as analysis_id,   
	ce1.condition_concept_id as stratum_1,
	EXTRACT(YEAR FROM condition_era_start_date)*100 + EXTRACT(MONTH FROM condition_era_start_date) as stratum_2, 
	COUNT(distinct PERSON_ID) as count_value
from
ohdsi_omop.condition_era ce1
group by ce1.condition_concept_id, 
	EXTRACT(YEAR FROM condition_era_start_date)*100 + EXTRACT(MONTH FROM condition_era_start_date)
;
--



--
-- 1003	Number of distinct condition era concepts per person
CREATE TEMP TABLE tempResults

AS
WITH  rawData(count_value)  AS 
(
  select COUNT(distinct ce1.condition_concept_id) as count_value
	from ohdsi_omop.condition_era ce1
	group by ce1.person_id
),
overallStats (avg_value, stdev_value, min_value, max_value, total) as
(
  select avg(1.0 * count_value) as avg_value,
    STDDEV(count_value) as stdev_value,
    min(count_value) as min_value,
    max(count_value) as max_value,
    COUNT(*) as total
  from rawData
),
stats (count_value, total, rn) as
(
  select count_value, 
  	COUNT(*) as total, 
		row_number() over (order by count_value) as rn
  FROM rawData
  group by count_value
),
priorStats (count_value, total, accumulated) as
(
  select s.count_value, s.total, sum(p.total) as accumulated
  from stats s
  join stats p on p.rn <= s.rn
  group by s.count_value, s.total, s.rn
)
 SELECT
 1003 as analysis_id,
  o.total as count_value,
  o.min_value,
	o.max_value,
	o.avg_value,
	o.stdev_value,
	MIN(case when p.accumulated >= .50 * o.total then count_value else o.max_value end) as median_value,
	MIN(case when p.accumulated >= .10 * o.total then count_value else o.max_value end) as p10_value,
	MIN(case when p.accumulated >= .25 * o.total then count_value else o.max_value end) as p25_value,
	MIN(case when p.accumulated >= .75 * o.total then count_value else o.max_value end) as p75_value,
	MIN(case when p.accumulated >= .90 * o.total then count_value else o.max_value end) as p90_value

FROM
 priorStats p
CROSS JOIN overallStats o
GROUP BY o.total, o.min_value, o.max_value, o.avg_value, o.stdev_value
;

insert into ohdsi_omop.ACHILLES_results_dist (analysis_id, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value)
select analysis_id, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value
from tempResults
;

truncate table tempResults;
drop table tempResults;

--



--
-- 1004	Number of persons with at least one condition occurrence, by condition_concept_id by calendar year by gender by age decile
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, stratum_2, stratum_3, stratum_4, count_value)
select 1004 as analysis_id,   
	ce1.condition_concept_id as stratum_1,
	EXTRACT(YEAR FROM condition_era_start_date) as stratum_2,
	p1.gender_concept_id as stratum_3,
	floor((EXTRACT(YEAR FROM condition_era_start_date) - p1.year_of_birth)/10) as stratum_4, 
	COUNT(distinct p1.PERSON_ID) as count_value
from ohdsi_omop.PERSON p1
inner join
ohdsi_omop.condition_era ce1
on p1.person_id = ce1.person_id
group by ce1.condition_concept_id, 
	EXTRACT(YEAR FROM condition_era_start_date),
	p1.gender_concept_id,
	floor((EXTRACT(YEAR FROM condition_era_start_date) - p1.year_of_birth)/10)
;
--




--
-- 1006	Distribution of age by condition_concept_id
CREATE TEMP TABLE rawData_1006

AS
SELECT
 ce.condition_concept_id as subject_id,
  p1.gender_concept_id,
  ce.condition_start_year - p1.year_of_birth as count_value

FROM
 ohdsi_omop.PERSON p1
inner join
(
  select person_id, condition_concept_id, min(EXTRACT(YEAR FROM condition_era_start_date)) as condition_start_year
  from ohdsi_omop.condition_era
  group by person_id, condition_concept_id
) ce on p1.person_id = ce.person_id
;

CREATE TEMP TABLE tempResults

AS
WITH  overallStats (stratum1_id, stratum2_id, avg_value, stdev_value, min_value, max_value, total)  AS 
(
  select subject_id as stratum1_id,
    gender_concept_id as stratum2_id,
    avg(1.0 * count_value) as avg_value,
    STDDEV(count_value) as stdev_value,
    min(count_value) as min_value,
    max(count_value) as max_value,
    COUNT(*) as total
  FROM rawData_1006
	group by subject_id, gender_concept_id
),
stats (stratum1_id, stratum2_id, count_value, total, rn) as
(
  select subject_id as stratum1_id, gender_concept_id as stratum2_id, count_value, COUNT(*) as total, row_number() over (partition by subject_id, gender_concept_id order by count_value) as rn
  FROM rawData_1006
  group by subject_id, gender_concept_id, count_value
),
priorStats (stratum1_id, stratum2_id, count_value, total, accumulated) as
(
  select s.stratum1_id, s.stratum2_id, s.count_value, s.total, sum(p.total) as accumulated
  from stats s
  join stats p on s.stratum1_id = p.stratum1_id and s.stratum2_id = p.stratum2_id and p.rn <= s.rn
  group by s.stratum1_id, s.stratum2_id, s.count_value, s.total, s.rn
)
 SELECT
 1006 as analysis_id,
  o.stratum1_id,
  o.stratum2_id,
  o.total as count_value,
  o.min_value,
	o.max_value,
	o.avg_value,
	o.stdev_value,
	MIN(case when p.accumulated >= .50 * o.total then count_value else o.max_value end) as median_value,
	MIN(case when p.accumulated >= .10 * o.total then count_value else o.max_value end) as p10_value,
	MIN(case when p.accumulated >= .25 * o.total then count_value else o.max_value end) as p25_value,
	MIN(case when p.accumulated >= .75 * o.total then count_value else o.max_value end) as p75_value,
	MIN(case when p.accumulated >= .90 * o.total then count_value else o.max_value end) as p90_value

FROM
 priorStats p
join overallStats o on p.stratum1_id = o.stratum1_id and p.stratum2_id = o.stratum2_id 
GROUP BY o.stratum1_id, o.stratum2_id, o.total, o.min_value, o.max_value, o.avg_value, o.stdev_value
;

insert into ohdsi_omop.ACHILLES_results_dist (analysis_id, stratum_1, stratum_2, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value)
select analysis_id, stratum1_id, stratum2_id, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value
from tempResults
;

truncate table rawData_1006;
drop table rawData_1006;

truncate table tempResults;
drop table tempResults;

--



--
-- 1007	Distribution of condition era length, by condition_concept_id
CREATE TEMP TABLE tempResults

AS
WITH  rawData(stratum1_id, count_value)  AS 
(
  select condition_concept_id as stratum1_id,
    (CAST( condition_era_end_date AS DATE) - CAST(condition_era_start_date AS DATE)) as count_value
  from  ohdsi_omop.condition_era ce1
),
overallStats (stratum1_id, avg_value, stdev_value, min_value, max_value, total) as
(
  select stratum1_id, 
    avg(1.0 * count_value) as avg_value,
    STDDEV(count_value) as stdev_value,
    min(count_value) as min_value,
    max(count_value) as max_value,
    COUNT(*) as total
  from rawData
  group by stratum1_id
),
stats (stratum1_id, count_value, total, rn) as
(
  select stratum1_id, 
		count_value, 
  	COUNT(*) as total, 
		row_number() over (partition by stratum1_id order by count_value) as rn
  FROM rawData
  group by stratum1_id, count_value
),
priorStats (stratum1_id, count_value, total, accumulated) as
(
  select s.stratum1_id, s.count_value, s.total, sum(p.total) as accumulated
  from stats s
  join stats p on s.stratum1_id = p.stratum1_id and p.rn <= s.rn
  group by s.stratum1_id, s.count_value, s.total, s.rn
)
 SELECT
 1007 as analysis_id,
  p.stratum1_id as stratum_1,
  o.total as count_value,
  o.min_value,
	o.max_value,
	o.avg_value,
	o.stdev_value,
	MIN(case when p.accumulated >= .50 * o.total then count_value else o.max_value end) as median_value,
	MIN(case when p.accumulated >= .10 * o.total then count_value else o.max_value end) as p10_value,
	MIN(case when p.accumulated >= .25 * o.total then count_value else o.max_value end) as p25_value,
	MIN(case when p.accumulated >= .75 * o.total then count_value else o.max_value end) as p75_value,
	MIN(case when p.accumulated >= .90 * o.total then count_value else o.max_value end) as p90_value

FROM
 priorStats p
join overallStats o on p.stratum1_id = o.stratum1_id
GROUP BY p.stratum1_id, o.total, o.min_value, o.max_value, o.avg_value, o.stdev_value
;

insert into ohdsi_omop.ACHILLES_results_dist (analysis_id, stratum_1, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value)
select analysis_id, stratum_1, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value
from tempResults
;

truncate table tempResults;
drop table tempResults;


--



--
-- 1008	Number of condition eras with invalid person
insert into ohdsi_omop.ACHILLES_results (analysis_id, count_value)
select 1008 as analysis_id,  
	COUNT(ce1.PERSON_ID) as count_value
from
	ohdsi_omop.condition_era ce1
	left join ohdsi_omop.PERSON p1
	on p1.person_id = ce1.person_id
where p1.person_id is null
;
--


--
-- 1009	Number of condition eras outside valid observation period
insert into ohdsi_omop.ACHILLES_results (analysis_id, count_value)
select 1009 as analysis_id,  
	COUNT(ce1.PERSON_ID) as count_value
from
	ohdsi_omop.condition_era ce1
	left join ohdsi_omop.observation_period op1
	on op1.person_id = ce1.person_id
	and ce1.condition_era_start_date >= op1.observation_period_start_date
	and ce1.condition_era_start_date <= op1.observation_period_end_date
where op1.person_id is null
;
--


--
-- 1010	Number of condition eras with end date < start date
insert into ohdsi_omop.ACHILLES_results (analysis_id, count_value)
select 1010 as analysis_id,  
	COUNT(ce1.PERSON_ID) as count_value
from
	ohdsi_omop.condition_era ce1
where ce1.condition_era_end_date < ce1.condition_era_start_date
;
--


--
-- 1020	Number of drug era records by drug era start month
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
select 1020 as analysis_id,   
	EXTRACT(YEAR FROM condition_era_start_date)*100 + EXTRACT(MONTH FROM condition_era_start_date) as stratum_1, 
	COUNT(PERSON_ID) as count_value
from
ohdsi_omop.condition_era ce1
group by EXTRACT(YEAR FROM condition_era_start_date)*100 + EXTRACT(MONTH FROM condition_era_start_date)
;
--




/********************************************

ACHILLES Analyses on LOCATION table

*********************************************/

--
-- 1100	Number of persons by location 3-digit zip
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
select 1100 as analysis_id,  
	left(l1.zip,3) as stratum_1, COUNT(distinct person_id) as count_value
from ohdsi_omop.PERSON p1
	inner join ohdsi_omop.LOCATION l1
	on p1.location_id = l1.location_id
where p1.location_id is not null
	and l1.zip is not null
group by left(l1.zip,3);
--


--
-- 1101	Number of persons by location state
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
select 1101 as analysis_id,  
	l1.state as stratum_1, COUNT(distinct person_id) as count_value
from ohdsi_omop.PERSON p1
	inner join ohdsi_omop.LOCATION l1
	on p1.location_id = l1.location_id
where p1.location_id is not null
	and l1.state is not null
group by l1.state;
--


--
-- 1102	Number of care sites by location 3-digit zip
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
select 1102 as analysis_id,  
	left(l1.zip,3) as stratum_1, COUNT(distinct care_site_id) as count_value
from ohdsi_omop.care_site cs1
	inner join ohdsi_omop.LOCATION l1
	on cs1.location_id = l1.location_id
where cs1.location_id is not null
	and l1.zip is not null
group by left(l1.zip,3);
--


--
-- 1103	Number of care sites by location state
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
select 1103 as analysis_id,  
	l1.state as stratum_1, COUNT(distinct care_site_id) as count_value
from ohdsi_omop.care_site cs1
	inner join ohdsi_omop.LOCATION l1
	on cs1.location_id = l1.location_id
where cs1.location_id is not null
	and l1.state is not null
group by l1.state;
--


/********************************************

ACHILLES Analyses on CARE_SITE table

*********************************************/


--
-- 1200	Number of persons by place of service
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
select 1200 as analysis_id,  
	cs1.place_of_service_concept_id as stratum_1, COUNT(person_id) as count_value
from ohdsi_omop.PERSON p1
	inner join ohdsi_omop.care_site cs1
	on p1.care_site_id = cs1.care_site_id
where p1.care_site_id is not null
	and cs1.place_of_service_concept_id is not null
group by cs1.place_of_service_concept_id;
--


--
-- 1201	Number of visits by place of service
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
select 1201 as analysis_id,  
	cs1.place_of_service_concept_id as stratum_1, COUNT(visit_occurrence_id) as count_value
from ohdsi_omop.visit_occurrence vo1
	inner join ohdsi_omop.care_site cs1
	on vo1.care_site_id = cs1.care_site_id
where vo1.care_site_id is not null
	and cs1.place_of_service_concept_id is not null
group by cs1.place_of_service_concept_id;
--


--
-- 1202	Number of care sites by place of service
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
select 1202 as analysis_id,  
	cs1.place_of_service_concept_id as stratum_1, 
	COUNT(care_site_id) as count_value
from ohdsi_omop.care_site cs1
where cs1.place_of_service_concept_id is not null
group by cs1.place_of_service_concept_id;
--


/********************************************

ACHILLES Analyses on ORGANIZATION table

*********************************************/

--





/********************************************

ACHILLES Analyses on PAYOR_PLAN_PERIOD table

*********************************************/


--
-- 1406	Length of payer plan (days) of first payer plan period by gender
CREATE TEMP TABLE tempResults

AS
WITH  rawData(stratum1_id, count_value)  AS 
(
  select p1.gender_concept_id as stratum1_id,
    (CAST( ppp1.payer_plan_period_end_date AS DATE) - CAST(ppp1.payer_plan_period_start_date AS DATE)) as count_value
  from ohdsi_omop.PERSON p1
	inner join 
	(select person_id, 
		payer_plan_period_START_DATE, 
		payer_plan_period_END_DATE, 
		ROW_NUMBER() over (PARTITION by person_id order by payer_plan_period_start_date asc) as rn1
		 from ohdsi_omop.payer_plan_period
	) ppp1
	on p1.PERSON_ID = ppp1.PERSON_ID
	where ppp1.rn1 = 1
),
overallStats (stratum1_id, avg_value, stdev_value, min_value, max_value, total) as
(
  select stratum1_id, 
    avg(1.0 * count_value) as avg_value,
    STDDEV(count_value) as stdev_value,
    min(count_value) as min_value,
    max(count_value) as max_value,
    COUNT(*) as total
  from rawData
  group by stratum1_id
),
stats (stratum1_id, count_value, total, rn) as
(
  select stratum1_id, 
  	count_value, 
  	COUNT(*) as total, 
		row_number() over (partition by stratum1_id order by count_value) as rn
  FROM rawData
  group by stratum1_id, count_value
),
priorStats (stratum1_id, count_value, total, accumulated) as
(
  select s.stratum1_id, s.count_value, s.total, sum(p.total) as accumulated
  from stats s
  join stats p on s.stratum1_id = p.stratum1_id and p.rn <= s.rn
  group by s.stratum1_id, s.count_value, s.total, s.rn
)
 SELECT
 1406 as analysis_id,
  p.stratum1_id as stratum_1,
  o.total as count_value,
  o.min_value,
	o.max_value,
	o.avg_value,
	o.stdev_value,
	MIN(case when p.accumulated >= .50 * o.total then count_value else o.max_value end) as median_value,
	MIN(case when p.accumulated >= .10 * o.total then count_value else o.max_value end) as p10_value,
	MIN(case when p.accumulated >= .25 * o.total then count_value else o.max_value end) as p25_value,
	MIN(case when p.accumulated >= .75 * o.total then count_value else o.max_value end) as p75_value,
	MIN(case when p.accumulated >= .90 * o.total then count_value else o.max_value end) as p90_value

FROM
 priorStats p
join overallStats o on p.stratum1_id = o.stratum1_id
GROUP BY p.stratum1_id, o.total, o.min_value, o.max_value, o.avg_value, o.stdev_value
;

insert into ohdsi_omop.ACHILLES_results_dist (analysis_id, stratum_1, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value)
select analysis_id, stratum_1, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value
from tempResults
;

truncate table tempResults;
drop table tempResults;


--



--
-- 1407	Length of payer plan (days) of first payer plan period by age decile
CREATE TEMP TABLE tempResults

AS
WITH  rawData(stratum_id, count_value)  AS 
(
  select floor((EXTRACT(YEAR FROM ppp1.payer_plan_period_START_DATE) - p1.YEAR_OF_BIRTH)/10) as stratum_id,
    (CAST( ppp1.payer_plan_period_end_date AS DATE) - CAST(ppp1.payer_plan_period_start_date AS DATE)) as count_value
  from ohdsi_omop.PERSON p1
	inner join 
	(select person_id, 
		payer_plan_period_START_DATE, 
		payer_plan_period_END_DATE, 
		ROW_NUMBER() over (PARTITION by person_id order by payer_plan_period_start_date asc) as rn1
		 from ohdsi_omop.payer_plan_period
	) ppp1
	on p1.PERSON_ID = ppp1.PERSON_ID
	where ppp1.rn1 = 1
),
overallStats (stratum_id, avg_value, stdev_value, min_value, max_value, total) as
(
  select stratum_id,
    avg(1.0 * count_value) as avg_value,
    STDDEV(count_value) as stdev_value,
    min(count_value) as min_value,
    max(count_value) as max_value,
    COUNT(*) as total
  FROM rawData
  group by stratum_id
),
stats (stratum_id, count_value, total, rn) as
(
  select stratum_id, count_value, COUNT(*) as total, row_number() over (order by count_value) as rn
  FROM rawData
  group by stratum_id, count_value
),
priorStats (stratum_id, count_value, total, accumulated) as
(
  select s.stratum_id, s.count_value, s.total, sum(p.total) as accumulated
  from stats s
  join stats p on s.stratum_id = p.stratum_id and p.rn <= s.rn
  group by s.stratum_id, s.count_value, s.total, s.rn
)
 SELECT
 1407 as analysis_id,
  o.stratum_id,
  o.total as count_value,
  o.min_value,
  o.max_value,
	o.avg_value,
	o.stdev_value,
	MIN(case when p.accumulated >= .50 * o.total then count_value else o.max_value end) as median_value,
	MIN(case when p.accumulated >= .10 * o.total then count_value else o.max_value end) as p10_value,
	MIN(case when p.accumulated >= .25 * o.total then count_value else o.max_value end) as p25_value,
	MIN(case when p.accumulated >= .75 * o.total then count_value else o.max_value end) as p75_value,
	MIN(case when p.accumulated >= .90 * o.total then count_value else o.max_value end) as p90_value

FROM
 priorStats p
join overallStats o on p.stratum_id = o.stratum_id
GROUP BY o.stratum_id, o.total, o.min_value, o.max_value, o.avg_value, o.stdev_value
;

insert into ohdsi_omop.ACHILLES_results_dist (analysis_id, stratum_1, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value)
select analysis_id, stratum_id, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value
from tempResults
;

truncate table tempResults;
drop table tempResults;


--




--
-- 1408	Number of persons by length of payer plan period, in 30d increments
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
select 1408 as analysis_id,  
	floor((CAST( ppp1.payer_plan_period_end_date AS DATE) - CAST( ppp1.payer_plan_period_start_date AS DATE))/30) as stratum_1, 
	COUNT(distinct p1.person_id) as count_value
from ohdsi_omop.PERSON p1
	inner join 
	(select person_id, 
		payer_plan_period_START_DATE, 
		payer_plan_period_END_DATE, 
		ROW_NUMBER() over (PARTITION by person_id order by payer_plan_period_start_date asc) as rn1
		 from ohdsi_omop.payer_plan_period
	) ppp1
	on p1.PERSON_ID = ppp1.PERSON_ID
	where ppp1.rn1 = 1
group by floor((CAST( ppp1.payer_plan_period_end_date AS DATE) - CAST( ppp1.payer_plan_period_start_date AS DATE))/30)
;
--


--
-- 1409	Number of persons with continuous payer plan in each year
-- Note: using temp table instead of nested query because this gives vastly improved

DROP TABLE IF EXISTS  temp_dates;

CREATE TEMP TABLE temp_dates

AS
SELECT
 distinct 
  EXTRACT(YEAR FROM payer_plan_period_start_date) as obs_year 

FROM
 
  ohdsi_omop.payer_plan_period
;

insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
select 1409 as analysis_id,  
	t1.obs_year as stratum_1, COUNT(distinct p1.PERSON_ID) as count_value
from
	ohdsi_omop.PERSON p1
	inner join 
    ohdsi_omop.payer_plan_period ppp1
	on p1.person_id = ppp1.person_id
	,
	temp_dates t1 
where EXTRACT(YEAR FROM ppp1.payer_plan_period_START_DATE) <= t1.obs_year
	and EXTRACT(YEAR FROM ppp1.payer_plan_period_END_DATE) >= t1.obs_year
group by t1.obs_year
;

truncate table temp_dates;
drop table temp_dates;
--


--
-- 1410	Number of persons with continuous payer plan in each month
-- Note: using temp table instead of nested query because this gives vastly improved performance in Oracle

DROP TABLE IF EXISTS  temp_dates;

CREATE TEMP TABLE temp_dates

AS
SELECT
 DISTINCT 
  EXTRACT(YEAR FROM payer_plan_period_start_date)*100 + EXTRACT(MONTH FROM payer_plan_period_start_date) AS obs_month,
  TO_DATE(CAST(EXTRACT(YEAR FROM payer_plan_period_start_date)  AS varchar(4)) ||  RIGHT('0' || CAST(EXTRACT(MONTH FROM payer_plan_period_start_date) AS VARCHAR(2)), 2) || '01' , 'yyyymmdd') AS obs_month_start,  
  (CAST((TO_DATE(CAST(EXTRACT(YEAR FROM payer_plan_period_start_date)  AS varchar(4)) ||  RIGHT('0' || CAST(EXTRACT(MONTH FROM payer_plan_period_start_date) AS VARCHAR(2)), 2) || '01' , 'yyyymmdd') + 1*INTERVAL'1 month') AS DATE) + -1) AS obs_month_end

FROM
 
  ohdsi_omop.payer_plan_period
;

insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
select 
  1410 as analysis_id, 
	obs_month as stratum_1, 
	COUNT(distinct p1.PERSON_ID) as count_value
from
	ohdsi_omop.PERSON p1
	inner join 
  ohdsi_omop.payer_plan_period ppp1
	on p1.person_id = ppp1.person_id
	,
	temp_dates
where ppp1.payer_plan_period_START_DATE <= obs_month_start
	and ppp1.payer_plan_period_END_DATE >= obs_month_end
group by obs_month
;

TRUNCATE TABLE temp_dates;
DROP TABLE temp_dates;
--



--
-- 1411	Number of persons by payer plan period start month
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
select 1411 as analysis_id, 
	TO_DATE(CAST(EXTRACT(YEAR FROM payer_plan_period_start_date)  AS varchar(4)) ||  RIGHT('0' || CAST(EXTRACT(MONTH FROM payer_plan_period_START_DATE) AS VARCHAR(2)), 2) || '01' , 'yyyymmdd') as stratum_1,
	 COUNT(distinct p1.PERSON_ID) as count_value
from
	ohdsi_omop.PERSON p1
	inner join ohdsi_omop.payer_plan_period ppp1
	on p1.person_id = ppp1.person_id
group by TO_DATE(CAST(EXTRACT(YEAR FROM payer_plan_period_start_date)  AS varchar(4)) ||  RIGHT('0' || CAST(EXTRACT(MONTH FROM payer_plan_period_START_DATE) AS VARCHAR(2)), 2) || '01' , 'yyyymmdd')
;
--



--
-- 1412	Number of persons by payer plan period end month
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
select 1412 as analysis_id,  
	TO_DATE(CAST(EXTRACT(YEAR FROM payer_plan_period_end_date)  AS varchar(4)) ||  RIGHT('0' || CAST(EXTRACT(MONTH FROM payer_plan_period_end_DATE) AS VARCHAR(2)), 2) || '01' , 'yyyymmdd') as stratum_1, 
	COUNT(distinct p1.PERSON_ID) as count_value
from
	ohdsi_omop.PERSON p1
	inner join ohdsi_omop.payer_plan_period ppp1
	on p1.person_id = ppp1.person_id
group by TO_DATE(CAST(EXTRACT(YEAR FROM payer_plan_period_end_date)  AS varchar(4)) ||  RIGHT('0' || CAST(EXTRACT(MONTH FROM payer_plan_period_end_DATE) AS VARCHAR(2)), 2) || '01' , 'yyyymmdd')
;
--


--
-- 1413	Number of persons by number of payer plan periods
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
select 1413 as analysis_id,  
	ppp1.num_periods as stratum_1, 
	COUNT(distinct p1.PERSON_ID) as count_value
from
	ohdsi_omop.PERSON p1
	inner join (select person_id, COUNT(payer_plan_period_start_date) as num_periods from ohdsi_omop.payer_plan_period group by PERSON_ID) ppp1
	on p1.person_id = ppp1.person_id
group by ppp1.num_periods
;
--

--
-- 1414	Number of persons with payer plan period before year-of-birth
insert into ohdsi_omop.ACHILLES_results (analysis_id, count_value)
select 1414 as analysis_id,  
	COUNT(distinct p1.PERSON_ID) as count_value
from
	ohdsi_omop.PERSON p1
	inner join (select person_id, MIN(EXTRACT(YEAR FROM payer_plan_period_start_date)) as first_obs_year from ohdsi_omop.payer_plan_period group by PERSON_ID) ppp1
	on p1.person_id = ppp1.person_id
where p1.year_of_birth > ppp1.first_obs_year
;
--

--
-- 1415	Number of persons with payer plan period end < start
insert into ohdsi_omop.ACHILLES_results (analysis_id, count_value)
select 1415 as analysis_id,  
	COUNT(ppp1.PERSON_ID) as count_value
from
	ohdsi_omop.payer_plan_period ppp1
where ppp1.payer_plan_period_end_date < ppp1.payer_plan_period_start_date
;
--



/********************************************

ACHILLES Analyses on COHORT table

*********************************************/


--
-- 1700	Number of records by cohort_concept_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
select 1700 as analysis_id, 
	cohort_definition_id as stratum_1, 
	COUNT(subject_ID) as count_value
from
	ohdsi_omop.cohort c1
group by cohort_definition_id
;
--


--
-- 1701	Number of records with cohort end date < cohort start date
insert into ohdsi_omop.ACHILLES_results (analysis_id, count_value)
select 1701 as analysis_id, 
	COUNT(subject_ID) as count_value
from
	ohdsi_omop.cohort c1
where c1.cohort_end_date < c1.cohort_start_date
;
--

/********************************************

ACHILLES Analyses on MEASUREMENT table

*********************************************/



--
-- 1800	Number of persons with at least one measurement occurrence, by measurement_concept_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
select 1800 as analysis_id, 
	m.measurement_CONCEPT_ID as stratum_1,
	COUNT(distinct m.PERSON_ID) as count_value
from
	ohdsi_omop.measurement m
group by m.measurement_CONCEPT_ID
;
--


--
-- 1801	Number of measurement occurrence records, by measurement_concept_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
select 1801 as analysis_id, 
	m.measurement_concept_id as stratum_1,
	COUNT(m.PERSON_ID) as count_value
from
	ohdsi_omop.measurement m
group by m.measurement_CONCEPT_ID
;
--



--
-- 1802	Number of persons by measurement occurrence start month, by measurement_concept_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, stratum_2, count_value)
select 1802 as analysis_id,   
	m.measurement_concept_id as stratum_1,
	EXTRACT(YEAR FROM measurement_date)*100 + EXTRACT(MONTH FROM measurement_date) as stratum_2, 
	COUNT(distinct PERSON_ID) as count_value
from
	ohdsi_omop.measurement m
group by m.measurement_concept_id, 
	EXTRACT(YEAR FROM measurement_date)*100 + EXTRACT(MONTH FROM measurement_date)
;
--



--
-- 1803	Number of distinct measurement occurrence concepts per person
CREATE TEMP TABLE tempResults

AS
WITH  rawData(count_value)  AS 
(
  select num_measurements as count_value
  from
	(
  	select m.person_id, COUNT(distinct m.measurement_concept_id) as num_measurements
  	from
  	ohdsi_omop.measurement m
  	group by m.person_id
	) t0
),
overallStats (avg_value, stdev_value, min_value, max_value, total) as
(
  select avg(1.0 * count_value) as avg_value,
    STDDEV(count_value) as stdev_value,
    min(count_value) as min_value,
    max(count_value) as max_value,
    COUNT(*) as total
  from rawData
),
stats (count_value, total, rn) as
(
  select count_value, 
  	COUNT(*) as total, 
		row_number() over (order by count_value) as rn
  FROM rawData
  group by count_value
),
priorStats (count_value, total, accumulated) as
(
  select s.count_value, s.total, sum(p.total) as accumulated
  from stats s
  join stats p on p.rn <= s.rn
  group by s.count_value, s.total, s.rn
)
 SELECT
 1803 as analysis_id,
  o.total as count_value,
  o.min_value,
	o.max_value,
	o.avg_value,
	o.stdev_value,
	MIN(case when p.accumulated >= .50 * o.total then count_value else o.max_value end) as median_value,
	MIN(case when p.accumulated >= .10 * o.total then count_value else o.max_value end) as p10_value,
	MIN(case when p.accumulated >= .25 * o.total then count_value else o.max_value end) as p25_value,
	MIN(case when p.accumulated >= .75 * o.total then count_value else o.max_value end) as p75_value,
	MIN(case when p.accumulated >= .90 * o.total then count_value else o.max_value end) as p90_value

FROM
 priorStats p
CROSS JOIN overallStats o
GROUP BY o.total, o.min_value, o.max_value, o.avg_value, o.stdev_value
;

insert into ohdsi_omop.ACHILLES_results_dist (analysis_id, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value)
select analysis_id, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value
from tempResults
;

truncate table tempResults;

drop table tempResults;


--



--
-- 1804	Number of persons with at least one measurement occurrence, by measurement_concept_id by calendar year by gender by age decile
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, stratum_2, stratum_3, stratum_4, count_value)
select 1804 as analysis_id,   
	m.measurement_concept_id as stratum_1,
	EXTRACT(YEAR FROM measurement_date) as stratum_2,
	p1.gender_concept_id as stratum_3,
	floor((EXTRACT(YEAR FROM measurement_date) - p1.year_of_birth)/10) as stratum_4, 
	COUNT(distinct p1.PERSON_ID) as count_value
from ohdsi_omop.PERSON p1
inner join ohdsi_omop.measurement m on p1.person_id = m.person_id
group by m.measurement_concept_id, 
	EXTRACT(YEAR FROM measurement_date),
	p1.gender_concept_id,
	floor((EXTRACT(YEAR FROM measurement_date) - p1.year_of_birth)/10)
;
--

--
-- 1805	Number of measurement records, by measurement_concept_id by measurement_type_concept_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, stratum_2, count_value)
select 1805 as analysis_id, 
	m.measurement_concept_id as stratum_1,
	m.measurement_type_concept_id as stratum_2,
	COUNT(m.PERSON_ID) as count_value
from ohdsi_omop.measurement m
group by m.measurement_concept_id,	
	m.measurement_type_concept_id
;
--



--
-- 1806	Distribution of age by measurement_concept_id
CREATE TEMP TABLE rawData_1806

AS
SELECT
 o1.measurement_concept_id as subject_id,
  p1.gender_concept_id,
	o1.measurement_start_year - p1.year_of_birth as count_value

FROM
 ohdsi_omop.PERSON p1
inner join
(
	select person_id, measurement_concept_id, min(EXTRACT(YEAR FROM measurement_date)) as measurement_start_year
	from ohdsi_omop.measurement
	group by person_id, measurement_concept_id
) o1
on p1.person_id = o1.person_id
;

CREATE TEMP TABLE tempResults

AS
WITH  overallStats (stratum1_id, stratum2_id, avg_value, stdev_value, min_value, max_value, total)  AS 
(
  select subject_id as stratum1_id,
    gender_concept_id as stratum2_id,
    avg(1.0 * count_value) as avg_value,
    STDDEV(count_value) as stdev_value,
    min(count_value) as min_value,
    max(count_value) as max_value,
    COUNT(*) as total
  FROM rawData_1806
	group by subject_id, gender_concept_id
),
stats (stratum1_id, stratum2_id, count_value, total, rn) as
(
  select subject_id as stratum1_id, gender_concept_id as stratum2_id, count_value, COUNT(*) as total, row_number() over (partition by subject_id, gender_concept_id order by count_value) as rn
  FROM rawData_1806
  group by subject_id, gender_concept_id, count_value
),
priorStats (stratum1_id, stratum2_id, count_value, total, accumulated) as
(
  select s.stratum1_id, s.stratum2_id, s.count_value, s.total, sum(p.total) as accumulated
  from stats s
  join stats p on s.stratum1_id = p.stratum1_id and s.stratum2_id = p.stratum2_id and p.rn <= s.rn
  group by s.stratum1_id, s.stratum2_id, s.count_value, s.total, s.rn
)
 SELECT
 1806 as analysis_id,
  o.stratum1_id,
  o.stratum2_id,
  o.total as count_value,
  o.min_value,
	o.max_value,
	o.avg_value,
	o.stdev_value,
	MIN(case when p.accumulated >= .50 * o.total then count_value else o.max_value end) as median_value,
	MIN(case when p.accumulated >= .10 * o.total then count_value else o.max_value end) as p10_value,
	MIN(case when p.accumulated >= .25 * o.total then count_value else o.max_value end) as p25_value,
	MIN(case when p.accumulated >= .75 * o.total then count_value else o.max_value end) as p75_value,
	MIN(case when p.accumulated >= .90 * o.total then count_value else o.max_value end) as p90_value

FROM
 priorStats p
join overallStats o on p.stratum1_id = o.stratum1_id and p.stratum2_id = o.stratum2_id 
GROUP BY o.stratum1_id, o.stratum2_id, o.total, o.min_value, o.max_value, o.avg_value, o.stdev_value
;

insert into ohdsi_omop.ACHILLES_results_dist (analysis_id, stratum_1, stratum_2, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value)
select analysis_id, stratum1_id, stratum2_id, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value
from tempResults
;

truncate table rawData_1806;
drop table rawData_1806;

truncate table tempResults;
drop table tempResults;


--

--
-- 1807	Number of measurement occurrence records, by measurement_concept_id and unit_concept_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, stratum_2, count_value)
select 1807 as analysis_id, 
	m.measurement_concept_id as stratum_1,
	m.unit_concept_id as stratum_2,
	COUNT(m.PERSON_ID) as count_value
from ohdsi_omop.measurement m
group by m.measurement_concept_id, m.unit_concept_id
;
--



--
-- 1809	Number of measurement records with invalid person_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, count_value)
select 1809 as analysis_id,  
	COUNT(m.PERSON_ID) as count_value
from ohdsi_omop.measurement m
	left join ohdsi_omop.PERSON p1 on p1.person_id = m.person_id
where p1.person_id is null
;
--


--
-- 1810	Number of measurement records outside valid observation period
insert into ohdsi_omop.ACHILLES_results (analysis_id, count_value)
select 1810 as analysis_id,  
	COUNT(m.PERSON_ID) as count_value
from ohdsi_omop.measurement m
	left join ohdsi_omop.observation_period op on op.person_id = m.person_id
	and m.measurement_date >= op.observation_period_start_date
	and m.measurement_date <= op.observation_period_end_date
where op.person_id is null
;
--



--
-- 1812	Number of measurement records with invalid provider_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, count_value)
select 1812 as analysis_id,  
	COUNT(m.PERSON_ID) as count_value
from ohdsi_omop.measurement m
	left join ohdsi_omop.provider p on p.provider_id = m.provider_id
where m.provider_id is not null
	and p.provider_id is null
;
--

--
-- 1813	Number of observation records with invalid visit_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, count_value)
select 1813 as analysis_id, COUNT(m.PERSON_ID) as count_value
from ohdsi_omop.measurement m
	left join ohdsi_omop.visit_occurrence vo on m.visit_occurrence_id = vo.visit_occurrence_id
where m.visit_occurrence_id is not null
	and vo.visit_occurrence_id is null
;
--


--
-- 1814	Number of measurement records with no value (numeric or concept)
insert into ohdsi_omop.ACHILLES_results (analysis_id, count_value)
select 1814 as analysis_id,  
	COUNT(m.PERSON_ID) as count_value
from
	ohdsi_omop.measurement m
where m.value_as_number is null
	and m.value_as_concept_id is null
;
--


--
-- 1815  Distribution of numeric values, by measurement_concept_id and unit_concept_id
CREATE TEMP TABLE rawData_1815

AS
SELECT
 measurement_concept_id as subject_id, 
	unit_concept_id,
	value_as_number as count_value

FROM
 ohdsi_omop.measurement m
where m.unit_concept_id is not null
	and m.value_as_number is not null
;

CREATE TEMP TABLE tempResults

AS
WITH  overallStats (stratum1_id, stratum2_id, avg_value, stdev_value, min_value, max_value, total)  AS 
(
  select subject_id as stratum1_id,
    unit_concept_id as stratum2_id,
    avg(1.0 * count_value) as avg_value,
    STDDEV(count_value) as stdev_value,
    min(count_value) as min_value,
    max(count_value) as max_value,
    COUNT(*) as total
  FROM rawData_1815
	group by subject_id, unit_concept_id
),
stats (stratum1_id, stratum2_id, count_value, total, rn) as
(
  select subject_id as stratum1_id, unit_concept_id as stratum2_id, count_value, COUNT(*) as total, row_number() over (partition by subject_id, unit_concept_id order by count_value) as rn
  FROM rawData_1815
  group by subject_id, unit_concept_id, count_value
),
priorStats (stratum1_id, stratum2_id, count_value, total, accumulated) as
(
  select s.stratum1_id, s.stratum2_id, s.count_value, s.total, sum(p.total) as accumulated
  from stats s
  join stats p on s.stratum1_id = p.stratum1_id and s.stratum2_id = p.stratum2_id and p.rn <= s.rn
  group by s.stratum1_id, s.stratum2_id, s.count_value, s.total, s.rn
)
 SELECT
 1815 as analysis_id,
  o.stratum1_id,
  o.stratum2_id,
  o.total as count_value,
  o.min_value,
	o.max_value,
	o.avg_value,
	o.stdev_value,
	MIN(case when p.accumulated >= .50 * o.total then count_value else o.max_value end) as median_value,
	MIN(case when p.accumulated >= .10 * o.total then count_value else o.max_value end) as p10_value,
	MIN(case when p.accumulated >= .25 * o.total then count_value else o.max_value end) as p25_value,
	MIN(case when p.accumulated >= .75 * o.total then count_value else o.max_value end) as p75_value,
	MIN(case when p.accumulated >= .90 * o.total then count_value else o.max_value end) as p90_value

FROM
 priorStats p
join overallStats o on p.stratum1_id = o.stratum1_id and p.stratum2_id = o.stratum2_id 
GROUP BY o.stratum1_id, o.stratum2_id, o.total, o.min_value, o.max_value, o.avg_value, o.stdev_value
;

insert into ohdsi_omop.ACHILLES_results_dist (analysis_id, stratum_1, stratum_2, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value)
select analysis_id, stratum1_id, stratum2_id, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value
from tempResults
;

truncate table rawData_1815;
drop table rawData_1815;

truncate table tempResults;
drop table tempResults;

--


--
-- 1816	Distribution of low range, by measurement_concept_id and unit_concept_id
CREATE TEMP TABLE rawData_1816

AS
SELECT
 measurement_concept_id as subject_id, 
	unit_concept_id,
	range_low as count_value

FROM
 ohdsi_omop.measurement m
where m.unit_concept_id is not null
	and m.value_as_number is not null
	and m.range_low is not null
	and m.range_high is not null
;

CREATE TEMP TABLE tempResults

AS
WITH  overallStats (stratum1_id, stratum2_id, avg_value, stdev_value, min_value, max_value, total)  AS 
(
  select subject_id as stratum1_id,
    unit_concept_id as stratum2_id,
    avg(1.0 * count_value) as avg_value,
    STDDEV(count_value) as stdev_value,
    min(count_value) as min_value,
    max(count_value) as max_value,
    COUNT(*) as total
  FROM rawData_1816
	group by subject_id, unit_concept_id
),
stats (stratum1_id, stratum2_id, count_value, total, rn) as
(
  select subject_id as stratum1_id, unit_concept_id as stratum2_id, count_value, COUNT(*) as total, row_number() over (partition by subject_id, unit_concept_id order by count_value) as rn
  FROM rawData_1816
  group by subject_id, unit_concept_id, count_value
),
priorStats (stratum1_id, stratum2_id, count_value, total, accumulated) as
(
  select s.stratum1_id, s.stratum2_id, s.count_value, s.total, sum(p.total) as accumulated
  from stats s
  join stats p on s.stratum1_id = p.stratum1_id and s.stratum2_id = p.stratum2_id and p.rn <= s.rn
  group by s.stratum1_id, s.stratum2_id, s.count_value, s.total, s.rn
)
 SELECT
 1816 as analysis_id,
  o.stratum1_id,
  o.stratum2_id,
  o.total as count_value,
  o.min_value,
	o.max_value,
	o.avg_value,
	o.stdev_value,
	MIN(case when p.accumulated >= .50 * o.total then count_value else o.max_value end) as median_value,
	MIN(case when p.accumulated >= .10 * o.total then count_value else o.max_value end) as p10_value,
	MIN(case when p.accumulated >= .25 * o.total then count_value else o.max_value end) as p25_value,
	MIN(case when p.accumulated >= .75 * o.total then count_value else o.max_value end) as p75_value,
	MIN(case when p.accumulated >= .90 * o.total then count_value else o.max_value end) as p90_value

FROM
 priorStats p
join overallStats o on p.stratum1_id = o.stratum1_id and p.stratum2_id = o.stratum2_id 
GROUP BY o.stratum1_id, o.stratum2_id, o.total, o.min_value, o.max_value, o.avg_value, o.stdev_value
;

insert into ohdsi_omop.ACHILLES_results_dist (analysis_id, stratum_1, stratum_2, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value)
select analysis_id, stratum1_id, stratum2_id, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value
from tempResults
;

truncate table rawData_1816;
drop table rawData_1816;

truncate table tempResults;
drop table tempResults;

--


--
-- 1817	Distribution of high range, by observation_concept_id and unit_concept_id
CREATE TEMP TABLE rawData_1817

AS
SELECT
 measurement_concept_id as subject_id, 
	unit_concept_id,
	range_high as count_value

FROM
 ohdsi_omop.measurement m
where m.unit_concept_id is not null
	and m.value_as_number is not null
	and m.range_low is not null
	and m.range_high is not null
;

CREATE TEMP TABLE tempResults

AS
WITH  overallStats (stratum1_id, stratum2_id, avg_value, stdev_value, min_value, max_value, total)  AS 
(
  select subject_id as stratum1_id,
    unit_concept_id as stratum2_id,
    avg(1.0 * count_value) as avg_value,
    STDDEV(count_value) as stdev_value,
    min(count_value) as min_value,
    max(count_value) as max_value,
    COUNT(*) as total
  FROM rawData_1817
	group by subject_id, unit_concept_id
),
stats (stratum1_id, stratum2_id, count_value, total, rn) as
(
  select subject_id as stratum1_id, unit_concept_id as stratum2_id, count_value, COUNT(*) as total, row_number() over (partition by subject_id, unit_concept_id order by count_value) as rn
  FROM rawData_1817
  group by subject_id, unit_concept_id, count_value
),
priorStats (stratum1_id, stratum2_id, count_value, total, accumulated) as
(
  select s.stratum1_id, s.stratum2_id, s.count_value, s.total, sum(p.total) as accumulated
  from stats s
  join stats p on s.stratum1_id = p.stratum1_id and s.stratum2_id = p.stratum2_id and p.rn <= s.rn
  group by s.stratum1_id, s.stratum2_id, s.count_value, s.total, s.rn
)
 SELECT
 1817 as analysis_id,
  o.stratum1_id,
  o.stratum2_id,
  o.total as count_value,
  o.min_value,
	o.max_value,
	o.avg_value,
	o.stdev_value,
	MIN(case when p.accumulated >= .50 * o.total then count_value else o.max_value end) as median_value,
	MIN(case when p.accumulated >= .10 * o.total then count_value else o.max_value end) as p10_value,
	MIN(case when p.accumulated >= .25 * o.total then count_value else o.max_value end) as p25_value,
	MIN(case when p.accumulated >= .75 * o.total then count_value else o.max_value end) as p75_value,
	MIN(case when p.accumulated >= .90 * o.total then count_value else o.max_value end) as p90_value

FROM
 priorStats p
join overallStats o on p.stratum1_id = o.stratum1_id and p.stratum2_id = o.stratum2_id 
GROUP BY o.stratum1_id, o.stratum2_id, o.total, o.min_value, o.max_value, o.avg_value, o.stdev_value
;

insert into ohdsi_omop.ACHILLES_results_dist (analysis_id, stratum_1, stratum_2, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value)
select analysis_id, stratum1_id, stratum2_id, count_value, min_value, max_value, avg_value, stdev_value, median_value, p10_value, p25_value, p75_value, p90_value
from tempResults
;

truncate table rawData_1817;
drop table rawData_1817;

truncate table tempResults;
drop table tempResults;

--



--
-- 1818	Number of observation records below/within/above normal range, by observation_concept_id and unit_concept_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, stratum_2, stratum_3, count_value)
select 1818 as analysis_id,  
	m.measurement_concept_id as stratum_1,
	m.unit_concept_id as stratum_2,
	case when m.value_as_number < m.range_low then 'Below Range Low'
		when m.value_as_number >= m.range_low and m.value_as_number <= m.range_high then 'Within Range'
		when m.value_as_number > m.range_high then 'Above Range High'
		else 'Other' end as stratum_3,
	COUNT(m.PERSON_ID) as count_value
from ohdsi_omop.measurement m
where m.value_as_number is not null
	and m.unit_concept_id is not null
	and m.range_low is not null
	and m.range_high is not null
group by measurement_concept_id,
	unit_concept_id,
	  case when m.value_as_number < m.range_low then 'Below Range Low'
		when m.value_as_number >= m.range_low and m.value_as_number <= m.range_high then 'Within Range'
		when m.value_as_number > m.range_high then 'Above Range High'
		else 'Other' end
;
--




--
-- 1820	Number of observation records by condition occurrence start month
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
select 1820 as analysis_id,   
	EXTRACT(YEAR FROM measurement_date)*100 + EXTRACT(MONTH FROM measurement_date) as stratum_1, 
	COUNT(PERSON_ID) as count_value
from ohdsi_omop.measurement m
group by EXTRACT(YEAR FROM measurement_date)*100 + EXTRACT(MONTH FROM measurement_date)
;
--

--
-- 1821	Number of measurement records with no numeric value
insert into ohdsi_omop.ACHILLES_results (analysis_id, count_value)
select 1821 as analysis_id,  
	COUNT(m.PERSON_ID) as count_value
from
	ohdsi_omop.measurement m
where m.value_as_number is null
;
--

--end of measurment analyses

/********************************************

Reports 

*********************************************/


--
-- 1900	concept_0 report

INSERT INTO ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, stratum_2, count_value)
select 1900 as analysis_id, table_name as stratum_1, source_value as stratum_2, cnt as count_value
 from (
select 'measurement' as table_name,measurement_source_value as source_value, COUNT(*) as cnt from ohdsi_omop.measurement where measurement_concept_id = 0 group by measurement_source_value 
union
select 'procedure_occurrence' as table_name,procedure_source_value as source_value, COUNT(*) as cnt from ohdsi_omop.procedure_occurrence where procedure_concept_id = 0 group by procedure_source_value 
union
select 'drug_exposure' as table_name,drug_source_value as source_value, COUNT(*) as cnt from ohdsi_omop.drug_exposure where drug_concept_id = 0 group by drug_source_value 
union
select 'condition_occurrence' as table_name,condition_source_value as source_value, COUNT(*) as cnt from ohdsi_omop.condition_occurrence where condition_concept_id = 0 group by condition_source_value 
) a
where cnt >= 1 --use other threshold if needed (e.g., 10)
order by a.table_name desc, cnt desc
;
--


/********************************************

ACHILLES Iris Analyses 

*********************************************/
--starting at id 2000

--
-- 2000	patients with at least 1 Dx and 1 Rx
insert into ohdsi_omop.ACHILLES_results (analysis_id, count_value)
select 2000 as analysis_id,  
--gender_concept_id as stratum_1, COUNT_BIG(distinct person_id) as count_value
        CAST(a.cnt AS BIGINT) AS count_value
    FROM (
                select COUNT(*) cnt from (
                    select distinct person_id from ohdsi_omop.condition_occurrence
                    intersect
                    select distinct person_id from ohdsi_omop.drug_exposure
                ) b
         ) a
         ;
--



--
-- 2001	patients with at least 1 Dx and 1 Proc
insert into ohdsi_omop.ACHILLES_results (analysis_id, count_value)
select 2001 as analysis_id,  
--gender_concept_id as stratum_1, COUNT_BIG(distinct person_id) as count_value
        CAST(a.cnt AS BIGINT) AS count_value
    FROM (
                select COUNT(*) cnt from (
                    select distinct person_id from ohdsi_omop.condition_occurrence
                    intersect
                    select distinct person_id from ohdsi_omop.procedure_occurrence
                ) b
         ) a
         ;
--



--
-- 2002	patients with at least 1 Mes and 1 Dx and 1 Rx
insert into ohdsi_omop.ACHILLES_results (analysis_id, count_value)
select 2002 as analysis_id,  
--gender_concept_id as stratum_1, COUNT_BIG(distinct person_id) as count_value
        CAST(a.cnt AS BIGINT) AS count_value
    FROM (
                select COUNT(*) cnt from (
                    select distinct person_id from ohdsi_omop.measurement
                    intersect
                    select distinct person_id from ohdsi_omop.condition_occurrence
                    intersect
                    select distinct person_id from ohdsi_omop.drug_exposure
                ) b
         ) a
         ;
--


--
-- 2003	Patients with at least one visit
-- this analysis is in fact redundant, since it is possible to get it via
-- dist analysis 203 and query select count_value from achilles_results_dist where analysis_id = 203;
insert into ohdsi_omop.ACHILLES_results (analysis_id, count_value)
select 2003 as analysis_id,  COUNT(distinct person_id) as count_value
from ohdsi_omop.visit_occurrence;
--


/********************************************

ACHILLES Analyses on DEVICE_EXPOSURE  table

*********************************************/



--
-- 2100	Number of persons with at least one device exposure , by device_concept_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
select 2100 as analysis_id, 
	m.device_CONCEPT_ID as stratum_1,
	COUNT(distinct m.PERSON_ID) as count_value
from
	ohdsi_omop.device_exposure m
group by m.device_CONCEPT_ID
;
--


--
-- 2101	Number of device exposure  records, by device_concept_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
select 2101 as analysis_id, 
m.device_CONCEPT_ID as stratum_1,
	COUNT(m.PERSON_ID) as count_value
from
	ohdsi_omop.device_exposure m
group by m.device_CONCEPT_ID
;
--



--
-- 2102	Number of persons by device by  start month, by device_concept_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, stratum_2, count_value)
select 2102 as analysis_id,   
	m.device_CONCEPT_ID as stratum_1,
	EXTRACT(YEAR FROM device_exposure_start_date)*100 + EXTRACT(MONTH FROM device_exposure_start_date) as stratum_2, 
	COUNT(distinct PERSON_ID) as count_value
from
	ohdsi_omop.device_exposure m
group by m.device_CONCEPT_ID, 
	EXTRACT(YEAR FROM device_exposure_start_date)*100 + EXTRACT(MONTH FROM device_exposure_start_date)
;
--

--2103 is not implemented at this point


--
-- 2104	Number of persons with at least one device occurrence, by device_concept_id by calendar year by gender by age decile
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, stratum_2, stratum_3, stratum_4, count_value)
select 2104 as analysis_id,   
	m.device_CONCEPT_ID as stratum_1,
	EXTRACT(YEAR FROM device_exposure_start_date) as stratum_2,
	p1.gender_concept_id as stratum_3,
	floor((EXTRACT(YEAR FROM device_exposure_start_date) - p1.year_of_birth)/10) as stratum_4, 
	COUNT(distinct p1.PERSON_ID) as count_value
from ohdsi_omop.PERSON p1
inner join ohdsi_omop.device_exposure m on p1.person_id = m.person_id
group by m.device_CONCEPT_ID, 
	EXTRACT(YEAR FROM device_exposure_start_date),
	p1.gender_concept_id,
	floor((EXTRACT(YEAR FROM device_exposure_start_date) - p1.year_of_birth)/10)
;
--


--
-- 2105	Number of exposure records by device_concept_id by device_type_concept_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, stratum_2, count_value)
select 2105 as analysis_id, 
	m.device_CONCEPT_ID as stratum_1,
	m.device_type_concept_id as stratum_2,
	COUNT(m.PERSON_ID) as count_value
from ohdsi_omop.device_exposure m
group by m.device_CONCEPT_ID,	
	m.device_type_concept_id
;
--

--2106 and more analyses are not implemented at this point





/********************************************

ACHILLES Analyses on NOTE table

*********************************************/



--
-- 2200	Number of persons with at least one device exposure , by device_concept_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
select 2200 as analysis_id, 
	m.note_type_CONCEPT_ID as stratum_1,
	COUNT(distinct m.PERSON_ID) as count_value
from
	ohdsi_omop.note m
group by m.note_type_CONCEPT_ID
;
--


--
-- 2201	Number of device exposure  records, by device_concept_id
insert into ohdsi_omop.ACHILLES_results (analysis_id, stratum_1, count_value)
select 2201 as analysis_id, 
m.note_type_CONCEPT_ID as stratum_1,
	COUNT(m.PERSON_ID) as count_value
from
	ohdsi_omop.note m
group by m.note_type_CONCEPT_ID
;
--





--final processing of results
delete from ohdsi_omop.ACHILLES_results where count_value <= 5;
delete from ohdsi_omop.ACHILLES_results_dist where count_value <= 5;

