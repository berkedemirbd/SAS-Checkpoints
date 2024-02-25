%macro type_summary_automation;
	proc sql;
	create table SUV_summary as
	select type
			,origin
			,count(*) as no_of_units
			,sum(msrp) as total_msrp
			,sum(invoice) as total_of_invoice
	from sashelp.cars
	where upcase(type)="SUV"
	group by 1,2;
quit;

proc print data=work.SUV_summary;
run;
%mend ;

proc print data=sashelp.baseball;
run;


data fonksiyon1;
	set sashelp.baseball;
	drop natbat-nhits;
	result=largest(1, of natbat-nhits);
run;

/* Functions */
data sample;
	name='Thomas     Cruise     Mapothe';
	len=length(name);

proc print data=sample noobs;

data sample2;
	name2='Thomas     Cruise     Mapothe';
	compress=compress(name2);
	len2=length(compress);
proc print data=sample2 noobs;

data sample3;
	name3='Thomas     Cruise     Mapothe';
	compbl=compbl(name3);
	len3=length(compbl);
proc print data=sample3 noobs;
run;

/* Deletin specify arguments with compress */

data sample4;
	name4='Thomas     Cruise     Mapothe';
	compress=compress(name4, 'C', 'l');
proc print data=sample4 noobs;
run;
/* compress(value, 'x','y') rutinindeki her x,y vb değerleri için ayrı bir koşul tanımlı*/


/* combining */

data sample5;
first_name="Thomas";
middle_name="Cruise";
last_name="Mapother";
full_name=first_name||"-"||middle_name||"-"||last_name;
proc print data=sample5;
run;

