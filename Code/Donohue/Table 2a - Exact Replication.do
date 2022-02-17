/*** Table 2A ***/
 
clear all
#delimit;
set mem 800m;
set more off;
cap log close;

log using Table2aReplication.log, replace;

use Lott_Dataset.dta, clear;
gen density=popc/aream;
drop if year<1977;
drop if year>2000;
drop ppn;
drop ppb;
drop ppw;
drop ppnpermpc;
tabulate year, gen(yr);


/** Dummy Model **/

areg lratmur shallf aomur rpcpi rpcui rpcim rpcrpo popc ppb* ppw* ppn* density yr* [aweight=popc], absorb(fipsid);
areg lratrap shallf aorap rpcpi rpcui rpcim rpcrpo popc ppb* ppw* ppn* density yr* [aweight=popc], absorb(fipsid);
areg lrataga shallf aoaga rpcpi rpcui rpcim rpcrpo popc ppb* ppw* ppn* density yr* [aweight=popc], absorb(fipsid);
areg lratrob shallf aorob rpcpi rpcui rpcim rpcrpo popc ppb* ppw* ppn* density yr* [aweight=popc], absorb(fipsid);
areg lrataut shallf aoaut rpcpi rpcui rpcim rpcrpo popc ppb* ppw* ppn* density yr* [aweight=popc], absorb(fipsid);
areg lratbur shallf aobur rpcpi rpcui rpcim rpcrpo popc ppb* ppw* ppn* density yr* [aweight=popc], absorb(fipsid);
areg lratlar shallf aolar rpcpi rpcui rpcim rpcrpo popc ppb* ppw* ppn* density yr* [aweight=popc], absorb(fipsid);

/** Spline Model **/

gen trend = shlltrdb + shlltrda;

areg lratmur shlltrda trend aomur rpcpi rpcui rpcim rpcrpo popc ppb* ppw* ppn* density yr* [aweight=popc], absorb(fipsid);
areg lratrap shlltrda trend aorap rpcpi rpcui rpcim rpcrpo popc ppb* ppw* ppn* density yr* [aweight=popc], absorb(fipsid);
areg lrataga shlltrda trend aoaga rpcpi rpcui rpcim rpcrpo popc ppb* ppw* ppn* density yr* [aweight=popc], absorb(fipsid);
areg lratrob shlltrda trend aorob rpcpi rpcui rpcim rpcrpo popc ppb* ppw* ppn* density yr* [aweight=popc], absorb(fipsid);
areg lrataut shlltrda trend aoaut rpcpi rpcui rpcim rpcrpo popc ppb* ppw* ppn* density yr* [aweight=popc], absorb(fipsid);
areg lratbur shlltrda trend aobur rpcpi rpcui rpcim rpcrpo popc ppb* ppw* ppn* density yr* [aweight=popc], absorb(fipsid);
areg lratlar shlltrda trend aolar rpcpi rpcui rpcim rpcrpo popc ppb* ppw* ppn* density yr* [aweight=popc], absorb(fipsid);

log close;
