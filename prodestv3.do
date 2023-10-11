/*

╭━━━━┳━━━┳━━━╮╱╱╱╱╱╱╱╱╭╮╭━╮╭━╮╱╱╱╱╭╮╱╱╱╱╱╱╱╱╱╱╭┳╮
┃╭╮╭╮┃╭━━┫╭━╮┃╱╱╱╱╱╱╱╱┃┃┃┃╰╯┃┃╱╱╱╱┃┃╱╱╱╱╱╱╱╱╱╱┃┃┃
╰╯┃┃╰┫╰━━┫╰━╯┃╭━━┳━╮╭━╯┃┃╭╮╭╮┣━━┳━┫┃╭┳╮╭┳━━┳━━┫┃┃
╱╱┃┃╱┃╭━━┫╭━━╯┃╭╮┃╭╮┫╭╮┃┃┃┃┃┃┃╭╮┃╭┫╰╯┫┃┃┃╭╮┃━━╋┻╯
╱╱┃┃╱┃┃╱╱┃┃╱╱╱┃╭╮┃┃┃┃╰╯┃┃┃┃┃┃┃╭╮┃┃┃╭╮┫╰╯┃╰╯┣━━┣┳╮
╱╱╰╯╱╰╯╱╱╰╯╱╱╱╰╯╰┻╯╰┻━━╯╰╯╰╯╰┻╯╰┻╯╰╯╰┻━━┫╭━┻━━┻┻╯
╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱┃┃
╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╰╯

My thanks to Pak Sagap & BPS team for running this code. Some explanation:

1. This code requires prodest and outreg2 (ssc install prodest & ssc install outreg2 if haven't)

2. We may need to save a bit of *.dta, but of course we will drop some variables first. We only need a tag, a year, and several TFP & markups variables.

3. Everything will be zipped in a file named "For_Krisna.zip" and that's the only file we need!

4. Please put this do file in a folder contains the data. You only need to change 2 lines: the cd command (line 40) and use command (line 42) (3 apparently. The ISIC. Food & Beverage please!)

5. Thanks again!

*/


clear all
set more off
log using tfplog,replace
/*
╔╗─────────╔═══╗╔╗────╔═══╗╔╗─────╔╗
║║─────────║╔══╝║║────║╔═╗╠╝╚╗───╔╝╚╗
║║──╔══╦══╗║╚══╦╣║╔══╗║╚══╬╗╔╬══╦╩╗╔╝
║║─╔╣╔╗║╔╗║║╔══╬╣║║║═╣╚══╗║║║║╔╗║╔╣║
║╚═╝║╚╝║╚╝║║║──║║╚╣║═╣║╚═╝║║╚╣╔╗║║║╚╗
╚═══╩══╩═╗║╚╝──╚╩═╩══╝╚═══╝╚═╩╝╚╩╝╚═╝
───────╔═╝║
───────╚══╝
*/
cd "C:\github\foodbi" // Please change this to the proper working directory

import excel "C:\github\Foodbi\new_data\use\makro.xlsx", sheet("compile") firstrow clear
tsset year
save birate,replace

use "new_data/use/data0015.dta",clear // Pleace change this with the data in

xtset psid year
keep if disic2_4==10 // ISIC Rev. 4. For ISIC rev.3, 15

gen cost=it1vcu+rdnvcu+rimvcu+efuvcu+eplvcu+enpvcu+zpdvcu+zndvcu
gen c2=rdnvcu+rimvcu+zpdvcu+zndvcu+it1vcu
gen labshare=(zpdvcu+zndvcu)/cost
gen lab2=(zpdvcu+zndvcu)/c2
gen ln=log(zpdvcu+zndvcu)
gen lk=log(v1115)
gen lo=log(output)
gen lm=log(rdnvcu+rimvcu)
gen ll=log(ltlnou)
gen lva=log(vtlvcu)

merge m:1 year using birate
drop if psid==. // amid birate 2016++
save pakai,replace

prodest lva, free(ln) state(lk) proxy(lm) method(lp) fsresidual(om) va
outreg2 using "tfp1.xls",excel replace

predict mu,markups inputvar(ln)

predict tfp,omega
// REMOVE OUTLIERS DUE TO FUNNY INPUT
// outliers = 5% bot and 5% top
sum mu,det
drop if mu < r(p5) | mu > r(p95)
sum mu,det

save tfp1, replace

clear all


use mamin_new.dta,clear
destring year, replace
xtset Noobs year
keep if Disic2==10
gen cost=It1vcu+Rdnvcu+Rimvcu+Efuvcu+Eplvcu+Enpvcu+Zpdvcu+Zndvcu
gen labshare=(Zpdvcu+Zndvcu)/cost
gen ln=log(Zpdvcu+Zndvcu)
gen lk=log(V1115)
gen lo=log(Output)
gen lm=log(Rdnvcu+Rimvcu)
gen ll=log(Ltlnou)
gen lva=log(Vtlvcu)
merge m:1 year using birate
drop if Noobs==. // amid birate <2017
gen covid=0
replace covid=1 if year>2019
save pakau,replace

prodest lva, free(ln) state(lk) proxy(lm) method(lp) fsresidual(om) va
outreg2 using "tfp2.xls",excel replace

predict mu,markups inputvar(ln)

// REMOVE OUTLIERS DUE TO FUNNY INPUT
// outliers = 5% bot and 5% top
sum mu,det
drop if mu < r(p5) | mu > r(p95)
sum mu,det

predict ,parameters
predict tfp,omega

bys year: tabstat mu, stats(mean sd median p25 p75 min max)

save tfp2, replace

// Regressing by 4-digit KBLI

clear all
use pakai
levelsof disic4_4,local(ids)
foreach i in `ids' {
	clear all
	use pakai
	xtset psid year
	keep if disic4_4==`i'
	prodest lva, free(ln) state(lk) proxy(lm) method(lp) fsresidual(om) va
	predict tfp,omega
	predict mu,markups inputvar(ln)
	
	save tfpc`i',replace
	outreg2 using tfpc`i'.xls,replace se bdec(3) tdec(3) excel

}

use tfpc1010,clear
append using tfpc1020 tfpc1030 tfpc1040 tfpc1050 tfpc1061 tfpc1062 tfpc1071 tfpc1072 tfpc1073 tfpc1074 tfpc1079 tfpc1080
sum mu,det
drop if mu < r(p5) | mu > r(p95)
sum mu,det
save tfpc,replace

clear all
use pakau
levelsof Disic3,local(idd)
foreach i in `idd' {
	clear all
	use pakau
	xtset Noobs year
	//destring disic4,replace
	keep if Disic3==`i'
	prodest lva, free(ln) state(lk) proxy(lm) method(lp) fsresidual(om) va
	predict tfp,omega
	predict mu,markups inputvar(ln)
	save tfpd`i',replace
	outreg2 using tfpd`i'.xls,replace se bdec(3) tdec(3) excel

}

// use tfpd1011,clear

// append using tfpd1011 tfpd1012 tfpd1013 tfpd1021 tfpd1022 tfpd1029 tfpd1031 tfpd1032 tfpd1033 tfpd1039 tfpd1041 tfpd1042 tfpd1043 tfpd1049 tfpd1051 tfpd1052 tfpd1053 tfpd1059 tfpd1061 tfpd1062 tfpd1063 tfpd1071 tfpd1072 tfpd1073 tfpd1074 tfpd1075 tfpd1076 tfpd1077 tfpd1079 tfpd1080

use tfp101,clear
append using tfp102 tfp103 tfp104 tfp105 tfp106 tfp107 tfp108

sum mu,det
drop if mu < r(p5) | mu > r(p95)
sum mu,det
save tfpd,replace

tabstat mu if Disic4==1043, stats(mean sd median p25 p75 min max)
tabstat mu if Disic4==1063, stats(mean sd median p25 p75 min max)
tabstat mu if Disic4==1072, stats(mean sd median p25 p75 min max)

use tfpc,clear
tabstat mu if disic4_4==1040, stats(mean sd median p25 p75 min max)
tabstat mu if disic4_4==1062, stats(mean sd median p25 p75 min max)
tabstat mu if disic4_4==1072, stats(mean sd median p25 p75 min max)

log close