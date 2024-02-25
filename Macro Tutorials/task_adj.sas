
%put SASHELP kütüphanesindeki kütüphane adları: &choosen_datas;

%macro tentofifteen_do(string);
proc sql;
	select memname into: tables_names separated by ' '
	from dictionary.tables
	where libname eq "SASHELP";
run;

%put &tables_names;

%let choosen_datas = &tables_names;
	%do i=10 %to 15;
	%let adjusted_variable = %scan(&string, &i);
	%put &adjusted_variable;
filename rptfile filesrvc folderpath='/Users/19370025@ogrenci.ankara.edu.tr/asd' filename="&adjusted_variable..csv";
	proc export data=sashelp.&adjusted_variable.
		outfile=rptfile
		dbms=csv replace;

run;
	%end;
%mend;

%tentofifteen_do(&tables_names);

/*----------------------------------------------------------------------------------*/


/* With While Loop */

    
%macro tentofifteen_while(string);
proc sql;
        select memname into :tables_names separated by ' '
        from dictionary.tables
        where libname eq "SASHELP";
    quit;

    %put &tables_names;

    %let chosen_datas = &tables_names;

    %let i = 10;
    %do %while (%eval(&i <= 15));
        %let adjusted_variable = %scan(&string,&i);
        %put &adjusted_variable;

        filename rptfile filesrvc folderpath='/Users/19370025@ogrenci.ankara.edu.tr/asd' filename="&adjusted_variable..csv";
        
        proc export data=sashelp.&adjusted_variable.
            outfile=rptfile
            dbms=csv replace;
        run;

        %let i = %eval(&i + 1);
    %end;
%mend;

%tentofifteen_while(&tables_names);