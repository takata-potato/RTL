# 12_subroutines — task/functionと引数の受渡し

functionは時間を進めず、taskは待てる。refは呼出し元を直接参照する。

```bash
make learn LAB=12_subroutines
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | factorial(5)=120。refのswapで3と9を交換。taskで2ns経過。 |
| 1か所変える実験 | swapのrefをinputへ変えると呼出し元が変わらなくなる。 |
| 文法 | task automatic / function automatic / input / output / inout / ref / const ref / default argument / named argument / return / void cast |
| 仕様書 | §13、§6.21（詳細なページは索引から開く） |
| 実験形式 | sim |
| Icarus対象 | なし。Xcelium向け、または資料・外部機能の実験。 |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
