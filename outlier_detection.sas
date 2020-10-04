/* outlier detection */

%macro outlier_detection(libref= , _input_DATASET=, _input_OUTLIER_DETECTION_ID=, 
                         _input_BIAS_CORRECTION_ID=, work_ds=) ;
   /* Get outlier_detection metadata */
   data _null_ ;
      set &libref..outlier_detection ;
	  where trim(left(upcase(outlier_detection_id))) = 
         trim(left(upcase("&_input_OUTLIER_DETECTION_ID"))) ;
	  call symput("_outlier_detection_METHOD", trim(left(METHOD))) ;
	  call symput("_outlier_detection_H", trim(left(H))) ;
	  call symput("_outlier_detection_CUTOFFALPHA", trim(left(CUTOFFALPHA))) ;
	  call symput("_outlier_detection_MCDALPHA", trim(left(MCDALPHA))) ;
   run ;

   /* Get structure metadata */
   data _null_ ;
      set &libref..structure ;
	  where trim(left(upcase(dataset))) = trim(left(upcase("&_input_DATASET")))
         and trim(left(upcase(variable_type))) = "N"
         and trim(left(upcase(variable_role))) = "F";
	  retain count 0 ;
      count +  1 ;
	  call symput("_structure_count", trim(left(count))) ;
	  call symput("_structure_NAME"||trim(left(count)), trim(left(VARIABLE_NAME))) ;
   run ;
   
   data _outlier_tmp ;
      set &work_ds ;
	  _outlier_y = ranuni(1) ;
   run ;

   /* Get bias_correction metadata */
   data _null_ ;
      set &libref..bias_correction ;
	  where trim(left(upcase(bias_correction_id))) = 
         trim(left(upcase("&_input_BIAS_CORRECTION_ID"))) ;
	  retain count 0 ;
      count +  1 ;
	  call symput("_bias_correction_count", trim(left(count))) ;
	  call symput("_bias_correction_VAR_NAME"||trim(left(count)), trim(left(VAR_NAME))) ;
   run ;

   proc robustreg data=_outlier_tmp method=lts ;
      model _outlier_y = 
      %do _i = 1 %to &_bias_correction_count ;
	     &&_bias_correction_VAR_NAME&_i
	  %end ; / leverage(MCDInfo
         %if &_outlier_detection_H ^= . and &_outlier_detection_H ^= %then
		    H = &_outlier_detection_H ;
         %if &_outlier_detection_CUTOFFALPHA ^= . and 
             &_outlier_detection_CUTOFFALPHA ^= %then
			 cutoffalpha = &_outlier_detection_CUTOFFALPHA ;
         %if &_outlier_detection_MCDALPHA ^= . and 
             &_outlier_detection_MCDALPHA ^= %then
             mcdalpha = &_outlier_detection_MCDALPHA ;
      ) ;
      output out=_outlier_tmp_output outlier=_outlier;
   run;
 
   data &work_ds (drop = _outlier);
      set _outlier_tmp_output ;
	  if _outlier = 1 then delete ;
   run ;

   proc datasets library = work memtype=data noprint ;
      delete _outlier_tmp _outlier_tmp_output ;
   run ;
   quit ;

%mend outlier_detection ;

%outlier_detection(libref=kernel, _input_DATASET=INSURANCE_DATA, 
                   _input_OUTLIER_DETECTION_ID=1, 
                   _input_BIAS_CORRECTION_ID=1, work_ds=_output_tmp) ;
