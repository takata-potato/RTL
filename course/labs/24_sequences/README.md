# 24_sequences — SVAの列：遅延・繰返し・合成

A→B→Cという時間の並びを記述し、複数の演算子で同じトレースを照合する。

```bash
make learn LAB=24_sequences
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | A,B,Cを1サイクルずつ送ると複合sequenceが成立。 |
| 1か所変える実験 | Bのサイクルを1つ遅らせ、##1を##[1:2]へ変えた場合を比べる。 |
| 文法 | sequence / ## / [*] / [=] / [->] / first_match / and / or / intersect / throughout / within / local variable / sequence argument / matched / triggered |
| 仕様書 | §16.7、§16.8、§16.9、§16.10、§16.11、§16.12（詳細なページは索引から開く） |
| 実験形式 | sim |
| Icarus対象 | なし。Xcelium向け、または資料・外部機能の実験。 |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
