clear all
set more off
log using regression,replace

cd "C:\github\foodbi"

// 00-15
use tfpc,clear
duplicates drop disic4_4 year,force
xtset disic4_4 year
xtreg mui tfpi wa_cr44d,fe
outreg2 using "reg/regacr4.xls",excel replace

//xtreg mui tfp wa_hhi4d_y,fe
//outreg2 using "reg/regahhi.xls",excel replace

gen lwpi=log(wpio)

// no lags

xtreg lwpi L.lending mui wa_cr44d,fe
outreg2 using "reg/regawpi.xls",excel replace

xtreg lwpi L.birate mui wa_cr44d,fe
outreg2 using "reg/regawpibi.xls",excel replace

// lags

xtreg lwpi L.lending mui wa_cr44d,fe
outreg2 using "reg/regawpil.xls",excel replace

xtreg lwpi L.birate mui wa_cr44d,fe
outreg2 using "reg/regawpibil.xls",excel replace

// 17-21

use tfpd,clear
duplicates drop Disic4 year,force
xtset Disic4 year
xtreg mui tfpi wa_cr44d,fe
outreg2 using "reg/regbcr4.xls",excel replace

//xtreg mui tfp wa_hhi4d_y,fe
//outreg2 using "reg/regbhhi.xls",excel replace

gen lwpi=log(wpi)

//no lags

xtreg lwpi lending mui tfpi wa_cr44d,fe
outreg2 using "reg/regbwpi.xls",excel replace

xtreg lwpi L.birate mui tfpi wa_cr44d,fe
outreg2 using "reg/regbwpibi.xls",excel replace

// lags

xtreg lwpi lending mui tfpi wa_cr44d,fe
outreg2 using "reg/regbwpi.xls",excel replace

xtreg lwpi L.birate mui tfpi wa_cr44d,fe
outreg2 using "reg/regbwpibi.xls",excel replace

log close

