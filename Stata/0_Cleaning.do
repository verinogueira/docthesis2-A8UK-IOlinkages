/* Basic setting up */
cls
clear all
set more off

* set current directory *
cd "C:\Users\vd16509\OneDrive - University of Essex\RESEARCH\PUBLISHING\Chapter2\Codessss"


/* packages required > uncomment below to install */

*ssc install sxpose 
*ssc install sutex
*ssc install estout

*!*!*! program parmest was updated and only works with Stata 16 !*!*!*
*** version to Stata 11 should be installed > uninstall latest version ***
*ado uninstall parmest
*net install parmest, from (http://www.rogernewsonresources.org.uk/stata11)


/* Cleaning APS */
run "Stata/0_Cleaning_2014.do"

/* Cleaning year 2014 */
run "Stata/0_Cleaning_2014.do"

/* Cleaning year 2003 */
run "Stata/0_Cleaning_2003.do"
