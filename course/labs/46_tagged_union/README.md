# 46_tagged_union — tagged unionとパターン照合

値と種類を一緒に持ち、タグが一致したときだけ中身を読む。

```bash
make learn LAB=46_tagged_union
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | Some(42)は42、Noneは-1になる。 |
| 1か所変える実験 | SomeをNoneへ切り替え、不適切なメンバー読取りを避ける仕組みを見る。 |
| 文法 | union tagged / tagged / matches / case matches / pattern variable / &&& |
| 仕様書 | §7.3、§11.9、§12.6（詳細なページは索引から開く） |
| 実験形式 | sim |
| Icarus対象 | なし。Xcelium向け、または資料・外部機能の実験。 |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
