clear all
set more off
log using regression,replace

cd "C:\github\foodbi"

// 00-15
use tfpa,clear

xtset psid year
xtreg mu tfp wa_cr44d i.disic3_4,fe
outreg2 using "reg/regacr4.xls",excel replace

xtreg mu tfp wa_hhi4d_y i.ownership i.disic3_4,fe
outreg2 using "reg/regahhi.xls",excel replace

gen lwpi=log(wpio)

xtreg lwpi birate mu wa_cr44d i.disic3_4,fe
outreg2 using "reg/regawpi.xls",excel replace

// 17-21

use tfpb,clear

xtset nobs year
xtreg mu tfp wa_cr44d i.disic3_4,fe
outreg2 using "reg/regbcr4.xls",excel replace

xtreg mu tfp wa_hhi4d_y i.ownership i.disic3_4,fe
outreg2 using "reg/regbhhi.xls",excel replace

gen lwpi=log(wpio)

xtreg lwpi birate mu tfp i.disic3_4,fe
outreg2 using "reg/regbwpi.xls",excel replace

log close

