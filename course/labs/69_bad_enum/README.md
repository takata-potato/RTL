# 69_bad_enum — 失敗を学ぶ：enumへ整数を直入れ

enumはビット幅が同じだけでは暗黙に代入できない。

```bash
make learn LAB=69_bad_enum
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | BAD_ENUM_ASSIGNの代入に型変換の診断が出る。 |
| 1か所変える実験 | STATE_ONEへの名前代入または$castの戻り値検査に書き換える。 |
| 文法 | strong enum typing / explicit cast / required cast / compile error |
| 仕様書 | §6.19、§6.24（詳細なページは索引から開く） |
| 実験形式 | compile_fail |
| Icarus対象 | あり |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
