/*------------------------- 
パーソンイヤーデータの準備

Author: Ryota Mugiyama
Date: 2024-05-31

Notes: 
- 年および年齢の変数を作成
- データを15歳から調査時年齢までの長さに拡張
-------------------------*/ 

use "../data/ssm2015.dta", clear

drop id // 説明のためにid変数を作成
gen id = _n // 説明のためにid変数を作成

gen birthyear = .
replace birthyear = meibo_2 + 1925 if meibo_1 == 1 /*昭和の場合*/
replace birthyear = meibo_2 + 1988 if meibo_1 == 2 /*平成の場合*/
gen birthmonth = meibo_3 
lab var birthyear "出生年"
lab var birthmonth "出生月"

gen age2014 = 2014 - birthyear
lab var age2014 "年齢（2014年12月31日時点）"
gen currentage = q1_2_5
lab var currentage "年齢（調査時点）"

expand age2014 - 14 // 15歳から2014年12月31日時点年齢までの期間のperson-year dataを作成
sort id
by id: gen age = _n + 14
lab var age "年齢（時変）"

gen year = birthyear + age
lab var year "年（時変）"

sort id year

*br id year age age2014 birthyear birthmonth if birthmonth == 1