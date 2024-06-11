## 職歴関連変数の作成
## 
## Author: Ryota Mugiyama
## Date: 2024-06-01
## Notes: 
## Variables:
##   job "職歴頁（時変）"
##   nfirm "従業先番号（時変）"
##   industry "産業（時変）"
##   firmsize "企業規模（時変）"
##   status "従業上の地位（時変）"
##   occupation "職業（時変）"
##   title "役職（時変）"
##   reason "離職理由（時変）"
##   reason_other "離職理由（その他）（時変）"
##   work "就業状態（時変）"

# 職歴に関連する変数の名前のつけかえ
ssm2015personyear <- ssm2015personyear %>%
  rename(
    job1 = q8_1,
    job2 = q9_2,
    job3 = q9_3,
    job4 = q9_4,
    job5 = q9_5,
    job6 = q9_6,
    job7 = q9_7,
    job8 = q9_8,
    job9 = q9_9,
    job10 = q9_10,
    job11 = q9_11,
    job12 = q9_12,
    job13 = q9_13,
    job14 = q9_14,
    job15 = q9_15,
    job16 = q9_16,
    job17 = q9_17,
    job18 = q9_18,
    job19 = q9_19,
    job20 = q9_20,
    job21 = q9_21,
    job22 = q9_22
    ) %>%
  rename(
    q9_1_c_1 = q8_2, # 従業先番号
    q9_1_c_2 = q8_b, # 産業
    q9_1_c_3 = q8_c, # 従業員数
    q9_1_c_4 = q8_a, # 従業上の地位
    q9_1_c_5 = q8_f, # 仕事の内容（職業）
    q9_1_c_6 = q8_g, # 役職
    q9_1_c_7 = q8_h_1, # 職歴頁開始年齢
    q9_1_c_8 = q8_h_2 # 職歴頁終了年齢
    ) %>% 
  rename_with(\(x) str_replace(x, "q9_", "nfirm"), ends_with("_c_1")) %>% # 従業先番号
  rename_with(\(x) str_replace(x, "_c_1", ""), starts_with("nfirm")) %>%   
  rename_with(\(x) str_replace(x, "q9_", "industry"), ends_with("_c_2")) %>% # 産業
  rename_with(\(x) str_replace(x, "_c_2", ""), starts_with("industry")) %>% 
  rename_with(\(x) str_replace(x, "q9_", "firmsize"), ends_with("_c_3")) %>% # 従業員数
  rename_with(\(x) str_replace(x, "_c_3", ""), starts_with("firmsize")) %>%
  rename_with(\(x) str_replace(x, "q9_", "status"), ends_with("_c_4")) %>% # 従業上の地位
  rename_with(\(x) str_replace(x, "_c_4", ""), starts_with("status")) %>%
  rename_with(\(x) str_replace(x, "q9_", "occupation"), ends_with("_c_5")) %>% # 仕事の内容（職業）
  rename_with(\(x) str_replace(x, "_c_5", ""), starts_with("occupation")) %>%
  rename_with(\(x) str_replace(x, "q9_", "title"), ends_with("_c_6")) %>% # 役職
  rename_with(\(x) str_replace(x, "_c_6", ""), starts_with("title")) %>%
  rename_with(\(x) str_replace(x, "q9_", "jobst"), ends_with("_c_7")) %>% # 職歴頁開始年齢
  rename_with(\(x) str_replace(x, "_c_7", ""), starts_with("jobst")) %>%
  rename_with(\(x) str_replace(x, "q9_", "joben"), ends_with("_c_8")) %>% # 職歴頁終了年齢
  rename_with(\(x) str_replace(x, "_c_8", ""), starts_with("joben")) %>%
  rename_with(\(x) str_replace(x, "q9_", "reason"), ends_with("_b_1")) %>% # 離職理由
  rename_with(\(x) str_replace(x, "_b_1", ""), starts_with("reason")) %>%
  rename_with(\(x) str_replace(x, "q9_", "reason_other"), ends_with("_b_1_9")) %>% # 離職理由（その他）
  rename_with(\(x) str_replace(x, "_b_1_9", ""), starts_with("reason_other"))

ssm2015personyear <- ssm2015personyear %>% 
  mutate(job = if_else(is.na(jobst1) == FALSE & jobst1 <= age, job1, NA_real_)) %>% 
  mutate(job = if_else(is.na(jobst2) == FALSE & jobst2 <= age, job2, job)) %>%
  mutate(job = if_else(is.na(jobst3) == FALSE & jobst3 <= age, job3, job)) %>%
  mutate(job = if_else(is.na(jobst4) == FALSE & jobst4 <= age, job4, job)) %>%
  mutate(job = if_else(is.na(jobst5) == FALSE & jobst5 <= age, job5, job)) %>%
  mutate(job = if_else(is.na(jobst6) == FALSE & jobst6 <= age, job6, job)) %>%
  mutate(job = if_else(is.na(jobst7) == FALSE & jobst7 <= age, job7, job)) %>%
  mutate(job = if_else(is.na(jobst8) == FALSE & jobst8 <= age, job8, job)) %>%
  mutate(job = if_else(is.na(jobst9) == FALSE & jobst9 <= age, job9, job)) %>%
  mutate(job = if_else(is.na(jobst10) == FALSE & jobst10 <= age, job10, job)) %>%
  mutate(job = if_else(is.na(jobst11) == FALSE & jobst11 <= age, job11, job)) %>%
  mutate(job = if_else(is.na(jobst12) == FALSE & jobst12 <= age, job12, job)) %>%
  mutate(job = if_else(is.na(jobst13) == FALSE & jobst13 <= age, job13, job)) %>%
  mutate(job = if_else(is.na(jobst14) == FALSE & jobst14 <= age, job14, job)) %>%
  mutate(job = if_else(is.na(jobst15) == FALSE & jobst15 <= age, job15, job)) %>%
  mutate(job = if_else(is.na(jobst16) == FALSE & jobst16 <= age, job16, job)) %>%
  mutate(job = if_else(is.na(jobst17) == FALSE & jobst17 <= age, job17, job)) %>%
  mutate(job = if_else(is.na(jobst18) == FALSE & jobst18 <= age, job18, job)) %>%
  mutate(job = if_else(is.na(jobst19) == FALSE & jobst19 <= age, job19, job)) %>%
  mutate(job = if_else(is.na(jobst20) == FALSE & jobst20 <= age, job20, job)) %>%
  mutate(job = if_else(is.na(jobst21) == FALSE & jobst21 <= age, job21, job)) %>%
  mutate(job = if_else(is.na(jobst22) == FALSE & jobst22 <= age, job22, job))

# id * 職歴頁のデータを作成（離職理由以外）
vars <- c("nfirm", "industry", "firmsize", "status", "occupation", "title")
for (i in 1:6){
  df <- ssm2015personyear %>% 
    select(id, c(paste0(vars[i], 1:22))) %>% 
    distinct(id, .keep_all = TRUE) %>%
    pivot_longer(cols = -id) %>% 
    group_by(id) %>% 
    mutate(job = 1:n()) %>% 
    select(id, job, value) %>% 
    na.omit() 
  colnames(df) <- c("id", "job", vars[i])
  assign(paste0("df_", vars[i]), df)
}

# id * 職歴頁のデータを作成（離職理由）
vars <- c("reason", "reason_other")
for (i in 1:2){
  df <- ssm2015personyear %>% 
    select(id, c(paste0(vars[i], 2:22))) %>% 
    distinct(id, .keep_all = TRUE) %>%
    pivot_longer(cols = -id) %>% 
    group_by(id) %>% 
    mutate(job = 1:n() + 1) %>% 
    select(id, job, value) %>% 
    na.omit() 
  colnames(df) <- c("id", "job", vars[i])
  assign(paste0("df_", vars[i]), df)
}

# 職歴頁に応じて時変の変数（id*職歴頁データ）を結合
ssm2015personyear <- ssm2015personyear %>% 
  left_join(df_nfirm, by = c("id", "job")) %>% 
  left_join(df_industry, by = c("id", "job")) %>%
  left_join(df_firmsize, by = c("id", "job")) %>%
  left_join(df_status, by = c("id", "job")) %>%
  left_join(df_occupation, by = c("id", "job")) %>%
  left_join(df_title, by = c("id", "job")) %>%
  left_join(df_reason, by = c("id", "job")) %>%
  left_join(df_reason_other, by = c("id", "job"))

# 就業状態を表す変数の作成
ssm2015personyear <- ssm2015personyear %>%
  mutate(
    work = case_when(
      age < jobst1 ~ 0,
      is.na(nfirm) == FALSE & nfirm > 0 ~ 1,
      nfirm == 0 ~ 0
    )
  )

# 中間生成物の削除
rm(df, 
   df_nfirm, 
   df_industry, 
   df_firmsize, 
   df_status, 
   df_occupation, 
   df_title, 
   df_reason, 
   df_reason_other)
