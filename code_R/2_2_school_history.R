## 教育歴関連変数の作成
## 
## Author: Ryota Mugiyama
## Date: 2024-06-01
## Notes: 
## Variables:
##   school'i' "'i'番目の学校種別（専修学校以上）"
##   age_school'i' "'i'番目の学校の入学年齢"
##   duration_school'i' "'i'番目の学校の在学年数
##   school_grad'i' "'i'番目の学校（専修学校以上）
##   schoolst'i' "'i'番目の学校の入学年齢"
##   schoolen'i' "'i'番目の学校の終了年齢"
##   school_enrolled "学校に通っているか否か（時変）"

# 教育歴に関連する変数の名前のつけかえ
ssm2015personyear <- ssm2015personyear %>%
  rename(
    school1 = q20_1,
    school2 = q20_2,
    school3 = q20_3,
    age_school1 = q20_1_b_1,
    age_school2 = q20_2_b_1,
    age_school3 = q20_3_b_1,
    duration_school1 = q20_1_b_2,
    duration_school2 = q20_2_b_2,
    duration_school3 = q20_3_b_2,
    school_grad1 = q20_1_a,
    school_grad2 = q20_2_a,
    school_grad3 = q20_3_a,
  )

# 入学年と卒業年を求める
ssm2015personyear <- ssm2015personyear %>% 
  mutate(
    schoolst1 = if_else(school1 < 88 & age_school1 != 999, age_school1, NA_real_),
    schoolst2 = if_else(school2 < 88 & age_school2 != 999, age_school2, NA_real_),
    schoolst3 = if_else(school3 < 88 & age_school3 != 999, age_school3, NA_real_),
    schoolen1 = if_else(school1 < 88 & age_school1 != 999, age_school1 + duration_school1, NA_real_),
    schoolen2 = if_else(school2 < 88 & age_school2 != 999, age_school2 + duration_school2, NA_real_),
    schoolen3 = if_else(school3 < 88 & age_school3 != 999, age_school3 + duration_school3, NA_real_)
  )

ssm2015personyear <- ssm2015personyear %>%
  mutate(school_enrolled = if_else(q18_5 == 1 & age >= 15 & age < 18, 1, 0)) %>% 
  mutate(school_enrolled = if_else(schoolst1 <= age & age < schoolen1, 1, school_enrolled)) %>%
  mutate(school_enrolled = if_else(schoolst2 <= age & age < schoolen2, 1, school_enrolled)) %>%
  mutate(school_enrolled = if_else(schoolst3 <= age & age < schoolen3, 1, school_enrolled))
