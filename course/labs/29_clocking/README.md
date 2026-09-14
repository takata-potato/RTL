# 29_clocking — clocking blockでサンプルと駆動を分ける

入力はエッジ直前、出力はエッジ後に扱い、DUTとの競合を避ける。

```bash
make learn LAB=29_clocking
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | cb.dへ7を送る。DUTが次のposedgeで取り込み、その次のcbサンプルでq=7。 |
| 1か所変える実験 | cb.qを1回早く読むと旧値が見える。入力skewを図と照らして考える。 |
| 文法 | clocking / default clocking / input #1step / output #0 / clocking event / ## / cycle delay / synchronous drive |
| 仕様書 | §14、§16.18、§25.7（詳細なページは索引から開く） |
| 実験形式 | sim |
| Icarus対象 | なし。Xcelium向け、または資料・外部機能の実験。 |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
