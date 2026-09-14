# 03_types — 2値・4値・整数・実数・時間

宣言時の値、ビット幅、2値型への代入によるX/Z消失。

```bash
make learn LAB=03_types
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | logicはX、bitは0。byte/shortint/int/longintは8/16/32/64bit。 |
| 1か所変える実験 | bit b4をlogicにするとXを保存する。 |
| 文法 | bit / logic / reg / byte / shortint / int / longint / integer / time / real / shortreal / realtime / const / type |
| 仕様書 | §6.1、§6.2、§6.3、§6.4、§6.5、§6.8、§6.9、§6.11、§6.12、§6.13、§6.20、§6.22、§6.23（詳細なページは索引から開く） |
| 実験形式 | sim |
| Icarus対象 | あり |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
