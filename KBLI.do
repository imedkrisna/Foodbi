clear all
set more off
cd "C:\github\foodbi"

// Reading a bunch of excels. File's not public so data isn't here.
// data is in my local so yeah

import excel "KBLI\mf10t17.xlsx", sheet("Data") firstrow
gen year=2017
rename	Disic417	Disic4
rename	Disic217	Disic2
rename	Dprovi17	Dprovi
rename	Dkabup17	Dkabup
rename	Ltlnou17	Ltlnou
rename	Zpdvcu17	Zpdvcu
rename	Zndvcu17	Zndvcu
rename	Efuvcu17	Efuvcu
rename	Eplvcu17	Eplvcu
rename	Yelvcu17	Yelvcu
rename	Ibrvcu17	Ibrvcu
rename	Irrvcu17	Irrvcu
rename	Irdvcu17	Irdvcu
rename	Iotvcu17	Iotvcu
rename	Rdnvcu17	Rdnvcu
rename	Rimvcu17	Rimvcu
rename	Yprvcu17	Yprvcu
rename	Yisvcu17	Yisvcu
rename	Nopvcu17	Nopvcu
rename	V1115	V1115
rename	Shfvcu17	Shfvcu
rename	Iinput17	Iinput
rename	Output17	Output
rename	Vtlvcu17	Vtlvcu


save kbli1,replace
clear

import excel "KBLI\mf10t18.xlsx", sheet("Data") firstrow
gen year=2018
rename	Disic418	Disic4
rename	Disic218	Disic2
rename	Dprovi18	Dprovi
rename	Dkabup18	Dkabup
rename	Ltlnou18	Ltlnou
rename	Zpdvcu18	Zpdvcu
rename	Zndvcu18	Zndvcu
rename	Efuvcu18	Efuvcu
rename	Eplvcu18	Eplvcu
rename	Yelvcu18	Yelvcu
rename	Ibrvcu18	Ibrvcu
rename	Iislov18	Iislov
rename	Iisfov18	Iisfov
rename	Irrvcu18	Irrvcu
rename	Irdvcu18	Irdvcu
rename	Iotvcu18	Iotvcu
rename	Rdnvcu18	Rdnvcu
rename	Rimvcu18	Rimvcu
rename	Yprvcu18	Yprvcu
rename	Yisvcu18	Yisvcu
rename	Nopvcu18	Nopvcu
rename	V1115	V1115
rename	Output18	Output
rename	Iinput18	Iinput
rename	Vtlvcu18	Vtlvcu
rename	Shfvcu18	Shfvcu

append using kbli1
save kbli1,replace

clear
import excel "KBLI\mf10t19.xlsx", sheet("Data") firstrow
gen year=2019
rename	Disic419	Disic4
rename	Disic219	Disic2
rename	Dprovi19	Dprovi
rename	Dkabup19	Dkabup
rename	Ltlnou19	Ltlnou
rename	Zpdvcu19	Zpdvcu
rename	Zndvcu19	Zndvcu
rename	Efuvcu19	Efuvcu
rename	Eplvcu19	Eplvcu
rename	Yelvcu19	Yelvcu
rename	Ibrvcu19	Ibrvcu
rename	Iislov19	Iislov
rename	Iisfov19	Iisfov
rename	Irrvcu19	Irrvcu
rename	Irdvcu19	Irdvcu
rename	Iotvcu19	Iotvcu
rename	Rdnvcu19	Rdnvcu
rename	Rimvcu19	Rimvcu
rename	Yprvcu19	Yprvcu
rename	Yisvcu19	Yisvcu
rename	Yrsvcu19	Yrsvcu
rename	Ysnvcu19	Ysnvcu
rename	Nopvcu19	Nopvcu
rename	V1115	V1115
rename	Output19	Output
rename	Iinput19	Iinput
rename	Vtlvcu19	Vtlvcu
rename	Shfvcu19	Shfvcu
append using kbli1
save kbli1,replace
clear
import excel "KBLI\mf10t20.xlsx", sheet("Data") firstrow
gen year=2020
rename	Disic420	Disic4
rename	Disic220	Disic2
rename	Pprv1ypr	Pprv1ypr
rename	Dprovi20	Dprovi
rename	Dkabup20	Dkabup
rename	Ltlnou20	Ltlnou
rename	Zpdvcu20	Zpdvcu
rename	Zndvcu20	Zndvcu
rename	Yprvcu20	Yprvcu
rename	Output20	Output
rename	Iinput20	Iinput
rename	Vtlvcu20	Vtlvcu
rename	Rdnvcu20	Rdnvcu
rename	Rimvcu20	Rimvcu
rename	Efuvcu20	Efuvcu
rename	Ibrvcu20	Ibrvcu
rename	Iislov20	Iislov
rename	Iisfov20	Iisfov
rename	Ipkvcu20	Ipkvcu
rename	Irdvcu20	Irdvcu
rename	Eplvcu20	Eplvcu
rename	Iotvcu20	Iotvcu
rename	Yisvcu20	Yisvcu
rename	Yelvcu20	Yelvcu20
rename	Shfvcu20	Shfvcu
rename	Nopvcu20	Nopvcu
rename	Ytovcu20	Ytovcu
rename	V1115	V1115
append using kbli1
save kbli1,replace

// If use LP but industry

/*drop if V1115==0
destring Disic4, generate(id)
bys id year: egen to=total(Output)
bys id year: egen ti=total(Iinput)
bys id year: egen tk=total(V1115)
bys id year: egen tn=total(Ltlnou)
bys id year: egen tm=total(Rimvcu+Rdnvcu)
bys id year: egen tnp=total(Zpdvcu+Zndvcu)


keep id year to tk tn tm tnp ti
duplicates drop
xtset id year

gen lo=log(to)
gen lk=log(tk)
gen ln=log(tn)
gen lm=log(tm)

prodest lo, free(ln) proxy(lm) state(lk) method(lp) acf trans

gen theta=.5792606+(2*ln* -.014627)+(lk*-.0256636)+(lm*.0004717)
gen alp=tnp/to
gen alpa=tnp/ti
gen mu=theta/alp
gen mua=theta/alpa
*/

// If not use industry but use normal translog
// still needs deflator

gen lo=log(Output)
gen lk=log(V1115)
gen ln=log(Ltlnou)
gen lk2=lk*lk
gen ln2=ln*ln
gen lkn=lk*ln
destring Disic4, generate(id)
//reg lo lk ln i.id
reg lo lk ln lk2 ln2 lkn i.id

gen theta=2.166884+(2*-.0755881*ln)+(-.0247054*lk)

gen alpa=(Zpdvcu+Zndvcu)/(Zpdvcu+Zndvcu+V1115)
gen alp=(Zpdvcu+Zndvcu)/Output

gen mua=theta/alpa
gen mu=theta/alp



