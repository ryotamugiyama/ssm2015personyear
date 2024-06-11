## パーソンイヤーデータの準備
## 
## Author: Ryota Mugiyama
## Date: 2024-05-31
## Notes: 
##   年および年齢の変数を作成
##   データを15歳から調査時年齢までの長さに拡張
## Variables:
##   birthyear "出生年"
##   birthmonth "出生月"
##   age2014 "年齢（2014年12月31日時点）"
##   currentage "年齢（調査時点）"
##   age "年齢（時変）"
##   year "年（時変）"

ssm2015 <- read_rds("../data/ssm2015.rds")

# パーソンイヤーデータの準備
ssm2015 <- ssm2015 %>%
  select(-id) %>% 
  mutate(id = 1:n()) %>%  # 説明のためにid変数を作成
  mutate(
    birthyear = case_when(
      meibo_1 == 1 ~ meibo_2 + 1925,  # 昭和の場合
      meibo_1 == 2 ~ meibo_2 + 1988   # 平成の場合
    ),
    birthmonth = meibo_3,
    age2014 = 2014 - birthyear,
    currentage = q1_2_5
  )

ssm2015personyear <- ssm2015 %>%
  uncount(age2014 - 14) %>% # 15歳から2014年12月31日時点年齢までの期間のperson-year dataを作成
  group_by(id) %>% 
  mutate(age = 14 + 1:n()) %>%
  mutate(year = birthyear + age) %>% 
  arrange(id, age) 
