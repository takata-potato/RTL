# 75_declaration_forms — const/ref/type/varの違い

constは変更禁止、refは参照渡し、typeは式の型。parameter typeで入出力の型を決める。

```bash
make learn LAB=75_declaration_forms
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | 型パラメーター8bitのデータが2レーンへ渡り、const ref関数が配列和6を返す。 |
| 1か所変える実験 | const refの引数を書き換えようとしてコンパイル診断を確認する。 |
| 文法 | const / const ref / var / type / parameter type / macromodule / generate / endgenerate / genvar / uwire |
| 仕様書 | §6.18、§6.20、§6.23、§13.5、§23.2、§27（詳細なページは索引から開く） |
| 実験形式 | sim |
| Icarus対象 | なし。Xcelium向け、または資料・外部機能の実験。 |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
