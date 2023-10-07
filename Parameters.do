
set more off
clear all
cd "C:\github\foodbi" // Please change this to the proper working directory
//Create dta from excel
foreach i in 17 18 19 20 21 {
    import excel "C:\github\Foodbi\new_data\use\mamin`i'.xlsx", sheet("Data") firstrow clear
    destring Disic4`i', replace
	destring Disic2`i', replace
	destring Dprovi`i', replace
	destring Dkabup`i', replace
	save "new_data\use\mamin`i'.dta", replace
}

//Remove year in every variables

foreach i in 17 18 19 20 21 {
    use "new_data\use\mamin`i'.dta", clear
    foreach var of varlist Disic4`i'-Prprex`i' {
        local newvar : subinstr local var "`i'" "", all
        rename `var' `newvar'
    }
    save "new_data\use\mamin`i'_n.dta", replace
    clear
}

// HHI
foreach i in 17 18 19 20 21{
	use "new_data\use\mamin`i'_n.dta"
	egen tva4d=total(Vtlvcu), by(Disic4)
	gsort Disic4
	by Disic4: gen sh14d=(Vtlvcu/tva4d)^2
	egen hhi4d=total(sh14d), by(Disic4)
	egen hhi2d=mean(hhi4d), by(Disic2)
	save "new_data\use\mamin`i'_n.dta", replace
}


// CR4
foreach i in 17 18 19 20 21{
	use "new_data\use\mamin`i'_n.dta"
	egen rankva=rank(Vtlvcu), field by (Disic4)
	gsort Disic4 rankva
	by Disic4 : gen csumva4d=sum(Vtlvcu)
	gen z=csumva4d if rankva==4
	egen csum4va4d=max(z), by(Disic4)
	gen cr44d=csum4va4d/tva4d
	save "new_data\use\mamin`i'_n.dta", replace
}

//PCM
foreach i in 17 18 19 20 21{
	use "new_data\use\mamin`i'_n.dta"
	gen Ztdvcu=Zpdvcu+Zndvcu
	gen pcm=(Output-Rdnvcu-Rimvcu-Efuvcu-Enpvcu-Ztdvcu-It1vcu)/Output
	save "new_data\use\mamin`i'_n.dta", replace
}


//Import dependency
foreach i in 17 18 19 20 21{
	use "new_data\use\mamin`i'_n.dta", clear
	gen imdep=Rimvcu/Vtlvcu
	gen imdep_l=0
	replace imdep_l=1 if imdep>0.3
	label define importdepend 0 "non-import depend" 1 "import depend", replace
	label values imdep_l importdepend
	save "new_data\use\mamin`i'_n.dta", replace
}

//Sales orientation
foreach i in 17 18 19 20 21{
	use "new_data\use\mamin`i'_n.dta", clear
	gen salesor=0
	replace salesor=1 if Prprex==0
	label define salesorientation 0 "exporter" 1 "domestic"
	label values salesor salesorientation
	label variable salesor "sales orientation"
	save "new_data\use\mamin`i'_n.dta", replace
}

//Ownership untuk 17-19
foreach i in 17 18 19 {
	use "new_data\use\mamin`i'_n.dta", clear
	gen ownership=0
	replace ownership=0 if Dasing>20
	replace ownership=1 if Ddmstk==100
	replace ownership=2 if Dpusat!=0 | Dpemda!=0
	label define ownership 0 "foreign" 1 "domestic" 2 "SOE", replace
	label values ownership ownership
	label variable ownership "ownership"
	save "new_data\use\mamin`i'_n.dta", replace
}

foreach i in 20 21{
	use "new_data\use\mamin`i'_n.dta", clear
	gen ownership=0
	replace ownership=0 if Dasing>20
	replace ownership=1 if Ddmstk==100
	replace ownership=2 if Dpusda!=0
	label define ownership 0 "foreign" 1 "domestic" 2 "SOE", replace
	label values ownership ownership
	label variable ownership "ownership"
	save "new_data\use\mamin`i'_n.dta", replace
}

//Create share
foreach i in 17 18 19 20 21{
	use "new_data\use\mamin`i'_n.dta", clear
	egen tout4d=total(Output), by(Disic4)
	label variable tout4d "Total output isic4d"
	gen share=Output/tout4d
	label variable share "share"
	save "new_data\use\mamin`i'_n.dta", replace
}

//WEIGHTED AVERAGE
//using asgen w.avg
foreach i in 17 18 19 20 21{
	use "new_data\use\mamin`i'_n.dta", clear
	foreach p of varlist hhi4d cr44d pcm {
		asgen wa_`p'=`p', w(share) by(Disic4)
		label variable wa_`p' "w.avg of `p'"
	}
	save "new_data\use\mamin`i'_n.dta", replace
}

//COLLAPSE
foreach i in 17 18 19 20 21{
	use "new_data\use\mamin`i'_n.dta", clear
	collapse (mean) wa_hhi4d wa_cr44d wa_pcm, by(Disic2)
	save "new_data\use\mamin`i'_n_coll.dta",replace
}

foreach i in 17 18 19 20 21{
	use "new_data\use\mamin`i'_n.dta", clear
	collapse (mean) wa_hhi4d wa_cr44d wa_pcm, by(imdep_l)
	save "new_data\use\mamin`i'_n_imdep.dta",replace
}

foreach i in 17 18 19 20 21{
	use "new_data\use\mamin`i'_n.dta", clear
	collapse (mean) wa_hhi4d wa_cr44d wa_pcm if Disic4==1072 | Disic4==1040 | Disic4==1061, by(Disic4)
	save "new_data\use\mamin`i'_n_spec.dta", replace
}

foreach i in 17 18 19 20 21{
	use "new_data\use\mamin`i'_n.dta", clear
	collapse (mean) wa_hhi4d wa_cr44d wa_pcm, by(salesor)
	save "new_data\use\mamin`i'_n_salesor.dta",replace
}

foreach i in 17 18 19 20 21{
	use "new_data\use\mamin`i'_n.dta", clear
	collapse (mean) wa_hhi4d wa_cr44d wa_pcm, by(ownership)
	save "new_data\use\mamin`i'_n_ownership.dta",replace
}

//MERGE

//salesor
foreach i in 17 18 19 20 21{
	use "new_data\use\mamin`i'_n_salesor.dta", clear
	rename wa_hhi4d wa_hhi4d`i'
	rename wa_cr44d wa_cr44d`i'
	rename wa_pcm wa_pcm`i'
	save "new_data\use\mamin`i'_new_salesor.dta",replace
}

use "new_data\use\mamin17_new_salesor"
foreach i in 18 19 20 21{
	merge 1:1 salesor using "new_data\use\mamin`i'_new_salesor", nogen
}

order wa_hhi4d17-wa_pcm21, alphabetic
order salesor
save "new_data\use\salesor",replace

//ownership
foreach i in 17 18 19 20 21{
	use "new_data\use\mamin`i'_n_ownership.dta", clear
	rename wa_hhi4d wa_hhi4d`i'
	rename wa_cr44d wa_cr44d`i'
	rename wa_pcm wa_pcm`i'
	save "new_data\use\mamin`i'_new_ownership.dta",replace
}
use "new_data\use\mamin17_new_ownership",clear
foreach i in 18 19 20 21{
	merge 1:1 ownership using "new_data\use\mamin`i'_new_ownership", nogen
}

order wa_hhi4d17-wa_pcm21, alphabetic
order ownership
save "new_data\use\ownership",replace

//import depedency
foreach i in 17 18 19 20 21{
	use "new_data\use\mamin`i'_n_imdep.dta", clear
	rename wa_hhi4d wa_hhi4d`i'
	rename wa_cr44d wa_cr44d`i'
	rename wa_pcm wa_pcm`i'
	save "new_data\use\mamin`i'_new_imdep.dta",replace
}
use "new_data\use\mamin17_new_imdep",clear
foreach i in 18 19 20 21{
	merge 1:1 imdep using "new_data\use\mamin`i'_new_imdep", nogen
}

order wa_hhi4d17-wa_pcm21, alphabetic
order imdep
save "new_data\use\imdep",replace

//Specified for pre and post covid

foreach i in imdep ownership salesor {
   use "new_data/use/`i'", clear
   foreach o in wa_cr44d wa_hhi4d wa_pcm{
       gen `o'_precov = (`o'17 + `o'18 + `o'19)/3
	   gen `o'_postcov = (`o'20 + `o'21)/2
   }
   save `i', replace
}