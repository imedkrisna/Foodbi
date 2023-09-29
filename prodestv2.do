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

use "new_data/use/data0015.dta" // Pleace change this with the data in

xtset psid year
keep if disic2_4==10 // ISIC Rev. 4. For ISIC rev.3, 15

gen cost=it1vcu+rdnvcu+rimvcu+efuvcu+eplvcu+enpvcu+zpdvcu+zndvcu
gen labshare=(zpdvcu+zndvcu)/cost
gen ln=log(zpdvcu+zndvcu)
gen lk=log(v1115)
gen lo=log(output)
gen lm=log(rdnvcu+rimvcu)
gen ll=log(ltlnou)

save pakai,replace

prodest lo, free(ln) state(lk) proxy(lm) method(lp) fsresidual(om)
outreg2 using "tfp1.xls",excel replace

predict mu1,markups inputvar(ln)
predict mu2,markups inputvar(lm)
gen mu3=0.1887008/labshare
predict ,parameters
predict tfp,omega

save tfp1, replace

clear


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

prodest lo, free(ln) state(lk) proxy(lm) method(lp) fsresidual(om)
outreg2 using "tfp2.xls",excel replace

predict mu1,markups inputvar(ln)
predict mu2,markups inputvar(lm)
gen mu3=.3410782 /labshare
predict ,parameters
predict tfp,omega

save tfp2, replace

/*


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