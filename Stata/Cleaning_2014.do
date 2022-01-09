
/* This file takes the raw data from KLEMS and WIOD and produce the files for MATLAB */ 
*** run with Stata/IC 14.2 for Windows ***
* command 'saveold' makes .dta files compatible with version 13 *

/* Data for United Kingdom, year 2014 */

/* Basic setting up */
cls
clear all
set more off

* set current directory *
*cd "C:\YourPath\YourFolder"
cd "C:\Users\vd16509\OneDrive - University of Essex\RESEARCH\PUBLISHING\Chapter2\Codes"
****************************************************************************************

/* EU KLEMS database, September 2017 release */
*!*!* national currency *!*!*

*** Nominal: Gross value added at current basic prices (in millions of national currency) *
import excel "RawData\UK_output_17ii.xlsx", sheet("VA") firstrow clear
drop VA1970 VA1971 VA1972 VA1973 VA1974 VA1975 VA1976 VA1977 VA1978 VA1979 VA1980 VA1981 VA1982 VA1983 VA1984 VA1985 VA1986 VA1987 VA1988 VA1989 VA1990 VA1991 VA1992 VA1993 VA1994
drop desc AW
drop if code=="" 
drop VA1995 VA1996 VA1997 VA1998 VA1999 VA2000 VA2001 VA2002 VA2003 VA2004 VA2005 VA2006 VA2007 VA2008 VA2009 VA2010 VA2011 VA2012 VA2013 VA2015
saveold "Stata\Output\KLEMS_GBR_2014.dta", replace


*** Real: Gross value added, volume (2010 prices) *
import excel "RawData\UK_output_17ii.xlsx", sheet("VA_QI") firstrow clear
drop desc VA_QI1970 VA_QI1971 VA_QI1972 VA_QI1973 VA_QI1974 VA_QI1975 VA_QI1976 VA_QI1977 VA_QI1978 VA_QI1979 VA_QI1980 VA_QI1981 VA_QI1982 VA_QI1983 VA_QI1984 VA_QI1985 VA_QI1986 VA_QI1987 VA_QI1988 VA_QI1989 VA_QI1990 VA_QI1991 VA_QI1992 VA_QI1993 VA_QI1994 VA_QI1995 VA_QI1996 VA_QI1997 VA_QI1998 VA_QI1999 VA_QI2000 VA_QI2001 VA_QI2002 VA_QI2003 VA_QI2004 VA_QI2005 VA_QI2006 VA_QI2007 VA_QI2008 VA_QI2009 VA_QI2010 VA_QI2011 VA_QI2012 VA_QI2013 VA_QI2015 AW
drop if code=="" 

* merge KLEMS *
merge m:m code using "Stata\Output\KLEMS_GBR_2014.dta"
/* 
    Result                           # of obs.
    -----------------------------------------
    not matched                             0
    matched                                42  (_merge==3)
    -----------------------------------------
*/
drop _merge

saveold "Stata\Output\KLEMS_GBR_2014.dta", replace


*** Number of persons engaged (thousands) ***
import excel "RawData\UK_output_17ii.xlsx", sheet("EMP") firstrow clear

drop desc EMP1970 EMP1971 EMP1972 EMP1973 EMP1974 EMP1975 EMP1976 EMP1977 EMP1978 EMP1979 EMP1980 EMP1981 EMP1982 EMP1983 EMP1984 EMP1985 EMP1986 EMP1987 EMP1988 EMP1989 EMP1990 EMP1991 EMP1992 EMP1993 EMP1994 EMP1995 EMP1996 EMP1997 EMP1998 EMP1999 EMP2000 EMP2001 EMP2002 EMP2003 EMP2004 EMP2005 EMP2006 EMP2007 EMP2008 EMP2009 EMP2010 EMP2011 EMP2012 EMP2013 EMP2015 AW
drop if code=="" 

* merge KLEMS *
merge m:m code using "Stata\Output\KLEMS_GBR_2014.dta"
/* 
    Result                           # of obs.
    -----------------------------------------
    not matched                             0
    matched                                42  (_merge==3)
    -----------------------------------------
*/
drop _merge

saveold "Stata\Output\KLEMS_GBR_2014.dta", replace

*** Labour compensation (in millions of national currency) *
import excel "RawData\UK_output_17ii.xlsx", sheet("LAB") firstrow clear

drop desc LAB1970 LAB1971 LAB1972 LAB1973 LAB1974 LAB1975 LAB1976 LAB1977 LAB1978 LAB1979 LAB1980 LAB1981 LAB1982 LAB1983 LAB1984 LAB1985 LAB1986 LAB1987 LAB1988 LAB1989 LAB1990 LAB1991 LAB1992 LAB1993 LAB1994 LAB1995 LAB1996 LAB1997 LAB1998 LAB1999 LAB2000 LAB2001 LAB2002 LAB2003 LAB2004 LAB2005 LAB2006 LAB2007 LAB2008 LAB2009 LAB2010 LAB2011 LAB2012 LAB2013 LAB2015 AW
drop if code=="" 

* merge KLEMS *
merge m:m code using "Stata\Output\KLEMS_GBR_2014.dta"
/* 
    Result                           # of obs.
    -----------------------------------------
    not matched                             0
    matched                                42  (_merge==3)
    -----------------------------------------
*/
drop _merge

saveold "Stata\Output\KLEMS_GBR_2014.dta", replace


*** Capital compensation (in millions of national currency) *
import excel "RawData\UK_output_17ii.xlsx", sheet("CAP") firstrow clear

drop desc CAP1970 CAP1971 CAP1972 CAP1973 CAP1974 CAP1975 CAP1976 CAP1977 CAP1978 CAP1979 CAP1980 CAP1981 CAP1982 CAP1983 CAP1984 CAP1985 CAP1986 CAP1987 CAP1988 CAP1989 CAP1990 CAP1991 CAP1992 CAP1993 CAP1994 CAP1995 CAP1996 CAP1997 CAP1998 CAP1999 CAP2000 CAP2001 CAP2002 CAP2003 CAP2004 CAP2005 CAP2006 CAP2007 CAP2008 CAP2009 CAP2010 CAP2011 CAP2012 CAP2013 CAP2015 AW
drop if code=="" 

* merge KLEMS *
merge m:m code using "Stata\Output\KLEMS_GBR_2014.dta"
/* 
    Result                           # of obs.
    -----------------------------------------
    not matched                             0
    matched                                42  (_merge==3)
    -----------------------------------------
*/
drop _merge

saveold "Stata\Output\KLEMS_GBR_2014.dta", replace


*** Nominal capital stock, in millions of national currency *
import excel "RawData\UK_capital_17i.xlsx", sheet("K_GFCF") firstrow clear

drop desc K_GFCF1970 K_GFCF1971 K_GFCF1972 K_GFCF1973 K_GFCF1974 K_GFCF1975 K_GFCF1976 K_GFCF1977 K_GFCF1978 K_GFCF1979 K_GFCF1980 K_GFCF1981 K_GFCF1982 K_GFCF1983 K_GFCF1984 K_GFCF1985 K_GFCF1986 K_GFCF1987 K_GFCF1988 K_GFCF1989 K_GFCF1990 K_GFCF1991 K_GFCF1992 K_GFCF1993 K_GFCF1994 K_GFCF1995 K_GFCF1996 K_GFCF1997 K_GFCF1998 K_GFCF1999 K_GFCF2000 K_GFCF2001 K_GFCF2002 K_GFCF2003 K_GFCF2004 K_GFCF2005 K_GFCF2006 K_GFCF2007 K_GFCF2008 K_GFCF2009 K_GFCF2010 K_GFCF2011 K_GFCF2012 K_GFCF2013 K_GFCF2015

* merge KLEMS *
merge m:m code using "Stata\Output\KLEMS_GBR_2014.dta"
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

saveold "Stata\Output\KLEMS_GBR_2014.dta", replace



* * * DATA CLEANING * * *
use "Stata\Output\KLEMS_GBR_2014.dta", replace


*** merging industries ***
*!*!*!* WIOD have industries R and S merged *!*!*!* 
replace code="R-S" if code=="R" | code=="S" 
collapse (sum) K_GFCF2014 CAP2014 LAB2014 EMP2014 VA_QI2014 VA2014, by(code)

*!*!*!* Industries B, C22-C23 and H53 produced negative y *!*!*!* 
* Merging B with A
replace code="A-B" if code=="A" | code=="B" 
* Merging C22-C23 with C20-C21
replace code="20-23" if code=="20-21" | code=="22-23" 
* Merging H53 with H49-H52
replace code="49-53" if code=="49-52" | code=="53" 
collapse (sum) K_GFCF2014 CAP2014 LAB2014 EMP2014 VA_QI2014 VA2014, by(code)


* convert £ to US$: $/£= 1.64741560946446 by comparing WIOD with KLEMS *
gen CAP = CAP2014*1.64741560946446
replace CAP = 0 if missing(CAP) 

gen KAP = K_GFCF2014*1.64741560946446
replace KAP = 0 if missing(KAP) 

gen LAB = LAB2014*1.64741560946446
replace LAB = 0 if missing(LAB) 

gen EMP = EMP2014
replace EMP = 0 if missing(EMP) 

gen VA_QI = VA_QI2014*1.64741560946446
replace VA_QI = 0 if missing(VA_QI) 

gen VA = VA2014*1.64741560946446
replace VA = 0 if missing(VA) 

*** prices ***
gen PRI = VA / VA_QI


*** drop variables in dollars and VA_QI2014 ***
drop CAP2014 LAB2014 EMP2014 VA_QI2014 VA2014 K_GFCF2014
order code VA PRI KAP CAP EMP LAB

saveold "Stata\Output\KLEMS_GBR_2014_clean.dta", replace



/* SKILLS */
/* EU KLEMS database, September 2017 release */
/* Educational attainment	
1	University graduates (ISCED_5 + 6)
2	Intermediate
3	No formal qualifications */
*!*!* less industries, only 19 *!*!*

*** Shares of employment type in total industry employment ***
import excel "RawData\UK_labour_17i.xlsx", sheet("H_shares") firstrow clear
drop if year!=2014
collapse (sum) A B C D E F G H I J K L M N O P Q R S_T_U TOT MARKT, by(Edu)

* transpose dataset 
xpose, clear varname

drop if _varname=="Edu" | _varname=="MARKT" | _varname=="TOT"
rename _varname code
gen L_shares = v2 + v3
rename v1 H_shares
drop v2 v3
order code L_shares H_shares
saveold "Stata\Output\KLEMS_Skills_GBR_2014.dta", replace

* merge KLEMS *
merge m:m code using "Stata\Output\KLEMS_GBR_2014_clean.dta"
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
saveold "Stata\Output\KLEMS_GBR_2014_Complete.dta", replace

*** Export KLEMS data; Prices & Quantities spreadsheet ***
export excel using "MATLAB\Data_GBR_2014.xls", sheet("pri_qua") firstrow(variables) sheetreplace



/* Shares skill compensation in total industry labour compensation */
* aggregate only; to calculate skill market wages *
import excel "RawData\UK_labour_17i.xlsx", sheet("W_shares") firstrow clear
drop if year!=2014
collapse (sum) A B C D E F G H I J K L M N O P Q R S_T_U TOT MARKT, by(Edu)
drop A B C D E F G H I J K L M N O P Q R S_T_U MARKT

xpose, clear
drop if v1==1
gen LAB_L_share = v2 + v3
rename v1 LAB_H_share
drop v2 v3
order LAB_L_share LAB_H_share
saveold "Stata\Output\KLEMS_LAB_shares_GBR_2014.dta", replace

*** Export KLEMS data; Low and High-skilled labour shares spreadsheet ***
export excel using "MATLAB\Data_GBR_2014.xls", sheet("LH_shares") firstrow(variables) sheetreplace



/* * * WIOD * * */
*** Generate National Input-Output Table ***
*** Values are denoted in millions of US dollars ***
import excel "RawData\GBR_niot_nov16.xlsx", sheet("National IO-tables") firstrow clear

drop if Year!=2014
drop Year
drop Description
drop if Origin=="Imports"
drop Origin
drop if Code=="II_fob" | Code=="TXSP" | Code=="EXP_adj" | Code=="PURR" | Code=="PURNR" | Code=="IntTTM" 
drop CONS_h CONS_np CONS_g GFCF INVEN EXP

destring A01 A02 A03 B C10C12 C13C15 C16 C17 C18 C19 C20 C21 C22 C23 C24 C25 C26 C27 C28 C29 C30 C31_C32 C33 D35 E36 E37E39 F G45 G46 G47 H49 H50 H51 H52 H53 I J58 J59_J60 J61 J62_J63 K64 K65 K66 L68 M69_M70 M71 M72 M73 M74_M75 N O84 P85 Q R_S T U GO, replace
format A01 A02 A03 B C10C12 C13C15 C16 C17 C18 C19 C20 C21 C22 C23 C24 C25 C26 C27 C28 C29 C30 C31_C32 C33 D35 E36 E37E39 F G45 G46 G47 H49 H50 H51 H52 H53 I J58 J59_J60 J61 J62_J63 K64 K65 K66 L68 M69_M70 M71 M72 M73 M74_M75 N O84 P85 Q R_S T U GO %17.0g
saveold "Stata\Output\NIOT_GBR_2014.dta", replace


*** MERGE industries according to KLEMS (prices) ***
* rows *
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
saveold "Stata\Output\NIOT_GBR_2014_narrow.dta", replace

*** Export KLEMS data; Low and High-skilled labour shares spreadsheet ***
export excel using "MATLAB\Data_GBR_2014.xls", sheet("IO") firstrow(variables) sheetreplace

