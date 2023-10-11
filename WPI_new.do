clear all
set more off

cd "C:\github\foodbi"

use "new_data/use/wpi_new",clear

rename avg17 avg2017
rename avg18 avg2018
rename avg19 avg2019
drop avg2022

forvalues i = 2017/2021 {
	bys KBLI: egen wpi`i'=mean(avg`i')
	drop avg`i'
}

duplicates drop KBLI,force

reshape long wpi, i(KBLI) j(year)

rename KBLI Disic4

save wpibaru,replace

use mamin_new,clear
merge m:1 Disic4 year using wpibaru