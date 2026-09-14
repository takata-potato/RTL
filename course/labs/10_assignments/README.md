# 10_assignments — 代入・保持・force/release

組合せ、FF、ラッチそれぞれで値がいつ更新されるか見る。

```bash
make learn LAB=10_assignments
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | FFはposedge後、ラッチはgate=1中に追従、forceしたwireはreleaseで元へ戻る。 |
| 1か所変える実験 | always_ffの<=を=へ変え、14_schedulingと比較する。 |
| 文法 | assign / always_comb / always_ff / always_latch / blocking / nonblocking / force / release / compound assignment |
| 仕様書 | §10、§9.2（詳細なページは索引から開く） |
| 実験形式 | sim |
| Icarus対象 | あり |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
