/*
PROGRAM      DATASET.SAS
DESCRIPTION  Creates SAS data set for the specified table.
USAGE        %dataset(libref=, table=, mis=) ;
PARAMETERS
   libref - is the name of the library storing the data dictionary data sets.
   table  - is the name of the table for which is required to create the SAS data set. 
            If the value of the parameter equal _ALL_, all defined data sets are created.
   mis    - is the code identifying the missing value.
REQUIRES The object, property, location, library data sets must exist.
AUTHORS T.Kolosova and S.Berestizhevsky
*/
%macro dataset (libref=, table=, mis=) ;
   /*
   The following DATA step creates an array of macro variables containing 
   the names of data sets corresponding to all tables in Object.
   */
   %if &table = _ALL_ %then %do ;
      data _null_ ;
         set &libref..Object ;
		 retain tables 0 ;
		 tables + 1 ;
		 call symput("tables", trim(left(tables))) ;
         call symput("table"||trim(left(tables)), trim(left(table))) ;
      run ;
   %end ;
   %else %do ;
      %let tables = 1 ;
	  %let table1 = &table ;
   %end ;
   %do _dataset_i = 1 %to &tables ;
      /*
      The following DATA step creates dataset macro variable containing 
      the name of data set corresponding to the specified table.
      */
      data _null_ ;
         set &libref..Object ;
         where upcase(left(table)) = upcase("&&table&_dataset_i") ;
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
         where upcase(left(table)) = upcase("&&table&_dataset_i") ;
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
         where upcase(left(table)) = upcase("&&table&_dataset_i") ; 
  	     call symput("libname", left(library)) ; 
  	  run ; 

      /*
      The following DATA step generates SAS data set for the
      specified table according to the values of the macro variables
      created in the previous DATA step.
      */
      data &libname..&dataset ;
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
         stop ;
      run ;

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
   %end ;
      
%mend dataset ;

%dataset(libref=kernel, table=_ALL_, mis=.);

