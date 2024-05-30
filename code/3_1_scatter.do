/*------------------------- 
データの構造

Author: Ryota Mugiyama
Date: 2024-05-31

Note：
調査年および年齢のレキシス図を書いてみる
-------------------------*/ 

use "../data/ssm2015personyear.dta", clear

gen n = 1
collapse (count) n, by(year age)
twoway scatter age year [fweight = n], ///
	xlabel(1950(10)2020) ylabel(10(10)80) ///
	xsize(6) ysize(6) m(oh)

graph export "../results/lexis.pdf", replace