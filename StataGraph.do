// Stata Graph. Make sure you run this after prodest latest v

// making MU GRAPH time series
// 2000-2015
use tfpa,clear

egen avmu=mean(mu),by(year)
egen sdmu=sd(mu),by(year)
serrbar avmu sdmu year,ylabel(0(1)8) xlabel(#15) 

graph export "graph/muayear.png", as(png) replace

use tfpa,clear

egen avmu=median(mu),by(disic3_4)
egen sdmu=sd(mu),by(disic3_4)
serrbar avmu sdmu disic3_4,ylabel(0(1)11.5) xlabel(#10) 

graph export "graph/muaisic.png", as(png) replace

//2017-2021
use tfpb,clear

egen avmu=mean(mu),by(year)
egen sdmu=sd(mu),by(year)
serrbar avmu sdmu year,ylabel(0(1)8) xlabel(#5) 

graph export "graph/mubyear.png", as(png) replace

use tfpb,clear

egen avmu=mean(mu),by(disic3)
egen sdmu=sd(mu),by(disic3)
destring disic3,replace
serrbar avmu sdmu disic3,ylabel(0(1)11.5) xlabel(#10) 

graph export "graph/mubisic.png", as(png) replace