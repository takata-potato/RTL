# 34_udp — UDPの真理値表と状態表

小さな部品を表で定義する。組合せUDPとposedgeで保持するUDPを比較する。

```bash
make learn LAB=34_udp
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | ANDの全入力4組とUDP FFの保持を検査する。 |
| 1か所変える実験 | 表の0 ? : 0を消すと、該当入力が未定義のXになる。 |
| 文法 | primitive / table / endtable / combinational UDP / sequential UDP / edge descriptor / ? / - / initial |
| 仕様書 | §29（詳細なページは索引から開く） |
| 実験形式 | sim |
| Icarus対象 | あり |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
