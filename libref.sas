/*
   PROGRAM     LIBREF
   DESCRIPTION Assigns SAS library references according to the Library table meta data
   USAGE       %libref(libname);
   PARAMETERS  libname - is the name of the library storing the library data set
   REQUIRES    The Library data set corresponding to the Library table
   AUTHORS     T.Kolosova and S.Berestizhevsky
*/ 

  %macro libref (libname) ;

   /*
   The following DATA step creates macro variables and fills them with data from
   the library data set:
   libs - contains the number of libraries, defined in the library data set
   lib  - is a series of macro variables containing names of the libraries
   loc  - is a series of macro variables containing physical locations of these libraries.
   */

   %let libs = 0 ;
   data _null_ ;
      set &libname..Library ;
      call symput("libs", _n_) ;
      call symput("lib" || left(_n_), trim(library)) ;
      call symput("loc" || left(_n_),trim(location)) ;
   run ;

   /*
   The following loop generates required LIBNAME statements.
   */

   %if &libs > 0 %then
      %do i = 1 %to &libs ;
         libname &&lib&i "&&loc&i" ;
      %end ;

  %mend libref ;

  %libref(kernel) ;
