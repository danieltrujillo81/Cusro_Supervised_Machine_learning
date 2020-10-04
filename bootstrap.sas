/*
PROGRAM      BOOTSTRAP.SAS
DESCRIPTION  Creates training or testing dataset using bootstrap method.
USAGE        %BOOTSTRAP(data=, output =, samples=, size=, balanced=, random=) ;
PARAMETERS
   data     - input dataset
   output   - output for bootstrapped dataset
   samples  - number of resamples to generate 
   size     - size of each resample
   balanced - balanced resampling, or uniform resampling
   random   - seed for pseudorandom numbers
REQUIRES The object, property, location, library data sets must exist.
AUTHORS T.Kolosova and S.Berestizhevsky
REFERENCES
   Gleason, J.R. (1988) "Algorithms for balanced bootstrap simulations," 
      American Statistician, 42, 263-266;
*/
%macro bootstrap(data=, output =, samples=, size=, balanced=, random= );
   %if %upcase(&balanced) = B %then
      %bootsbalance(data=&data, samples=&samples, random=&random, output = &output);
   %else
      %bootsuni(data=&data, samples=&samples, random=&random, size=&size, output = &output);
%mend bootstrap;

/* Balanced bootstrap resampling */
%macro bootsbalance (data=, samples=, random=, output =);
*** find number of observations in the input data set;
   data _null_;
      set &data nobs=_nobs;
      call symput('_nobs',trim(left(_nobs)));
      stop;
   run;

   data &output ;
      drop _a _cbig _ii _j _jbig _k _s;
      array _c(&_nobs) _temporary_; /* cell counts */
      array _p(&_nobs) _temporary_; /* pointers */
      do _j=1 to &_nobs;
         _c(_j)=&samples;
      end;
      do _j=1 to &_nobs;
         _p(_j)=_j;
      end;
      _k=&_nobs; /* number of nonempty cells left */
      _jbig=_k; /* index of largest cell */
      _cbig = &samples; /* _cbig >= _c(_j) */
      do _sample_=1 to &samples;
         do _i=1 to &_nobs;
            do until(_s<=_c(_j));
               _j=ceil(ranuni(&random)*_k);
               /* choose a cell */
               _s=ceil(ranuni(&random)*_cbig);
               /* accept cell? */
            end;
            _l=_p(_j);
            _obs_=_l;
            _c(_j)+-1;
            if _j=_jbig then do;
               _a=floor((&samples-_sample_+_k)/_k);
               if _cbig-_c(_j)>_a then do;
                  do _ii=1 to _k;
                     if _c(_ii)>_c(_jbig) then _jbig=_ii;
                  end;
                  _cbig=_c(_jbig);
               end;
            end;
            if _c(_j)=0 then do;
               if _jbig=_k then _jbig=_j;
               _p(_j)=_p(_k);
               _c(_j)=_c(_k);
               _k+-1;
            end;
            set &data point = _l ;
            output;
         end;
      end;
      stop;
   run;
%mend bootsbalance;

/* Uniform bootstrap resampling */
%macro bootsuni (data=, samples=, random=, size=, output= );
*** find number of observations in the input data set;
   data _null_;
      set &data nobs=_nobs;
      call symput('_nobs',trim(left(_nobs)));
      stop;
   run;

   %if %bquote(&size)= %then %let size=&_nobs;
   %else %let size = %eval(&size*&_nobs/100) ;

   %do sample=1 %to &samples;
      data _tmp_&sample ;
         sample = &sample ;
         do _i=1 to &size;
            _p=ceil(ranuni(%eval(&random+&sample))*&_nobs);
            set &data point=_p;
            output ;
         end;
         stop;
      run;

      %if &sample > 1 %then %do ;
         proc append base = _tmp_1 data = _tmp_&sample ;
         run ;
      %end ;
   %end;

   data &output ;
      set _tmp_1 ;
   run ;
   proc datasets library = work memtype=data noprint ;
      delete
      %do sample=1 %to &samples;
         _tmp_&sample
      %end ;;
   run ;
   quit ;
%mend bootsuni;


%macro select(data=, samples=, random=, size=, output= );

   %if %bquote(&size)= %then %let size=100;

   %do sample=1 %to &samples;
      data _tmp_&sample ;
	     set &data ;
         sample = &sample ;
         if 100*ranuni(%eval(&random+&sample))<= &size 
            then output ;
      run;

      %if &sample > 1 %then %do ;
         proc append base = _tmp_1 data = _tmp_&sample ;
         run ;
      %end ;
   %end;

   data &output ;
      set _tmp_1 ;
   run ;

   proc datasets library = work memtype=data noprint ;
      delete
      %do sample=1 %to &samples;
         _tmp_&sample
      %end ;;
   run ;
   quit ;
%mend select;
