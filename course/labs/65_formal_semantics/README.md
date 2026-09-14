# 65_formal_semantics — SVAの空列・vacuous・strong/weak

同じassertが成功でも、要求が来なかっただけの成功と、応答まで観測した成功を区別する。

```bash
make learn LAB=65_formal_semantics
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | req=0の区間は応答検査がvacuous。reqが来た区間は23/25/48でcoverを使い成立を確認する。 |
| 1か所変える実験 | 23のreqを常に0にしてassertが失敗しなくても有効な試験とは限らないことを確認する。 |
| 文法 | empty match / vacuous success / finite trace / infinite trace / strong / weak / sequence rewriting |
| 仕様書 | §16.12、§F（詳細なページは索引から開く） |
| 実験形式 | reference |
| Icarus対象 | なし。Xcelium向け、または資料・外部機能の実験。 |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
