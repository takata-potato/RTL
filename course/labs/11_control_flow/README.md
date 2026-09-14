# 11_control_flow — 分岐・繰返し・脱出

ループの条件とbreak/continue、X/Zを含むcaseの違い。

```bash
make learn LAB=11_control_flow
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | 偶数0+2+4+6=12。casezでZがワイルドカードになる。 |
| 1か所変える実験 | casezをcaseに変えるとZ入力はdefaultへ行く。casexではXも無視される点を比べる。 |
| 文法 | if / case / casez / casex / unique / unique0 / priority / inside / for / foreach / repeat / while / do while / break / continue / return / disable |
| 仕様書 | §12、§11.4（詳細なページは索引から開く） |
| 実験形式 | sim |
| Icarus対象 | なし。Xcelium向け、または資料・外部機能の実験。 |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
