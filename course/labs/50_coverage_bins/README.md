# 50_coverage_bins — 遷移bin・条件・除外bin

値だけでなく0→1→2という遷移も測る。除外と違反を区別する。

```bash
make learn LAB=50_coverage_bins
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | 有効サンプル0,1,2で遷移binを1回通り、value binも100%。 |
| 1か所変える実験 | enable=0でsampleしてiffによる除外を試す。3を入力するとillegal_binsの診断になる。 |
| 文法 | transition bins / bins[] / wildcard bins / with / iff / ignore_bins / illegal_bins / binsof / intersect / start / stop / set_inst_name |
| 仕様書 | §19.4、§19.5、§19.6、§19.7、§19.8、§19.10、§19.11（詳細なページは索引から開く） |
| 実験形式 | sim |
| Icarus対象 | なし。Xcelium向け、または資料・外部機能の実験。 |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
