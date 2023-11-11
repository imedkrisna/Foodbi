// only 2017-2021

clear all
set more off
log using regression,replace

cd "C:\github\foodbi"

// PCM FIRMS

use tfpd,clear

gen tc = Rdnvcu+Rimvcu+Efuvcu+Enpvcu+Ztdvcu+It1vcu

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

