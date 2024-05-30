/*------------------------- 
第一子出産が就業率に与える効果に関する固定効果モデル

Author: Ryota Mugiyama
Date: 2024-05-31

Note：
1945-1984年出生、15-59歳、学生でない男女のうち、
- 調査時点で子どもがいない人については全員
- 第一子出産を経験した人については、出産4年前から
を分析対象として、第一子出産が就業率をどの程度変化させるかをみる
-------------------------*/ 

use "../data/ssm2015personyear.dta", clear

gen sex = q1_1
lab var sex "Sex"
lab def sexlab 1 "Men" 2 "Women"
lab val sex sexlab

gen time_from_birth = .
replace time_from_birth = age - age_birth1 if age_birth1 != 8888
replace time_from_birth = 20 if time_from_birth > 20 & time_from_birth != . // 第一子出産から20年以上経過した場合をまとめる
replace time_from_birth = -3 if age_birth1 == 8888 // 第1子を出産していない個人をrefに含める（3年前とする）
replace time_from_birth = . if time_from_birth < -4 // 第1子を出産した人の、出産の5年以上前のperson-yearは欠損とする
replace time_from_birth = time_from_birth + 5


lab var time_from_birth "第1子出産からの年数"
lab def time_from_birthlab ///
	1 "-4" ///
	2 "-3 (ref.)" ///
	3 "-2" ///
	4 "-1" ///
	5 "-0" ///
	6 "1" ///
	7 "2" ///
	8 "3" ///
	9 "4" ///
	10 "5" ///
	11 "6" ///
	12 "7" ///
	13 "8" ///
	14 "9" ///
	15 "10" ///
	16 "11" ///
	17 "12" ///
	18 "13" ///
	19 "14" ///
	20 "15" ///
	21 "16" ///
	22 "17" ///
	23 "18" ///
	24 "19" ///
	25 "20 or later"
lab val time_from_birth time_from_birthlab

keep if birthyear >= 1945 & birthyear <= 1984
keep if age >= 15 & age <= 59
keep if school_enrolled == 0
keep if time_from_birth != .
keep if work != .

tabulate time_from_birth work if sex == 1,r nof
tabulate time_from_birth work if sex == 2,r nof

xtset id year

*** Fixed effect model

forvalues i = 1/2{
	*** Fixed effect model, demeaned
	xtreg work ib2.time_from_birth c.age##c.age i.year if sex == `i', fe cluster(id)
	est sto model1_sex`i'
	*** Fixed effect model, LSDV
	reghdfe work ib2.time_from_birth c.age##c.age if sex == `i', absorb(id year) cluster(id)
	est sto model2_sex`i'
}

*** Estimated results
esttab ///
	model1_sex1 model2_sex1 ///
	model1_sex2 model2_sex2, ///
	b(3) se nogaps label nonumber ///
	mtitles("Model 1, men" "Model 2, men" "Model 1, women" "Model 2, women")  ///
	scalar(r2)
