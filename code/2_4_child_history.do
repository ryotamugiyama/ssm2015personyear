/*------------------------- 
子ども関連変数の作成

Author: Ryota Mugiyama
Date: 2024-06-11

Notes: 
2024-06-11 無回答ケースについての細かな修正を追加
2025-01-26 第i子が生まれたときの回答者の年齢の計算方法の修正
-------------------------*/ 

*** 第i子が生まれた年（実子・養子区別なし）
forvalues i = 1/4{
	gen birthyear_child`i' = .
	replace birthyear_child`i' = dq13_`i'_2b + 1925 if dq13_`i'_2a == 1 & dq13_`i'_2b != 88 & dq13_`i'_2b != 99
	replace birthyear_child`i' = dq13_`i'_2b + 1988 if dq13_`i'_2a == 2 & dq13_`i'_2b != 88 & dq13_`i'_2b != 99
	replace birthyear_child`i' = 8888 if dq13_`i'_2a == 8
	replace birthyear_child`i' = 9999 if dq13_`i'_2a == 9
	replace birthyear_child`i' = 9999 if dq13_`i'_2b == 99 // 元号はわかるが年が不明の場合は9999とする

	lab var birthyear_child`i' "第`i'子が生まれた年"
}

*** 第i子が生まれたときの回答者の年齢（実子・養子区別なし）
forvalues i = 1/4{
	gen age_birth`i' = .
	replace age_birth`i' = birthyear_child`i' - birthyear if birthyear_child`i' != 8888 & birthyear_child`i' != 9999
	replace age_birth`i' = 8888 if birthyear_child`i' == 8888	

	lab var age_birth`i' "第`i'子が生まれたときの年齢"
}

*** 第i子の年齢（実子・養子区別なし）
forvalues i = 1/4{
	gen age_child`i' = .
	replace age_child`i' = year - birthyear_child`i' if year >= birthyear_child`i'	
	lab var age_child`i' "第`i'子の年齢（時変）"
}


*** 子どもの人数（時変、実子・養子区別なし、最大4人）
gen number_child = .
replace number_child = 0 if year < birthyear_child1
replace number_child = 1 if year >= birthyear_child1 & year < birthyear_child2
replace number_child = 2 if year >= birthyear_child1 & year >= birthyear_child2 & year < birthyear_child3
replace number_child = 3 if year >= birthyear_child1 & year >= birthyear_child2 & year >= birthyear_child3 & year < birthyear_child4
replace number_child = 4 if year >= birthyear_child1 & year >= birthyear_child2 & year >= birthyear_child3 & year >= birthyear_child4

lab var number_child "子ども人数（時変）"
lab def number_childlab ///
	0 "0人" ///
	1 "1人" ///
	2 "2人" ///
	3 "3人" ///
	4 "4人以上"
lab val number_child number_childlab

*** 末子年齢（時変、実子・養子区別なし、5人以上子どもがいる場合でも末子は4番目になる点に注意）
gen age_lchild = .
replace age_lchild = age_child1 if year >= birthyear_child1 & year < birthyear_child2
replace age_lchild = age_child2 if year >= birthyear_child1 & year >= birthyear_child2 & year < birthyear_child3
replace age_lchild = age_child3 if year >= birthyear_child1 & year >= birthyear_child2 & year >= birthyear_child3 & year < birthyear_child4
replace age_lchild = age_child4 if year >= birthyear_child1 & year >= birthyear_child2 & year >= birthyear_child3 & year >= birthyear_child4

lab var age_lchild "末子年齢"
