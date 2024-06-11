## 全codeを統合するmaster R code
## 
## Author: Ryota Mugiyama
## Date: 2024-06-11
## 
## Notes:
## あらかじめ次のようにフォルダとファイルを置いておく必要があります
## - project（名前はなんでもいい）
##   - data
##     - SSM2015_v070_20170227.sav
##   - code
##     - _master_ssm2015personyear.do
##     - 1_expand_data.do
##     - 2_1_job_history.do
##     - 2_2_school_history.do
##     - 2_3_marriage_history.do
##     - 2_4_child_history.do
## 
## working directoryは../project/codeとする必要があります
## .Rprojを開くと、当該フォルダがworking directoryに設定されます
##
## tidyverse, havenパッケージを事前にインストールしておく必要があります。
## tidyverse 2.0.0, haven 2.5.3で動作確認済みです。

library(tidyverse)
library(haven)

#　データの読み込み（sav-rdsの変換）------------------------------------------------
ssm2015 <- read_sav("../data/SSM2015_v070_20170227.sav") %>% 
  zap_labels() # labelがあると後で厄介なことが起こりがちなので消しておく

saveRDS(ssm2015, "../data/ssm2015.rds")

# 1. パーソンイヤーデータの準備---------------------------------------------------
source("1_expand_data.R")

# 2. 時変の変数の作成---------------------------------------------------

## 2.1 職歴関連変数---------------------------------------------------
source("2_1_job_history.R")

## 2.2 学校関連変数---------------------------------------------------
source("2_2_school_history.R")

## 2.3 婚姻状態関連変数---------------------------------------------------
source("2_3_marriage_history.R")

## 2.4 子ども関連変数---------------------------------------------------
source("2_4_child_history.R")

## データを保存---------------------------------------------------
saveRDS(ssm2015personyear, "../data/ssm2015personyear.rds")