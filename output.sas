/* output dataset */

%macro output(libref=, input_id=) ;
   /* Get input metadata */
   data _null_ ;
      set &libref..input ;
	  where trim(left(upcase(input_id))) = trim(left(upcase("&input_id")));
	  call symput("_input_TITLE", trim(left(TITLE))) ;
      call symput("_input_DATASET", trim(left(DATASET))) ;
      call symput("_input_OUTLIER_DETECTION_ID", trim(left(OUTLIER_DETECTION_ID))) ;
      call symput("_input_BIAS_CORRECTION_ID", trim(left(BIAS_CORRECTION_ID))) ;
      call symput("_input_OUTPUT_TABLE_ID", trim(left(OUTPUT_TABLE_ID))) ;
      stop ;
   run ;

   /* Get object, location metadata */
   data _null_ ;
      merge &libref..object ;
	  where trim(left(upcase(DATASET))) = trim(left(upcase("&_input_DATASET")));
	  call symput("_object_TABLE", trim(left(TABLE))) ;
      stop ;
   run ;
   data _null_ ;
      merge &libref..location ;
	  where trim(left(upcase(TABLE))) = trim(left(upcase("&_object_TABLE")));
	  call symput("_location_LIBRARY", trim(left(LIBRARY))) ;
      stop ;
   run ;

   /* Get structure metadata */
   data _null_ ;
      set &libref..structure ;
	  where trim(left(upcase(dataset))) = trim(left(upcase("&_input_DATASET")));
	  retain count 0 ;
      count +  1 ;
	  call symput("_structure_count", trim(left(count))) ;
	  call symput("_structure_NAME"||trim(left(count)), trim(left(VARIABLE_NAME))) ;
      call symput("_structure_ROLE"||trim(left(count)), trim(left(VARIABLE_ROLE))) ;
   run ;

   /* Get output metadata */
   data _null_ ;
      set &libref..output ;
	  where trim(left(upcase(OUTPUT_TABLE_ID))) = trim(left(upcase("&_input_OUTPUT_TABLE_ID")));
	  retain count 0 ;
      count +  1 ;
	  call symput("_output_count", trim(left(count))) ;
	  call symput("_output_ROLE"||trim(left(count)), trim(left(OUTPUT_ROLE))) ;
	  call symput("_output_TABLE_PREFIX"||trim(left(count)), trim(left(TABLE_PREFIX))) ;
	  call symput("_output_WITH_RETURN"||trim(left(count)), trim(left(WITH_RETURN))) ;
	  call symput("_output_DATA_PCT"||trim(left(count)), trim(left(DATA_PCT))) ;
	  call symput("_output_BTS_ID"||trim(left(count)), trim(left(BTS_ID))) ;
   run ;

   data _output_tmp ;
	  set &_location_LIBRARY..&_input_DATASET ;
      keep 
	  %do _i = 1 %to &_structure_count ;
	     &&_structure_NAME&_i
	  %end ;;
   run ;

   /* outlier detection */
   %outlier_detection(libref=&libref, _input_DATASET=&_input_DATASET, 
                   _input_OUTLIER_DETECTION_ID=&_input_OUTLIER_DETECTION_ID, 
                   _input_BIAS_CORRECTION_ID=&_input_BIAS_CORRECTION_ID, 
                   work_ds=_output_tmp) ;
   %goto exit;
   /* bias correction */

   /* create training and testing datasets using bootstrap */
   %do _i = 1 %to &_output_count ;
      /* create data set for bootstrap */

      %if %upcase(&&_output_WITH_RETURN&_i) = Y %then 
	      %bootsuni(data=_output_tmp, samples=1, random=&seed, 
                    size=&&_output_DATA_PCT&_i, 
                    output = &&_output_TABLE_PREFIX&_i);

      %else %select(data=_output_tmp, samples=1, random=&seed, 
                    size=&&_output_DATA_PCT&_i, 
                    output = &&_output_TABLE_PREFIX&_i);

      data &&_output_TABLE_PREFIX&_i ;
	     set &&_output_TABLE_PREFIX&_i ;
         keep 
	     %do _i2 = 1 %to &_structure_count ;
	        &&_structure_NAME&_i2  
	     %end ;;
      run ;

   %end ;
%exit: 
%mend output ;


%output(libref=kernel, input_id=1) ;
