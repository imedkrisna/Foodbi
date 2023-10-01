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


import excel "C:\github\Foodbi\new_data\use\mf11krm.xlsx", sheet("Data") firstrow case(lower)
destring year, replace
xtset nobs year
keep if disic2=="10"
gen cost=it1vcu+rdnvcu+rimvcu+efuvcu+eplvcu+enpvcu+zpdvcu+zndvcu
gen labshare=(zpdvcu+zndvcu)/cost
gen ln=log(zpdvcu+zndvcu)
gen lk=log(v1115)
gen lo=log(output)
gen lm=log(rdnvcu+rimvcu)
gen ll=log(ltlnou)
gen lva=log(vtlvcu)
gen disic3=substr(disic4, 1, 3)
merge m:1 year using birate
drop if nobs==. // amid birate <2017
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

// Regressing by 3-digit KBLI

clear all
use pakai
levelsof disic3_4,local(ids)
foreach i in `ids' {
	clear all
	use pakai
	xtset psid year
	keep if disic3_4==`i'
	prodest lva, free(ln) state(lk) proxy(lm) method(lp) fsresidual(om) va
	predict tfp,omega
	predict mu1,markups inputvar(ln)
	
	save tfpa`i',replace
	outreg2 using tfpa`i'.xls,replace se bdec(3) tdec(3) excel

}

clear all
use tfpa101
append using tfpa102 tfpa103 tfpa104 tfpa105 tfpa106 tfpa107 tfpa108
sum mu,det
drop if mu < r(p5) | mu > r(p95)
sum mu,det
save tfpa,replace

clear all
use pakau
destring disic3,replace
levelsof disic3,local(ids)
foreach i in `ids' {
	clear all
	use pakau
	xtset nobs year
	destring disic3,replace
	keep if disic3==`i'
	prodest lva, free(ln) state(lk) proxy(lm) method(lp) fsresidual(om) va
	predict tfp,omega
	predict mu1,markups inputvar(ln)
	save tfpb`i',replace
	outreg2 using tfpb`i'.xls,replace se bdec(3) tdec(3) excel

}

clear all
use tfpb101
append using tfpb102 tfpb103 tfpb104 tfpb105 tfpb106 tfpb107 tfpb108
sum mu,det
drop if mu < r(p5) | mu > r(p95)
sum mu,det
save tfpb,replace

/*

clear all
use pakau
destring disic3,replace
levelsof disic3,local(ids)
foreach i in `ids' {
	use tfpb`i',clear
	sum mu1,det
}

// COVID IMPACT

clear all
use pakau
keep if year<2020 // before covid
prodest lva, free(ln) state(lk) proxy(lm) method(lp) fsresidual(om) va
predict tfp,omega
predict mu,markups inputvar(ln)
sum mu,det
drop if mu < r(p5) | mu > r(p95)
sum mu,det
bys year: tabstat mu, stats(mean median min max)
save before,replace

clear all
use pakau
keep if year>=2020 // after covid
prodest lva, free(ln) state(lk) proxy(lm) method(lp) fsresidual(om) va
predict tfp,omega
predict mu,markups inputvar(ln)
sum mu,det
drop if mu < r(p5) | mu > r(p95)
sum mu,det
bys year: tabstat mu, stats(mean median min max)
save after,replace





╔═══╗────╔╗────╔═╗╔╗─────────╔═══╗╔╗
║╔══╝────║║────║╔╝║║─────────║╔══╝║║
║╚══╦═╗╔═╝║╔══╦╝╚╗║║──╔══╦══╗║╚══╦╣║╔══╗
║╔══╣╔╗╣╔╗║║╔╗╠╗╔╝║║─╔╣╔╗║╔╗║║╔══╬╣║║║═╣
║╚══╣║║║╚╝║║╚╝║║║─║╚═╝║╚╝║╚╝║║║──║║╚╣║═╣
╚═══╩╝╚╩══╝╚══╝╚╝─╚═══╩══╩═╗║╚╝──╚╩═╩══╝
─────────────────────────╔═╝║
─────────────────────────╚══╝


zipfile tfp*,saving(For_Krisnav1, replace)

local list: dir . files "tfp*"
foreach f of local list {
	erase "`f'"
}
*/

log close