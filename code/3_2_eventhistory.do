/*------------------------- 
従業上の地位による初婚への移行の違いに関するイベントヒストリー分析

Author: Ryota Mugiyama
Date: 2024-05-31

Note：
18-49歳、1945-1984年生まれコホートの男女を分析対象として、従業上の地位と初婚への移行の関連をみる
-------------------------*/ 

use "../data/ssm2015personyear.dta", clear

gen sex = q1_1
lab var sex "Sex"
lab def sexlab 1 "Men" 2 "Women"
lab val sex sexlab

gen firstmarriage = .
replace firstmarriage = 0 if age < age_firstmarriage
replace firstmarriage = 1 if age == age_firstmarriage

gen cohort = .
replace cohort = 1 if birthyear >= 1945 & birthyear < 1955
replace cohort = 2 if birthyear >= 1955 & birthyear < 1965
replace cohort = 3 if birthyear >= 1965 & birthyear < 1975
replace cohort = 4 if birthyear >= 1975 & birthyear < 1985
lab var cohort "Cohort"
lab def cohortlab 1 "1945-54" 2 "1955-64" 3 "1965-74" 4 "1975-84"
lab val cohort cohortlab

gen employmentstatus = .
replace employmentstatus = 1 if status == 1 | status == 2
replace employmentstatus = 2 if status == 3 | status == 3 | status == 5 | status == 6
replace employmentstatus = 3 if status == 7 | status == 8 | status == 9
replace employmentstatus = 4 if work == 0
replace employmentstatus = 5 if school_enrolled == 1
lab var employmentstatus "Employment status"
lab def employmentstatuslab ///
	1 "Regular employment" ///
	2 "Non-regular employment" ///
	3 "Self-employment" ///
	4 "Non-employment" ///
	5 "School enrollment"
lab val employmentstatus employmentstatuslab

xtset id age
gen employmentstatus_lag = L1.employmentstatus
lab var employmentstatus_lag "Employment status"
lab val employmentstatus_lag employmentstatuslab

keep if age >= 18 & age <= 49
drop if firstmarriage == .
drop if cohort == .
drop if age_firstmarriage < 18

*** Kaplan-Meier survival estimates
stset age , id(id) f(firstmarriage)
sts graph, ///
	by(sex) noorigin ///
	legend(r(1) pos(6) order(1 "Men" 2 "Women") ) ///
	xtitle("Age") ytitle("Survival rate") 

*** Logit model
forvalues i = 1/2{
	*** Non-lagged independent variables
	logit firstmarriage i.employmentstatus c.age##c.age##c.age i.cohort if sex == `i'
	est sto model1_sex`i'
	*** one-year lagged independent variables
	logit firstmarriage i.employmentstatus_lag c.age##c.age##c.age i.cohort if sex == `i'
	est sto model2_sex`i'	
}

*** Estimated results
esttab ///
	model1_sex1 model2_sex1 ///
	model1_sex2 model2_sex2, ///
	b(3) se nogaps label nonumber ///
	mtitles("Model 1, men" "Model 2, men" "Model 1, women" "Model 2, women")  ///
	order( ///
		1.employmentstatus 2.employmentstatus 3.employmentstatus 4.employmentstatus 5.employmentstatus ///
		1.employmentstatus_lag 2.employmentstatus_lag 3.employmentstatus_lag 4.employmentstatus_lag 5.employmentstatus_lag ) ///
	scalar(chi2 r2_p)

