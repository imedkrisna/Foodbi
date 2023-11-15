// Stata Graph. Make sure you run this after prodest latest v

// making MU GRAPH time series

//2017-2021
use tfpd,clear

//turn this off for all obs

sum pcm,det
drop if pcm < r(p5) | pcm > r(p95)
sum mu,detail
drop if mu>r(p95)
drop if tfp==.
asgen pcmi=pcm, w(Output) by(Disic4 year)
la var pcmi "Industry PCM"
drop mui
asgen mui=mu,w(Output) by(Disic4 year)
asgen Dasingi=Dasing,w(Output) by(Disic4 year)

save tfpdd,replace

// end of turn this off line

egen avmu=mean(mu),by(year)
egen sdmu=sd(mu),by(year)
serrbar avmu sdmu year,ylabel(0(1)8) xlabel(#5) 

graph export "figv3/mubyear.png", as(png) replace

use tfpdd,clear

egen avmu=mean(mu),by(Disic3)
egen sdmu=sd(mu),by(Disic3)
destring Disic3,replace
serrbar avmu sdmu Disic3, xlabel(#10) 

graph export "figv3/mubisic.png", as(png) replace

//17-21 only 3 industries (1043,1063,1072)

use tfpdd,clear
sort year
twoway (line mui year if Disic4==1043,lp(longdash)) || (line mui year if Disic4==1063,lp(shortdash)) || (line mui year if Disic4==1072) ||,legend(label(1 "Vegetable oil") label(2 "Rice mill") label(3 "Sugar refinery")) title("markups in 3 industries")

graph export "figv3/muinew.png", as(png) replace

twoway (line wa_cr44d year if Disic4==1043,lp(longdash)) || (line wa_cr44d year if Disic4==1063,lp(shortdash)) || (line wa_cr44d year if Disic4==1072) ||,legend(label(1 "Vegetable oil") label(2 "Rice mill") label(3 "Sugar refinery")) title("CR4 in 3 industries")

graph export "figv3/muiCR4.png", as(png) replace

twoway (line wa_hhi4d year if Disic4==1043,lp(longdash)) || (line wa_hhi4d year if Disic4==1063,lp(shortdash)) || (line wa_hhi4d year if Disic4==1072) ||,legend(label(1 "Vegetable oil") label(2 "Rice mill") label(3 "Sugar refinery")) title("HHI in 3 industries")

graph export "figv3/muiHHI.png", as(png) replace

