# 51_constraint_control — 制約の継承・soft・unique・外部定義

softは既定値、hardは必須条件。状態固定時にも制約の整合性を検査できる。

```bash
make learn LAB=51_constraint_control
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | soft limit=2をinline limit=4で上書き。配列4要素は重複なし。 |
| 1か所変える実験 | softを外してhardにするとlimit=4のinline制約と矛盾する。 |
| 文法 | extern constraint / constraint inheritance / soft / disable soft / unique constraint / if constraint / implication / randomize(null) / local:: / pre_randomize / post_randomize |
| 仕様書 | §18.5、§18.6、§18.7、§18.8、§18.9、§18.10（詳細なページは索引から開く） |
| 実験形式 | sim |
| Icarus対象 | なし。Xcelium向け、または資料・外部機能の実験。 |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
