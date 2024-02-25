libname data "/home/u63766092/sasuser.v94/lib";

proc import datafile="/home/u63766092/sasuser.v94/lib/airline.csv"
			dbms=csv
			out=data.airways
			replace;
run;


proc sql;
  create table unique_countries as
  select distinct place as country
  from unreviewed;
quit;


data temiz;
	set data.airways(drop=content header date route);
run;


data unreviewed;
  set temiz;
  if not find(author, "reviews") = 0 then author="Anonymus";
run;


data planes;
    set unreviewed;

    /* Eğer '/' karakteri bulunuyorsa, bu karakterden öncesini al */
    if index(aircraft, '/') > 0 then
        new_aircraft = substr(aircraft, 1, index(aircraft, '/') - 1);
    /* Eğer '-' karakteri bulunuyorsa, bu karakterden öncesini al */
    else if index(aircraft, '-') > 0 then
        new_aircraft = substr(aircraft, 1, index(aircraft, '-') - 1);
    else if index(aircraft, ',') > 0 then
        new_aircraft = substr(aircraft, 1, index(aircraft, '-') - 1);
    else
        new_aircraft = aircraft;

    drop aircraft; 
run;


proc sql;
  create table unique_places as
  select distinct place
  from planes;
quit;

data filtered_dataset;
  set planes;
  /* Sadece belirli ülkeleri içeren bir filtre oluşturun */
  if place in ('Argentina', 'Australia', 'Austria', 'Bahrain', 'Belgium', 'Botswana', 'Brazil', 'Bulgaria', 
               'Canada', 'Chile', 'China', 'Cyprus', 'Czech Republic', 'Denmark', 'Dominican Repu', 'France', 
               'Germany', 'Ghana', 'Greece', 'Hong Kong', 'Hungary', 'Iceland', 'India', 'Ireland', 'Italy', 
               'Japan', 'Jordan', 'Kuwait', 'Malaysia', 'Mexico', 'Netherlands', 'New Zealand', 'Norway', 
               'Panama', 'Poland', 'Portugal', 'Qatar', 'Romania', 'Russian Federa', 'Saint Kitts an', 
               'Saudi Arabia', 'Senegal', 'Singapore', 'Slovakia', 'Solo Leisure', 'South Africa', 'South Korea',
               'Spain', 'Sweden', 'Switzerland', 'Taiwan', 'Thailand', 'Turkey', 'United Arab Em', 'United Kingdom', 
               'United States', 'Vietnam');
run;

data filtered_dataset2;
  set filtered_dataset;

  /* Sadece belirli ülkeleri içeren bir filtre oluşturun */
  if traveller_type not in ('Solo Leisure', 'Couple Leisure', 'Family Leisure', '') then
    traveller_type = 'Unknown';
  else if missing(traveller_type) then
    traveller_type = 'Unknown';

run;

data filtered_dataset2;
  set filtered_dataset;

  /* Sadece belirli ülkeleri içeren bir filtre oluşturun */
  if recommended not in ('yes', 'no', '') then
    traveller_type = ' ';

run;


data filtered_dataset3;
  set filtered_dataset2;

  /* Sadece belirli ülkeleri içeren bir filtre oluşturun */
  if trip_verified not in ('Verified', 'Not Verified') then
    trip_verified = ' ';

run;

/* Encode Verified */

data kategorik;
  set filtered_dataset3;

  /* Verified kategorik değişkenini 0-1 kukla değişkenine çevirme */
  if trip_verified = 'Verified' then
    verified_binary = 1;
  else if trip_verified = 'Not Verified' then
    verified_binary = 0;
  else
    verified_binary = .; /* Eğer başka bir değer varsa missing olarak işaretle */

  drop trip_verified; /* İlk hali artık gerekli olmadığından kaldırabilirsiniz */
run;

/*Encode Seat Type*/

data kategorik2;
  set kategorik;

  /* Verified kategorik değişkenini 0-1 kukla değişkenine çevirme */
  if seat_type = 'Economy Class' then
    seat_binary = 0;
  else if seat_type = 'Premium Economy' then
    seat_binary = 1;
  else if seat_type = 'Business Class' then
    seat_binary = 2;
  else if seat_type = 'First Class' then
    seat_binary = 3;
  else
    seat_binary = .; /* Eğer başka bir değer varsa missing olarak işaretle */
	drop seat_type;
run;


data nonminus;
  set kategorik2;

  /* Herhangi bir sayısal değişken sıfırdan küçükse sıfıra eşitle */
  array num_vars _numeric_;

  do i = 1 to dim(num_vars);
    if num_vars[i] < 0 then num_vars[i] = 0;
  end;

run;






data _null_;
  set nonminus end=eof;

  /* Toplam null değer sayısını saklamak için değişken */
  null_count = 0;

  /* Satırdaki herhangi bir değişken null mu kontrol et */
  array num_vars[*] _numeric_;
  array char_vars[*] _character_;

  do i = 1 to dim(num_vars);
    if num_vars[i] = . then do;
      null_count + 1; /* Her null değer bulunduğunda sayacı artır */
    end;
  end;

  do i = 1 to dim(char_vars);
    if char_vars[i] = "" then do;
      null_count + 1; /* Her null değer bulunduğunda sayacı artır */
    end;
  end;

  /* EOF (End of File) kontrolü */
  if eof then do;
    if null_count > 0 then
      put "Toplam " null_count " adet null değer bulunmaktadır.";
    else
      put "Null değer bulunmamaktadır.";
  end;
run;

/* Null Kalmadı */


proc freq data=final;
  tables new_aircraft / out=unique_values_aircraft(keep=new_aircraft);
run;


data unique_aircraft;
  set final;
  /* Sadece 'Boeing', 'A' veya 'E' ile başlayanları tut, diğerlerini sil */
  if prxmatch('/^(Boeing|A|E)/i', new_aircraft) > 0;
run;


proc freq data=unique_aircraft;
  tables new_aircraft / out=unique_values_aircraft(keep=new_aircraft);
run;




data final;
	set nonminus (drop=i);
run;

proc print data=unique_aircraft;
run;

proc freq data=unique_aircraft;
run;

proc print data=data.airways;
run;



proc export data=unique_aircraft
  /* CSV dosyasının adı ve yolu */
  outfile="/home/u63766092/sasuser.v94/Final/BRITISH.csv"
  /* CSV formatını belirtin */
  dbms=csv
  /* Veri setinizdeki değişken isimlerini koruyun */
  replace;
run;
