# 21_random_sequences — 乱数シード・randcase・randsequence

値の乱数だけでなく、実行する処理の枝や文法的な並びも選べる。

```bash
make learn LAB=21_random_sequences
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | randcaseは10/20、randsequenceはヘッダー1回とbody1回。seed=123を再設定すると同じ値。 |
| 1か所変える実験 | SEED=2で全体の乱数列を変更し、チェックは特定列へ依存しないことを確認する。 |
| 文法 | srandom / pre_randomize / post_randomize / randcase / randsequence / production / := / rand join / $urandom_range / $dist_normal |
| 仕様書 | §18.10、§18.13、§18.14、§18.15、§18.16、§18.17、§20.15、§N（詳細なページは索引から開く） |
| 実験形式 | sim |
| Icarus対象 | なし。Xcelium向け、または資料・外部機能の実験。 |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
