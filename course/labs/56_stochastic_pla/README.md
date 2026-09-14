# 56_stochastic_pla — キュー解析とPLAシステムタスク

古典的な待ち行列解析タスクと、配列で表す論理面を試す。

```bash
make learn LAB=56_stochastic_pla
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | キューへjob=7,info=42を追加して取り出す。OR arrayは選択行のORを出力。 |
| 1か所変える実験 | 2件追加しFIFO/LIFOのqueue_typeを1/2へ切り替える。 |
| 文法 | $q_initialize / $q_add / $q_remove / $q_full / $q_exam / $async$and$array / $async$or$array / $sync$and$array / $async$and$plane |
| 仕様書 | §20.16、§20.17（詳細なページは索引から開く） |
| 実験形式 | sim |
| Icarus対象 | なし。Xcelium向け、または資料・外部機能の実験。 |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
