
/* This file takes the raw data from KLEMS and WIOD and produce the files for MATLAB */ 
*** run with Stata/IC 14.2 for Windows ***
* command 'saveold' makes .dta files compatible with version 13 *

/* Data for United Kingdom, year 2003 */


/* EU KLEMS database, September 2017 release */
*!*!* national currency *!*!*

*** Nominal: Gross value added at current basic prices (in millions of national currency) *
import excel "RawData\UK_output_17ii.xlsx", sheet("VA") firstrow clear
keep code VA2003
drop if code=="" 
saveold "Stata\Output\KLEMS_GBR_2003.dta", replace


*** Real: Gross value added, volume (2010 prices) *
import excel "RawData\UK_output_17ii.xlsx", sheet("VA_QI") firstrow clear
keep code VA_QI2003
drop if code=="" 

* merge KLEMS *
merge m:m code using "Stata\Output\KLEMS_GBR_2003.dta"
/* 
    Result                           # of obs.
    -----------------------------------------
    not matched                             0
    matched                                42  (_merge==3)
    -----------------------------------------
*/
drop _merge

saveold "Stata\Output\KLEMS_GBR_2003.dta", replace


*** Number of persons engaged (thousands) ***
import excel "RawData\UK_output_17ii.xlsx", sheet("EMP") firstrow clear
keep code EMP2003
drop if code=="" 

* merge KLEMS *
merge m:m code using "Stata\Output\KLEMS_GBR_2003.dta"
/* 
    Result                           # of obs.
    -----------------------------------------
    not matched                             0
    matched                                42  (_merge==3)
    -----------------------------------------
*/
drop _merge

saveold "Stata\Output\KLEMS_GBR_2003.dta", replace

*** Labour compensation (in millions of national currency) *
import excel "RawData\UK_output_17ii.xlsx", sheet("LAB") firstrow clear
keep code LAB2003
drop if code=="" 

* merge KLEMS *
merge m:m code using "Stata\Output\KLEMS_GBR_2003.dta"
/* 
    Result                           # of obs.
    -----------------------------------------
    not matched                             0
    matched                                42  (_merge==3)
    -----------------------------------------
*/
drop _merge

saveold "Stata\Output\KLEMS_GBR_2003.dta", replace


*** Capital compensation (in millions of national currency) *
import excel "RawData\UK_output_17ii.xlsx", sheet("CAP") firstrow clear
keep code CAP2003
drop if code=="" 

* merge KLEMS *
merge m:m code using "Stata\Output\KLEMS_GBR_2003.dta"
/* 
    Result                           # of obs.
    -----------------------------------------
    not matched                             0
    matched                                42  (_merge==3)
    -----------------------------------------
*/
drop _merge

saveold "Stata\Output\KLEMS_GBR_2003.dta", replace


*** Nominal capital stock, in millions of national currency *
import excel "RawData\UK_capital_17i.xlsx", sheet("K_GFCF") firstrow clear
keep code K_GFCF2003

* merge KLEMS *
merge m:m code using "Stata\Output\KLEMS_GBR_2003.dta"
/* 
    Result                           # of obs.
    -----------------------------------------
    not matched                             0
    matched                                42  (_merge==3)
    -----------------------------------------
*/
drop _merge

*** drop aggregations ***
drop if code=="C"
drop if code=="G"
drop if code=="H"
drop if code=="J"
drop if code=="R-S"
drop if code=="O-U"
drop if code=="MARKT"
drop if code=="TOT"

saveold "Stata\Output\KLEMS_GBR_2003.dta", replace





* * * DATA CLEANING * * *
use "Stata\Output\KLEMS_GBR_2003.dta", replace


*** merging industries ***
*!*!*!* WIOD have industries R and S merged *!*!*!* 
replace code="R-S" if code=="R" | code=="S" 

*!*!*!* Industries B, C22-C23 and H53 produced negative y *!*!*!* 
* Merging B with A
replace code="A-B" if code=="A" | code=="B" 
* Merging C22-C23 with C20-C21
replace code="20-23" if code=="20-21" | code=="22-23" 
* Merging H53 with H49-H52
replace code="49-53" if code=="49-52" | code=="53" 
collapse (sum) K_GFCF2003 CAP2003 LAB2003 EMP2003 VA_QI2003 VA2003, by(code)


* convert £ to US$: $/£= 1.63437 by comparing WIOD with KLEMS *
gen CAP = CAP2003*1.63437
replace CAP = 0 if missing(CAP) 

gen KAP = K_GFCF2003*1.63437
replace KAP = 0 if missing(KAP) 

gen LAB = LAB2003*1.63437
replace LAB = 0 if missing(LAB) 

gen EMP = EMP2003
replace EMP = 0 if missing(EMP) 

gen VA_QI = VA_QI2003*1.63437
replace VA_QI = 0 if missing(VA_QI) 

gen VA = VA2003*1.63437
replace VA = 0 if missing(VA) 

*** prices ***
gen PRI = VA / VA_QI


*** drop variables in dollars and VA_QI2003 ***
drop CAP2003 LAB2003 EMP2003 VA_QI2003 VA2003 K_GFCF2003
order code VA PRI KAP CAP EMP LAB

saveold "Stata\Output\KLEMS_GBR_2003_clean.dta", replace



/* SKILLS */
/* EU KLEMS database, September 2017 release */
/* Educational attainment	
1	University graduates (ISCED_5 + 6)
2	Intermediate
3	No formal qualifications */
*!*!* less industries, omly 19 *!*!*

*** Shares of employment type in total industry employment ***
* using year 2008: the earliest available
import excel "RawData\UK_labour_17i.xlsx", sheet("H_shares") firstrow clear
drop if year!=2008
collapse (sum) A B C D E F G H I J K L M N O P Q R S_T_U TOT MARKT, by(Edu)

* transpose dataset 
xpose, clear varname

drop if _varname=="Edu" | _varname=="MARKT" | _varname=="TOT"
rename _varname code
gen L_shares = v2 + v3
rename v1 H_shares
drop v2 v3
order code L_shares H_shares
saveold "Stata\Output\KLEMS_Skills_GBR_2003.dta", replace

* merge KLEMS *
merge m:m code using "Stata\Output\KLEMS_GBR_2003_clean.dta"
/*  Result                           # of obs.
    -----------------------------------------
    not matched                            35
        from master                        12  (_merge==1)
        from using                         23  (_merge==2)

    matched                                 7  (_merge==3)
    ----------------------------------------- */
drop _merge


*** extrapolating skill shares for all industries ***

* create reference variable for source industries
sort code
gen ref = _n
gen check = .
order check ref code
replace check=ref if code=="C" 
replace check=ref if code=="G"
replace check=ref if code=="H"
replace check=ref if code=="J"
replace check=ref if code=="S_T_U"



* BEFORE running these two blocks 
* VERIFY C is in row 21 *
replace L_shares=L_shares[21] if code=="10-12"	
replace L_shares=L_shares[21] if code=="13-15"	
replace L_shares=L_shares[21] if code=="16-18"	
replace L_shares=L_shares[21] if code=="19"	
replace L_shares=L_shares[21] if code=="20-23"	
replace L_shares=L_shares[21] if code=="24-25"	
replace L_shares=L_shares[21] if code=="26-27"	
replace L_shares=L_shares[21] if code=="28"	
replace L_shares=L_shares[21] if code=="19"	
replace L_shares=L_shares[21] if code=="29-30"	
replace L_shares=L_shares[21] if code=="31-33"	

replace H_shares=H_shares[21] if code=="10-12"	
replace H_shares=H_shares[21] if code=="13-15"	
replace H_shares=H_shares[21] if code=="16-18"	
replace H_shares=H_shares[21] if code=="19"	
replace H_shares=H_shares[21] if code=="20-23"	
replace H_shares=H_shares[21] if code=="24-25"	
replace H_shares=H_shares[21] if code=="26-27"	
replace H_shares=H_shares[21] if code=="28"	
replace H_shares=H_shares[21] if code=="19"	
replace H_shares=H_shares[21] if code=="29-30"	
replace H_shares=H_shares[21] if code=="31-33"	

* BEFORE running these two blocks 
* VERIFY G is in row 26 *
replace L_shares=L_shares[26] if code=="45"	
replace L_shares=L_shares[26] if code=="46"	
replace L_shares=L_shares[26] if code=="47"	

replace H_shares=H_shares[26] if code=="45"	
replace H_shares=H_shares[26] if code=="46"	
replace H_shares=H_shares[26] if code=="47"	

* BEFORE running these two lines 
* VERIFY H is in row 27 *
replace L_shares=L_shares[27] if code=="49-53"	

replace H_shares=H_shares[27] if code=="49-53"	

* BEFORE running these two blocks 
* VERIFY J is in row 29 *
replace L_shares=L_shares[29] if code=="58-60"	
replace L_shares=L_shares[29] if code=="61"	
replace L_shares=L_shares[29] if code=="62-63"	

replace H_shares=H_shares[29] if code=="58-60"	
replace H_shares=H_shares[29] if code=="61"	
replace H_shares=H_shares[29] if code=="62-63"	

* BEFORE running these two lines 
* VERIFY S_T_U is in row 40 *
replace L_shares=L_shares[40] if code=="T"	

replace H_shares=H_shares[40] if code=="T"	


* average out those more aggregated than overall dataset *
replace L_shares=(L_shares[18]+L_shares[20])/2 if code=="A-B"	
replace H_shares=(H_shares[18]+H_shares[20])/2 if code=="A-B"	

replace L_shares=(L_shares[22]+L_shares[24])/2 if code=="D-E"	
replace H_shares=(H_shares[22]+H_shares[24])/2 if code=="D-E"	

replace L_shares=(L_shares[32]+L_shares[34])/2 if code=="M-N"	
replace H_shares=(H_shares[32]+H_shares[34])/2 if code=="M-N"	

replace L_shares=(L_shares[38]+L_shares[40])/2 if code=="R-S"	
replace H_shares=(H_shares[38]+H_shares[40])/2 if code=="R-S"	



* clarify codes *
replace code="C10-C12" if code=="10-12"	
replace code="C13-C15" if code=="13-15"	
replace code="C16-C18" if code=="16-18"	
replace code="C19" if code=="19"	
replace code="C20-C23" if code=="20-23"	
replace code="C24-C25" if code=="24-25"	
replace code="C26-C27" if code=="26-27"	
replace code="C28" if code=="28"	
replace code="C19" if code=="19"	
replace code="C29-C30" if code=="29-30"	
replace code="C31-C33" if code=="31-33"	

replace code="G45" if code=="45"	
replace code="G46" if code=="46"	
replace code="G47" if code=="47"	

replace code="H49-H53" if code=="49-53"	

replace code="J58-J60" if code=="58-60"	
replace code="J61" if code=="61"
replace code="J62-J63" if code=="62-63"	

* FINISH THE MERGE *
* drop extra industries not in overall dataset
drop if VA==.

* drop U because all variables are zero or missing
drop if code=="U"

drop check ref
sort code
saveold "Stata\Output\KLEMS_GBR_2003_Complete.dta", replace

*** Export KLEMS data; Prices & Quantities spreadsheet ***
export excel using "MATLAB\Data_GBR_2003.xls", sheet("pri_qua") firstrow(variables) sheetreplace


/* Shares skill compensation in total industry labour compensation */
* aggregate only; to calculate skill market wages *
* using year 2008: the earliest available
import excel "RawData\UK_labour_17i.xlsx", sheet("W_shares") firstrow clear
drop if year!=2008 
collapse (sum) A B C D E F G H I J K L M N O P Q R S_T_U TOT MARKT, by(Edu)
drop A B C D E F G H I J K L M N O P Q R S_T_U MARKT

xpose, clear
drop if v1==1
gen LAB_L_share = v2 + v3
rename v1 LAB_H_share
drop v2 v3
order LAB_L_share LAB_H_share
saveold "Stata\Output\KLEMS_LAB_shares_GBR_2008.dta", replace

*** Export KLEMS data; Low and High-skilled labour shares spreadsheet ***
export excel using "MATLAB\Data_GBR_2003.xls", sheet("LH_shares") firstrow(variables) sheetreplace





/* * * WIOD * * */
*** Generate National Input-Output Table ***
*** Values are denoted in millions of US dollars ***
import excel "RawData\GBR_niot_nov16.xlsx", sheet("National IO-tables") firstrow clear

drop if Year==.
drop if Year!=2003
drop Year
drop Description
drop if Origin=="Imports"
drop Origin
drop if Code=="II_fob" | Code=="TXSP" | Code=="EXP_adj" | Code=="PURR" | Code=="PURNR" | Code=="IntTTM" 
drop CONS_h CONS_np CONS_g GFCF INVEN EXP

destring A01 A02 A03 B C10C12 C13C15 C16 C17 C18 C19 C20 C21 C22 C23 C24 C25 C26 C27 C28 C29 C30 C31_C32 C33 D35 E36 E37E39 F G45 G46 G47 H49 H50 H51 H52 H53 I J58 J59_J60 J61 J62_J63 K64 K65 K66 L68 M69_M70 M71 M72 M73 M74_M75 N O84 P85 Q R_S T U GO, replace
format A01 A02 A03 B C10C12 C13C15 C16 C17 C18 C19 C20 C21 C22 C23 C24 C25 C26 C27 C28 C29 C30 C31_C32 C33 D35 E36 E37E39 F G45 G46 G47 H49 H50 H51 H52 H53 I J58 J59_J60 J61 J62_J63 K64 K65 K66 L68 M69_M70 M71 M72 M73 M74_M75 N O84 P85 Q R_S T U GO %17.0g
saveold "Stata\Output\NIOT_GBR_2003.dta", replace

* aggregate according to KLEMS (prices) *
gen ref = _n
gen str1 code1=substr(Code,1,1)
order ref code1

replace code1="A-B" if code1=="A" | code1=="B" 
replace code1=Code if Code=="C10-C12"
replace code1=Code if Code=="C13-C15"
replace code1="C16-C18" if Code=="C16" | Code=="C17" | Code=="C18"
replace code1=Code if Code=="C19"
replace code1="C20-C23" if Code=="C20" | Code=="C21" | Code=="C22" | Code=="C23" 
replace code1="C24-C25" if Code=="C24" | Code=="C25" 
replace code1="C26-C27" if Code=="C26" | Code=="C27" 
replace code1=Code if Code=="C28"
replace code1="C29-C30" if Code=="C29" | Code=="C30" 
replace code1="C31-C33" if Code=="C31_C32" | Code=="C33" 

replace code1="D-E" if Code=="D35" | Code=="E36" | Code=="E37-E39" 
replace code1=Code if Code=="G45"
replace code1=Code if Code=="G46"
replace code1=Code if Code=="G47"

replace code1="H49-H53" if Code=="H49" | Code=="H50" | Code=="H51" | Code=="H52" | Code=="H53"

replace code1="J58-J60" if Code=="J58" | Code=="J59_J60" 
replace code1=Code if Code=="J61"

replace code1="J62-J63" if Code=="J62_J63" 

replace code1="M-N" if code1=="M" | code1=="N" 

replace code1="R-S" if Code=="R_S"

replace code1=Code if Code=="VA"

drop GO
drop if Code=="GO"

drop U
drop if Code=="U"


collapse (sum) A01 A02 A03 B C10C12 C13C15 C16 C17 C18 C19 C20 C21 C22 C23 C24 C25 C26 C27 C28 C29 C30 C31_C32 C33 D35 E36 E37E39 F G45 G46 G47 H49 H50 H51 H52 H53 I J58 J59_J60 J61 J62_J63 K64 K65 K66 L68 M69_M70 M71 M72 M73 M74_M75 N O84 P85 Q R_S T, by(code1)  


* columns *
gen AB = A01 + A02 + A03 + B
gen C16C18 = C16 + C17 + C18 
gen C20C23 = C20 + C21 + C22 + C23
gen C24C25 = C24 + C25 
gen C26C27 = C26 + C27 
gen C29C30 = C29 + C30 
gen C31C33 = C31_C32 + C33
gen DE = D35 + E36 + E37E39
gen H49H53 = H49 + H50 + H51 + H52 + H53
gen J58J60 = J58 + J59_J60 
gen J62J63 = J62_J63
gen K = K64 + K65 + K66
gen L = L68
gen MN = M69_M70 + M71 + M72 + M73 + M74_M75 + N
gen O = O84
gen P = P85

rename R_S RS

drop A01 A02 A03 B C16 C17 C18 C20 C21 C22 C23 C24 C25 C26 C27 C29 C30 C31_C32 C33 D35 E36 E37E39 H49 H50 H51 H52 H53 J58 J59_J60 J62_J63 K64 K65 K66 L68 M69_M70 M71 M72 M73 M74_M75 N O84 P85
order code1 AB C10C12 C13C15 C16C18 C19 C20C23 C24C25 C26C27 C28 C29C30 C31C33 DE F G45 G46 G47 H49H53 I J58J60 J61 J62J63 K L MN O P Q RS T


***** Variable T (household consumption as industry) has zeros everywhere ***
* T does not buy from other industries *
replace T=0.01 if code1!="VA"
drop if code1=="VA"
saveold "Stata\Output\NIOT_GBR_2003_narrow.dta", replace


*** Export KLEMS data; Low and High-skilled labour shares spreadsheet ***
export excel using "MATLAB\Data_GBR_2003.xls", sheet("IO") firstrow(variables) sheetreplace


