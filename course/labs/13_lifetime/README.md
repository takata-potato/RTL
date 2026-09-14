# 13_lifetime — スコープとstatic/automatic

staticローカルは呼出し間で残り、automaticローカルは毎回初期化される。

```bash
make learn LAB=13_lifetime
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | staticは1,2。automaticは1,1。パッケージとブロックの同名変数は別物。 |
| 1か所変える実験 | static関数をautomaticへ変えてカウンターが保存されなくなるのを確かめる。 |
| 文法 | static lifetime / automatic lifetime / package scope / block scope / :: / $unit |
| 仕様書 | §3.13、§6.21、§8.9、§23.9、§26.3（詳細なページは索引から開く） |
| 実験形式 | sim |
| Icarus対象 | なし。Xcelium向け、または資料・外部機能の実験。 |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
