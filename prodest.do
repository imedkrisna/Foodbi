// require prodest (ssc install prodest)
// require outreg2 (ssc install outreg2)
clear all
set more off
cd "C:\github\foodbi"

// Reading a bunch of excels. File's not public so data isn't here.
// data is in my local

use "new_data/panel/data0015_5long.dta"

xtset psid year

gen ln=log(ltlnou)
gen lk=log(v1115)
gen lo=log(output)
gen lm=log(rdnvcu+rimvcu)

prodest lo, free(ln) state(lk) proxy(lm) method(lp) acf translog fsresidual(om)

predict mu1,markups inputvar(ln)
predict mu2,markups inputvar(lm)
predict ,parameters
predict tfp,omega
