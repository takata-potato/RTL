# 35_specify — specifyとパス遅延

RTLの論理とセルの端子間遅延は別に記述できる。

```bash
make learn LAB=35_specify
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | 入力変化から出力までtyp値3ns。-mindelays/-maxdelaysで1ns/5ns。 |
| 1か所変える実験 | ARGS=-maxdelaysで5nsへ変更し、ARGS="-maxdelays +EXPECTED_DELAY=5"で照合する。 |
| 文法 | specify / specparam / parallel path => / full path *> / rise/fall delay / min:typ:max / pulsestyle / showcancelled |
| 仕様書 | §30、§11.11（詳細なページは索引から開く） |
| 実験形式 | sim |
| Icarus対象 | あり |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
