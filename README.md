# SSM職歴データのパーソンイヤーデータへの変換

**Author**: Ryota Mugiyama

**Initial upload**: 2024-05-31

**Last update**: 2024-06-11

**Version**: 1.1

## 概要
2015年SSM調査のパーソンイヤーデータを作成するコードをアップロードします。今後もちょくちょくアップデートする可能性があります。もし間違いなどを見つけた場合はご連絡をいただけるとありがたいです。

コードを利用する場合は、バージョンに応じて以下のように出典を記載していただくとありがたいです（修正を入れたらversionを更新します）。

麦山亮太，2024，「SSM職歴データのパーソンイヤーデータへの変換 ver1.0」（2024年5月31日閲覧，https://github.com/ryotamugiyama/ssm2015personyear ）．

## 使い方

ファイルを一括ダウンロードしていただき、ご自身のprojectフォルダにおいて、以下のように構造化したフォルダおよびファイルを準備してください。

* Project
    * data
        * SSM2015_v070_20170227.sav（またはSSJDA archiveなどからダウンロードしたその他のバージョンのファイル）
    * code
        * _master_ssm2015personyear.do
        * 1_expand_data.do
        * 2_1_job_history.do
        * 2_2_school_history.do
        * 2_3_marriage_history.do
        * 2_4_child_history.do
        * 2_9_variablelists.do
        * 3_1_scatter.do
        * 3_2_eventhistory.do
        * 3_3_fixedeffect.do
    * results
 
Stataで_master_ssm2015personyear.doを開き、working directoryを「code」フォルダに設定してください。

63行目（save "../data/ssm2015personyear.dta", replace）までを実行すると、「data」フォルダ内にパーソンイヤー形式に変換したdtaファイルが出力されます。
