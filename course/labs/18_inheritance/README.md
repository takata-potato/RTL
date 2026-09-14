# 18_inheritance — 継承・多態・アクセス制御

基底型ハンドルからvirtualメソッドを呼ぶと実体の実装が選ばれる。

```bash
make learn LAB=18_inheritance
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | ShapeハンドルでSquare.area()=16。downcast成功、別の派生型へは失敗。 |
| 1か所変える実験 | 基底クラスのvirtualを外せる非abstract例を作り、メソッド選択を比較する。 |
| 文法 | extends / super / virtual / pure virtual / virtual class / protected / local / extern / $cast |
| 仕様書 | §8.13、§8.14、§8.15、§8.16、§8.17、§8.18、§8.20、§8.21、§8.22、§8.23、§8.24（詳細なページは索引から開く） |
| 実験形式 | sim |
| Icarus対象 | なし。Xcelium向け、または資料・外部機能の実験。 |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
