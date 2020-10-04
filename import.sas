/*
PROGRAM      IMPORT.SAS
DESCRIPTION  Imports data from CSV file into the specified table.
USAGE        %import(libref=, table=, update=, file=, mis=) ;
PARAMETERS
   libref - is the name of the library storing the data dictionary data sets.
   table  - is the name of the table to be updated. 
   file   - full name of the CSV file to be imported.
   mis    - is the code identifying the missing value.
REQUIRES The object, property, location, library data sets must exist.
AUTHORS T.Kolosova and S.Berestizhevsky
*/
%macro import(libref=, table=, file=, mis=) ;
   /*
   The following DATA step creates dataset macro variable containing 
   the name of data set corresponding to the specified table.
   */
   data _null_ ;
      set &libref..Object ;
      where upcase(left(table)) = upcase("&table") ;
      call symput("dataset", trim(dataset)) ;
   run ;
   %let count = 0 ;
   %let _icount = 0 ;

   /*
   The following DATA step creates macro variables and fills them
   with data from the property data set:
   count - contains number of columns of the specified table.
   _v0 - is a series of macro variables containing names of the
         columns of the specified table with their types and length.
   _v2 - is a series of macro variables containing names of the
         columns of the specified table for which indexes are defined.
   _v3 - is a series of macro variables containing names of the
         columns of the specified table with their titles.
   */
   data _null_ ;
      retain _count 1 _icount 0 ;
      call symput("_v0" || left(_count), "&mis") ;
      set &libref..Property ;
      where upcase(left(table)) = upcase("&table") ;
      call symput("_v3" || left(_count), trim(left(column))|| ' =
         %nrbquote(' || trim(left(title)) || ')') ;
      if index(upcase(attribut), "I") > 0 then
      do ;
         _icount + 1 ;
         call symput("_v2" || left(_icount), left(column)) ;
         call symput("_icount", left(_icount)) ;
      end ;
      if upcase(type) = "C" then
         call symput("_v0" || left(_count), trim(left(column)) ||
            " $" || left(length)) ;
      if upcase(type) = "N" then
         call symput("_v0" || left(_count), trim(left(column)) ||
            " " || left(length)) ;
      
	  if upcase(type) = "C" then
         call symput("_v1" || left(_count), trim(left(column)) ||
            " $") ;
      if upcase(type) = "N" then
         call symput("_v1" || left(_count), trim(left(column))) ;

      call symput("count", _count) ;

      _count + 1 ;
   run ;

   /*  
   The following DATA step creates macro variable containing name of the library 
   where generated SAS data set corresponding to the specified table must be 
   stored. 
   */
   data _null_ ; 
      set &libref..Location ; 
      where upcase(left(table)) = upcase("&table") ; 
  	  call symput("libname", left(library)) ; 
   run ; 

   /*
   The following DATA step generates SAS data set for the
   specified table according to the values of the macro variables
   created in the previous DATA step, and imports data from the CSV file.
   */
   data &libname..&dataset ;
      %let _EFIERR_ = 0; /* set the ERROR detection macro variable */
      infile "&file" delimiter = ',' MISSOVER DSD lrecl=32767 firstobs=2 ;
      length
      %do _j = 1 %to &count ;
         &&_v0&_j
      %end ;
      ;
      label
      %do _j = 1 %to &count ;
         &&_v3&_j
      %end ;
      ;    
      input
      %do _j = 1 %to &count ;
         &&_v1&_j
      %end ;
      ;    
      if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
   run;

   /*
   The following PROC SQL creates indexes, if any, for the SAS
   data set generated in the previous DATA step according to the
   values of the macro variables stored in the _v2 macro variable.
   */
   %if &_icount > 0 %then
   %do ;
      proc sql ;
      %if &_icount = 1 %then
      %do ;
         create index &&_v2&_icount on &libname..&dataset (&&_v2&_icount) ;
      %end ;
      %else %do ;
         create index __index on &dataset
         (&&_v21
         %do i = 2 %to &_icount ;
            , &&_v2&_icount
         %end ;
         ) ;
      %end ;
	  quit ;
   %end ;
%mend import ;
/*
%import(libref=kernel, table=contamination, 
file=C:\AI Book\Software\Data Dictionaries\contamination.csv, mis=.);
%import(libref=kernel, table=cont_experiment, 
file=C:\AI Book\Software\Data Dictionaries\cont_experiment.csv, mis=.);
%import(libref=kernel, table=experiment, 
file=C:\AI Book\Software\Data Dictionaries\experiment.csv, mis=.);
%import(libref=kernel, table=features, 
file=C:\AI Book\Software\Data Dictionaries\features.csv, mis=.);
%import(libref=kernel, table=hyperparameters_domain, 
file=C:\AI Book\Software\Data Dictionaries\hyperparameters_domain.csv, mis=.);

%import(libref=kernel, table=metrics, 
file=C:\AI Book\Software\Data Dictionaries\metrics.csv, mis=.);
%import(libref=kernel, table=ml_method, 
file=C:\AI Book\Software\Data Dictionaries\ml_method.csv, mis=.);
%import(libref=kernel, table=results, 
file=C:\AI Book\Software\Data Dictionaries\results.csv, mis=.);
%import(libref=kernel, table=results_metrics, 
file=C:\AI Book\Software\Data Dictionaries\results_metrics.csv, mis=.);

%import(libref=kernel, table=structure, 
file=C:\AI Book\Software\Data Dictionaries\structure.csv, mis=.);
%import(libref=kernel, table=bias_correction, 
file=C:\AI Book\Software\Data Dictionaries\bias_correction.csv, mis=.);

%import(libref=kernel, table=outlier_detection, 
file=C:\AI Book\Software\Data Dictionaries\outlier_detection.csv, mis=.);
%import(libref=kernel, table=input, 
file=C:\AI Book\Software\Data Dictionaries\input.csv, mis=.);

%import(libref=kernel, table=bootstrap, 
file=C:\AI Book\Software\Data Dictionaries\bootstrap.csv, mis=.);
%import(libref=kernel, table=output, 
file=C:\AI Book\Software\Data Dictionaries\output.csv, mis=.);
*/
