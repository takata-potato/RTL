# 72_integrated_fifo — 総合演習：FIFOをRTL/TB/乱数/SVAで検証

深さ4のFIFOへpush/popを送り、キューを正解モデルとして毎回比較する。

```bash
make learn LAB=72_integrated_fifo
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | empty/full、同時push/pop、ポインター折返しを固定試験で踏んだ後、既定200回のランダム試験。 |
| 1か所変える実験 | ARGS=+CYCLES=1000で長く回す。RTLのread pointer更新を壊すとscoreboardが検出する。 |
| 文法 | synthesizable RTL / FIFO / parameter / always_ff / always_comb / class randomization / queue scoreboard / SVA / covergroup / plusargs / clocking discipline |
| 仕様書 | §4、§7、§8、§14、§15、§16、§18、§19、§21、§23、§25、§26、§27（詳細なページは索引から開く） |
| 実験形式 | sim |
| Icarus対象 | なし。Xcelium向け、または資料・外部機能の実験。 |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
