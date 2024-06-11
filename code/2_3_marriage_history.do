/*------------------------- 
婚姻状態関連変数の作成

Author: Ryota Mugiyama
Date: 2024-06-11

Notes: 
2024-06-01 初婚年齢、直近の結婚年齢、離別年齢、死別年齢のいずれかが欠損の場合は婚姻状態が欠損となるように変更
2024-06-11 年齢関係変数について、非該当の場合は8888となるように統一。また細かな論理エラーを修正
-------------------------*/ 

* 初婚年齢 ****************************
gen age_firstmarriage = . 
replace age_firstmarriage = q26 if q25 == 2 & q33 == 1 & q26 < 99 // 現在結婚していて、初婚で、結婚年齢回答あり
replace age_firstmarriage = sq1 if q33 == 2 & sq1 < 88 // 現在結婚していて、再婚で、初婚年齢回答あり
replace age_firstmarriage = q34 if q25 == 3 & q34 < 888 // 現在離別で、結婚年齢回答あり
replace age_firstmarriage = q34 if q25 == 4 & q34 < 888 // 現在死別で、結婚年齢回答あり
replace age_firstmarriage = 8888 if q25 == 1 // 現在未婚
lab var age_firstmarriage "初婚年齢"

* 直近の結婚年齢（2回以上結婚した人のみ） ****************************
gen age_recentmarriage = .
replace age_recentmarriage = 8888 if q25 == 2 & q33 == 1 // 現在結婚していて、初婚
replace age_recentmarriage = q26 if q26 < 99 & q25 == 2 & q33 == 2 // 現在結婚していて、再婚で、現在の結婚の結婚年齢回答あり
replace age_recentmarriage = 8888 if q25 == 1 // 現在未婚
replace age_recentmarriage = 8888 if q25 == 3 // 現在離別
replace age_recentmarriage = 8888 if q25 == 4 // 現在死別
lab var age_recentmarriage "直近の結婚年齢（2回以上結婚した人のみ）"

* 離別年齢 ****************************
gen age_divorce = .
replace age_divorce = 8888 if q25 == 2 & q33 == 1 // 現在結婚していて、初婚
replace age_divorce = sq2_1 if sq2_1 < 88 & q25 == 2 & q33 == 2 // 現在結婚していて、再婚で、離別年齢あり
replace age_divorce = 8888 if sq2_1 == 88 & q25 == 2 & q33 == 2 // 現在結婚していて、再婚で、離別年齢回答なし（死別）
replace age_divorce = 8888 if q25 == 1 // 現在未婚
replace age_divorce = q41 if q41 < 99 & q25 == 3 // 現在離別で、離別年齢あり
replace age_divorce = 8888 if q25 == 4 // 現在死別
lab var age_divorce "離別年齢"

* 死別年齢 ****************************
gen age_separate = .
replace age_separate = 8888 if q25 == 2 & q33 == 1 // 現在結婚していて、初婚
replace age_separate = sq2_2 if sq2_2 < 88 & q25 == 2 & q33 == 2 // 現在結婚していて、再婚で、死別年齢あり
replace age_separate = 8888 if sq2_2 == 88 & q25 == 2 & q33 == 2 // 現在結婚していて、再婚で、死別年齢回答なし（離別）
replace age_separate = 8888 if q25 == 1 // 現在未婚
replace age_separate = 8888 if q25 == 3 // 現在離別
replace age_separate = q41 if q41 < 99 & q25 == 4 // 現在死別で、死別年齢あり
lab var age_separate "死別年齢"

gen marstat = .
replace marstat = 1 if age < age_firstmarriage & age < age_recentmarriage & age < age_divorce & age < age_separate
replace marstat = 2 if age >= age_firstmarriage & age < age_recentmarriage & age < age_divorce & age < age_separate
replace marstat = 3 if age >= age_firstmarriage & age >= age_recentmarriage & age >= age_divorce
replace marstat = 3 if age >= age_firstmarriage & age >= age_recentmarriage & age >= age_separate
replace marstat = 4 if age >= age_firstmarriage & age < age_recentmarriage & age >= age_divorce & age < age_separate
replace marstat = 5 if age >= age_firstmarriage & age < age_recentmarriage & age < age_divorce & age >= age_separate
replace marstat = . if age_firstmarriage == .
replace marstat = . if age_recentmarriage == .
replace marstat = . if age_divorce == .
replace marstat = . if age_separate == .

lab var marstat "婚姻状態（時変）"
lab def marstatlab ///
	1 "未婚" ///
	2 "既婚（初婚）" ///
	3 "既婚（再婚）" ///
	4 "離別" ///
	5 "死別"
lab val marstat marstatlab
