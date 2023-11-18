// only 2017-2021

clear all
set more off
log using regression,replace

cd "C:\github\foodbi"

// tabstat

use tfpdd,clear

outreg2 using "regv3/sumstat.doc", replace sum(detail) keep(Ltlnou V1115 tc Output salesor tfp wa_cr44d wa_hhi4d pcm mu) eqkeep(N mean sd p50 min max) label

outreg2 using "regv3/sumstatv2.doc", replace sum(detail) keep(Ltlnou V1115 tc Output salesor tfp wa_cr44d wa_hhi4d pcm mu) eqkeep(N mean sd p50 min max) label

outreg2 using "regv3/sumstatv3.doc", replace sum(detail) keep(ln lk ltc lo tfp wa_cr44d wa_hhi4d pcm mu) eqkeep(N mean sd p50 min max) label

// before drop: N=35,280 (see sumstat) 
// after drop: N=17,733 (see sumstat v2 and v3)

xtset Noobs year

// FIRMS

// Does market concentration affects markups?

xtreg lmu wa_cr44d ln Dasing cov,r
outreg2 using "regv3/freg1.doc", replace ctitle(OLS) label
xtreg lmu wa_cr44d ln Dasing cov,r fe
outreg2 using "regv3/freg1.doc", append ctitle(Fixed Effects) addtext(Firm FE, YES) label
xtreg lmu wa_cr44d ln Dasing cov i.Disic4,r fe
outreg2 using "regv3/freg1.doc", append ctitle(Fixed Effects) addtext(Firm FE, YES, Industry FE, YES) label keep(wa_cr44d ln Dasing cov)

// Does PCM better?

xtreg pcm wa_cr44d ln cov Dasing,r
outreg2 using "regv3/freg2.doc", replace ctitle(OLS) label
xtreg pcm wa_cr44d ln cov Dasing, fe r
outreg2 using "regv3/freg2.doc", append ctitle(OLS) label
xtreg pcm Dasing wa_cr44d i.Disic4 ln cov, fe r
outreg2 using "regv3/freg2.doc", append ctitle(Fixed Effects) addtext(Firm FE, YES, Industry FE, YES) label keep(wa_cr44d birate Dasing ln cov mu)

// So PCM is a value-added metric?

xtreg pcm mu ln cov Dasing,r
outreg2 using "regv3/freg3.doc", replace ctitle(OLS) label
xtreg pcm mu ln cov Dasing, fe r
outreg2 using "regv3/freg3.doc", append ctitle(OLS) label
xtreg pcm Dasing mu i.Disic4 ln cov,fe r
outreg2 using "regv3/freg3.doc", append ctitle(Fixed Effects) addtext(Firm FE, YES, Industry FE, YES) label keep(wa_cr44d birate Dasing ln cov mu)

// What if we combine them?

xtreg pcm mu wa_cr44d ln cov Dasing,r
outreg2 using "regv3/freg4.doc", replace ctitle(OLS) label
xtreg pcm mu wa_cr44d ln cov Dasing, fe r
outreg2 using "regv3/freg4.doc", append ctitle(OLS) label
xtreg pcm wa_cr44d Dasing mu i.Disic4 ln cov,fe r
outreg2 using "regv3/freg4.doc", append ctitle(Fixed Effects) addtext(Firm FE, YES, Industry FE, YES) label keep(wa_cr44d birate Dasing ln cov mu tfp)

// INDUSTRY

duplicates drop Disic4 year,force
xtset Disic4 year

// Does market concentration affects markups?

xtreg mui wa_cr44d Dasingi cov,r
outreg2 using "regv3/ireg1.doc", replace ctitle(OLS) label
xtreg mui wa_cr44d Dasingi cov,r fe
outreg2 using "regv3/ireg1.doc", append ctitle(Fixed Effects) addtext(Firm FE, YES) label

// Does PCM better?

xtreg pcmi wa_cr44d cov Dasingi,r
outreg2 using "regv3/ireg2.doc", replace ctitle(OLS) label
xtreg pcmi wa_cr44d cov Dasingi, fe r
outreg2 using "regv3/ireg2.doc", append ctitle(OLS) label

// So PCM is a value-added metric?

xtreg pcmi mui cov Dasingi,r
outreg2 using "regv3/ireg3.doc", replace ctitle(OLS) label
xtreg pcmi mui cov Dasingi, fe r
outreg2 using "regv3/ireg3.doc", append ctitle(OLS) label

// What if we combine them?

xtreg pcmi mui wa_cr44d cov Dasingi,r
outreg2 using "regv3/ireg4.doc", replace ctitle(OLS) label
xtreg pcmi mui wa_cr44d cov Dasingi, fe r
outreg2 using "regv3/ireg4.doc", append ctitle(OLS) label

//* WPI

clear all
use tfpdd,clear

duplicates drop Disic3 year,force
xtset Disic3 year

xtreg lwpi3 wa_cr44d cov,r
outreg2 using "regv3/wpi.doc", replace label ctitle(OLS)

xtreg lwpi wa_cr44d cov,fe r
outreg2 using "regv3/wpi.doc",append label ctitle(Fixed Effects) addtext(Industry FE,YES)

xtreg lwpi mui cov,r
outreg2 using "regv3/wpi.doc", append label ctitle(OLS)

xtreg lwpi mui cov,fe r
outreg2 using "regv3/wpi.doc",append label ctitle(Fixed Effects) addtext(Industry FE,YES)

xtreg lwpi mui wa_cr44d cov,r
outreg2 using "regv3/wpi.doc", append label ctitle(OLS)

xtreg lwpi mui wa_cr44d cov,fe r
outreg2 using "regv3/wpi.doc",append label ctitle(Fixed Effects) addtext(Industry FE,YES)

// WPI4

clear all
use tfpdd,clear
keep if lwpi!=.
duplicates drop Disic4 year,force
xtset Disic4 year

sepscatter lwpi2 wa_cr44d if lwpi2!=.,sep(Disic4)

xtreg lwpi2 wa_cr44d cov if lwpi2!=.,r
outreg2 using "regv3/wpi2.doc", replace label ctitle(OLS)

xtreg lwpi2  wa_cr44d cov if lwpi2!=.,fe r
outreg2 using "regv3/wpi2.doc",append label ctitle(Fixed Effects) addtext(Industry FE,YES)

xtreg lwpi2 lmui cov if lwpi2!=.,r
outreg2 using "regv3/wpi2.doc", append label ctitle(OLS)

xtreg lwpi2 lmui cov if lwpi2!=.,fe r
outreg2 using "regv3/wpi2.doc",append label ctitle(Fixed Effects) addtext(Industry FE,YES)

xtreg lwpi2 lmui wa_cr44d cov if lwpi2!=.,r
outreg2 using "regv3/wpi2.doc", append label ctitle(OLS)

xtreg lwpi2 birate lmui tfpi wa_cr44d cov if lwpi2!=.,fe r
outreg2 using "regv3/wpi2.doc",append label ctitle(Fixed Effects) addtext(Industry FE,YES)

//*/

log close

