clear
import delimited "/Users/ashleylowe/NPS/Data_Publications/Data/NPSM_Maintable.csv", clear 

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


preserve


generate grouphigh=0
replace grouphigh=1 if parkname=="Zion National Park"
replace grouphigh=1 if parkname=="Yosemite National Park"

generate groupmid=0
replace groupmid=1 if parkname=="Kings Canyon National Park"
replace groupmid=1 if parkname=="Sequoia National Park"
replace groupmid=1 if parkname=="Great Smoky Mountains National Park"
replace groupmid=1 if parkname=="Grand Canyon National Park"
replace groupmid=1 if parkname=="Joshua Tree National Park"
replace groupmid=1 if parkname=="Glacier National Park"
replace groupmid=1 if parkname=="Arches National Park"
replace groupmid=1 if parkname=="Grand Teton National Park"
replace groupmid=1 if parkname=="Rocky Mountain National Park"
replace groupmid=1 if parkname=="Olympic National Park"
replace groupmid=1 if parkname=="Death Valley National Park"
replace groupmid=1 if parkname=="Bryce Canyon National Park"
replace groupmid=1 if parkname=="Mount Rainier National Park"
*replace groupmid=1 if parkname=="Guadalupe Mountains National Park"
*replace groupmid=1 if parkname=="Carlsbad Caverns National Park"
*replace groupmid=1 if parkname=="Everglades National Park"
*replace groupmid=1 if parkname=="Yellowstone National Park"
generate grouplow=1
replace grouplow=0 if grouphigh==1 | groupmid==1


bysort park (modate) : gen cuminfluen90_year = sum(influential90_year)
bysort park (modate) : gen cuminfluen95_year = sum(influential95_year)
bysort park (modate) : gen cuminfluen99_year = sum(influential99_year)

generate uploadshigh=grouphigh*uploadsall
************
*Low Groups*
************


generate uploadsmid=groupmid*uploadsall
generate uploadslow=grouplow*uploadsall



**** Viral Qualifications ****  
generate cuminflu95grouphigh_year=grouphigh*cuminfluen95_year
generate cuminflu90grouphigh_year=grouphigh*cuminfluen90_year
generate cuminflu99grouphigh_year=grouphigh*cuminfluen99_year

generate cuminflu95groupmid_year=groupmid*cuminfluen95_year
generate cuminflu90groupmid_year=groupmid*cuminfluen90_year
generate cuminflu99groupmid_year=groupmid*cuminfluen99_year

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

gen user9=userq_9+userq_95+userq_99
gen user95=userq_95+userq_99

bysort park (modate) : gen cumavid90= sum(user9)
bysort park (modate) : gen cumvavid95= sum(user95)
bysort park (modate) : gen cuminfluencer99= sum(userq_99)

bysort park (modate) : gen cumallposters90= sum(allposters90)
*********All Influencer Post*************
generate allpostersH=grouphigh*cumallposters90
generate allpostersM=groupmid*cumallposters90
generate allpostersL=grouplow*cumallposters90

*********Only 90th of Engaging Post from Influencer ********
generate posters90PH=grouphigh*cumposter90
generate posters90PM=groupmid*cumposter90
generate posters90PL=grouplow*cumposter90

*********Just Viral Post***********
generate just90H=grouphigh*cumjust90
generate just90M=groupmid*cumjust90
generate just90L=grouplow*cumjust90

generate just95H=grouphigh*cumjust95
generate just95M=groupmid*cumjust95
generate just95L=grouplow*cumjust95

*********Just Avid User Groups Post***********
generate avid90H=grouphigh*cumavid90
generate avid90M=groupmid*cumavid90
generate avid90L=grouplow*cumavid90

generate vavid95H=grouphigh*cumvavid95
generate vavid95M=groupmid*cumvavid95
generate vavid95L=grouplow*cumvavid95


generate inf99H=grouphigh*cuminfluencer99
generate inf99M=groupmid*cuminfluencer99
generate inf99L=grouplow*cuminfluencer99

*********************************************************************************************************************************************
*********************************************************************************************************************************************
******************************				Instagram Variables				*****************************************************************
*****************************												*****************************************************************
*********************************************************************************************************************************************
*********************************************************************************************************************************************





reghdfe lnvisits t_above90 t_80 t_60 t_50 t_40 t_30 t_less30 lightrain moderaterain heavyrain lndisposable lnfee lngas unemploy lnstatepop per_65 nine_11 designation instalaunch uploads if year>=1993 & year<2020, absorb(i.park#i.month year) vce(cluster park yearmonth) 
outreg2 using threeclusters.doc, replace ctitle(Base) keep(uploads) addtext( Park*Month FE, YES, Year FE, YES, Controls, YES)

estimates store D

reghdfe lnvisits  t_above90 t_80 t_60 t_50 t_40 t_30 t_less30 lightrain moderaterain heavyrain lndisposable lnfee lngas unemploy lnstatepop per_65 nine_11 designation instalaunch uploadshigh uploadsmid uploadslow  if year>=1993 & year<2020, absorb(i.park#i.month yearmonth) vce(cluster park ) 
outreg2 using threeclusters.doc, append ctitle(Base) keep(uploadshigh uploadsmid uploadslow) addtext( Park*Month FE, YES, Year FE, YES, Controls, YES)

estimates store E

reghdfe lnvisits t_above90 t_80 t_60 t_50 t_40 t_30 t_less30 lightrain moderaterain heavyrain lndisposable lnfee lngas unemploy lnstatepop per_65 nine_11 designation instalaunch uploadshigh uploadsmid uploadslow cuminflu90grouphigh_year cuminflu90groupmid_year cuminflu90grouplow_year  if year>=1993 & year<2020, absorb(i.park#i.month  year) vce(cluster park yearmonth) 
outreg2 using threeclusters.doc, append ctitle(Base) keep(uploadshigh uploadsmid uploadslow cuminflu90grouphigh_year cuminflu90groupmid_year cuminflu90grouplow_year) addtext( Park*Month FE, YES, Year FE, YES, Controls, YES)

estimates store F

reghdfe lnvisits t_above90 t_80 t_60 t_50 t_40 t_30 t_less30 lightrain moderaterain heavyrain lndisposable lnfee lngas unemploy lnstatepop per_65 nine_11 designation instalaunch uploadshigh uploadsmid uploadslow cuminflu95grouphigh_year cuminflu95groupmid_year cuminflu95grouplow_year  if year>=1993 & year<2020, absorb(i.park#i.month  year) vce(cluster park yearmonth) 
outreg2 using threeclusters.doc, append ctitle(Base) keep(uploadshigh uploadsmid uploadslow cuminflu95grouphigh_year cuminflu95groupmid_year cuminflu95grouplow_year) addtext( Park*Month FE, YES, Year FE, YES, Controls, YES)

estimates store G

reghdfe lnvisits t_above90 t_80 t_60 t_50 t_40 t_30 t_less30 lightrain moderaterain heavyrain lndisposable lnfee lngas unemploy lnstatepop per_65 nine_11 designation instalaunch uploadshigh uploadsmid uploadslow allpostersH allpostersM allpostersL if year>=1993 & year<2020, absorb(i.park#i.month  year) vce(cluster park yearmonth) 
outreg2 using threeclusters.doc, append ctitle(Base) keep(uploadshigh uploadsmid uploadslow allpostersH allpostersM allpostersL) addtext( Park*Month FE, YES, Year FE, YES, Controls, YES)

estimates store H

reghdfe lnvisits t_above90 t_80 t_60 t_50 t_40 t_30 t_less30 lightrain moderaterain heavyrain lndisposable lnfee lngas unemploy lnstatepop per_65 nine_11 designation instalaunch uploadshigh uploadsmid uploadslow just90H just90M just90L if year>=1993 & year<2020, absorb(i.park#i.month  year) vce(cluster park yearmonth) 
outreg2 using threeclusters.doc, append ctitle(Base) keep(uploadshigh uploadsmid uploadslow just90H just90M just90L ) addtext( Park*Month FE, YES, Year FE, YES, Controls, YES)

estimates store I


coefplot (D* , asequation() \ , pstyle(p13)), keep(t_above90 t_80 t_60 t_50 t_40  t_30 t_less30 lightrain moderaterain  heavyrain) rename(t_above90=90F t_80=80F-90F t_60=60F-70F t_50=50F-60F t_40=40F-50F t_30=30F-40F  t_less30=30F<  lightrain=Light moderaterain=Moderate  heavyrain=Heavy) coeflabels() grid(none) xline(0, lpattern(solid) lcolor(red)) msymbol(d) cismooth levels(95) ciopts(lwidth(3 ..) lcolor(*.2 *.4 *.6 *.8 *1)) mcolor() xlab(, nogrid) xtitle("Log(Visitation)")  xscale(range(-0.04 .1))
graph export "/Users/ashleylowe/NPS/fig3ba.png", as(png) replace

coefplot (D* , asequation() \ , pstyle(p13)), keep(lndisposable lnfee lnstatepop per_65 lndisposable unemploy nine_11 designation) rename(lndisposable=Log(RDI) lngas=Log(Gas) lnfee=Log(Fee)  lnstatepop=Log(StatePop) per_65=Per.65+  unemploy=Unemploy nine_11=Post9/11 designation=Park.Desig) coeflabels() grid(none) xline(0, lpattern(solid) lcolor(red)) msymbol(d) cismooth levels(95) ciopts(lwidth(3 ..) lcolor(*.2 *.4 *.6 )) mcolor() xlab(, nogrid)  xscale(range(-2 6))
graph export "/Users/ashleylowe/NPS/fig3bb.png", as(png) replace


coefplot (D, asequation("{bf:All Parks}") \ E, asequation("{bf:PUDs by Viral Quality}") \ , pstyle(p1)), keep( uploads uploadshigh uploadsmid uploadslow ) rename(uploads=PUDs uploadshigh=High uploadsmid=Mid uploadslow=Low) coeflabels() grid(none) xline(0, lpattern(solid) lcolor(red)) msymbol(d) cismooth levels(95) ciopts(lwidth(3 ..) lcolor(*.4 *.6 )) mcolor() xlab(, nogrid) xtitle("Log(Visitation)")
graph save Graph "/Users/ashleylowe/NPS/fig6a.gph", replace
graph export "/Users/ashleylowe/NPS/fig6a.png", as(png) replace



coefplot  (F, label(90th) pstyle(p4)) (G, label(95th) pstyle(p2)) (H, label(AvidUser) pstyle(p3)) (I, label(Engagement Only) pstyle(p5)), keep(cuminflu90grouphigh_year cuminflu90groupmid_year cuminflu90grouplow_year cuminflu95grouphigh_year cuminflu95groupmid_year cuminflu95grouplow_year just90H just90M just90L allpostersH allpostersM allpostersL)  rename(cuminflu90grouphigh_year=High just90H=High allpostersH=High cuminflu90groupmid_year=Mid just90M=Mid allpostersM=Mid cuminflu90grouplow_year=Low cuminflu95grouphigh_year=High cuminflu95groupmid_year=Mid cuminflu95grouplow_year=Low allpostersL=Low just90L=Low) grid(none) xline(0, lpattern(solid) lcolor(red)) msymbol(d) cismooth levels(95) ciopts(lwidth(3 ..) lcolor(*.2 *.4 *.6 )) mcolor() xlab(, nogrid) xtitle("Log(Visitation)") legend(rows(1) on pos(6))
graph save Graph "/Users/ashleylowe/NPS/fig6b.gph", replace
graph export "/Users/ashleylowe/NPS/fig6b.png", as(png) replace



