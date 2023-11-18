clear all
set more off
cd "C:\github\foodbi" 

// treating tfpd as the final data used
use tfpd,clear

//gen hhi 4 digits
bys Disic4 year: egen output4=total(Output)
gen s4=Output/output4
bys Disic4 year: egen hhi4=total(s4*s4)

// gen cr4 4 digits
gsort Disic4 year -s4
by Disic4 year: egen cr4=total(s4*(_n<=4))

//gen hhi3
bys Disic3 year: egen output3=total(Output)
gen s3=Output/output3
bys Disic3 year: egen hhi3=total(s3*s3)

//gen cr4 3 digits
gsort Disic3 year -s3
by Disic3 year: egen cr3 = total(s3*(_n<=4))


sum pcm,det
drop if pcm < r(p5) | pcm > r(p95)
sum mu,detail
drop if mu>r(p95)
drop if tfp==.
asgen pcmi=pcm, w(Output) by(Disic4 year)
la var pcmi "Industry PCM"
drop mui
drop tfpi

asgen mui=mu,w(Output) by(Disic4 year)
asgen Dasingi=Dasing,w(Output) by(Disic4 year)
asgen Dasingi3=Dasing,w(Output) by(Disic3 year)
asgen mui3=mu,w(Output) by(Disic3 year)
asgen tfpi=tfp,w(Output) by(Disic4 year)
asgen tfpi3=tfp,w(Output) by(Disic3 year)

merge m:1 Disic3 year using wpi,gen(swt)
merge m:1 Disic4 year using wpi2,gen(swt2)

gen lmui=log(mui)
gen lmu=log(mu)
gen lmui3=log(mui3)
gen lpcm=log(pcm)
gen lpcmi=log(pcmi)
gen lhhi4=log(hhi4)
gen lhhi3=log(hhi3)
gen lcr3=log(cr3)
gen lbi=log(birate)
gen lwpi2=log(price)
gen lwpi=log(wpi10)
gen lcr4=log(cr4)
gen ldasing=log(Dasing)
gen ldasingi=log(Dasingi)

gen tc = Rdnvcu+Rimvcu+Efuvcu+Enpvcu+Ztdvcu+It1vcu
gen ltc=log(tc)

// labeling

la var Ltlnou "no. of workers"
la var Output "Output"
la var V1115 "Capitsah al"
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
la var lmu "Log of markups"
la var lmui "Log of industry markups"
la var lwpi "log of price index"
la var lwpi2 "log of price index"
la var Disic3 "ISIC-3-digits"
la var Disic2 "ISIC-2-digits"
la var Disic4 "ISIC-4-digits"
la var mui "Industry markups"
la var lbi "Log policy rate"
la var lcr4 "log CR4"
la var lcr3 "log CR4"
la var lhhi4 "log HHI"
la var lhhi3 "log HHI"
la var lmui3 "log of industry markups"

drop if Noobs==.

save tfpdd,replace

// summary statistics

outreg2 using "datv3/sumstat.doc", replace sum(detail) keep(Ltlnou V1115 tc Output salesor tfp wa_cr44d wa_hhi4d pcm mu) eqkeep(N mean sd p50 min max) label

outreg2 using "datv3/sumstatv2.doc", replace sum(detail) keep(Ltlnou V1115 tc Output salesor tfp wa_cr44d wa_hhi4d pcm mu) eqkeep(N mean sd p50 min max) label

outreg2 using "datv3/sumstatv3.doc", replace sum(detail) keep(ln lk ltc lo tfp wa_cr44d wa_hhi4d pcm mu) eqkeep(N mean sd p50 min max) label

