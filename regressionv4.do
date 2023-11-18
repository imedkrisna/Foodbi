// only 2017-2021

clear all
set more off
log using regression,replace

cd "C:\github\foodbi"

// tabstat

use tfpdd,clear

// before drop: N=35,280 (see sumstat) 
// after drop: N=17,733 (see sumstat v2 and v3)

xtset Noobs year

// FIRMS

// Does market concentration affects markups?

xtreg lmu lcr4 ln Dasing cov,r
outreg2 using "regv3/freg1.doc", replace ctitle(OLS) label
xtreg lmu lcr4 ln Dasing cov,r fe
outreg2 using "regv3/freg1.doc", append ctitle(FE) label
gmm (lpcm -{xb: lcr4 ln Dasing cov _cons}), instruments(i.Disic4 cov tfp)
outreg2 using "regv3/freg1.doc", append ctitle(GMM) label 

xtreg lmu lhhi4 ln Dasing cov,r
outreg2 using "regv3/freg1.doc", append ctitle(OLS) label
xtreg lmu lhhi4 ln Dasing cov,r fe
outreg2 using "regv3/freg1.doc", append ctitle(FE) label
gmm (lmu -{xb: lhhi4 ln Dasing cov _cons}), instruments(i.Disic4 cov )
outreg2 using "regv3/freg1.doc", append ctitle(GMM) label 

// Does PCM better?

xtreg lpcm lcr4 ln Dasing cov,r
outreg2 using "regv3/freg2.doc", replace ctitle(OLS) label
xtreg lpcm lcr4 ln Dasing cov, fe r
outreg2 using "regv3/freg2.doc", append ctitle(FE) label
gmm (lpcm -{xb: lcr4 ln Dasing cov _cons}), instruments(i.Disic4 cov )
outreg2 using "regv3/freg2.doc", append ctitle(GMM) label 
xtreg lpcm lhhi4 ln Dasing cov,r
outreg2 using "regv3/freg2.doc", append ctitle(OLS) label
xtreg lpcm lhhi4 ln Dasing cov, fe r
outreg2 using "regv3/freg2.doc", append ctitle(FE) label
gmm (lpcm -{xb: lhhi4 ln Dasing cov _cons}), instruments(i.Disic4 cov )
outreg2 using "regv3/freg2.doc", append ctitle(GMM) label 

// So PCM is a value-added metric?

xtreg lpcm lmu ln Dasing cov,r
outreg2 using "regv3/freg3.doc", replace ctitle(OLS) label
xtreg lpcm lmu ln Dasing cov, fe r
outreg2 using "regv3/freg3.doc", append ctitle(FE) label
gmm (lpcm -{xb: lmu ln Dasing cov _cons}), instruments(i.Disic4 cov)
outreg2 using "regv3/freg3.doc", append ctitle(GMM) label 


// What if we combine them?

xtreg lpcm lmu lcr4 ln Dasing cov,r
outreg2 using "regv3/freg4.doc", replace ctitle(OLS) label
xtreg lpcm lmu lcr4 ln Dasing cov, fe r
outreg2 using "regv3/freg4.doc", append ctitle(FE) label
gmm (lpcm -{xb: lmu lcr4 ln Dasing cov _cons}), instruments(i.Disic4 cov )
outreg2 using "regv3/freg4.doc", append ctitle(GMM) label 
xtreg lpcm lmu lhhi4 ln Dasing cov,r
outreg2 using "regv3/freg4.doc", append ctitle(OLS) label
xtreg lpcm lmu lhhi4 ln Dasing cov, fe r
outreg2 using "regv3/freg4.doc", append ctitle(FE) label
gmm (lpcm -{xb: lmu lhhi4 ln Dasing cov _cons}), instruments(i.Disic4 cov )
outreg2 using "regv3/freg4.doc", append ctitle(GMM) label 

// INDUSTRY

duplicates drop Disic4 year,force
xtset Disic4 year

// Does market concentration affects markups?

xtreg lmui lhhi4 cov,r
outreg2 using "regv3/ireg1.doc", replace ctitle(OLS) label
xtreg lmui lhhi4 cov,r fe
outreg2 using "regv3/ireg1.doc", append ctitle(FE)  label
gmm (lmui -{xb: lhhi4 cov _cons}), instruments(cov i.Disic4)
outreg2 using "regv3/ireg1.doc", append ctitle(GMM) label 
xtreg lmui lcr4 cov,r
outreg2 using "regv3/ireg1.doc", append ctitle(OLS) label
xtreg lmui lcr4 cov,r fe
outreg2 using "regv3/ireg1.doc", append ctitle(FE) label
gmm (lmui -{xb: lcr4 cov _cons}), instruments(cov i.Disic4)
outreg2 using "regv3/ireg1.doc", append ctitle(GMM) label

// Does PCM better?

xtreg lpcmi lcr4 cov ,r
outreg2 using "regv3/ireg2.doc", replace ctitle(OLS) label
xtreg lpcmi lcr4 cov , fe r
outreg2 using "regv3/ireg2.doc", append ctitle(FE) label
gmm (lpcmi -{xb: lcr4 cov _cons}), instruments(cov i.Disic4)
outreg2 using "regv3/ireg2.doc", append ctitle(GMM) label
xtreg lpcmi lhhi4 cov ,r
outreg2 using "regv3/ireg2.doc", append ctitle(OLS) label
xtreg lpcmi lhhi4 cov , fe r
outreg2 using "regv3/ireg2.doc", append ctitle(FE) label
gmm (lpcmi -{xb: lhhi4 cov _cons}), instruments(cov i.Disic4)
outreg2 using "regv3/ireg2.doc", append ctitle(GMM) label

// So PCM is a value-added metric?

xtreg lpcmi lmui cov ,r
outreg2 using "regv3/ireg3.doc", replace ctitle(OLS) label
xtreg lpcmi lmui cov , fe r
outreg2 using "regv3/ireg3.doc", append ctitle(FE) label
gmm (lpcmi -{xb: lmui cov _cons}), instruments(cov i.Disic4)
outreg2 using "regv3/ireg3.doc", append ctitle(GMM) label

// What if we combine them?

xtreg lpcmi lmui lcr4 cov ,r
outreg2 using "regv3/ireg4.doc", replace ctitle(OLS) label
xtreg lpcmi lmui lcr4 cov , fe r
outreg2 using "regv3/ireg4.doc", append ctitle(OLS) label
gmm (lpcmi -{xb: lmui lcr4 cov _cons}), instruments(cov i.Disic4)
outreg2 using "regv3/ireg4.doc", append ctitle(GMM) label
xtreg lpcmi lmui lhhi4 cov ,r
outreg2 using "regv3/ireg4.doc", append ctitle(OLS) label
xtreg lpcmi lmui lhhi4 cov , fe r
outreg2 using "regv3/ireg4.doc", append ctitle(OLS) label
gmm (lpcmi -{xb: lmui lhhi4  cov _cons}), instruments(cov i.Disic4)
outreg2 using "regv3/ireg4.doc", append ctitle(GMM) label

//* WPI

clear all
use tfpdd,clear

duplicates drop Disic3 year,force
xtset Disic3 year

xtreg lwpi lcr3 cov,r
outreg2 using "regv3/wpicr.doc", replace label ctitle(OLS)

xtreg lwpi lcr3 cov,fe r
outreg2 using "regv3/wpicr.doc",append label ctitle(FE) 

gmm (lwpi -{xb: lcr3 cov _cons}), instruments(cov i.Disic3)
outreg2 using "regv3/wpicr.doc", append ctitle(GMM) label

xtreg lwpi lhhi3 cov,r
outreg2 using "regv3/wpicr.doc", append label ctitle(OLS)

xtreg lwpi lhhi3 cov,fe r
outreg2 using "regv3/wpicr.doc",append label ctitle(FE) 

gmm (lwpi -{xb: lhhi3 cov _cons}), instruments(cov i.Disic3)
outreg2 using "regv3/wpicr.doc", append ctitle(GMM) label

xtreg lwpi lmui3 cov,r
outreg2 using "regv3/wpimu.doc", replace label ctitle(OLS)

xtreg lwpi lmui3 cov,fe r
outreg2 using "regv3/wpimu.doc",append label ctitle(FE)

gmm (lwpi -{xb: lmui3 cov _cons}), instruments(cov i.Disic3)
outreg2 using "regv3/wpimu.doc", append ctitle(GMM) label

// WPI4

clear all
use tfpdd,clear
keep if lwpi!=.
duplicates drop Disic4 year,force
xtset Disic4 year

sepscatter lwpi2 lcr4 if lwpi2!=.,sep(Disic4) legend(label(1 "beef") label(2 "poultry") label(3 "palm oil") label(4 "rice milling") label(5 "sugar") rows(1))

graph export "figv3/wpicr.png", as(png) replace

sepscatter lwpi2 lhhi4 if lwpi2!=.,sep(Disic4) legend(label(1 "beef") label(2 "poultry") label(3 "palm oil") label(4 "rice milling") label(5 "sugar") rows(1))

graph export "figv3/wpihhi.png", as(png) replace

sepscatter lwpi2 lmui if lwpi2!=.,sep(Disic4) legend(label(1 "beef") label(2 "poultry") label(3 "palm oil") label(4 "rice milling") label(5 "sugar") rows(1))

graph export "figv3/wpimu.png", as(png) replace

xtreg lwpi2 lcr4 cov if lwpi2!=.,r
outreg2 using "regv3/wpi2cr.doc", replace label ctitle(OLS)

xtreg lwpi2 lcr4 cov if lwpi2!=.,fe r
outreg2 using "regv3/wpi2cr.doc",append label ctitle(FE)

gmm (lwpi2 -{xb: lcr4 cov _cons}) if lwpi2!=., instruments(cov i.Disic4)
outreg2 using "regv3/wpi2cr.doc", append ctitle(GMM) label

xtreg lwpi2 lhhi4 cov if lwpi2!=.,r
outreg2 using "regv3/wpi2cr.doc", append label ctitle(OLS)

xtreg lwpi2 lhhi4 cov if lwpi2!=.,fe r
outreg2 using "regv3/wpi2cr.doc",append label ctitle(FE)

gmm (lwpi2 -{xb: lhhi4 cov _cons}) if lwpi2!=., instruments(cov i.Disic4)
outreg2 using "regv3/wpi2cr.doc", append ctitle(GMM) label

xtreg lwpi2 lmui cov if lwpi2!=.,r
outreg2 using "regv3/wpi2mu.doc", replace label ctitle(OLS)

xtreg lwpi2 lmui cov if lwpi2!=.,fe r
outreg2 using "regv3/wpi2mu.doc",append label ctitle(FE) 

gmm (lwpi2 -{xb: lmui cov _cons}) if lwpi2!=., instruments(cov i.Disic3)
outreg2 using "regv3/wpi2mu.doc", append ctitle(GMM) label

//*/

log close

