/*** Table 1A ***/
 
clear all
#delimit;
set mem 800m;
set more off;
cap log close;

log using Table1aReplication.log, replace;
 
use Lott_Dataset.dta, clear;
drop if year<1977;
drop if year>2000;
tabulate year, gen(yr);
summarize yr*;

/** Dummy Variable Model **/

areg lratmur shallf yr* [aweight=popc], absorb(fipsid);
areg lratrap shallf yr* [aweight=popc], absorb(fipsid);
areg lrataga shallf yr* [aweight=popc], absorb(fipsid);
areg lratrob shallf yr* [aweight=popc], absorb(fipsid);
areg lrataut shallf yr* [aweight=popc], absorb(fipsid);
areg lratbur shallf yr* [aweight=popc], absorb(fipsid);
areg lratlar shallf yr* [aweight=popc], absorb(fipsid);

/** Spline Model **/

gen trend = shlltrda + shlltrdb;

areg lratmur shlltrda trend yr*[aweight=popc], absorb(fipsid);
areg lratrap shlltrda trend yr*[aweight=popc], absorb(fipsid);
areg lrataga shlltrda trend yr*[aweight=popc], absorb(fipsid);
areg lratrob shlltrda trend yr*[aweight=popc], absorb(fipsid);

areg lrataut shlltrda trend yr*[aweight=popc], absorb(fipsid);
areg lratbur shlltrda trend yr*[aweight=popc], absorb(fipsid);
areg lratlar shlltrda trend yr*[aweight=popc], absorb(fipsid);

log close;
