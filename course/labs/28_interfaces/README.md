# 28_interfaces — interface・modport・virtual interface

信号を束ね、modportで向きを定め、classからvirtual interface経由で駆動する。

```bash
make learn LAB=28_interfaces
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | driverが7を送り、DUTが1を足して8を返す。 |
| 1か所変える実験 | DUT modportからinputのdataを書き換えようとすると方向違反になる。 |
| 文法 | interface / modport / interface port / parameterized interface / virtual interface / interface task / ref interface member |
| 仕様書 | §25（詳細なページは索引から開く） |
| 実験形式 | sim |
| Icarus対象 | なし。Xcelium向け、または資料・外部機能の実験。 |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
