# 08_strings — 文字列の操作と数値変換

文字列を組み立て、切り出し、数値を取り出す。

```bash
make learn LAB=08_strings
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | sv→SV、0x2a→42、addr=42のscan成功数は1。 |
| 1か所変える実験 | scan対象をaddr=oopsに変えると成功数が0になる。 |
| 文法 | string / len / getc / putc / substr / toupper / tolower / compare / icompare / atoi / atohex / itoa / hextoa / $sformatf / $sscanf |
| 仕様書 | §6.16、§11.10、§21.3（詳細なページは索引から開く） |
| 実験形式 | sim |
| Icarus対象 | なし。Xcelium向け、または資料・外部機能の実験。 |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
