// require prodest (ssc install prodest)
// require outreg2 (ssc install outreg2)
clear all
set more off
cd "C:\github\foodbi"

// Reading a bunch of excels. File's not public so data isn't here.
// data is in my local

use "new_data/panel/data0015_5long.dta"

xtset psid year

prodest 

