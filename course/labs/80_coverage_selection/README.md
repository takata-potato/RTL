# 80_coverage_selection — wildcard binとcrossの選択

bitパターンをまとめるbinと、crossの一部だけを対象にするbinを使う。

```bash
make learn LAB=80_coverage_selection
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | 上位bitごとのwildcard binと、値0/1×mode0/1の4組を踏む。 |
| 1か所変える実験 | binsof値集合のintersectを変え、対象になる組合せを手書きの表で確かめる。 |
| 文法 | wildcard bins / binsof / intersect / cross selection / ignore_bins |
| 仕様書 | §19.5、§19.6（詳細なページは索引から開く） |
| 実験形式 | sim |
| Icarus対象 | なし。Xcelium向け、または資料・外部機能の実験。 |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
