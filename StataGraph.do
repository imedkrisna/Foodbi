// Stata Graph. Make sure you run this after prodest latest v

// making MU GRAPH time series
// 2000-2015
use tfp1,clear

egen avmu=mean(mu),by(year)
egen sdmu=sd(mu),by(year)
serrbar avmu sdmu year,ysc(r(0 10))

graph export "mu1.png", as(png) replace

//2017-2021
use tfp2,clear

egen avmu=mean(mu),by(year)
egen sdmu=sd(mu),by(year)
serrbar avmu sdmu year, ysc(r(0 10))

graph export "mu2.png", as(png) replace