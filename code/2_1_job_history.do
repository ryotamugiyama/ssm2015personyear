/*------------------------- 
職歴関連変数の作成

Author: Ryota Mugiyama
Date: 2024-05-31

Notes: 
-------------------------*/ 


* 職歴に関連する変数の名前のつけかえ ***************************
	clonevar job1 = q8_1 // 職歴頁
	clonevar nfirm1 = q8_2 // 従業先番号
	clonevar industry1 = q8_b // 産業
	clonevar firmsize1 = q8_c // 従業員数
	clonevar status1 = q8_a // 従業上の地位
	clonevar occupation1 = q8_f // 仕事の内容（職業）
	clonevar title1 = q8_g // 役職
	clonevar jobst1 = q8_h_1 // 職歴頁開始年齢
	clonevar joben1 = q8_h_2 // 職歴頁終了年齢

qui forvalues i = 2/22{
	clonevar job`i' = q9_`i' // 職歴頁
	clonevar nfirm`i' = q9_`i'_c_1 // 従業先番号
	clonevar industry`i' = q9_`i'_c_2 // 産業
	clonevar firmsize`i' = q9_`i'_c_3 // 従業員数
	clonevar status`i' = q9_`i'_c_4 // 従業上の地位
	clonevar occupation`i' = q9_`i'_c_5 // 仕事の内容（職業）
	clonevar title`i' = q9_`i'_c_6 // 役職
	clonevar jobst`i' = q9_`i'_c_7 // 職歴頁開始年齢
	clonevar joben`i' = q9_`i'_c_8 // 職歴頁終了年齢
}
qui forvalues i = 2/22{
	clonevar reason`i' = q9_`i'_b_1 // 離職理由
	clonevar reason_other`i' = q9_`i'_b_1_9 // 離職理由（その他）
}

gen job = .
gen nfirm = .
gen industry = .
gen firmsize = .
gen status = .
gen occupation = .
gen title = .
gen reason = .
gen reason_other = .
qui forvalues i = 1/22{
	replace job = job`i' if jobst`i' <= age // 職歴頁
	replace nfirm = nfirm`i' if jobst`i' <= age // 従業先番号
	replace industry = industry`i' if jobst`i' <= age // 産業
	replace firmsize = firmsize`i' if jobst`i' <= age // 従業員数
	replace status = status`i' if jobst`i' <= age // 従業上の地位
	replace occupation = occupation`i' if jobst`i' <= age // 職業
	replace title = title`i' if jobst`i' <= age // 役職
}
qui forvalues i = 2/22{
	replace reason = reason`i' if jobst`i' <= age // 離職理由
	replace reason_other = reason_other`i' if jobst`i' <= age // 離職理由（その他）
}

*** 就業状態を表す変数（work）を作成
gen work = .
replace work = 0 if age < jobst1
replace work = 1 if nfirm != . & nfirm > 0
replace work = 0 if nfirm == 0

lab var job "職歴頁（時変）"
lab var nfirm "従業先番号（時変）"
lab var industry "産業（時変）"
lab var firmsize "企業規模（時変）"
lab var status "従業上の地位（時変）"
lab var occupation "職業（時変）"
lab var title "役職（時変）"
lab var reason "離職理由（時変）"
lab var reason_other "離職理由（その他）（時変）"
lab var work "就業状態（時変）"

