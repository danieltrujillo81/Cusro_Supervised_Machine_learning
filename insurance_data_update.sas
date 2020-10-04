proc freq data=data.insurance_data_raw ;
   table market_segment policy_limit coverage deductible premium 
         expiring_premium commission_percent /missing;
run ;

proc sort data = data.insurance_data_raw out = tmp ;
   by market_segment ;
run ;
proc means data=tmp(where=(policy_limit>0 and employees>0)) ;
   by market_segment ;
   var policy_limit;
run ;

proc reg data = data.insurance_data_raw (where=(premium > 0 and employees>0
                and premium < 2000000)) ;
   model premium = employees  ;
run ;

proc gplot data = data.insurance_data_raw (where=(deductible>0 and employees>0
                  and deductible < 1000000 and employees<10000)) ;
   plot deductible * employees  ;
run ;
quit ;
proc reg data = data.insurance_data_raw (where=(deductible > 0 and employees>0
                and deductible < 1000000 and employees<10000)) ;
   model deductible = employees  ;
run ;
quit ;

proc sgplot data = data.insurance_data_raw (where=(commission_percent>0)) ;
   histogram commission_percent  ;
run ;
quit ;

data tmp1 ;
   do i = 1 to 500 ;
      x=RAND('LOGNORMAL',2, 0.5);
	  if x < 20 then output ;
   end ;
run ;

proc sgplot data = tmp1 ;
   histogram x  ;
run ;
quit ;
/*******************************************/
data insurance_data ;
   set data.insurance_data_raw ;
   if market_segment = "NULL" and employees = 0 then 
      employees = int(1+ranuni(1)*92000) ;
   if market_segment = "NULL" then do ;
      if employees < 1000 then market_segment = "Small Business";
	  else if employees < 6000 then market_segment = "Middle Market";
	  else if employees < 18000 then market_segment = "National Accounts";
	  else market_segment = "Corporate Accounts";
   end ;
   if premium <= 1 then premium = int(150000+ranuni(1)*20000)+45*employees ;
   if policy_limit < 5000 then do ;
      if market_segment = "Small Business" then 
         policy_limit = 1000*int((2000000+ranuni(1)*1000000)/1000) ;
	  else if market_segment = "Middle Market";
         policy_limit = 1000*int((3000000+ranuni(1)*1000000)/1000) ;
	  else if market_segment = "National Accounts";
         policy_limit = 1000*int((5000000+ranuni(1)*1000000)/1000) ;
	  else policy_limit = 1000*int((6000000+ranuni(1)*1000000)/1000) ;
   end ;
   if trim(left(coverage))="NULL" then coverage = "DBA" ;
   if trim(left(coverage))="Workers Comp" then coverage = "WC" ;
   if trim(left(coverage))="Workers Comp;Workers Comp" then coverage = "WC" ;
   if trim(left(coverage))="Workers Compensation;DBA" then coverage = "DBAWC" ;
   if trim(left(coverage))="Workers Compensation;DBA;Employers Liability" 
      then coverage = "DBAWCEL" ;
   if trim(left(coverage))="Workers Compensation;DBA;Employers Liability;Completed Operations" 
      then coverage = "DBAWCEL" ;
   if trim(left(coverage))="Workers Compensation;Employers Liability" 
      then coverage = "WCEL" ;
   if deductible = 0 then 
      deductible = 1000*int((int(1800000+ranuni(1)*40000)+35*employees)/1000) ;
   if commission_percent < 2 then do;
      commission_percent=RAND('LOGNORMAL',2, 0.5);
	  commission_percent = 
      if commission_percent < 2 then commission_percent = 2 ;
	  if commission_percent > 17 then commission_percent = 15 ;

run ;
