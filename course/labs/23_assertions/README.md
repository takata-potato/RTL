# 23_assertions — SVAの入口：サンプル値と1サイクル後

posedgeでサンプルするSVAと、NBA後に値を読むTBの違い。

```bash
make learn LAB=23_assertions
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | reqを立てた次のサンプルでack。+BREAK_PROTOCOLでSVAが明示的に失敗する。 |
| 1か所変える実験 | ARGS=+BREAK_PROTOCOLで応答を壊し、SVA_FAILUREを確認する。 |
| 文法 | immediate assert / assert property / assume property / cover property / disable iff / $past / $rose / $fell / $stable / $isunknown / deferred assert |
| 仕様書 | §16.1、§16.2、§16.3、§16.4、§16.5、§16.6、§16.14、§16.15、§16.16、§20.13（詳細なページは索引から開く） |
| 実験形式 | sim |
| Icarus対象 | なし。Xcelium向け、または資料・外部機能の実験。 |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
