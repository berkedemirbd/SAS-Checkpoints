title "Trucks with Horsepower < 250";
proc print data=sashelp.gas;
	var Fuel CpRatio;
	where CpRatio>12;
run;
/*----------------------------------------------------------*/
title "Trucks wwith Horepower > 250";
proc print data=sashelp.cars;
	var Make Model MSRP Horsepower;
	where Type="Truck" and Horsepower>250;
run;
/*-----------------------------------------------------------*/
/* PUT Macro
- Put is a macto statement that writes to the log.
- Text is not quoted
- Use a NOTE:, WARNING:, or ERROR: prefix to color to the log message.
*/
%put NOTE: This is a great program!;


/* %LET name=value*/

%let type=Sports;
%let value=;
%let sum=3+4;
%let varlist=Make Model Type;
%symdel type hp;
/*----------------------------------------------------------*/

options symbolgen;
%let type=Truck;
%let hp=250;
title1 "Car Type : &type";
proc print data=sashelp.cars;
	var Make Model MSRP Horsepower;
	Where type="%type" and Horsepower>&hp;
run;
/*----------------------------------------------------------*/
%let lib=sashelp;
footnote "Data Source : &lib.cars";
proc print data=&lib..cars;
