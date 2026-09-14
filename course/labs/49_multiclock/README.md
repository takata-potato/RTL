# 49_multiclock — 複数クロックのアサーション

clk_aの要求から次のclk_bの応答へ、SVAのクロックを切り替える。

```bash
make learn LAB=49_multiclock
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | 異なる周期の2クロックを使用。req_aの後のclk_bではready_b=1。 |
| 1か所変える実験 | ready_bを0へ変えて失敗する時刻を比較する。future系は将来のサンプルを要するので別途規格の意味を読む。 |
| 文法 | multiclocked sequence / multiclocked property / clock flow / global clocking / $global_clock / $past_gclk / $rose_gclk / $future_gclk |
| 仕様書 | §14.14、§16.9.4、§16.13、§16.16（詳細なページは索引から開く） |
| 実験形式 | sim |
| Icarus対象 | なし。Xcelium向け、または資料・外部機能の実験。 |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
