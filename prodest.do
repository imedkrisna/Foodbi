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

4. Please put this do file in a folder contains the data. You only need to change 2 lines: the cd command (line 40) and use command (line 42)

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

use "new_data/panel/data0015_5long.dta" // Pleace change this with the data in

xtset psid year
keep if disic2==15
duplicates tag psid, generate(tagg)

gen cost=it1vcu+rdnvcu+rimvcu+efuvcu+eplvcu+enpvcu+zpdvcu+zndvcu
gen labshare=(zpdvcu+zndvcu)/cost
gen ln=log(zpdvcu+zndvcu)
gen lk=log(v1115)
gen lo=log(output)
gen lm=log(rdnvcu+rimvcu)

save pakai,replace 

prodest lo, free(ln) state(lk) proxy(lm) method(lp) acf translog fsresidual(om)
outreg2 using "tfp1.xls",excel replace

predict mu1,markups inputvar(ln)
predict mu2,markups inputvar(lm)
predict ,parameters
predict tfp,omega
keep tagg year mu1 mu2 tfp cost labshare 
save tfp1, replace

clear all

use pakai

xtset psid year

prodest lo, free(ln) state(lk) proxy(lm) method(lp) fsresidual(om)
outreg2 using "tfp2.xls",excel replace

predict mu1,markups inputvar(ln)
predict mu2,markups inputvar(lm)
predict ,parameters
predict tfp,omega
keep tagg year mu1 mu2 tfp cost labshare //needed to calculate markups
save tfp2, replace

clear all
use pakai
levelsof disic3,local(ids)
foreach i in `ids' {
	clear all
	use pakai
	xtset psid year
	keep if disic3==`i'
	prodest lo, free(ln) state(lk) proxy(lm) method(lp) fsresidual(om)
	predict tfp,omega
	predict,parameters
	predict mu1,markups inputvar(ln)
	predict mu2,markups inputvar(lm)
	keep tagg year mu1 mu2 tfp cost labshare
	save tfpb`i',replace
	outreg2 using tfpb`i'.xls,replace se bdec(3) tdec(3) excel

}

clear all
use pakai
levelsof disic3,local(ids)
foreach i in `ids' {
	clear all
	use pakai
	xtset psid year
	keep if disic3==`i'
	prodest lo, free(ln) state(lk) proxy(lm) method(lp) acf translog fsresidual(om)
	predict tfp,omega
	predict,parameters
	predict mu1,markups inputvar(ln)
	predict mu2,markups inputvar(lm)
	keep tagg year mu1 mu2 tfp cost labshare
	save tfpa`i',replace
	outreg2 using tfpa`i'.xls,replace se bdec(3) tdec(3) excel

}

rm pakai.dta
/*
╔═══╗────╔╗────╔═╗╔╗─────────╔═══╗╔╗
║╔══╝────║║────║╔╝║║─────────║╔══╝║║
║╚══╦═╗╔═╝║╔══╦╝╚╗║║──╔══╦══╗║╚══╦╣║╔══╗
║╔══╣╔╗╣╔╗║║╔╗╠╗╔╝║║─╔╣╔╗║╔╗║║╔══╬╣║║║═╣
║╚══╣║║║╚╝║║╚╝║║║─║╚═╝║╚╝║╚╝║║║──║║╚╣║═╣
╚═══╩╝╚╩══╝╚══╝╚╝─╚═══╩══╩═╗║╚╝──╚╩═╩══╝
─────────────────────────╔═╝║
─────────────────────────╚══╝
*/
log close
zipfile tfp*,saving(For_Krisna, replace)

local list: dir . files "tfp*"
foreach f of local list {
	erase "`f'"
}
