# 30_program — programのReactive領域

moduleのNBA更新を、programのReactive領域から読む。

```bash
make learn LAB=30_program
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | 最初のposedgeでDUTがq<=q+1を実行し、programはq=1を読む。 |
| 1か所変える実験 | programをmoduleに変えると同じposedgeで読む値は更新前になる。 |
| 文法 | program automatic / Reactive / Re-NBA / program port / program termination |
| 仕様書 | §24、§4.4、§4.8（詳細なページは索引から開く） |
| 実験形式 | sim |
| Icarus対象 | なし。Xcelium向け、または資料・外部機能の実験。 |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
