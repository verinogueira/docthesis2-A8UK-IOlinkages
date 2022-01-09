/* This file takes the APS microdata and constructs a dataset with the stocks
of labour (employees) in 2014 by nationality (UK, A8 & others) and skill level */ 


****************************************************************************************
/* 1 - Collecting and creating variables */
****************************************************************************************

use "RawData\apsp_jd14_eul_pwta17.dta", replace


keep PWTA17 idref ILODEFR INDE07M HIQUL11D AGE NATOX7_EUL_Sub
order idref PWTA17 AGE ILODEFR INDE07M HIQUL11D NATOX7_EUL_Sub
sort idref

saveold "Stata\Output\APS_2014.dta", replace

*** keep only if In Employment ***
keep if ILODEFR==1 
* (177344 observations deleted)

/* 
. tab HIQUL11D

         Highest qualification |
           (detailed grouping) |      Freq.     Percent        Cum.
-------------------------------+-----------------------------------
                     No answer |        308        0.22        0.22
          Degree or equivalent |     41,997       29.49       29.71
              Higher education |     14,930       10.48       40.19
    GCE, A-level or equivalent |     33,495       23.52       63.71
GCSE grades A*-C or equivalent |     29,284       20.56       84.27
          Other qualifications |     12,053        8.46       92.74
              No qualification |      8,535        5.99       98.73
                  Did not know |      1,811        1.27      100.00
-------------------------------+-----------------------------------
                         Total |    142,413      100.00

. tab HIQUL11D, nolabel

    Highest |
qualificati |
         on |
  (detailed |
  grouping) |      Freq.     Percent        Cum.
------------+-----------------------------------
         -8 |        308        0.22        0.22
          1 |     41,997       29.49       29.71
          2 |     14,930       10.48       40.19
          3 |     33,495       23.52       63.71
          4 |     29,284       20.56       84.27
          5 |     12,053        8.46       92.74
          6 |      8,535        5.99       98.73
          7 |      1,811        1.27      100.00
------------+-----------------------------------
      Total |    142,413      100.00
						 

drop -8 (No answer) only
Let 7 (Did not know) be Low Skilled

*/

drop if HIQUL11D==-8

*** low/high skill ***
gen HighSk=1 if HIQUL11D==1 | HIQUL11D==2 
replace HighSk=0 if HighSk==.

tab HIQUL11D if HighSk==0

gen LowSk=1 if HighSk==0
replace LowSk=0 if LowSk==.

*** combine Skill in one variable ***
gen Skill=1 if HighSk==1
replace Skill = 0 if LowSk==1
label define Skill_label 0 "Low-Skill" 1 "High-Skill" 
label values Skill Skill_label  
label variable Skill "Skill Level" 




* Nationality

/*
tab NATOX7_EUL_Sub

        Nationality Detailed |
                  Categories |      Freq.     Percent        Cum.
-----------------------------+-----------------------------------
                          -8 |         36        0.03        0.03
                          UK |    130,783       91.83       91.86
         European Union EU15 |      2,987        2.10       93.96
          European Union EU8 |      3,413        2.40       96.35
          European Union EU2 |        493        0.35       96.70
        European Union Other |         70        0.05       96.75
                Other Europe |        292        0.21       96.95
Middle East and Central Asia |        203        0.14       97.10
                   East Asia |        257        0.18       97.28
                  South Asia |      1,496        1.05       98.33
             South East Asia |        332        0.23       98.56
          Sub-Saharan Africa |        850        0.60       99.16
                North Africa |         96        0.07       99.22
               North America |        453        0.32       99.54
   Central and South America |        310        0.22       99.76
                     Oceania |        342        0.24      100.00
-----------------------------+-----------------------------------
                       Total |    142,413      100.00



. tab NATOX7_EUL_Sub, nolabel

Nationality |
   Detailed |
 Categories |      Freq.     Percent        Cum.
------------+-----------------------------------
         -8 |         36        0.03        0.03
          1 |    130,783       91.83       91.86
          2 |      2,987        2.10       93.96
          3 |      3,413        2.40       96.35
          4 |        493        0.35       96.70
          5 |         70        0.05       96.75
          6 |        292        0.21       96.95
          7 |        203        0.14       97.10
          8 |        257        0.18       97.28
          9 |      1,496        1.05       98.33
         10 |        332        0.23       98.56
         11 |        850        0.60       99.16
         12 |         96        0.07       99.22
         13 |        453        0.32       99.54
         14 |        310        0.22       99.76
         15 |        342        0.24      100.00
------------+-----------------------------------
      Total |    142,413      100.00
				   				   
*/

 
*** immigration from A8, British and Others ***
gen NAT_UK = 0
replace NAT_UK = 1 if NATOX7_EUL_Sub==1 

gen NAT_A8 = 0
replace NAT_A8 = 1 if NATOX7_EUL_Sub==3

gen NAT_Ot = 0
replace NAT_Ot = 1 if NAT_UK==0 & NAT_A8==0

*** weights ***
rename PWTA17 PWT

saveold "Stata\Output\APS_2014.dta", replace



****************************************************************************************
/* 2 - Creating final dataset */
****************************************************************************************

use "Stata\Output\APS_2014.dta", replace

gen YEAR=2014

saveold "Stata\Output\APS_main.dta", replace


/* take whole universe */
collapse (sum) PWT, by(YEAR)
format PWT %12.0fc
rename PWT Employees
label variable Employees "Population In Employment"

saveold "Stata\Output\APS_Employees.dta", replace


/* take skill groups */
use "Stata\Output\APS_main.dta", replace

keep if HighSk==1
collapse (sum) PWT, by(YEAR)
format PWT %12.0fc
rename PWT Pop_HighSk
label variable Pop_HighSk "High-Skill Employees"
saveold "Stata\Output\APS_Pop_HighSk.dta", replace

*** just in case ***
use "Stata\Output\APS_main.dta", replace

keep if LowSk==1
collapse (sum) PWT, by(YEAR)
format PWT %12.0fc
rename PWT Pop_LowSk
label variable Pop_LowSk "Low-Skill Employees"
saveold "Stata\Output\APS_Pop_LowSk.dta", replace

*** merge ***
use "Stata\Output\APS_Employees.dta", replace
merge m:m YEAR using "Stata\Output\APS_Pop_HighSk.dta"
	drop _merge
merge m:m YEAR using "Stata\Output\APS_Pop_LowSk.dta"
	drop _merge

saveold "Stata\Output\APS_Skills.dta", replace




/* take nationality groups */

***** A8: everyone from A8 countries, regardless of entry year *****
use "Stata\Output\APS_main.dta", replace
	keep if NAT_A8==1
collapse (sum) PWT, by(YEAR)
	format PWT %12.0fc
	rename PWT A8_Employees
	label variable A8_Employees "A8 Employees"
saveold "Stata\Output\APS_A8_Emp.dta", replace


***** UK *****
use "Stata\Output\APS_main.dta", replace
	keep if NAT_UK==1
collapse (sum) PWT, by(YEAR)
	format PWT %12.0fc
	rename PWT UK_Employees
	label variable UK_Employees "UK Employees"
saveold "Stata\Output\APS_UK_Emp.dta", replace


***** Others *****
use "Stata\Output\APS_main.dta", replace
	keep if NAT_Ot==1
collapse (sum) PWT, by(YEAR)
	format PWT %12.0fc
	rename PWT Ot_Employees
	label variable Ot_Employees "Ot Employees"
saveold "Stata\Output\APS_Ot_Emp.dta", replace




/* take nationality groups within skill groups */

***** A8: everyone from A8 countries, regardless of entry year *****
use "Stata\Output\APS_main.dta", replace
	keep if HighSk==1
	keep if NAT_A8==1
collapse (sum) PWT, by(YEAR)
	format PWT %12.0fc
	rename PWT A8_HighSk
	label variable A8_HighSk "A8 - High-Skill "
saveold "Stata\Output\APS_A8_HighSk.dta", replace

***** A8: everyone from A8 countries, regardless of entry year *****
use "Stata\Output\APS_main.dta", replace
	keep if LowSk==1
	keep if NAT_A8==1
collapse (sum) PWT, by(YEAR)
	format PWT %12.0fc
	rename PWT A8_LowSk
	label variable A8_LowSk "A8 - Low-Skill "
saveold "Stata\Output\APS_A8_LowSk.dta", replace


***** UK HIGH SKILL *****
use "Stata\Output\APS_main.dta", replace
	keep if HighSk==1
	keep if NAT_UK==1
collapse (sum) PWT, by(YEAR)
	format PWT %12.0fc
	rename PWT UK_HighSk
	label variable UK_HighSk "UK - High Skill "
saveold "Stata\Output\APS_UK_HighSk.dta", replace

***** UK LOW SKILL *****
use "Stata\Output\APS_main.dta", replace
	keep if LowSk==1
	keep if NAT_UK==1
collapse (sum) PWT, by(YEAR)
	format PWT %12.0fc
	rename PWT UK_LowSk
	label variable UK_LowSk "UK - Low Skill "
saveold "Stata\Output\APS_UK_LowSk.dta", replace


***** Others HIGH SKILL *****
use "Stata\Output\APS_main.dta", replace
	keep if HighSk==1
	keep if NAT_Ot==1
collapse (sum) PWT, by(YEAR)
	format PWT %12.0fc
	rename PWT Ot_HighSk
	label variable Ot_HighSk "Ot - High Skill "
saveold "Stata\Output\APS_Ot_HighSk.dta", replace

***** Others LOW SKILL *****
use "Stata\Output\APS_main.dta", replace
	keep if LowSk==1
	keep if NAT_Ot==1
collapse (sum) PWT, by(YEAR)
	format PWT %12.0fc
	rename PWT Ot_LowSk
	label variable Ot_LowSk "Ot - Low Skill "
saveold "Stata\Output\APS_Ot_LowSk.dta", replace


*** merge ***
use "Stata\Output\APS_Skills.dta", replace
	merge m:m YEAR using "Stata\Output\APS_A8_Emp.dta"
		drop _merge
	merge m:m YEAR using "Stata\Output\APS_UK_Emp.dta"
		drop _merge	
	merge m:m YEAR using "Stata\Output\APS_Ot_Emp.dta"
		drop _merge
	merge m:m YEAR using "Stata\Output\APS_A8_HighSk.dta"
		drop _merge
	merge m:m YEAR using "Stata\Output\APS_A8_LowSk.dta"
		drop _merge	
	merge m:m YEAR using "Stata\Output\APS_UK_HighSk.dta"
		drop _merge
	merge m:m YEAR using "Stata\Output\APS_UK_LowSk.dta"
		drop _merge
	merge m:m YEAR using "Stata\Output\APS_Ot_HighSk.dta"
		drop _merge
	merge m:m YEAR using "Stata\Output\APS_Ot_LowSk.dta"
		drop _merge

		

saveold "Stata\Output\APS_Skills_Natio_2014.dta", replace


export excel using "Exhibits\APS_2014_Stocks.xls", firstrow(variables) replace
