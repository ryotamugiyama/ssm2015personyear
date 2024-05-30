/*------------------------- 
学校関連変数の作成

Author: Ryota Mugiyama
Date: 2024-05-31

Notes: 
-------------------------*/ 

forvalues i = 1/3{
	clonevar school`i' = q20_`i'
	clonevar age_school`i' = q20_`i'_b_1
	clonevar duration_school`i' = q20_`i'_b_2
	clonevar school_grad`i' = q20_`i'_a

	gen schoolst`i' = age_school`i' if school`i' < 88 & age_school`i' != 999
	gen schoolen`i' = age_school`i' + duration_school`i' if school`i' < 88 & age_school`i' != 999	

	lab var school`i' "`i'番目の学校種別（専修学校以上）"
	lab var age_school`i' "`i'番目の学校の入学年齢"
	lab var duration_school`i' "`i'番目の学校の在学年数"
	lab var school_grad`i' "`i'番目の学校（専修学校以上）の卒中退"
	lab var schoolst`i' "`i'番目の学校の入学年齢"
	lab var schoolen`i' "`i'番目の学校の終了年齢"
}

gen school_enrolled = 0
replace school_enrolled = 1 if q18_5 == 1 & 15 <= age & age < 18 // 高校に通ったことがある場合は15~17歳の期間を学生とみなす（中退した場合の中退年齢が不明のため卒業者と同様に扱う）

forvalues i = 1/3{
	replace school_enrolled = 1 if schoolst`i' <= age & age < schoolen`i' // i番目の学校に通っていた期間を学生期間とみなす
}

lab var school_enrolled "学校に通っているか否か（時変）"
lab def school_enrolledlab 0 "通っていない" 1 "通っている"
lab val school_enrolled school_enrolledlab

* br id age school_enrolled schoolst0 schoolen0 schoolst1 schoolen1 schoolst2 schoolen2 schoolst3 schoolen3