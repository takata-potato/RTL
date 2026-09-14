# 05_struct_union — 構造体・共用体・代入パターン

structは並べて格納、unionは同じビットを別名で見る。

```bash
make learn LAB=05_struct_union
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | headerの4+4bitは0xa3、union.word=0xa3でも同じフィールドになる。 |
| 1か所変える実験 | structのメンバー順を逆にしてビット配置の変化を確かめる。 |
| 文法 | struct packed / union packed / unpacked struct / assignment pattern / default pattern |
| 仕様書 | §5.10、§6.4、§7.2、§7.3、§10.9（詳細なページは索引から開く） |
| 実験形式 | sim |
| Icarus対象 | なし。Xcelium向け、または資料・外部機能の実験。 |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
