# 54_legacy_storage — 昔の記述を読む：defparamとprocedural assign

既存コードを読むため、parameterの後付け変更と手続き的連続代入を試す。

```bash
make learn LAB=54_legacy_storage
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | defparamでWIDTH=3。assign中はdを追従、deassign後は最後の値を保持する。 |
| 1か所変える実験 | 新規RTLでは#(.WIDTH(3))へ書換え、手続き的assignは通常のalways記述へ置換する。 |
| 文法 | defparam / procedural assign / deassign / force variable / release variable / deprecated syntax |
| 仕様書 | §10.6、§23.10、§C（詳細なページは索引から開く） |
| 実験形式 | sim |
| Icarus対象 | あり |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
