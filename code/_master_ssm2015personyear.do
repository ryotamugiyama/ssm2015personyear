/*------------------------- 
全do-fileを統合するmaster do-file

Author: Ryota Mugiyama
Date: 2024-05-31

Notes:
あらかじめ次のようにフォルダとファイルを置いておく必要があります
- project（名前はなんでもいい）
   - data
      - SSM2015_v070_20170227.sav
   - code
      - _master_ssm2015personyear.do
      - 1_expand_data.do
      - 2_1_job_history.do
      - 2_2_school_history.do
      - 2_3_marriage_history.do
      - 2_4_child_history.do
      - 2_9_variablelists.do
      - 3_1_scatter.do
      - 3_2_eventhistory.do
      - 3_3_fixedeffect.do
   - results

resultsのフォルダは、3.1（レキシス図の作成）をやらないのなら不要です
-------------------------*/ 

clear all
set more off
macro drop _all

*** データの読み込み（sav - dtaの変換）
import spss "../data/SSM2015_v070_20170227.sav", clear
save "../data/ssm2015.dta", replace
clear all

/*----------------------------------------------------*/
   /* [>   1.  パーソンイヤーデータの準備   <] */ 
/*----------------------------------------------------*/

do "1_expand_data.do"

/*----------------------------------------------------*/
   /* [>   2.  時変の変数の作成   <] */ 
/*----------------------------------------------------*/

*** 2.1 職歴関連変数
do "2_1_job_history.do"

*** 2.2 学校関連変数
do "2_2_school_history.do"

*** 2.3 婚姻状態関連変数
do "2_3_marriage_history.do"

*** 2.4 子ども関連変数
do "2_4_child_history.do"

*** 2.9 作成した変数の一覧表
do "2_9_variablelists.do"

*** データを保存
save "../data/ssm2015personyear.dta", replace

/*----------------------------------------------------*/
   /* [>   3.  分析例   <] */ 
/*----------------------------------------------------*/

*** 3.1 データの構造の可視化（レキシス図）
do "3_1_scatter.do"

*** 3.2 従業上の地位による初婚への移行の違いに関するイベントヒストリー分析
do "3_2_eventhistory.do"

*** 3.3 第一子出産が就業率に与える効果に関する固定効果モデル
do "3_3_fixedeffect.do"





