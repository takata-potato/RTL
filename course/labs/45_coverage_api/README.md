# 45_coverage_api — コードカバレッジAPI

covergroupと別に、ツールが計測するtoggleカバレッジを問い合わせる。

```bash
make learn LAB=45_coverage_api
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | カバレッジが利用可能であることを先に検査し、取得値と最大値を表示する。 |
| 1か所変える実験 | -coverage allを外すと計測できない場合がある。NOCOVを100%と取り違えない。 |
| 文法 | $coverage_control / $coverage_get / $coverage_get_max / $coverage_save / SV_COV_START / SV_COV_CHECK / SV_COV_TOGGLE / SV_COV_HIER |
| 仕様書 | §40、§20.14（詳細なページは索引から開く） |
| 実験形式 | sim |
| Icarus対象 | なし。Xcelium向け、または資料・外部機能の実験。 |

Xceliumの-coverage allを付与する。標準APIの対応は導入版で要確認。API未対応やNOCOVは成功扱いにしない。

コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
