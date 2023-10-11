// Stata Graph. Make sure you run this after prodest latest v

// making MU GRAPH time series
// 2000-2015
use tfpc,clear

egen avmu=mean(mu),by(year)
egen sdmu=sd(mu),by(year)
serrbar avmu sdmu year,ylabel(0(1)8) xlabel(#15) 

graph export "graph/muayear.png", as(png) replace

use tfpc,clear

egen avmu=median(mu),by(disic3_4)
egen sdmu=sd(mu),by(disic3_4)
serrbar avmu sdmu disic3_4,ylabel(0(1)11.5) xlabel(#10) 

graph export "graph/muaisic.png", as(png) replace

//2017-2021
use tfpd,clear

egen avmu=mean(mu),by(year)
egen sdmu=sd(mu),by(year)
serrbar avmu sdmu year,ylabel(0(1)8) xlabel(#5) 

graph export "graph/mubyear.png", as(png) replace

use tfpd,clear

egen avmu=mean(mu),by(Disic3)
egen sdmu=sd(mu),by(Disic3)
destring Disic3,replace
serrbar avmu sdmu Disic3,ylabel(0(1)11.5) xlabel(#10) 

graph export "graph/mubisic.png", as(png) replace

//00-15 only 3 industries (1040,1061,1062,1072)

use tfpc,clear
sort year
twoway (line mui year if disic4_4==1040,lp(longdash)) || (line mui year if disic4_4==1061,lp(shortdash)) || (line mui year if disic4_4==1072) ||,legend(label(1 "Vegetable oil") label(2 "Rice mill") label(3 "Sugar refinery")) title("markups in 3 industries")

graph export "graph/muiold.png", as(png) replace



//17-21 only 3 industries (1043,1063,1072)

use tfpd,clear
sort year
twoway (line mui year if Disic4==1043,lp(longdash)) || (line mui year if Disic4==1063,lp(shortdash)) || (line mui year if Disic4==1072) ||,legend(label(1 "Vegetable oil") label(2 "Rice mill") label(3 "Sugar refinery")) title("markups in 3 industries")

graph export "graph/muinew.png", as(png) replace

