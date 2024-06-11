## 婚姻歴関連変数の作成
## 
## Author: Ryota Mugiyama
## Date: 2024-06-11
## Notes: 
## Variables:
##   birthyear_child'i' "第'i'子が生まれた年"
##   age_birth'i' "第'i'子が生まれたときの年齢"
##   age_child'i' "第'i'子の年齢（時変）"
##   number_child "子ども人数（時変）"
##   number_child_factor "子ども人数（時変）（factor変数）"
##   age_lchild "末子年齢"

# 第i子が生まれた年（実子・養子区別なし）
ssm2015personyear <- ssm2015personyear %>%
  mutate(
    birthyear_child1 = case_when(
      dq13_1_2a == 1 & dq13_1_2b != 88 & dq13_1_2b != 99 ~ dq13_1_2b + 1925,
      dq13_1_2a == 2 & dq13_1_2b != 88 & dq13_1_2b != 99 ~ dq13_1_2b + 1988,
      dq13_1_2a == 8 ~ 8888,
      dq13_1_2a == 9 ~ 9999,
      dq13_1_2b == 99 ~ 9999
    ),
    birthyear_child2 = case_when(
      dq13_2_2a == 1 & dq13_2_2b != 88 & dq13_2_2b != 99 ~ dq13_2_2b + 1925,
      dq13_2_2a == 2 & dq13_2_2b != 88 & dq13_2_2b != 99 ~ dq13_2_2b + 1988,
      dq13_2_2a == 8 ~ 8888,
      dq13_2_2a == 9 ~ 9999,
      dq13_2_2b == 99 ~ 9999
    ),
    birthyear_child3 = case_when(
      dq13_3_2a == 1 & dq13_3_2b != 88 & dq13_3_2b != 99 ~ dq13_3_2b + 1925,
      dq13_3_2a == 2 & dq13_3_2b != 88 & dq13_3_2b != 99 ~ dq13_3_2b + 1988,
      dq13_3_2a == 8 ~ 8888,
      dq13_3_2a == 9 ~ 9999,
      dq13_3_2b == 99 ~ 9999
    ),
    birthyear_child4 = case_when(
      dq13_4_2a == 1 & dq13_4_2b != 88 & dq13_4_2b != 99 ~ dq13_4_2b + 1925,
      dq13_4_2a == 2 & dq13_4_2b != 88 & dq13_4_2b != 99 ~ dq13_4_2b + 1988,
      dq13_4_2a == 8 ~ 8888,
      dq13_4_2a == 9 ~ 9999,
      dq13_4_2b == 99 ~ 9999
    ))

# 第i子が生まれたときの回答者の年齢（実子・養子区別なし）
ssm2015personyear <- ssm2015personyear %>% 
  mutate(
    age_birth1 = case_when(
      birthyear_child1 != 8888 & birthyear_child1 != 9999 ~ birthyear_child1 - birthyear - 1,
      birthyear_child1 == 8888 ~ 8888
    ),
    age_birth2 = case_when(
      birthyear_child2 != 8888 & birthyear_child2 != 9999 ~ birthyear_child2 - birthyear - 1,
      birthyear_child2 == 8888 ~ 8888
    ),
    age_birth3 = case_when(
      birthyear_child3 != 8888 & birthyear_child3 != 9999 ~ birthyear_child3 - birthyear - 1,
      birthyear_child3 == 8888 ~ 8888
    ),
    age_birth4 = case_when(
      birthyear_child4 != 8888 & birthyear_child4 != 9999 ~ birthyear_child4 - birthyear - 1,
      birthyear_child4 == 8888 ~ 8888
    )) 

# 第i子の年齢（実子・養子区別なし）
ssm2015personyear <- ssm2015personyear %>% 
  mutate(
    age_child1 = if_else(year >= birthyear_child1, year - birthyear_child1, NA_real_),
    age_child2 = if_else(year >= birthyear_child2, year - birthyear_child2, NA_real_),
    age_child3 = if_else(year >= birthyear_child3, year - birthyear_child3, NA_real_),
    age_child4 = if_else(year >= birthyear_child4, year - birthyear_child4, NA_real_)) 

# 子どもの人数（時変、実子・養子区別なし、最大4人）
ssm2015personyear <- ssm2015personyear %>% 
  mutate(number_child = case_when(
    year < birthyear_child1 ~ 0,
    year >= birthyear_child1 & year < birthyear_child2 ~ 1,
    year >= birthyear_child1 & year >= birthyear_child2 & year < birthyear_child3 ~ 2,
    year >= birthyear_child1 & year >= birthyear_child2 & year >= birthyear_child3 & year < birthyear_child4 ~ 3,
    year >= birthyear_child1 & year >= birthyear_child2 & year >= birthyear_child3 & year >= birthyear_child4 ~ 4
    ))

# 末子年齢（時変、実子・養子区別なし、5人以上子どもがいる場合でも末子は4番目になる点に注意）
ssm2015personyear <- ssm2015personyear %>% 
  mutate(age_lchild = case_when(
    year >= birthyear_child1 & year < birthyear_child2 ~ age_child1,
    year >= birthyear_child1 & year >= birthyear_child2 & year < birthyear_child3 ~ age_child2,
    year >= birthyear_child1 & year >= birthyear_child2 & year >= birthyear_child3 & year < birthyear_child4 ~ age_child3,
    year >= birthyear_child1 & year >= birthyear_child2 & year >= birthyear_child3 & year >= birthyear_child4 ~ age_child4
  ))
