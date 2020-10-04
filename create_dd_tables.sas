libname kernel 'C:\AI Book\Software\Data Dictionaries' ;
	
data data.library ;
   length LIBRARY $ 8 ; label LIBRARY = "SAS library name" ;
   length LOCATION Character 80 ; 
      label LOCATION = "Operating system-specic file name for SAS library" ;
cards ;
kernel	C:\AI Book\Software\Data Dictionaries
;;;;
run ;

data data.object ;
   length TABLE $ 8 ; label TABLE = "Table name" ;
   length TITLE $ 80 ; label TITLE = "Table title" ;
   length DATASET $ 8 ; 
      label DATASET = "SAS or R dataset name where data of the table is stored" ;
run ;

data data.location;
   length TABLE $ 8 ; label TABLE = "Table name" ;
   length LIBRARY $ 8 ; label LIBRARY = "SAS library name" ;
run ;

data data.message ;
   length MESSAGE 8 ; label = "MESSAGE Message identification number" ;
   length TEXT $ 80 ; label = "TEXT Message text" ;
   length MESTYPE $ 1 ; 
      label MESTYPE = "Message type: E—rror message, W—warning, I—informative message" ;
   length OUTPUT $ 2 ; 
      label OUTPUT = "Output message destination: S—screen and/or D—dataset" ;
run ;

data data.property ;
   length TABLE $ 8 ; label TABLE = "Table name" ;
   length COLUMN $ 8 ; label COLUMN = "Column name" ;
   length TITLE $ 80 ; label TITLE = "Column title" ;
   length TYPE $ 1 ; label TYPE = "Column data type: C—character or N—numeric" ;
   length LENGTH 8 ; label LENGTH = "Column length" ;
   length ATTRIBUT $ 2 ; label ATTRIBUT = "Column property: P—primary key" ;
   length DOMTAB $ 8 ; label DOMTAB = "Domain table name" ;
   length DOMCOL $ 8 ; label DOMCOL = "Domain column name" ;
   length MEANTAB $ 8 ; label MEANTAB = "Meaning table name" ;
   length MEANCOL $ 8 ; label MEANCOL = "Meaning column name" ;
   length INITVAL $ 80 ; label INITVAL = "Initial column’s value" ;
   length FORMULA $ 80 ; label FORMULA = "The formula for the computed column" ;
   length MISSING $ 1 ; label MISSING = "Code of missing value" ;
   length MESSAGE 8 ; label MESSAGE = "Error message identification number" ;
run ;

data data.link ;
   length TABLE $ 8 ; label TABLE = "Table name" ;
   length RELTABLE $ 8 ; label RELTABLE = "Name of the related table" ;
   length COLUMN $ 8 ; label COLUMN = "Column name" ;
   length RELCOL $ 8 ; label RELCOL = "Name of the column from the related table" ;
run ;
