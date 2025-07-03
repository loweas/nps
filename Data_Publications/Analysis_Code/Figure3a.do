*** Use code below to set your local file path
*local datadir ""

use "/Users/ashleylowe/NPS/Data_Publications/Figure3a.dta", clear


nbreg edge_liked_bycount i.year i.de_month#i.park locationinfo poiinfo things2do hashtags hashtagsquared caption_outhashtag Positive Negative subjectivity userQ_2 userQ_5 userQ_75 userQ_90, cluster(parkname)

estimate store A


nbreg edge_liked_bycount i.year i.de_month#i.park locationinfo poiinfo things2do hashtags hashtagsquared caption_outhashtag Positive Negative subjectivity userQ_2 userQ_5 userQ_75 userQ_9 userQ_95 userQ_99, cluster(parkname)

estimate store B

poisson edge_liked_bycount i.year i.de_month#i.park locationinfo poiinfo things2do hashtags hashtagsquared caption_outhashtag Positive Negative subjectivity userQ_2 userQ_5 userQ_75 userQ_90, cluster(parkname)

estimate store D



coefplot (A, label() mcolor(navy)), keep(locationinfo poiinfo things2do Positive Negative subjectivity hashtags hashtagsquared caption_outhashtag userQ_2 userQ_5 userQ_75 userQ_90)  rename(locationinfo=Location poiinfo=Point-of-Interest things2do=Things-2-Do hashtags=Hashtag hashtagsquared=HashtagSqu caption_outhashtag=Num.Words subjectivity=Subjectivity userQ_2=Low userQ_5=Mid userQ_75=High userQ_90=Avid) grid(none) xline(0, lpattern(solid) lcolor(red)) headings(Location= "{bf:Information}"  Positive= "{bf:Sentiment Analysis}" Low = "{bf:User Posting Intensity}" 1 = "{bf:Number of Hashtags}" ) msymbol(d) cismooth levels(95) ciopts(lwidth(3 ..) lcolor(*.4 *.6 )) mcolor() xlab(, nogrid) xtitle("Number of Likes")

graph save Graph "/Users/ashleylowe/NPS/Data_Publications/Pictures/fig3a.gph", replace
graph export "/Users/ashleylowe/NPS/Data_Publications/Pictures/fig3a.png", as(png) replace


coefplot (B, label() mcolor(navy)), keep(locationinfo poiinfo things2do Positive Negative subjectivity hashtags hashtagsquared caption_outhashtag userQ_2 userQ_5 userQ_75 userQ_9 userQ_95 userQ_99)  rename(locationinfo=Location poiinfo=Point-of-Interest things2do=Things-2-Do hashtags=Hashtag hashtagsquared=HashtagSqu caption_outhashtag=Num.Words subjectivity=Subjectivity userQ_2=Low userQ_5=Mid userQ_75=High userQ_9=Avid High userQ_95=VeryAvid High userQ_99=Influencer) grid(none) xline(0, lpattern(solid) lcolor(red)) headings(Location= "{bf:Information}"  Positive= "{bf:Sentiment Analysis}" Low = "{bf:User Posting Intensity}" 1 = "{bf:Number of Hashtags}" ) msymbol(d) cismooth levels(95) ciopts(lwidth(3 ..) lcolor(*.4 *.6 )) mcolor() xlab(, nogrid) xtitle("Number of Likes")

graph save Graph "/Users/ashleylowe/NPS/Data_Publications/Pictures/Extfig6.gph", replace
graph export "/Users/ashleylowe/NPS/Data_Publications/Pictures/Extfig6.png", as(png) replace


coefplot (D, label() mcolor(navy)), keep(locationinfo poiinfo things2do Positive Negative subjectivity hashtags hashtagsquared caption_outhashtag userQ_2 userQ_5 userQ_75 userQ_90 )  rename(locationinfo=Location poiinfo=Point-of-Interest things2do=Things-2-Do hashtags=Hashtag hashtagsquared=HashtagSqu caption_outhashtag=Num.Words subjectivity=Subjectivity userQ_2=Low userQ_5=Mid userQ_75=High userQ_90=Avid) grid(none) xline(0, lpattern(solid) lcolor(red)) headings(Location= "{bf:Information}"  Positive= "{bf:Sentiment Analysis}" Low = "{bf:User Posting Intensity}" 1 = "{bf:Number of Hashtags}" ) msymbol(d) cismooth levels(95) ciopts(lwidth(3 ..) lcolor(*.4 *.6 )) mcolor() xlab(, nogrid) xtitle("Number of Likes")

graph save Graph "/Users/ashleylowe/NPS/Data_Publications/Pictures/Extfig6b.gph", replace
graph export "/Users/ashleylowe/NPS/Data_Publications/Pictures/Extfig6b.png", as(png) replace








