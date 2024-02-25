%macro kahve;

data work.baseball;
set casuser.baseball;
run;
%mend; /* bitti */ /* the end */ /* macro end */
/* % görürsen >> haa bu macro */
%kahve;


proc cas;
	table.save / table={name="BASEBALL" caslib="SASHELP"}
		name="BASEBALL.csv";
run;


/* mimic export act (right click on data) */
CAS MYSESSION;
CASLIB _ALL_ ASSIGN;

%MACRO SAVE_AS_CSV(TABLE_NAME=, CASLIB_NAME=);
	filename rptfile filesrvc folderuri='/folders/folders/@myFolder'
	filename="&TABLE_NAME..csv";

	proc export DATA=&CASLIB_NAME..&TABLE_NAME.
		OUTFILE=rptfile
		DBMS=CSV REPLACE;
	RUN;
%MEND;

%SAVE_AS_CSV(TABLE_NAME=BASEBALL,CASLIB_NAME=SASHELP);



/*
	--- sashelpteki tüm table nameleri bir macro variable kaydet.
	--- bu macro variable'ın [10,15] >> hint: use %if %then %do
	--- bu işlemi, ben sadece bir macro fonksiyon satırını çalıştırarak görebiliyor olayım.
*/


/*****

&TABLE_NAME.CSV >>> BASEBALLCSV
&TABLE_NAME..CSV >>>>	BASEBALL.CSV

******/

filename rptfile filesrvc folderuri='/folders/folders/@myFolder'
	filename="rptfile.pdf";


%MACRO SAVE_AS_CSV(TABLE_NAME=, CASLIB_NAME=);
	filename rptfile filesrvc folderpath='/AIoT Projects'
	filename="&TABLE_NAME..csv";

	proc export DATA=&CASLIB_NAME..&TABLE_NAME.
		OUTFILE=rptfile
		DBMS=CSV REPLACE;
	RUN;
%MEND;

%SAVE_AS_CSV(TABLE_NAME=BASEBALL,CASLIB_NAME=SASHELP);

/***	'/files/files/0079a701-cae4-4cfc-924c-391b35d4cc10'	***/

proc sql;
	describe table dictionary.tables;
run;

proc sql;
	describe table sashelp.baseball;
run;

proc sql;
	select * from dictionary.dictionaries;
run;

proc sql;
	select memname into: tables_names separated by ' '
	from dictionary.tables
	where libname eq "SASHELP";
run;

%put &tables_names;

%put %sysfunc(countw(&tables_names));


%macro xxx;
	%local i;
	%do j=1 %to %sysfunc(countw(&tables_names));
		
	%end;

%mend xxx;

%xxx;


/*	klasör altındaki dosyaları listele	*/
filename content filesrvc folderpath='/Public';

data _null_;
	did=dopen('content'); /*cd*/
	mcount=dnum(did);
	putlog mcount=;
	do i=1 to mcount;
		memname=dread(did,i);
		putlog i @5 memname;
	end;
	rc=dclose(did);
run;
