
/* This file uses the data produced by MATLAB and create the chapter's figures */ 
*** run with Stata/IC 14.2 for Windows ***
* command 'saveold' makes .dta files compatible with version 13 *

/* Data for United Kingdom, year 2014 */

clear all
set more off
*cd "C:\YourPath\YourFolder"
cd "C:\Users\vd16509\OneDrive - University of Essex\RESEARCH\PUBLISHING\Chapter2\Codes\Stata"
****************************************************************************************



********************************************************************************
*** EXTRA ***
********************************************************************************
clear all
set more off
*cd "C:\Users\vd16509\OneDrive - University of Essex\RESEARCH\Second\PART_2\Stata"
cd "C:\Users\V\OneDrive - University of Essex\RESEARCH\Second\PART_2\Stata"
********************************************************************************

/* data */
import excel "Linkages_weights.xls", sheet("Sheet1") firstrow clear

saveold "Linkages_weights.dta", replace

forvalues i = 1(1)29 {
graph bar (asis) Weights_`i', over(code, label(angle(ninety))) /// 
	bar(1, fcolor(emidblue) lcolor(none) lwidth(none)) /// 
	ytitle("") ylabel(0(.25)1) ///
	title(Linkages Effects: Weights Matrix Industry `i') scheme(s1manual)
graph export "Weights_`i'.png", as(png) replace
}
*

gen factors_share=1-gammai

graph bar (asis) factors_share, over(code, label(angle(ninety))) /// 
	bar(1, fcolor(emidblue) lcolor(none) lwidth(none)) /// 
	ytitle("") ylabel(0(.25)1) ///
	title(Linkages Effects: factors_share) scheme(s1manual)
graph export "factors_share.png", as(png) replace

gen eff_LS_IO = link_LS_i*(-3.14633523300463)
gen eff_LS_noIO = l_shares*(-3.14633523300463)
gen eff_HS_IO = link_HS_i*(-2.21519123775648)
gen eff_HS_noIO = h_shares*(-2.21519123775648)

twoway (scatter eff_LS_IO l_shares, mlabel(code) mcolor(dkorange) mlabcolor(dkorange) msymbol(circle)) ///
	(lfit eff_LS_IO l_shares, lcolor(dkorange)) (lfit eff_LS_noIO l_shares, lcolor(black)), ///
	xline(0.367658972012389, lcolor(black) lwidth(medium)) scheme(s1manual) ///
	legend(on order(1 "IO CF LS" 2 "Fit" 3 "No-IO CF LS") rows(1)) 
graph export "IOnoIO_LS_lshares_model.png", as(png) replace

twoway (scatter eff_HS_IO h_shares, mlabel(code) mcolor(gray) mlabcolor(gray) msymbol(circle)) ///
	(lfit eff_HS_IO h_shares, lcolor(gray)) (lfit eff_HS_noIO h_shares, lcolor(black)), ///
	xline(0.288685166164643, lcolor(black) lwidth(medium)) scheme(s1manual) ///
	legend(on order(1 "IO CF HS" 2 "Fit" 3 "No-IO CF HS") rows(1)) 
graph export "IOnoIO_HS_hshares_model.png", as(png) replace

gen link_real_LS = link_LS_i/ l_shares
gen link_real_HS = link_HS_i/ h_shares

graph bar (asis) link_real_LS, over(code, label(angle(ninety))) /// 
	bar(1, fcolor(emidblue) lcolor(none) lwidth(none)) /// 
	ytitle("") yline(1, lcolor(black) lwidth(medium))  ///
	title(Linkages Effects LS CF: IO / no-IO) scheme(s1manual)
graph export "link_real_LS.png", as(png) replace

graph bar (asis) link_real_HS, over(code, label(angle(ninety))) /// 
	bar(1, fcolor(emidblue) lcolor(none) lwidth(none)) /// 
	ytitle("") yline(1, lcolor(black) lwidth(medium))  ///
	title(Linkages Effects HS CF: IO / no-IO) scheme(s1manual)
graph export "link_real_HS.png", as(png) replace


graph bar (asis) l_shares_adj, over(code, label(angle(ninety))) /// 
	bar(1, fcolor(emidblue) lcolor(none) lwidth(none)) /// 
	ytitle("") yline(1, lcolor(black) lwidth(medium))  ///
	title(Adjusted Low-skilled labour shares) scheme(s1manual)
graph export "l_shares_adj.png", as(png) replace

graph bar (asis) h_shares_adj, over(code, label(angle(ninety))) /// 
	bar(1, fcolor(emidblue) lcolor(none) lwidth(none)) /// 
	ytitle("") yline(1, lcolor(black) lwidth(medium))  ///
	title(Adjusted High-skilled labour shares) scheme(s1manual)
graph export "h_shares_adj.png", as(png) replace

gen ratio_LS = l_shares / link_LS_i
gen ratio_HS = h_shares / link_HS_i

twoway (scatter ratio_LS l_shares, mlabel(code) mcolor(dkorange) mlabcolor(dkorange) msymbol(circle)) ///
	(lfit ratio_LS l_shares, lcolor(dkorange)), ///
	yline(1, lcolor(black) lwidth(medium))  ///
	xline(0.367658972012389, lcolor(black) lwidth(medium)) scheme(s1manual) ///
	legend(on order(1 "Ratio CF LS" 2 "Fit") rows(1)) 
graph export "ratioLS_lshares_model.png", as(png) replace

twoway (scatter ratio_HS h_shares, mlabel(code) mcolor(gray) mlabcolor(gray) msymbol(circle)) ///
	(lfit ratio_HS h_shares, lcolor(gray)), ///
	yline(1, lcolor(black) lwidth(medium))  ///
	xline(0.288685166164643, lcolor(black) lwidth(medium)) scheme(s1manual) ///
	legend(on order(1 "Ratio CF HS" 2 "Fit") rows(1)) 
graph export "ratioHS_hshares_model.png", as(png) replace

saveold "Linkages_weights.dta", replace


*******************


twoway (scatter gr_LS_IO l_shares, mlabel(code) mcolor(dkorange) mlabcolor(dkorange) msymbol(circle)) ///
	(lfit gr_LS_IO l_shares, lcolor(dkorange)) (lfit gr_LS_noIO l_shares, lcolor(black)), ///
	xline(0.367658972012389, lcolor(black) lwidth(medium)) scheme(s1manual) ///
	legend(on order(1 "IO CF LS" 2 "Fit" 3 "No-IO CF LS") rows(1)) 
graph export "IOnoIO_LS_lshares_data.png", as(png) replace

twoway (scatter gr_HS_IO h_shares, mlabel(code) mcolor(gray) mlabcolor(gray) msymbol(circle)) ///
	(lfit gr_HS_IO h_shares, lcolor(gray)) (lfit gr_HS_noIO h_shares, lcolor(black)), ///
	xline(0.288685166164643, lcolor(black) lwidth(medium)) scheme(s1manual) ///
	legend(on order(1 "IO CF HS" 2 "Fit" 3 "No-IO CF HS") rows(1)) 
graph export "IOnoIO_HS_hshares_data.png", as(png) replace



