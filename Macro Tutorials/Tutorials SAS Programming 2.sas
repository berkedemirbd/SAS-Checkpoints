proc print data=sashelp.AIR;
run;

data secili_degerler;
	set sashelp.cars;
	where type='SUV';

/*-------------------------------------------------------------------*/
/* Mixing */
proc sort data=secili_degerler(keep=Horsepower Enginesize Model MSRP Origin);
by EngineSize;
where EngineSize>=3.4;


proc sql;
	select Origin
	from secili_degerler
	where Origin='USA';

proc print data=secili_degerler;
run;

/*-------------------------------------------------------------------*/

proc contents data=sashelp.cars;
run;

/*------------------------------------------------------------------*/

proc print data=sashelp.orsales;
run;

/*------------------------------------------------------------------*/
/* Retain ile sayaç değişkeni*/
data retaindeneme;
	set sashelp.orsales;
	retain veri 25;
	veri = veri-1;
	if veri = 0 then stop;
proc print data=retaindeneme;
run;


data retaindeneme;
	set sashelp.orsales;
	retain veri 25;
	veri = veri-1;
	if veri = 0 then stop;
run;

proc print data=retaindeneme;
run;

data mytry;
	set sashelp.orsales;
	proc sort data=sashelp.orsales;
	by quantity;
run;

Data deneme;
	set mytry;
	First_value=First.quantiy;
	Last_value=Last.quantity;
run;

proc sort data=deneme;
by quantity;
first_obs=first.profit;
last_obs=last.profit;

proc print data=deneme;
run;