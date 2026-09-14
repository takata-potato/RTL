# 14_scheduling — イベント領域とNBAを目で見る

#0はNBAの完了待ちにならない。値を表示する領域で見える値が変わる。

```bash
make learn LAB=14_scheduling
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | ACTIVE q=0、INACTIVE q=0、POSTPONED q=1。同じ時刻でも順序がある。 |
| 1か所変える実験 | q<=1をq=1に変えるとActiveから1が見える。 |
| 文法 | Active / Inactive / NBA / Postponed / $display / $strobe / #0 / intra-assignment delay / nonblocking assignment |
| 仕様書 | §4、§9.4、§10.4、§21.2（詳細なページは索引から開く） |
| 実験形式 | sim |
| Icarus対象 | あり |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
