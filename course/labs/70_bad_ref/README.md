# 70_bad_ref — 失敗を学ぶ：refの実引数

refは変数そのものを参照するので、計算式は渡せない。

```bash
make learn LAB=70_bad_ref
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | BAD_REF_ARGUMENT(1+2)でref実引数が変数でないと診断される。 |
| 1か所変える実験 | int tmpに1+2を代入してからtmpを渡す。 |
| 文法 | ref argument / variable actual / type equivalence / compile error |
| 仕様書 | §13.5.2（詳細なページは索引から開く） |
| 実験形式 | compile_fail |
| Icarus対象 | なし。Xcelium向け、または資料・外部機能の実験。 |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
