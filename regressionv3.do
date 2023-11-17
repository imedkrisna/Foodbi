// only 2017-2021

clear all
set more off
log using regression,replace

cd "C:\github\foodbi"

// tabstat

use tfpdd,clear

// labeling

la var Ltlnou "no. of workers"
la var Output "Output"
la var V1115 "Capital"
la var tc "Total cost"
la var Prprex "% output exported"
la var salesor "Sales orientation"
la var tfp "Total factor productivity"
la var wa_cr44d "Industry CR4"
la var wa_hhi4d "Industry HHI"
la var pcm "Price-cost margin"
la var mu "Markups"
la var ln "Log #Workers"
la var birate "Policy rate"
la var cov "COVID-19 Dummy"
la var Dasing "Foreign ownership"

// REMOVE OUTLIERS DUE TO FUNNY INPUT
// outliers = 5% bot and 5% top

outreg2 using "regv3/sumstat.doc", replace sum(detail) keep(Ltlnou V1115 tc Output salesor tfp wa_cr44d wa_hhi4d pcm mu) eqkeep(N mean sd p50 min max) label

outreg2 using "regv3/sumstatv2.doc", replace sum(detail) keep(Ltlnou V1115 tc Output salesor tfp wa_cr44d wa_hhi4d pcm mu) eqkeep(N mean sd p50 min max) label

outreg2 using "regv3/sumstatv3.doc", replace sum(detail) keep(ln lk ltc lo tfp wa_cr44d wa_hhi4d pcm mu) eqkeep(N mean sd p50 min max) label

// before drop: N=35,280 (see sumstat) 
// after drop: N=17,733 (see sumstat v2 and v3)

xtset Noobs year

// FIRMS

// Does market concentration affects markups?

xtreg lmu 

// PCM CR4

xtreg pcm wa_cr44d birate Dasing ln cov tfp,r
outreg2 using "regv3/pcmCR4firm.doc", replace ctitle(OLS) label
xtreg pcm wa_cr44d birate Dasing ln cov tfp,fe r
outreg2 using "regv3/pcmCR4firm.doc", append ctitle(Fixed Effects) addtext(Firm FE, YES) label
xtreg pcm wa_cr44d birate Dasing ln cov tfp i.Disic4,fe r
outreg2 using "regv3/pcmCR4firm.doc", append ctitle(Fixed Effects) addtext(Firm FE, YES, Industry FE, YES) keep(wa_cr44d birate Dasing ln cov tfp) label

// PCM MARKUPS

xtreg pcm mu birate wa_cr44d ln cov tfp Dasing,r
outreg2 using "regv3/pcmMUfirm.doc", replace ctitle(OLS) label
xtreg pcm mu birate Dasing wa_cr44d i.Disic4 ln cov tfp,fe r
outreg2 using "regv3/pcmMUfirm.doc", append ctitle(Fixed Effects) addtext(Firm FE, YES) label keep(wa_cr44d birate Dasing ln cov mu tfp)
xtreg pcm mu birate wa_cr44d i.Disic4 ln cov tfp Dasing,fe r
outreg2 using "regv3/pcmMUfirm.doc", append ctitle(Fixed Effects) addtext(Firm FE, YES) keep(wa_cr44d birate Dasing ln cov mu tfp) label

xtreg pcm lmu birate wa_cr44d ln cov tfp Dasing,r
outreg2 using "regv3/pcmMUfirm_l.doc", replace ctitle(OLS) label
xtreg pcm lmu birate Dasing wa_cr44d i.Disic4 ln cov tfp,fe r
outreg2 using "regv3/pcmMUfirm_l.doc", append ctitle(Fixed Effects) addtext(Firm FE, YES) label keep(wa_cr44d birate Dasing ln cov mu tfp)
xtreg pcm lmu birate wa_cr44d i.Disic4 ln cov tfp Dasing,fe r
outreg2 using "regv3/pcmMUfirm_l.doc", append ctitle(Fixed Effects) addtext(Firm FE, YES) keep(wa_cr44d birate Dasing ln cov mu tfp) label

// INDUSTRY

duplicates drop Disic4 year,force
xtset Disic4 year

// CR4 MU

xtreg mui wa_cr44d,r
outreg2 using "regv3/CR4MU.doc", replace ctitle(OLS) label
xtreg mui wa_cr44d,r fe
outreg2 using "regv3/CR4MU.doc", append ctitle(FE) label
xtreg mui wa_cr44d birate Dasingi cov tfpi,r
outreg2 using "regv3/CR4MU.doc", append ctitle(OLS) label
xtreg mui wa_cr44d birate Dasingi cov tfpi,r fe
outreg2 using "regv3/CR4MU.doc", append ctitle(FE) label

// PCM CR4

xtreg pcmi wa_cr44d birate Dasingi cov tfpi,r
outreg2 using "regv3/pcmCR4in.doc", replace ctitle(OLS) label
xtreg pcmi wa_cr44d birate Dasingi cov tfpi,fe r
outreg2 using "regv3/pcmCR4in.doc", append ctitle(Fixed Effects) addtext(Industry, YES) label

// PCM MU

xtreg pcmi mui wa_cr44d birate Dasingi cov tfpi,r
outreg2 using "regv3/pcmCR4in.doc", replace ctitle(OLS) label
xtreg pcmi mui wa_cr44d birate Dasingi cov tfpi,fe r
outreg2 using "regv3/pcmCR4in.doc", append ctitle(Fixed Effects) addtext(Industry FE, YES) label

xtreg pcmi lmui wa_cr44d birate Dasingi cov tfpi,r
outreg2 using "regv3/pcmCR4in_l.doc", replace ctitle(OLS) label
xtreg pcmi lmui wa_cr44d birate Dasingi cov tfpi,fe r
outreg2 using "regv3/pcmCR4in_l.doc", append ctitle(Fixed Effects) addtext(Industry FE, YES) label

//* WPI

xtreg lwpi birate tfpi wa_cr44d cov,r
outreg2 using "regv3/wpi.doc", replace label ctitle(OLS)

xtreg lwpi birate tfpi wa_cr44d cov,fe r
outreg2 using "regv3/wpi.doc",append label ctitle(Fixed Effects) addtext(Industry FE,YES)

xtreg lwpi birate lmui tfpi cov,r
outreg2 using "regv3/wpi.doc", append label ctitle(OLS)

xtreg lwpi birate lmui tfpi cov,fe r
outreg2 using "regv3/wpi.doc",append label ctitle(Fixed Effects) addtext(Industry FE,YES)

xtreg lwpi birate lmui tfpi wa_cr44d cov,r
outreg2 using "regv3/wpi.doc", append label ctitle(OLS)

xtreg lwpi birate lmui tfpi wa_cr44d cov,fe r
outreg2 using "regv3/wpi.doc",append label ctitle(Fixed Effects) addtext(Industry FE,YES)

// WPI4

xtreg lwpi2 birate tfpi wa_cr44d cov if lwpi2!=.,r
outreg2 using "regv3/wpi2.doc", replace label ctitle(OLS)

xtreg lwpi2 birate tfpi wa_cr44d cov if lwpi2!=.,fe r
outreg2 using "regv3/wpi2.doc",append label ctitle(Fixed Effects) addtext(Industry FE,YES)

xtreg lwpi2 birate lmui tfpi cov if lwpi2!=.,r
outreg2 using "regv3/wpi2.doc", append label ctitle(OLS)

xtreg lwpi2 birate lmui tfpi cov if lwpi2!=.,fe r
outreg2 using "regv3/wpi2.doc",append label ctitle(Fixed Effects) addtext(Industry FE,YES)

xtreg lwpi2 birate lmui tfpi wa_cr44d cov if lwpi2!=.,r
outreg2 using "regv3/wpi2.doc", append label ctitle(OLS)

xtreg lwpi2 birate lmui tfpi wa_cr44d cov if lwpi2!=.,fe r
outreg2 using "regv3/wpi2.doc",append label ctitle(Fixed Effects) addtext(Industry FE,YES)

//*/

log close

