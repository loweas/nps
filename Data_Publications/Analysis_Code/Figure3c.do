*** Use code below to set your local file path

clear 
clear matrix
set more off, permanently

use "/Users/ashleylowe/NPS/Data_Publications/nps_social_combined.dta", replace
keep if parktype=="National Park"

sort parkname
cap drop parkid
egen parkid = group(parkname)
xtset parkid yrmonth


g year_firsttwitterpost = 1960 + floor(firsttweetmonth_tw/12) // the year() fn doesn't like %tm dates
g year_firstinstagrampost = 1960 + floor(firstpost_ym_ig/12) // the year() fn doesn't like %tm dates
g after_twitter = (yrmonth >= firsttweetmonth_tw)
g after_instagram = (yrmonth >= firstpost_ym_ig)

* park-by-X FEs
sort parkid yrmonth
egen park_x_year = group(parkid year)
egen park_x_month = group(parkid month)

* post vars
g post2010 = (year >= 2010)
g post2015 = (year >= 2015)

* some new vars
g ln_recvisits = ln(recreationvisits)
g ihs_recvisits = asinh(recreationvisits)
g d2016 = (year==2016)

* generate social media exposure variables via composite rank
di 62/4
tab rank_social
g rank1 = (rank_social < 15.5)
g rank2 = (rank_social >= 15.5 & rank_social <= 31)
g rank3 = (rank_social > 31 & rank_social < 46.5)
g rank4 = (rank_social >= 46.5)
g SME_lo = (rank4==1 | rank3==1)
g SME_hi = (rank2==1 | rank1==1)

* generate google trends rank for IV
tab rank_gtrends
g grank1 = (rank_gtrends < 15.5)
g grank2 = (rank_gtrends >= 15.5 & rank_gtrends < 31)
g grank3 = (rank_gtrends >= 31   & rank_gtrends < 46.5)
g grank4 = (rank_gtrends >= 46.5)
g google_lo = (grank4==1 | grank3==1)
g google_hi = (grank2==1 | grank1==1)

* rescale revenue variables to millions of dollars
replace rev_total = rev_total/1000000
replace rev_totentrancefee = rev_totentrancefee/1000000
replace rev_totpasses = rev_totpasses/1000000
replace rev_totreccampfees = rev_totreccampfees/1000000

global W = "tMax_bin1 tMax_bin2 tMax_bin3 tMax_bin4 tMax_bin5 tMax_bin6 tMax_bin7 prcp"
global X1 = "realpci unemploymentrate"
global X2 = "realgdp unemploymentrate"
global TR =  "trend" 

label var post2010 "$1[\mbox{Post 2010}_{t}]$"
label var post2015 "$1[\mbox{Post 2015}_{t}]$"
label var after_twitter "$1[\mbox{Post Twitter}_{it}]$"
label var after_instagram "$1[\mbox{Post Instagram}_{it}]$"




*****************************************
* Table 1, Panel A - SME hi/lo
*****************************************
* replace post variable before each regression post = [post2010, post2015, after_twitter, after_instagram]
cap drop post 
cap drop post_SME_hi
	g post = post2010
	g post_SME_hi = post2010*SME_hi
reghdfe ihs_recvisits post_SME_hi $W $X1 if year>=2000, absorb(park_x_month year) cluster(park_x_month yrmonth)

tab parkname if recreationvisits==0 & e(sample)

estimate store A

cap drop post 
cap drop post_SME_hi
cap drop post_google_hi
	g post = post2010
	g post_SME_hi = post2010*SME_hi
	g post_google_hi = post2010*google_hi
ivreghdfe ihs_recvisits (post_SME_hi = post_google_hi) $W $X1 if year>=2000, absorb(park_x_month year) cluster(park_x_month yrmonth)


estimate store B

cap drop post 
cap drop post_SME_hi
	g post = post2010
	g post_SME_hi = post2010*SME_hi
reghdfe ihs_recvisits post_SME_hi $W $X1 if year>=2000, absorb(park_x_month year) vce(robust)
tab parkname if recreationvisits==0 & e(sample)

estimate store C

cap drop post 
cap drop post_SME_hi
cap drop post_google_hi
	g post = post2010
	g post_SME_hi = post2010*SME_hi
	g post_google_hi = post2010*google_hi
ivreghdfe ihs_recvisits (post_SME_hi = post_google_hi) $W $X1 if year>=2000, absorb(park_x_month yrmonth) vce(robust)


estimate store D


cap drop post 
cap drop post_SME_hi
	g post = post2010
	g post_SME_hi = post2010*SME_hi
reghdfe ihs_recvisits post_SME_hi $W $X1 if year>=2000, absorb(park_x_month year) cluster(parkid yrmonth)

tab parkname if recreationvisits==0 & e(sample)

estimate store E

cap drop post 
cap drop post_SME_hi
cap drop post_google_hi
	g post = post2010
	g post_SME_hi = post2010*SME_hi
	g post_google_hi = post2010*google_hi
ivreghdfe ihs_recvisits (post_SME_hi = post_google_hi) $W $X1 if year>=2000, absorb(park_x_month year)  partial($W $X1)  cluster(parkid yrmonth)


estimate store F

cap drop post 
cap drop post_SME_hi
cap drop post_google_hi
	g post = post2015
	g post_SME_hi = post2015*SME_hi
	g post_google_hi = post2015*google_hi
ivreghdfe ihs_recvisits (post_SME_hi = post_google_hi) $W $X1 if year>=2000, absorb(park_x_month year)  partial($W $X1)  cluster(parkid yrmonth)


estimate store G



import delimited "/Users/ashleylowe/NPS/Data_Publications/NPSM_Maintable1.csv", clear 

***************
*Import to run*
***************

gen modate = ym(year, month)
format modate %tm 
egen park = group(parkname)

egen regions = group(region)
egen states = group(state)
gen lnvisits=log( recreationvisits)
generate lngas=log(realgasprice)
generate lnnomgas=log(nomilgasprice)
generate lnpop=log(popthm)
drop if year>=2020
destring state_pop, replace
generate lnstatepop=log(state_pop)
generate lndisposable =log(real_disposablepi)
gen per_65=percentpop65*100
gen lnrecreaction_hyperbolic= asinh( recreationvisits)
egen parkmonth = group(park month)
egen yearmonth = group(year month)
*******************************************
*Generate variable for instagram that has *
* 0s before Insta to run on FULL DATA set *
*******************************************
drop if puds==0 & year==2019
generate uploadsall=puds


**************************************************
*Instagram Use variable 1 for May 2012 and beyond*
**************************************************

generate instmay2012=0
replace instmay2012=1 if year >=2012 & month>=5
replace instmay2012=1 if year >2012 

generate insta2014=0
replace insta2014=1 if year >=2014 & month>=1
replace insta2014=1 if year >2014 


generate instalaunch=0
replace instalaunch=1 if year >=2010 & month>=10
replace instalaunch=1 if year >2010 

generate nine_11=0
replace nine_11=1 if year >=2001 & month>=10
replace nine_11=1 if year >=2002

*********************
*Following Bergstorm*
*********************

replace pervehiclefee=0 if pervehiclefee==.
generate lnfee_hyper=asinh( pervehicle)
generate lnfee=log( pervehicle)

replace lnfee=0 if lnfee==.
generate lnfee1=log( pervehicle+1)



generate fee=pervehiclefee
replace fee=1 if fee>0

xtset park modate


** PNAS Paper grouping **

gen grouphigh_GOOGLE=0
replace grouphigh_GOOGLE=1 if parkname=="Acadia National Park"
replace grouphigh_GOOGLE=1 if parkname=="Arches National Park"
replace grouphigh_GOOGLE=1 if parkname=="Badlands National Park"
replace grouphigh_GOOGLE=1 if parkname=="Bryce Canyon National Park"
replace grouphigh_GOOGLE=1 if parkname=="Canyonlands National Park"
replace grouphigh_GOOGLE=1 if parkname=="Carlsbad Caverns National Park"
replace grouphigh_GOOGLE=1 if parkname=="Crater Lake National Park"
replace grouphigh_GOOGLE=1 if parkname=="Death Valley National Park"
replace grouphigh_GOOGLE=1 if parkname=="Everglades National Park"
replace grouphigh_GOOGLE=1 if parkname=="Glacier National Park"
replace grouphigh_GOOGLE=1 if parkname=="Crater Lake National Park"
replace grouphigh_GOOGLE=1 if parkname=="Grand Canyon National Park"
replace grouphigh_GOOGLE=1 if parkname=="Grand Teton National Park"
replace grouphigh_GOOGLE=1 if parkname=="Joshua Tree National Park"
replace grouphigh_GOOGLE=1 if parkname=="Kings Canyon National Park"
replace grouphigh_GOOGLE=1 if parkname=="Mammoth Cave National Park"
replace grouphigh_GOOGLE=1 if parkname=="Mesa Verde National Park"
replace grouphigh_GOOGLE=1 if parkname=="Mount Rainier National Park"
replace grouphigh_GOOGLE=1 if parkname=="Olympic National Park"
replace grouphigh_GOOGLE=1 if parkname=="Redwood National Park"
replace grouphigh_GOOGLE=1 if parkname=="Rocky Mountain National Park"
replace grouphigh_GOOGLE=1 if parkname=="Sequoia National Park"
replace grouphigh_GOOGLE=1 if parkname=="Shenandoah National Park"
replace grouphigh_GOOGLE=1 if parkname=="Yellowstone National Park"
replace grouphigh_GOOGLE=1 if parkname=="Yosemite National Park"
replace grouphigh_GOOGLE=1 if parkname=="Zion National Park"



gen grouphigh_CASEY=0
replace grouphigh_CASEY=1 if parkname=="Acadia National Park"
replace grouphigh_CASEY=1 if parkname=="Arches National Park"
replace grouphigh_CASEY=1 if parkname=="Badlands National Park"
replace grouphigh_CASEY=1 if parkname=="Big Bend National Park"
replace grouphigh_CASEY=1 if parkname=="Bryce Canyon National Park"
replace grouphigh_CASEY=1 if parkname=="Canyonlands National Park"
replace grouphigh_CASEY=1 if parkname=="Capitol Reef National Park"
replace grouphigh_CASEY=1 if parkname=="Death Valley National Park"
replace grouphigh_CASEY=1 if parkname=="Everglades National Park"
replace grouphigh_CASEY=1 if parkname=="Glacier National Park"
replace grouphigh_CASEY=1 if parkname=="Grand Canyon National Park"
replace grouphigh_CASEY=1 if parkname=="Grand Teton National Park"
replace grouphigh_CASEY=1 if parkname=="Great Smoky Mountains National Park"
replace grouphigh_CASEY=1 if parkname=="Joshua Tree National Park"
replace grouphigh_CASEY=1 if parkname=="Mount Rainier National Park"
replace grouphigh_CASEY=1 if parkname=="Olympic National Park"
replace grouphigh_CASEY=1 if parkname=="Petrified Forest National Park"
replace grouphigh_CASEY=1 if parkname=="Redwood National Park"
replace grouphigh_CASEY=1 if parkname=="Rocky Mountain National Park"
replace grouphigh_CASEY=1 if parkname=="Saguaro National Park"
replace grouphigh_CASEY=1 if parkname=="Sequoia National Park"
replace grouphigh_CASEY=1 if parkname=="Shenandoah National Park"
replace grouphigh_CASEY=1 if parkname=="Yellowstone National Park"
replace grouphigh_CASEY=1 if parkname=="Yosemite National Park"
replace grouphigh_CASEY=1 if parkname=="Zion National Park"


** Split into 20/20 PNAS Paper grouping **



gen grouphigh_CASEY20=0

replace grouphigh_CASEY20=1 if parkname=="Yellowstone National Park"
replace grouphigh_CASEY20=1 if parkname=="Yosemite National Park"
replace grouphigh_CASEY20=1 if parkname=="Glacier National Park"
replace grouphigh_CASEY20=1 if parkname=="Grand Canyon National Park"
replace grouphigh_CASEY20=1 if parkname=="Zion National Park"
replace grouphigh_CASEY20=1 if parkname=="Joshua Tree National Park"
replace grouphigh_CASEY20=1 if parkname=="Badlands National Park"
replace grouphigh_CASEY20=1 if parkname=="Death Valley National Park"
replace grouphigh_CASEY20=1 if parkname=="Great Smoky Mountains National Park"
replace grouphigh_CASEY20=1 if parkname=="Arches National Park"
replace grouphigh_CASEY20=1 if parkname=="Grand Teton National Park"
replace grouphigh_CASEY20=1 if parkname=="Mount Rainier National Park"
replace grouphigh_CASEY20=1 if parkname=="Rocky Mountain National Park"
replace grouphigh_CASEY20=1 if parkname=="Sequoia National Park"
replace grouphigh_CASEY20=1 if parkname=="Bryce Canyon National Park"
replace grouphigh_CASEY20=1 if parkname=="Redwood National Park"
replace grouphigh_CASEY20=1 if parkname=="Everglades National Park"
replace grouphigh_CASEY20=1 if parkname=="Shenandoah National Park"
replace grouphigh_CASEY20=1 if parkname=="Acadia National Park"
replace grouphigh_CASEY20=1 if parkname=="Olympic National Park"







gen Googletrend20=0
replace Googletrend20=1 if parkname=="Acadia National Park"
replace Googletrend20=1 if parkname=="Badlands National Park"
replace Googletrend20=1 if parkname=="Bryce Canyon National Park"
replace Googletrend20=1 if parkname=="Big Bend National Park"
replace Googletrend20=1 if parkname=="Carlsbad Caverns National Park"
replace Googletrend20=1 if parkname=="Glacier National Park"
replace Googletrend20=1 if parkname=="Crater Lake National Park"
replace Googletrend20=1 if parkname=="Grand Canyon National Park"
replace Googletrend20=1 if parkname=="Grand Teton National Park"
replace Googletrend20=1 if parkname=="Joshua Tree National Park"
replace Googletrend20=1 if parkname=="Mesa Verde National Park"
replace Googletrend20=1 if parkname=="Mount Rainier National Park"
replace Googletrend20=1 if parkname=="Olympic National Park"
replace Googletrend20=1 if parkname=="Redwood National Park"
replace Googletrend20=1 if parkname=="Rocky Mountain National Park"
replace Googletrend20=1 if parkname=="Sequoia National Park"
replace Googletrend20=1 if parkname=="Shenandoah National Park"
replace Googletrend20=1 if parkname=="Yellowstone National Park"
replace Googletrend20=1 if parkname=="Yosemite National Park"
replace Googletrend20=1 if parkname=="Zion National Park"


gen Googletrend15=0
replace Googletrend15=1 if parkname=="Grand Canyon National Park"
replace Googletrend15=1 if parkname=="Yellowstone National Park"
replace Googletrend15=1 if parkname=="Yosemite National Park"
replace Googletrend15=1 if parkname=="Zion National Park"
replace Googletrend15=1 if parkname=="Glacier National Park"
replace Googletrend15=1 if parkname=="Joshua Tree National Park"
replace Googletrend15=1 if parkname=="Shenandoah National Park"
replace Googletrend15=1 if parkname=="Acadia National Park"
replace Googletrend15=1 if parkname=="Grand Teton National Park"
replace Googletrend15=1 if parkname=="Rocky Mountain National Park"
replace Googletrend15=1 if parkname=="Crater Lake National Park"
replace Googletrend15=1 if parkname=="Mount Rainier National Park"
replace Googletrend15=1 if parkname=="Bryce Canyon National Park"
replace Googletrend15=1 if parkname=="Sequoia National Park"
replace Googletrend15=1 if parkname=="Big Bend National Park"




********K medion instead of means Cluster 3 groups *************

preserve


generate grouphigh=0
replace grouphigh=1 if parkname=="Zion National Park"
replace grouphigh=1 if parkname=="Yosemite National Park"
replace grouphigh=1 if parkname=="Kings Canyon National Park"
replace grouphigh=1 if parkname=="Sequoia National Park"
replace grouphigh=1 if parkname=="Great Smoky Mountains National Park"
replace grouphigh=1 if parkname=="Grand Canyon National Park"
replace grouphigh=1 if parkname=="Joshua Tree National Park"
replace grouphigh=1 if parkname=="Olympic National Park"
replace grouphigh=1 if parkname=="Glacier National Park"
replace grouphigh=1 if parkname=="Arches National Park"
replace grouphigh=1 if parkname=="Grand Teton National Park"
replace grouphigh=1 if parkname=="Rocky Mountain National Park"
replace grouphigh=1 if parkname=="Death Valley National Park"
replace grouphigh=1 if parkname=="Bryce Canyon National Park"
replace grouphigh=1 if parkname=="Mount Rainier National Park"
*replace grouphigh=1 if parkname=="Guadalupe Mountains National Park"
*replace grouphigh=1 if parkname=="Carlsbad Caverns National Park"
*replace grouphigh=1 if parkname=="Everglades National Park"
*replace grouphigh=1 if parkname=="Yellowstone National Park"


generate grouplow=1
replace grouplow=0 if grouphigh==1 


bysort park (modate) : gen cuminfluen90_year = sum(influential90_year)
bysort park (modate) : gen cuminfluen95_year = sum(influential95_year)
bysort park (modate) : gen cuminfluen99_year = sum(influential99_year)

generate uploadshigh=grouphigh*uploadsall
************
*Low Groups*
************


generate uploadslow=grouplow*uploadsall



**** Viral Qualifications ****  
generate cuminflu95grouphigh_year=grouphigh*cuminfluen95_year
generate cuminflu90grouphigh_year=grouphigh*cuminfluen90_year
generate cuminflu99grouphigh_year=grouphigh*cuminfluen99_year

generate cuminflu95grouplow_year=grouplow*cuminfluen95_year
generate cuminflu90grouplow_year=grouplow*cuminfluen90_year
generate cuminflu99grouplow_year=grouplow*cuminfluen99_year


replace poster95="." if poster95=="NA"
replace poster90="." if poster90=="NA"
replace allposters90="." if allposters90=="NA"
replace justinf90="." if justinf90=="NA"
replace justinf95="." if justinf95=="NA"

destring allposters90, replace
destring poster90, replace
destring poster95, replace
destring justinf90, replace
destring justinf95, replace

bysort park (modate) : gen cumposter90= sum(poster90)
bysort park (modate) : gen cumposter95= sum(poster95)
bysort park (modate) : gen cumjust90= sum(justinf90)
bysort park (modate) : gen cumjust95= sum(justinf95)

bysort park (modate) : gen cumallposters90= sum(allposters90)
*********All Influencer Post*************
generate allpostersH=grouphigh*cumallposters90
generate allpostersL=grouplow*cumallposters90

*********Only 90th of Engaging Post from Influencer ********
generate posters90PH=grouphigh*cumposter90
generate posters90PL=grouplow*cumposter90

*********Just Viral Post***********
generate just90H=grouphigh*cumjust90
generate just90L=grouplow*cumjust90

generate just95H=grouphigh*cumjust95
generate just95L=grouplow*cumjust95


generate relativelyviral=0
replace relativelyviral=1 if cuminfluen90_year>=1

generate relativelyviral99=0
replace relativelyviral99=1 if cuminfluen99_year>=1

egen parkyear = group(park year)


generate post2015=0
replace post2015=1 if year >=2015


generate relativelyinfluencer=0
replace relativelyinfluencer=1 if cumallposters90>=1


cap drop post 
cap drop post_SME_hi
cap drop post_google_hi
	g post = instalaunch
	g post_SME_hi = instalaunch*grouphigh_CASEY
	g post_google_hi = instalaunch*grouphigh_GOOGLE

reghdfe lnrecreaction_hyperbolic t_above90 t_80 t_60 t_50 t_40 t_30 t_less30 lightrain moderaterain heavyrain lndisposable unemploy post post_SME_hi if year>=1993 & year<2020, absorb(i.park##i.month i.year) cluster(park yearmonth) 

estimate store G

ivreghdfe lnrecreaction_hyperbolic t_above90 t_80 t_60 t_50 t_40 t_30 t_less30 lightrain moderaterain heavyrain lndisposable unemploy (post_SME_hi= post_google_hi) if year>=1993 & year<2020, absorb(i.park##i.month i.year) cluster(park yearmonth) 
estimate store H

reghdfe lnrecreaction_hyperbolic t_above90 t_80 t_60 t_50 t_40 t_30 t_less30 lightrain moderaterain heavyrain lndisposable unemploy lnfee_hyper lngas lnstatepop per_65 nine_11 designation  post post_SME_hi if year>=1993 & year<2020, absorb(i.park##i.month i.year) cluster(park yearmonth) 
estimate store I

ivreghdfe lnrecreaction_hyperbolic t_above90 t_80 t_60 t_50 t_40 t_30 t_less30 lightrain moderaterain heavyrain lndisposable unemploy  lnfee_hyper lngas lnstatepop per_65 nine_11 designation  (post_SME_hi= post_google_hi) if year>=1993 & year<2020, absorb(i.park##i.month i.year) cluster(park yearmonth) 

estimate store J

reghdfe lnvisits t_above90 t_80 t_60 t_50 t_40 t_30 t_less30 lightrain moderaterain heavyrain lndisposable unemploy lnfee_hyper lngas lnstatepop per_65 nine_11 designation  post post_SME_hi if year>=1993 & year<2020, absorb(i.park##i.month i.year) cluster(park yearmonth) 
estimate store K

ivreghdfe lnvisits t_above90 t_80 t_60 t_50 t_40 t_30 t_less30 lightrain moderaterain heavyrain lndisposable unemploy  lnfee_hyper lngas lnstatepop per_65 nine_11 designation  (post_SME_hi= post_google_hi) if year>=1993 & year<2020, absorb(i.park##i.month i.year) cluster(park yearmonth) 

estimate store L

cap drop post 
cap drop post_SME_hi
cap drop post_google_hi
	g post = instalaunch
	g post_SME_hi = instalaunch*grouphigh
	g post_google_hi = instalaunch*grouphigh_GOOGLE

reghdfe lnvisits t_above90 t_80 t_60 t_50 t_40 t_30 t_less30 lightrain moderaterain heavyrain lndisposable unemploy lnfee_hyper lngas lnstatepop per_65 nine_11 designation  post post_SME_hi if year>=1993 & year<2020, absorb(i.park##i.month i.year) cluster(park yearmonth) 
estimate store M

ivreghdfe lnvisits t_above90 t_80 t_60 t_50 t_40 t_30 t_less30 lightrain moderaterain heavyrain lndisposable unemploy  lnfee_hyper lngas lnstatepop per_65 nine_11 designation  (post_SME_hi= post_google_hi) if year>=1993 & year<2020, absorb(i.park##i.month i.year) cluster(park yearmonth) 

estimate store N



coefplot (A, label(Wichman (2024) OLS) pstyle(p1)) (B, label(W24 IV) pstyle(p1)) (E, label(W24 Adjusted SEs OLS) pstyle(p2)) (F, label(W24 Adj. SE IV) pstyle(p2)) (M, label(Preferred Visitation Model OLS) pstyle(p9)) (N, label(Preferred Visitation model IV) pstyle(p9)), keep(post_SME_hi) grid(none) xline(0, lpattern(solid) lcolor(red)) msymbol(d) cismooth levels(90 95 ) ciopts(lwidth(3 ..) lcolor(*.2 *.6 *.8 *1)) mcolor() xlab(, nogrid) xtitle("Log(Visitation)") ytitle("Post 2010 Media Influence")

graph save Graph "/Users/ashleylowe/NPS/fig3c.gph", replace
graph export "/Users/ashleylowe/NPS/fig3c.png", as(png) replace

**************
coefplot (A, label(PNAS) pstyle(p1)) (C, label(Robust) pstyle(p2)) (E, label(Cluster Park) pstyle(p3)) (G, label(OurData) pstyle(p4))  (I, label(Inclusion Variables) pstyle(p5)) (K, label(LogVisitation) pstyle(p6)) (M, label(ParkGroup) pstyle(p7)), keep(post_SME_hi) grid(none) xline(0, lpattern(solid) lcolor(red)) msymbol(d) cismooth levels(95) ciopts(recast(rcap)) mcolor() xlab(, nogrid) xtitle("Transformation of Visitation") ytitle("Post 2010 Media Influence - Fixed Effects")

coefplot (B, label(PNAS) pstyle(p1)) (D, label(Robust) pstyle(p2)) (F, label(Cluster Park) pstyle(p3)) (H, label(OurData) pstyle(p4))  (J, label(Included Pop./Cost) pstyle(p5)) (L, label(LogVisitation) pstyle(p6)) (N, label(ParkGroup) pstyle(p7)), keep(post_SME_hi) grid(none) xline(0, lpattern(solid) lcolor(red)) msymbol(d) cismooth levels(95) ciopts(recast(rcap)) mcolor() xlab(, nogrid) xtitle("Transformation of Visitation") ytitle("Post 2010 Media Influence - Google Trends IV")




