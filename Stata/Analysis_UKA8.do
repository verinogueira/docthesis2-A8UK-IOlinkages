
/* This file uses the data produced by MATLAB and create the chapter's figures */ 
*** run with Stata/IC 14.2 for Windows ***
* command 'saveold' makes .dta files compatible with version 13 *


/* Basic setting up */
cls
clear all
set more off

* set current directory *
*cd "C:\YourPath\YourFolder"
cd "C:\Users\vd16509\OneDrive - University of Essex\RESEARCH\PUBLISHING\Chapter2\Codes"
****************************************************************************************


/* Data for United Kingdom, year 2014 */


/* create dataset for industry labels */
import excel "MATLAB\Data_GBR_2014.xls", sheet("pri_qua") firstrow clear
gen industry = _n
keep code industry
order industry code
saveold "Stata\Output\Code_UKA8.dta", replace


/* generate main working file */
import excel "Stata\Input\Summary_UKA8_2014.xls", sheet("Sheet1") firstrow clear
merge m:m industry using "Stata\Output\Code_UKA8.dta"
drop _merge
order industry code

rename dqidL_cf qchange_LIO
rename dqidH_cf qchange_HIO
rename dqidE_cf qchange_EIO

rename pq_weight go_i

rename dqidL_ratios Ratio_CF_LS 
rename dqidH_ratios Ratio_CF_HS 

rename L_in L_in_weighted
rename H_in H_in_weighted

label variable l_shares "Low-skilled labour shares"
label variable h_shares "High-skilled labour shares"
label variable L_in_weighted "Weighted average of low-skill purchases"
label variable H_in_weighted "Weighted average of high-skill purchases"

order industry code l_shares h_shares L_in_weighted H_in_weighted


* no-IO output changes = shares * magnitude of the shock
* magnitude of the shocks --> LS: -3.1463; HS: -2.2152; ES: -2.8566
*!*!* for the paper I calculated whole no-IO model instead *!*!*
*^^^*(MATLAB files in folder "Extra") *^^^*
gen qchange_LnoIO = l_shares*(-3.1463)
gen qchange_HnoIO = h_shares*(-2.2152)
gen qchange_EnoIO = e_shares*(-2.8566)


saveold "Stata\Output\Analysis_UKA8_2014.dta", replace
use "Stata\Output\Analysis_UKA8_2014.dta", clear


/* PLOTS */

* reference lines = aggregate shares: LS: 0.367658972012389; HS: 0.288685166164643

*** Figure 2.5 ***
twoway (scatter qchange_LIO l_shares, mcolor(dkorange) msymbol(circle)) ///
		(lfit qchange_LIO l_shares [pweight = go_i], lcolor(dkorange)) (lfit qchange_LnoIO l_shares, lcolor(black)) ///
		(scatter qchange_LIO l_shares [pweight = go_i], mcolor(dkorange) msymbol(circle_hollow)), ///
	xline(0.367658972012389, lcolor(black) lwidth(medium)) ///
	legend(on order(1 "IO CF LS" 2 "Fit" 3 "No-IO CF LS") rows(1)) ///
	ytitle(Weighted output changes CF LS) xtitle(Low-skill labour shares) scheme(s1manual) 
graph export "Exhibits\qchange_LIO_w_l_shares.png", as(png) replace	
	
twoway (scatter qchange_HIO h_shares, mcolor(gray) msymbol(circle)) ///
		(lfit qchange_HIO h_shares [pweight = go_i], lcolor(gray)) (lfit qchange_HnoIO h_shares, lcolor(black)) ///
		(scatter qchange_HIO h_shares [pweight = go_i], mcolor(gray) msymbol(circle_hollow)), ///
	xline(0.288685170120347, lcolor(black) lwidth(medium)) ///
	legend(on order(1 "IO CF HS" 2 "Fit" 3 "No-IO CF HS") rows(1)) ///
	ytitle(Weighted output changes CF HS) xtitle(High-skill labour shares) scheme(s1manual) 
graph export "Exhibits\qchange_HIO_w_h_shares.png", as(png) replace	


twoway (scatter qchange_EIO e_shares, mcolor(gold) msymbol(circle)) ///
		(lfit qchange_EIO e_shares [pweight = go_i], lcolor(gold)) (lfit qchange_EnoIO e_shares, lcolor(black)) ///
		(scatter qchange_EIO e_shares [pweight = go_i], mcolor(gold) msymbol(circle_hollow)), ///
	xline(0.656344142132736, lcolor(black) lwidth(medium)) ///
	legend(on order(1 "IO CF ES" 2 "Fit" 3 "No-IO CF ES") rows(1)) ///
	ytitle(Weighted output changes CF ES) xtitle(Labour shares) scheme(s1manual) 
graph export "Exhibits\qchange_EIO_w_e_shares.png", as(png) replace	



*** Table 2.2 ***
eststo clear
eststo: regress qchange_EIO e_shares [pweight = go_i]
eststo: regress qchange_EnoIO e_shares 
eststo: regress qchange_LIO l_shares [pweight = go_i]
eststo: regress qchange_LnoIO l_shares 
eststo: regress qchange_HIO h_shares [pweight = go_i]
eststo: regress qchange_HnoIO h_shares 

esttab using "Exhibits\FitLines.tex", se ar2 replace booktabs         ///
     title(Fit lines for output changes on factor shares)    ///
     addnote("Note: pweights, or sampling weights, are weights that denote the inverse of the probability that the observation is included because of the sampling design..") 
esttab using "Exhibits\FitLines.csv", replace wide plain

eststo clear


*** Figure 2.6 ***

twoway (scatter Ratio_CF_LS l_shares, mlabel(code) mcolor(dkorange) mlabcolor(dkorange) msymbol(circle)) ///
	(lfit Ratio_CF_LS l_shares, lcolor(dkorange)), ///
	yline(1, lcolor(black) lwidth(medium))  ///
	xline(0.367658972012389, lcolor(black) lwidth(medium)) scheme(s1manual) ///
	legend(on order(1 "Ratio CF LS" 2 "Fit") rows(1)) 
graph export "Exhibits\ratioLS_lshares_data.png", as(png) replace

twoway (scatter Ratio_CF_HS h_shares, mlabel(code) mcolor(gray) mlabcolor(gray) msymbol(circle)) ///
	(lfit Ratio_CF_HS h_shares, lcolor(gray)), ///
	yline(1, lcolor(black) lwidth(medium))  ///
	xline(0.288685166164643, lcolor(black) lwidth(medium)) scheme(s1manual) ///
	legend(on order(1 "Ratio CF HS" 2 "Fit") rows(1)) 
graph export "Exhibits\ratioHS_hshares_data.png", as(png) replace

saveold "Stata\Output\Analysis_UKA8_2014.dta", replace

*** Figure 2.8 ***

twoway (scatter L_in_weighted l_shares, mlabel(code) mcolor(dkorange) mlabcolor(dkorange*.75) msymbol(circle) msize(medlarge) mlabposition(11) mlabgap(zero)) ///
    (line l_shares l_shares, lcolor(black)), ///
	xtitle("`: var label l_shares'") ytitle("`: var label L_in_weighted'") ///
		xlabel(0(0.1)0.7) ylabel(0(0.1)0.7) ///
	xline(0.367658972012389, lcolor(black) lwidth(medium)) ///
	legend(order(1 "L_in_weighted" 2 "45-degree Line") rows(1)) scheme(s1manual) 
graph export "Exhibits\L_in_l_shares.png", as(png) replace


twoway (scatter H_in_weighted h_shares, mlabel(code) mcolor(gs6) mlabcolor(gray*.75) msymbol(circle) msize(medlarge) mlabposition(11) mlabgap(zero)) ///
    (line h_shares h_shares, lcolor(black)), ///	
	xlabel(0(0.1)0.7) ylabel(0(0.1)0.7) ///
	xtitle("`: var label h_shares'") ytitle("`: var label H_in_weighted'") ///
	xline(0.288685166164643, lcolor(black) lwidth(medium)) ///
	legend(order(1 "H_in_weighted" 2 "45-degree Line") rows(1)) scheme(s1manual) 
graph export "Exhibits\H_in_h_shares.png", as(png) replace





*********************************************************************************
/* Robustness test: Using parameters of 2003 */
************************************************************************************************************



* create base file with industry codes *
use "Stata\Output\Code_UKA8", clear
saveold "Stata\Output\Analysis_UKA8_PAR2003", replace

	
* import from MATLAB *
foreach s in EIO EnoIO {
	import excel "Stata\Input\PAR2003_UKA8_`s'.xls", sheet("Sheet1") firstrow clear
	gen qchange_`s'_PAR2003 = q_cf/q_obs *100-100
	label variable qchange_`s' "Output Changes `s' CF
	drop q_obs q_cf
		merge m:m industry using "Stata\Output\Analysis_UKA8_PAR2003.dta"
		drop _merge
    saveold "Stata\Output\Analysis_UKA8_PAR2003", replace
}
*
order industry code

label variable go_i "Gross output shares"
label variable e_shares "Labour shares"

saveold "Stata\Output\Analysis_UKA8_PAR2003.dta", replace


* Figure 2.20 *

twoway (scatter qchange_EIO_PAR2003 e_shares, mcolor(gold) msymbol(circle)) ///
		(lfit qchange_EIO_PAR2003 e_shares [pweight = go_i], lcolor(gold)) ///
		(lfit qchange_EnoIO_PAR2003 e_shares, lcolor(black)) ///
		(scatter qchange_EIO_PAR2003 e_shares [pweight = go_i], mcolor(gold) msymbol(circle_hollow)), ///
	xline(0.645142615699552, lcolor(black) lwidth(medium)) ///
	legend(on order(1 "IO CF ES" 2 "Fit" 3 "No-IO CF ES") rows(1)) ///
	ytitle(Weighted output changes CF ES PARAMETERS 2003) xtitle(Labour shares) scheme(s1manual) 
graph export "Exhibits\qchange_EIO_w_e_shares_PAR2003.png", as(png) replace	



*** Table 2.3 ***
eststo clear
eststo: regress qchange_EIO_PAR2003 e_shares [pweight = go_i]
eststo: regress qchange_EnoIO_PAR2003 e_shares 

esttab using "Exhibits\FitLinesG2003B.tex", b(2) se(2) ar(2) replace booktabs         ///
     title(Fit lines for output changes on factor shares PARAMETERS 2003)    ///
     addnote("Note: pweights, or sampling weights, are weights that denote the inverse of the probability that the observation is included because of the sampling design..") 
esttab using "Exhibits\FitLinesG2003.csv", replace wide plain

eststo clear

********************************
