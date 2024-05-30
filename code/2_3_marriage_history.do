/*------------------------- 
婚姻状態関連変数の作成

Author: Ryota Mugiyama
Date: 2024-05-31

Notes: 
-------------------------*/ 

* 初婚年齢 ****************************
*** 98: 未婚（censored）
gen age_firstmarriage = . 
replace age_firstmarriage = q26 if q25 == 2 & q33 == 1 // 現在結婚していて、初婚
replace age_firstmarriage = sq1 if q33 == 2 & sq1 != 99 // 現在結婚していて、再婚
replace age_firstmarriage = q34 if q25 == 3 | q25 == 4 // 現在離別または死別
replace age_firstmarriage = 98 if q25 == 1 // 現在未婚
replace age_firstmarriage = . if age_firstmarriage == 99 | age_firstmarriage == 999 // 婚姻状態無回答
lab var age_firstmarriage "初婚年齢"

* 直近の結婚年齢（2回以上結婚した人のみ） ****************************
gen age_recentmarriage = .
replace age_recentmarriage = 98 if q25 == 2 & q33 == 1 // 現在結婚していて、初婚
replace age_recentmarriage = q26 if q26 != 999 & q25 == 2 & q33 == 2 // 現在結婚していて、再婚
replace age_recentmarriage = 98 if q25 == 1 // 現在未婚
replace age_recentmarriage = 98 if q25 == 3 // 現在離別
replace age_recentmarriage = 98 if q25 == 4 // 現在死別
lab var age_recentmarriage "直近の結婚年齢（2回以上結婚した人のみ）"

* 離別年齢 ****************************
gen age_divorce = .
replace age_divorce = 98 if q25 == 2 & q33 == 1 // 現在結婚していて、初婚
replace age_divorce = sq2_1 if sq2_1 != 88 & sq2_1 != 999 & q25 == 2 & q33 == 2 // 現在結婚していて、再婚
replace age_divorce = 98 if sq2_1 == 88 & q25 == 2 & q33 == 2 // 現在結婚していて、再婚
replace age_divorce = 98 if q25 == 1 // 現在未婚
replace age_divorce = q41 if q41 != 99 & q41 != 999 & q25 == 3 // 現在離別
replace age_divorce = 98 if q25 == 4 // 現在死別
lab var age_divorce "離別年齢"

* 死別年齢 ****************************
gen age_separate = .
replace age_separate = 98 if q25 == 2 & q33 == 1 // 現在結婚していて、初婚
replace age_separate = sq2_2 if sq2_2 != 88 & sq2_2 != 999 & q25 == 2 & q33 == 2 // 現在結婚していて、再婚
replace age_separate = 98 if sq2_2 == 88 & q25 == 2 & q33 == 2 // 現在結婚していて、再婚
replace age_separate = 98 if q25 == 1 // 現在未婚
replace age_separate = 98 if q25 == 3 // 現在離別
replace age_separate = q41 if q41 != 99 & q41 != 999 & q25 == 4 // 現在死別
lab var age_separate "死別年齢"

gen marstat = .
replace marstat = 1 if age < age_firstmarriage & age < age_recentmarriage & age < age_divorce & age < age_separate
replace marstat = 2 if age >= age_firstmarriage & age < age_recentmarriage & age < age_divorce & age < age_separate
replace marstat = 3 if age >= age_firstmarriage & age >= age_recentmarriage & age >= age_divorce
replace marstat = 3 if age >= age_firstmarriage & age >= age_recentmarriage & age >= age_separate
replace marstat = 4 if age >= age_firstmarriage & age < age_recentmarriage & age >= age_divorce & age < age_separate
replace marstat = 5 if age >= age_firstmarriage & age < age_recentmarriage & age < age_divorce & age >= age_separate

lab var marstat "婚姻状態（時変）"
lab def marstatlab ///
	1 "未婚" ///
	2 "既婚（初婚）" ///
	3 "既婚（再婚）" ///
	4 "離別" ///
	5 "死別"
lab val marstat marstatlab

*br id age age_firstmarriage age_recentmarriage age_divorce age_separate marstat
*br id age age_firstmarriage age_recentmarriage age_divorce age_separate firstmarriage recentmarriage divorce separate