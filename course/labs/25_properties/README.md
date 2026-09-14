# 25_properties — propertyの合成と有限トレース

sequenceを真偽の性質として使い、終了までに成立すべき条件を表す。

```bash
make learn LAB=25_properties
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | busyを保った後doneになり、強い有限sequenceとuntilが成立する。 |
| 1か所変える実験 | doneを立てない変更で失敗や終了時未完了がどう報告されるか観察する。 |
| 文法 | property / strong / weak / not / and / or / iff / implies / until / until_with / s_until / s_eventually / always / accept_on / reject_on / expect |
| 仕様書 | §16.12、§16.17、§F（詳細なページは索引から開く） |
| 実験形式 | sim |
| Icarus対象 | なし。Xcelium向け、または資料・外部機能の実験。 |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
