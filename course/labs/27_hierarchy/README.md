# 27_hierarchy — module・package・generate

パラメーターで回路を展開し、階層名から各レーンを確認する。

```bash
make learn LAB=27_hierarchy
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | 4レーンの加算器が0+10,1+10,2+10,3+10を計算。 |
| 1か所変える実験 | LANESを1や8へ変え、generateの展開数と階層が変わるのを見る。 |
| 文法 | module / parameter / localparam / package / import / export / generate for / generate if / generate case / genvar / named port / .* / hierarchical name |
| 仕様書 | §3、§23、§26、§27（詳細なページは索引から開く） |
| 実験形式 | sim |
| Icarus対象 | あり |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
