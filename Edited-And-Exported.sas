CAS SESS1;
caslib _all_ assign;
options compress=yes;

libname asd "/shared/home/19370025@ogrenci.ankara.edu.tr/asd";

proc import datafile="/shared/home/19370025@ogrenci.ankara.edu.tr/asd/airline.csv"
			dbms=csv
			out=asd.airline
			replace;
run;

/********************************************************/
/*  save table to caslib                                */
/********************************************************/
data PUBLIC.airline;
	set asd.airline;
run;

data yeni (keep=author aircraft place);
   set PUBLIC.airline;
run;

proc print data=yeni;
run;

proc casutil outcaslib="CASUSER" sessref=SESS1 incaslib="PUBLIC";
    save casdata="AIRLINE" casout="AIRLINE.SASHDAT" compress replace;
    promote casdata="AIRLINE";
quit;



proc print data=asd.airline;
run;


data temiz;
	set asd.airline (drop = content header);
run;



data unreviewed;
  set temiz (drop=route date_flown);
  if find(author, "reviews") = 0 then output;
run;

/* Ülkeler Kukla*/
data kukla_degisken;
	set unreviewed;
if place="United Kingdom" then kukla=0;
else if place="United States" then kukla=1;
else if place="Germany" then kukla=2;
else if place="Australia" then kukla=3;
else if place="Canada" then kukla=4;

else kukla=5;

where not missing(aircraft) and not missing(traveller_type) and not missing(seat_type) and not missing(recommended);
run;


/* null datalar */


data temiz2;
	set kukla_degisken;
	if traveller_type="" then delete;
run;



/* Air Craft için Kukla ve Boş Veri Temizliği */
data edited;
  set kukla_degisken;

  /* 'bos_degisken' ve 'diget_bos_degisken' değişkenleri boş olan satırları silme */
  if missing(aircraft) or missing(author) or missing(place) then delete;
run;



/* Uçak modellerinin kukla değişkene aktarılması */



/* A320 : 176
	Boeing 777 : 136
	Boeing 747-400 : 68
	Boeing 747 : 57
	A380 : 85
*/
/* deneme*/
  /* 'Uçaklar için kukla */

data deneme_kukla;
	set edited;
  if find(aircraft, "380") then kukla_ucak=0;
	else if find(aircraft, "777") then kukla_ucak=1;
	else if find (aircraft, "320") then kukla_ucak=2;
	else if find (aircraft, "787") then kukla_ucak=3;
	else kukla_ucak=4;
run;



/* En çok bulunan ülkeler 
	Australia : 30 
	Canada :30
	Germany : 18
	United Kingdom : 630
	United States : 91
*/

data onway;
  set deneme_kukla;
  if _n_ ne 62; /* _n_ değişkeni gözlem numarasını temsil eder */
run;



data revize;
	set onway;
run;

data revize;
	set revize;
  /* 59. satırdaki null tarih değerine elle bir değer atamak */
  if _n_ = 216 then do;
    Date = '12JAN2020'd; /* Atamak istediğiniz tarih değerini buraya yazın */
    put Date;
  end;

run;

data revize;
	set revize;
  /* 59. satırdaki null tarih değerine elle bir değer atamak */
  if _n_ = 59 then do;
    Date = '25MAR2023'd; /* Atamak istediğiniz tarih değerini buraya yazın */
    put Date;
  end;

run;


data revize;
  set revize;

  /* seat_type sütunundaki değerleri kontrol et */
  if not (traveller_type in ('Family Leisure', 'Couple Leisure', 'Solo Leisure','Business')) then do;
    traveller_type = 'Other'; /* Eğer değer A, B veya C değilse, D atansın */
    put traveller_type;
  end;

run;

data revize;
	set revize (drop=recommended);
run;


data onway;
  set onway;

  /* seat_type sütunundaki değerleri kontrol et */
  if not (seat_type in ('A', 'B', 'C')) then do;
    seat_type = 'D'; /* Eğer değer A, B veya C değilse, D atansın */
    put "Değiştirilen seat_type: " seat_type;
  end;

run;

/* 
Satır Numarası: 59  içerisinde en az bir null değer var.
Satır Numarası: 216  içerisinde en az bir null değer var.
Satır Numarası: 322  içerisinde en az bir null değer var.
Satır Numarası: 351  içerisinde en az bir null değer var.
Satır Numarası: 361  içerisinde en az bir null değer var.
Satır Numarası: 362  içerisinde en az bir null değer var.
Satır Numarası: 399  içerisinde en az bir null değer var.
Satır Numarası: 411  içerisinde en az bir null değer var.
Satır Numarası: 428  içerisinde en az bir null değer var.
Satır Numarası: 454  içerisinde en az bir null değer var.
Satır Numarası: 614  içerisinde en az bir null değer var.
Satır Numarası: 638  içerisinde en az bir null değer var.
Satır Numarası: 739  içerisinde en az bir null değer var.
Satır Numarası: 875  içerisinde en az bir null değer var.
Satır Numarası: 888  içerisinde en az bir null değer var.
Satır Numarası: 898  içerisinde en az bir null değer var.
Satır Numarası: 916  içerisinde en az bir null değer var.
Satır Numarası: 933  içerisinde en az bir null değer var.
Kontrol tamamlandı.
*/


/* yedek 3*/
data revize2;
	set revize;
run;

data revize2;
  set revize2;

  /* seat_type sütunundaki değeri kontrol et */
  if missing(rating) then do;
    /* seat_type değeri null ise, kendinden önceki değeri ile doldur */
    rating = lag(rating);
    put rating;
  end;

run;

data revize2;
  set revize2;
  
  /* 875. gözlemi silmek için */
  if _n_ ne 875 then output;

run;

data revize2;
  set revize2;

  /* seat_type sütunundaki değeri kontrol et */
  if missing(date) then do;
    /* seat_type değeri null ise, kendinden önceki değeri ile doldur */
    date = lag(date);
    put rating;
  end;

run;


data revize2;
  set revize2;
	FORMAT date mmddyy10.;
run;


data kukla_traveller;
	set revize2;
if place="Solo Leisure" then kukla_traveller=0;
else if traveller_type	="Couple Leisure" then kukla_traveller=1;
else if traveller_type	="Family Leisure" then kukla_traveller=2;
else if traveller_type	="Business" then kukla_traveller=3;
else kukla_traveller=4;

run;

data verified_revize;
  set kukla_traveller;

  /* seat_type sütunundaki değerleri kontrol et */
  if not (trip_verified in ('Verified', 'Not Verified')) then do;
    trip_verified = 'Other'; /* Eğer değer A, B veya C değilse, D atansın */
    put trip_verified;
  end;

run;

data kukla_verified;
	set verified_revize;
if trip_verified="Not Verified" then kukla_verified=0;
else if trip_verified="Verified" then kukla_verified=1;
else kukla_verified=2;

run;

data seat_revize;
  set kukla_verified;

  /* seat_type sütunundaki değerleri kontrol et */
  if not (seat_type in ('Business Class', 'Economy Class','First Claass','Premium Economy')) then do;
    seat_type = 'Other'; /* Eğer değer A, B veya C değilse, D atansın */
    put seat_type;
  end;

run;

data kukla_seat;
	set seat_revize;
if seat_type="Economy Class" then kukla_seat=0;
else if seat_type="Business Class" then kukla_seat=1;
else if seat_type="First Class" then kukla_seat=2;
else kukla_seat=3;

run;



data final;
	set kukla_seat;
	if  entertainment="-1" then do entertainment=1;
end;
run;

proc glm data=asd.final2;
   model rating = date seat_comfort cabin_staff_service food_beverages ground_service value_for_money entertainment kukla kukla_ucak kukla_traveller kukla_verified kukla_seat/ solution;
run;

data asd.final2;
	set final;
	
	if seat_comfort < 0 then seat_comfort = 0;
	else if cabin_staff_service < 0 then cabin_staff_service = 0;
	else if food_beverages < 0 then food_beverages = 0;
	else if ground_service < 0 then ground_service = 0;
	else if value_for_money < 0 then value_for_money = 0;
run;


/* Grafikler */

/*--Comparative Scatter Plot--*/

data asd.final2;
	set asd.final2 (drop=place aircraft traveller_type seat_type trip_verified);
run;


data terto;
	set asd.final2;
/* Vazgeçiş --- Null Değerlerin Olduğu Satırı Silme */
where not missing(date) and not missing(rating) and not missing(seat_comfort) and not missing(cabin_staff_service)  
and not missing(food_beverages) and not missing(ground_service) and not missing(value_for_money) 
and not missing(entertainment) and not missing(kukla) and not missing(kukla_ucak) and not missing(kukla_traveller)
and not missing(kukla_verified) and not missing(kukla_seat);
run;

data _null_;
  set terto end=eof;

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

proc print data=terto;
run;
/*----------------------------*/

/* Veri setinizi seçin */
proc export data=work.yedek_2
  /* CSV dosyasının adı ve yolu */
  outfile="/shared/home/19370025@ogrenci.ankara.edu.tr/Practices - Macro/son.csv"
  /* CSV formatını belirtin */
  dbms=csv
  /* Veri setinizdeki değişken isimlerini koruyun */
  replace;
run;


data _null_;
  set yedek_2.sas;
  file "/shared/home/19370025@ogrenci.ankara.edu.tr/Practices - Macro/final.csv" dlm=',' dsd;
  put _all_;
run;
