# 81_interconnect — interconnectとinoutの接続専用net

interconnectは型を決めず接続だけを記述する。値を読むのは接続先の型付きnet。

```bash
make learn LAB=81_interconnect
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | 送り手の0xa5がinoutの接続を通り、受け手のsenseで読める。 |
| 1か所変える実験 | interconnectを直接$displayへ渡すと使用制限に抵触する。接続先のsenseを表示する。 |
| 文法 | interconnect / inout / tri / net port connection / port type resolution |
| 仕様書 | §6.6.8、§6.7、§23.3、§25（詳細なページは索引から開く） |
| 実験形式 | sim |
| Icarus対象 | なし。Xcelium向け、または資料・外部機能の実験。 |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
