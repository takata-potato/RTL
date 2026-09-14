# 31_nettypes — netの解決関数と複数ドライバー

標準netは4値と強さを解決、ユーザー定義nettypeは独自の解決関数を使える。

```bash
make learn LAB=31_nettypes
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | wand(1,0)=0、wor(1,0)=1、realの独自sum netは1.25+2.5=3.75。 |
| 1か所変える実験 | sum解決を最大値へ変更して複数アナログ値の合成を試す。 |
| 文法 | wire / tri / wand / wor / uwire / nettype / resolution function / user-defined nettype / interconnect |
| 仕様書 | §6.6、§6.7、§10.3、§23.3（詳細なページは索引から開く） |
| 実験形式 | sim |
| Icarus対象 | なし。Xcelium向け、または資料・外部機能の実験。 |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
