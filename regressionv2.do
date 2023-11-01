clear all
set more off
log using regression,replace

cd "C:\github\foodbi"

// 00-15
use tfpc,clear

xtset psid year
xtreg pcm mu lending wa_cr44d i.disic4_4,fe
outreg2 using "reg/regapcmfirm.xls",excel replace

duplicates drop disic4_4 year,force
xtset disic4_4 year
xtreg mui tfpi wa_cr44d,fe
outreg2 using "reg/regacr4.xls",excel replace

xtreg wa_pcm lending mui wa_cr44d,fe
outreg2 using "reg/regapcmind.xls",excel replace

//xtreg mui tfp wa_hhi4d_y,fe
//outreg2 using "reg/regahhi.xls",excel replace

gen lwpi=log(wpio)

// no lags

xtreg lwpi lending mui wa_cr44d,fe
outreg2 using "reg/regawpi.xls",excel replace

xtreg lwpi birate mui wa_cr44d,fe
outreg2 using "reg/regawpibi.xls",excel replace

// lags

xtreg lwpi L.lending mui wa_cr44d,fe
outreg2 using "reg/regawpil.xls",excel replace

xtreg lwpi L.birate mui wa_cr44d,fe
outreg2 using "reg/regawpibil.xls",excel replace

// 17-21

use tfpd,clear

xtset Noobs year
xtreg pcm mu lending wa_cr44d i.Disic4,fe
outreg2 using "reg/regbpcmfirm.xls",excel replace

duplicates drop Disic4 year,force
xtset Disic4 year
xtreg mui tfpi wa_cr44d,fe
outreg2 using "reg/regbcr4.xls",excel replace

//xtreg mui tfp wa_hhi4d_y,fe
//outreg2 using "reg/regbhhi.xls",excel replace



xtreg wa_pcm lending mui wa_cr44d,fe
outreg2 using "reg/regbpcmind.xls",excel replace

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

