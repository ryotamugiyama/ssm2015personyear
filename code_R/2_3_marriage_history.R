## 婚姻歴関連変数の作成
## 
## Author: Ryota Mugiyama
## Date: 2024-06-11
## Notes: 
## Variables:
##   age_firstmarriage "初婚年齢"
##   age_recentmarriage "直近の結婚年齢（2回以上結婚した人のみ）"
##   age_divorce "離別年齢"
##   age_separate "死別年齢"
##   marstat "婚姻状態（時変）"
##   marstat_factor "婚姻状態（時変）（factor変数）"

# 初婚年齢
ssm2015personyear <- ssm2015personyear %>%
  mutate(age_firstmarriage = case_when(
      q25 == 2 & q33 == 1 & q26 < 99 ~ q26, # 現在結婚していて、初婚で、結婚年齢回答あり
      q33 == 2 & sq1 < 88 ~ sq1, # 現在結婚していて、再婚で、初婚年齢回答あり
      q25 == 3 & q34 < 888 ~ q34, # 現在離別で、結婚年齢回答あり
      q25 == 4 & q34 < 888 ~ q34, # 現在死別で、結婚年齢回答あり
      q25 == 1 ~ 8888 # 現在未婚
    ))

# 直近の結婚年齢（2回以上結婚した人のみ）
ssm2015personyear <- ssm2015personyear %>%
  mutate(
    age_recentmarriage = case_when(
      q25 == 2 & q33 == 1 ~ 8888, # 現在結婚していて、初婚
      q26 < 99 & q25 == 2 & q33 == 2 ~ q26, # 現在結婚していて、再婚で、現在の結婚の結婚年齢回答あり
      q25 == 1 ~ 8888, # 現在未婚
      q25 == 3 ~ 8888, # 現在離別
      q25 == 4 ~ 8888 # 現在死別
    ))

# 離別年齢
ssm2015personyear <- ssm2015personyear %>% 
  mutate(
    age_divorce = case_when(
      q25 == 2 & q33 == 1 ~ 8888, # 現在結婚していて、初婚
      sq2_1 < 88 & q25 == 2 & q33 == 2 ~ sq2_1, # 現在結婚していて、再婚で、離別年齢あり
      sq2_1 == 88 & q25 == 2 & q33 == 2 ~ 8888, # 現在結婚していて、再婚で、離別年齢回答なし（死別）
      q25 == 1 ~ 8888, # 現在未婚
      q41 < 99 & q25 == 3 ~ q41, # 現在離別で、離別年齢あり
      q25 == 4 ~ 8888 # 現在死別
    ))

ssm2015personyear <- ssm2015personyear %>%
  mutate(
    age_separate = case_when(
      q25 == 2 & q33 == 1 ~ 8888, # 現在結婚していて、初婚
      sq2_2 < 88 & q25 == 2 & q33 == 2 ~ sq2_2, # 現在結婚していて、再婚で、死別年齢あり
      sq2_2 == 88 & q25 == 2 & q33 == 2 ~ 8888, # 現在結婚していて、再婚で、死別年齢回答なし（離別）
      q25 == 1 ~ 8888, # 現在未婚
      q25 == 3 ~ 8888, # 現在死別
      q41 < 99 & q25 == 4 ~ q41, # 現在死別で、死別年齢あり
    ))
    
# 婚姻状態
ssm2015personyear <- ssm2015personyear %>%
  mutate(
    marstat = case_when(
      age < age_firstmarriage & age < age_recentmarriage & age < age_divorce & age < age_separate ~ 1,
      age >= age_firstmarriage & age < age_recentmarriage & age < age_divorce & age < age_separate ~ 2,
      age >= age_firstmarriage & age >= age_recentmarriage & age >= age_divorce ~ 3,
      age >= age_firstmarriage & age >= age_recentmarriage & age >= age_separate ~ 3,
      age >= age_firstmarriage & age < age_recentmarriage & age >= age_divorce & age < age_separate ~ 4,
      age >= age_firstmarriage & age < age_recentmarriage & age < age_divorce & age >= age_separate ~ 5
    )
  ) %>% 
  mutate(marstat_factor = factor(marstat, 
                                 levels = 1:5, 
                                 labels = c("未婚", "既婚（初婚）", "既婚（再婚）", "離別", "死別")))

