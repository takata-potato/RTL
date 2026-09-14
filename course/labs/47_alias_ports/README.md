# 47_alias_ports — alias・非ANSIポート・interconnect

aliasは代入でなく同じnetの別名。古い形式のポート宣言も読む。

```bash
make learn LAB=47_alias_ports
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | alias経由で0xa5、非ANSIモジュールで0x5aへ反転。 |
| 1か所変える実験 | aliasを双方向assignで真似すると意味が同じとは限らないことを検討する。 |
| 文法 | alias / non-ANSI module / extern module / interconnect / port collapse / hierarchical reference |
| 仕様書 | §10.11、§23.2、§23.3、§23.5、§23.6、§23.7、§23.8（詳細なページは索引から開く） |
| 実験形式 | sim |
| Icarus対象 | なし。Xcelium向け、または資料・外部機能の実験。 |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
