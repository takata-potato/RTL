# 06_arrays — 配列の向きと寸法

変数名の左はpacked、右はunpacked。昇順・降順でleft/rightが変わる。

```bash
make learn LAB=06_arrays
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | packed 2×8bitは16bit、unpackedの添字は2..4。 |
| 1か所変える実験 | unpackedの[2:4]を[4:2]にし、left/rightとlow/highを比較する。 |
| 文法 | packed / unpacked / 多次元配列 / foreach / $left / $right / $low / $high / $size / $dimensions / $unpacked_dimensions |
| 仕様書 | §5.11、§7.4、§7.6、§7.7、§7.11、§20.7（詳細なページは索引から開く） |
| 実験形式 | sim |
| Icarus対象 | あり |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
