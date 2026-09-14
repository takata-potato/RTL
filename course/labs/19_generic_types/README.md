# 19_generic_types — 型パラメーターとinterface class

同じ入れ物にint型とbyte型を渡す。interface classはメソッドの契約になる。

```bash
make learn LAB=19_generic_types
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | Holder#(int)は32bit、Holder#(byte)は8bit。Readable経由で7を読む。 |
| 1か所変える実験 | Holder#(byte)へ300を入れて幅による切詰めを観察する。 |
| 文法 | parameter type / parameterized class / interface class / implements / typedef class / type operator |
| 仕様書 | §6.25、§8.25、§8.26、§8.27、§8.28、§13.8（詳細なページは索引から開く） |
| 実験形式 | sim |
| Icarus対象 | なし。Xcelium向け、または資料・外部機能の実験。 |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
