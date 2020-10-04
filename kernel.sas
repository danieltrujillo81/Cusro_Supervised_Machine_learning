/*
  PROGRAM     KERNEL
  DESCRIPTION Creates four SAS data sets: library, object, location and property,
              and fills in these datasets wiht meta data
  USAGE       define library in %let libref = <libref>;
  PARAMETERS  libref  - is the name of the library that stores created data sets          
  REQUIRES    
  AUTHORS     T.Kolosova and S.Berestizhevsky
*/
%let libref = kernel ;
	
data &libref..library ;
   length LIBRARY $ 8 ; label LIBRARY = "SAS library name" ;
   length LOCATION $ 80 ; 
      label LOCATION = "Operating system-specic file name for SAS library" ;
   infile datalines delimiter=','; 
   input LIBRARY $ LOCATION $;
   datalines;
kernel,C:\AI Book\Software\Data Dictionaries
data,C:\AI Book\Software\Application Data
;
run ;

data &libref..object ;
   length TABLE $ 32 ; label TABLE = "Table name" ;
   length TITLE $ 80 ; label TITLE = "Table title" ;
   length DATASET $ 32 ; 
      label DATASET = "SAS or R dataset name where data of the table is stored" ;
   infile datalines delimiter=','; 
   input TABLE $ TITLE $ DATASET $;
   datalines;
MESSAGE,Message table lists application messages,MESSAGE
LINK,Tables linked by foreign keys,LINK
INPUT,References to data cleansing processes,INPUT
STRUCTURE,Properties of datasets,STRUCTURE
OUTLIER_DETECTION,Cleansing methods,OUTLIER_DETECTION
BIAS_CORRECTION,Cleansing methods parameters,BIAS_CORRECTION
BOOTSTRAP,Bootstrap processes,BOOTSTRAP
OUTPUT,Output from bootstrap and cleansing,OUTPUT
EXPERIMENT,Experiemnt description,EXPERIMENT
FEATURES,List of Features,FEATURES
METRICS,Metrics and their cutoff values,METRICS
ML_METHOD,Machine learning method and its hyparameters,ML_METHOD
HYPERPARAMETERS_DOMAIN,Hyperparameters domain values,HYPERPARAMETERS_DOMAIN
RESULTS,Results of experiments,RESULTS
RESULTS_METRICS,Values of classification metrics results,RESULTS_METRICS
CONTAMINATION,Training dataset contamination,CONTAMINATION
CONT_EXPERIMENT,Training dataset labels contamination,CONT_EXPERIMENT
CONT_RESULTS,Results of contamination experiments,CONT_RESULTS
CONT_METRIC,Metrics of contamination experiments,CONT_METRIC
INSURANCE_DATA,Insurance underwriting data,INSURANCE_DATA
;
run ;

data &libref..location;
   length TABLE $ 32 ; label TABLE = "Table name" ;
   length LIBRARY $ 8 ; label LIBRARY = "SAS library name" ;
   infile datalines delimiter=','; 
   input TABLE $ LIBRARY $;
   datalines;
MESSAGE, kernel
LINK, kernel
INPUT, kernel
STRUCTURE, kernel
OUTLIER_DETECTION, kernel
BIAS_CORRECTION, kernel
BOOTSTRAP, kernel
OUTPUT, kernel
EXPERIMENT, kernel
FEATURES, kernel
METRICS, kernel
ML_METHOD, kernel
HYPERPARAMETERS_DOMAIN, kernel
RESULTS, kernel
RESULTS_METRICS, kernel
CONTAMINATION, kernel
CONT_EXPERIMENT, kernel
CONT_RESULTS, kernel
CONT_METRIC, kernel
INSURANCE_DATA, data
;
run ;

data &libref..property ;
   length TABLE $ 32 ; label TABLE = "Table name" ;
   length COLUMN $ 32 ; label COLUMN = "Column name" ;
   length TITLE $ 80 ; label TITLE = "Column title" ;
   length TYPE $ 1 ; label TYPE = "Column data type: C—character or N—numeric" ;
   length LENGTH 8 ; label LENGTH = "Column length" ;
   length ATTRIBUT $ 2 ; label ATTRIBUT = "Column property: P—primary key" ;
   length DOMTAB $ 32 ; label DOMTAB = "Domain table name" ;
   length DOMCOL $ 32 ; label DOMCOL = "Domain column name" ;
   length MEANTAB $ 32 ; label MEANTAB = "Meaning table name" ;
   length MEANCOL $ 32; label MEANCOL = "Meaning column name" ;
   length INITVAL $ 80 ; label INITVAL = "Initial column’s value" ;
   length FORMULA $ 80 ; label FORMULA = "The formula for the computed column" ;
   length MISSING $ 1 ; label MISSING = "Code of missing value" ;
   length MESSAGE 8 ; label MESSAGE = "Error message identification number" ;
   infile datalines delimiter=','; 
   input TABLE $ COLUMN $ TITLE $ TYPE $ LENGTH ATTRIBUT $ DOMTAB $ DOMCOL $ 
         MEANTAB $ MEANCOL $ INITVAL $ FORMULA $ MISSING $ MESSAGE;
   datalines;
MESSAGE,MESSAGE,Message identification number,N,8,P, , , , , , ,.,.
MESSAGE,TEXT,Message text,C,80, , , , , , , , ,.
MESSAGE,MESTYPE,Message type: E—rror message W—warning I—informative message,C,1, , , , , ,W, , ,.
MESSAGE,OUTPUT,Output message destination: S—screen and/or D—dataset,C,2, , , , , ,S, , ,.
LINK,TABLE,Table name,C,32,P, , , , , , , ,.
LINK,RELTABLE,Name of the related table,C,32,P, , , , , , , ,.
LINK,COLUMN,Column name,C,32,P, , , , , , , ,.
LINK,RELCOL,Name of the column from the related table,C,32,P, , , , , , , ,.
INPUT,INPUT_ID,Input ID,C,8,P, , , , , , , ,.
INPUT,TITLE,Input ID title,C,80, , , , , , , , ,.
INPUT,DATASET,Dataset (file) name,C,32, , , , , , , , ,.
INPUT,OUTLIER_DETECTION_ID,Reference to the primary key of the Outlier_Detection table,C,8, , , , , , , , ,.
INPUT,BIAS_CORRECTION_ID,Reference to the primary key of the Bias_Correction table,C,8, , , , , , , , ,.
INPUT,OUTPUT_TABLE_ID,Reference to the primary key of the Output table,C,8, , , , , , , , ,.
STRUCTURE,DATASET,Dataset name ,C,32,P, , , , , , , ,.
STRUCTURE,VARIABLE_NAME,Variable name ,C,32,P, , , , , , , ,.
STRUCTURE,VARIABLE_TITLE,Variable title ,C,80, , , , , , , , ,.
STRUCTURE,VARIABLE_TYPE,Variable type: C—character or N—numeric,C,1, , , , , , , , ,.
STRUCTURE,VARIABLE_LENGTH,Variable length ,N,8, , , , , , , ,.,.
STRUCTURE,VARIABLE_ROLE,Variable role: F(eature) or L(abel) ,C,1, , , , , , , , ,.
STRUCTURE,FORMULA,Formula for computed variable ,C,80, , , , , , , , ,.
STRUCTURE,MISSING,Code of missing value,C,1, , , , , , , , ,.
OUTLIER_DETECTION,OUTLIER_DETECTION_ID,Outlier detection procedure ID,C,8,P, , , , , , , ,.
OUTLIER_DETECTION,METHOD,Method name ,C,8, , , , , , , , ,.
OUTLIER_DETECTION,H,H value with default (3*n + p + 1)/4,N,8, , , , , , , ,.,.
OUTLIER_DETECTION,CUTOFFALPHA,Cut-off Alpha value with default 0.025,N,8, , , , , ,0.025, ,.,.
OUTLIER_DETECTION,MCDALPHA,MCD Alpha value with default 0.025,N,8, , , , , ,0.025, ,.,.
BIAS_CORRECTION,BIAS_CORRECTION_ID,Bias correction ID,C,8,P, , , , , , , ,.
BIAS_CORRECTION,BIAS_TITLE,Bias correction title,C,8, , , , , , , , ,.
BIAS_CORRECTION,SID,Sequential number ,C,8,P, , , , , , , ,.
BIAS_CORRECTION,VAR_NAME,Name of the dataset variable,C,32, , , , , , , , ,.
BIAS_CORRECTION,METRIC,Metric: M(ean) M(e)D(ian),C,8, , , , , ,MEDIAN, , ,.
BIAS_CORRECTION,BTS_ID,Reference to the Bootstrap table,C,8, , , , , , , , ,.
BOOTSTRAP,BTS_ID,Bootstrap ID,C,8,P, , , , , , , ,.
BOOTSTRAP,BTS_TITLE,Bootstrap title,C,8, , , , , , , , ,.
BOOTSTRAP,RESAMPLE_SIZE_PCT,Percent of sample for m-out-of-n bootstrap,N,8, , , , , , , ,.,.
BOOTSTRAP,REPLICATIONS,Number of subsamples to be created,N,8, , , , , , , ,.,.
BOOTSTRAP,DISTRIBUTION,Name of the distribution for random sample selection,C,1, , , , , ,U, , ,.
BOOTSTRAP,STRATA_VAR,Name of a variable that defines strata,C,32, , , , , , , , ,.
OUTPUT,OUTPUT_TABLE_ID,Output ID,C,8,P, , , , , , , ,.
OUTPUT,OUTPUT_ROLE,Output data role,C,8,P, , , , , , , ,.
OUTPUT,TABLE_PREFIX,Prefix of output table name,C,8, , , , , , , , ,.
OUTPUT,WITH_RETURN,Select data from input dataset with or without return,C,1, , , , , ,N, , ,.
OUTPUT,DATA_PCT,Percent of input data used to create output table,N,8, , , , , , , ,.,.
OUTPUT,BTS_ID,Reference to the Bootstrap table,C,8, , , , , , , , ,.
EXPERIMENT,EXP_ID,Experiment ID,C,8,P, , , , , , , ,.
EXPERIMENT,FEATURE_ID,Reference to the primary key of the Features table,C,8, , , , , , , , ,.
EXPERIMENT,METHOD_ID,Reference to the primary key of the ML_Method table,C,8, , , , , , , , ,.
EXPERIMENT,METRIC_ID,Reference to the primary key of the Metrics table,C,8, , , , , , , , ,.
EXPERIMENT,DESIGN,Type of design of experiment,C,4, , , , , , , , ,.
EXPERIMENT,MODEL,Type of model of possible effects of factors on response,C,8, , , , , , , , ,.
FEATURES,FEATURE_ID,Features set ID,C,8,P, , , , , , , ,.
FEATURES,OUTPUT_TABLE_ID,Reference to the primary key of the Output table of input component data dictionary,C,8,P, , , , , , , ,.
FEATURES,OUTPUT_ROLE,Reference to the primary key of the Output table,C,80,P, , , , , , , ,.
FEATURES,VAR_NAME,Variable name from the output table,C,32,P, , , , , , , ,.
METRICS,METRIC_ID,Metric ID,C,8,P, , , , , , , ,.
METRICS,SID,Sequential number,C,8,P, , , , , , , ,.
METRICS,METRIC,Metric name,C,8, , , , , , , , ,.
METRICS,MIN_CUTOFF,Minimum cutoff value for a metric,N,8, , , , , , , ,.,.
METRICS,MAX_CUTOFF,Maximum cutoff value for a metric,N,8, , , , , , , ,.,.
ML_METHOD,METHOD_ID,Machine learning method ID,C,8,P, , , , , , , ,.
ML_METHOD,METHOD_NAME,Machine learning method name,C,8,P, , , , , , , ,.
ML_METHOD,KERNEL,Kernel transformation name,C,8,P, , , , , , , ,.
ML_METHOD,PAR_NAME,Reference to the Hyperparameters_Domain table,C,8,P, , , , , , , ,.
ML_METHOD,MIN_VALUE,Minimum value of hyperparameter,N,8, , , , , , , ,.,.
ML_METHOD,MAX_VALUE,Maximum value of hyperparameter,N,8, , , , , , , ,.,.
ML_METHOD,LEVELS,Number of levels for values of hyperparameters,N,8, , , , , , , ,.,.
HYPERPARAMETERS_DOMAIN,METHOD_NAME,ML method name,C,8,P, , , , , , , ,.
HYPERPARAMETERS_DOMAIN,KERNEL,Kernel name,C,8,P, , , , , , , ,.
HYPERPARAMETERS_DOMAIN,PAR_NAME,Hyperparameter name,C,8,P, , , , , , , ,.
HYPERPARAMETERS_DOMAIN,VALUE_TYPE,Value type: I(nteger) C(continues),C,1, , , , , , , , ,.
HYPERPARAMETERS_DOMAIN,UPPER_VALUE,Highest possible value of the hyperparameter,N,8, , , , , , , ,.,.
HYPERPARAMETERS_DOMAIN,LOWER_VALUE,Lowest possible value of the hyperparameter,N,8, , , , , , , ,.,.
RESULTS,EXP_ID,Experiment ID,C,8,P, , , , , , , ,.
RESULTS,SID,Sequential number ID,N,8,P, , , , , , ,.,.
RESULTS,FEATUIRE_ID,Feature ID,C,8, , , , , , , , ,.
RESULTS,RESULT_METRIC_ID,Result metric ID,C,8, , , , , , , , ,.
RESULTS,METHOD_NAME,ML method,C,8, , , , , , , , ,.
RESULTS,KERNEL,Kernel name,C,8, , , , , , , , ,.
RESULTS,PAR_NAME,Hyperparameter name,C,8, , , , , , , , ,.
RESULTS,LEVEL_VALUE,Optimal level for hyperparameter,N,8, , , , , , , ,.,.
RESULTS_METRICS,RESULT_METRIC_ID,Result metric ID,C,8,P, , , , , , , ,.
RESULTS_METRICS,METRIC_ID,Metric ID,C,8,P, , , , , , , ,.
RESULTS_METRICS,METRIC_SID,Sequential number ,N,8,P, , , , , , ,.,.
RESULTS_METRICS,METRIC_VALUE,Result metric value,N,8, , , , , , , ,.,.
CONTAMINATION,CONT_ID,Contamination ID,C,8,P, , , , , , , ,.
CONTAMINATION,EXP_ID,Reference to Design of Experiment for ML,C,8,P, , , , , , , ,.
CONTAMINATION,METRIC_ID,Reference to Metric table ,C,8, , , , , , , , ,.
CONT_EXPERIMENT,CONT_ID,Contamination ID,C,8,P, , , , , , , ,.
CONT_EXPERIMENT,SID,Sequential number,N,8,P, , , , , , ,.,.
CONT_EXPERIMENT,PCT_CONT_0,Percent of contamination of labels for 0,N,8, , , , , , , ,.,.
CONT_EXPERIMENT,PCT_CONT_1,Percent of contamination of labels for 1,N,8, , , , , , , ,.,.
CONT_RESULTS,CONT_ID,Contamination ID,C,8,P, , , , , , , ,.
CONT_RESULTS,EXP_ID,Reference to the Results table,C,8,P, , , , , , , ,.
CONT_RESULTS,EXP_SID,Reference to the Results table,C,8,P, , , , , , , ,.
CONT_RESULTS,CONT_SID,Sequential number of contamination,C,8,P, , , , , , , ,.
CONT_RESULTS,CONT_METRIC_ID,Contamination Metric ID,C,4, , , , , , , , ,.
CONT_METRIC,CONT_METRIC_ID,Contamination Metric ID,C,8,P, , , , , , , ,.
CONT_METRIC,METRIC_ID,Reference to Metric table ,C,8,P, , , , , , , ,.
CONT_METRIC,METRIC_SID,Sequential number for METRIC_ID,C,8,P, , , , , , , ,.
CONT_METRIC,METRIC_VALUE,Value of specified metric,N,8, , , , , , , ,.,.
INSURANCE_DATA,SID,Record ID,C,23,P, , , , , , , ,
INSURANCE_DATA,POLICY_TYPE,New or Renewal,C,7, , , , , , , , ,
INSURANCE_DATA,ISWON,Bound Label ,N,8, , , , , , , , ,
INSURANCE_DATA,UNDERWRITER,Underwriter ID,C,18, , , , , , , , ,
INSURANCE_DATA,STATE,State,C,14, , , , , , , , ,
INSURANCE_DATA,INDUSTRY,Industry,C,23, , , , , , , , ,
INSURANCE_DATA,DECLINED_REASON,Reason to Decline,C,38, , , , , , , , ,
INSURANCE_DATA,EFFECTIVE_MONTH,Policy Effective Month,C,3, , , , , , , , ,
INSURANCE_DATA,EMPLOYEES,N of employees,N,8, , , , , , , , ,
INSURANCE_DATA,EFFECTIVE_YEAR,Policy Effective Year,N,8, , , , , , , , ,
INSURANCE_DATA,MARKET_SEGMENT,Market Segment,C,23, , , , , , , , ,
INSURANCE_DATA,PLACING_BROKER,Broker ID,C,18, , , , , , , , ,
INSURANCE_DATA,POLICY_LIMIT,Policy Limit,N,8, , , , , , , , ,
INSURANCE_DATA,COVERAGE,Policy Coverage,C,84, , , , , , , , ,
INSURANCE_DATA,DEDUCTIBLE,Deductible,N,8, , , , , , , , ,
INSURANCE_DATA,PREMIUM,Premium,N,8, , , , , , , , ,
INSURANCE_DATA,APPLICATION_DATE,Application Date,N,8, , , , , , , , ,
INSURANCE_DATA,BOUND_DATE,Bound Date,N,8, , , , , , , , ,
INSURANCE_DATA,EXPIRING_PREMIUM,Premium of Expiring Policy,N,8, , , , , , , , ,
INSURANCE_DATA,COMMISSION_PERCENT,Commission Percent,N,8, , , , , , , , ,
;   
run ;

/***/
