# 53_preprocessor_edges — 指令の作用範囲・暗黙の接続・行番号

未接続inputの既定駆動と、診断に出る論理ファイル名を操作する。

```bash
make learn LAB=53_preprocessor_edges
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | unconnected_drive pull1の範囲で作った未接続inputは1になる。 |
| 1か所変える実験 | pull1をpull0へ変え、期待値も0にする。resetallはマクロのundefineallとは別。 |
| 文法 | resetall / undefineall / unconnected_drive / nounconnected_drive / celldefine / endcelldefine / pragma / line / begin_keywords / end_keywords |
| 仕様書 | §22.3、§22.5、§22.9、§22.10、§22.11、§22.12、§22.14（詳細なページは索引から開く） |
| 実験形式 | sim |
| Icarus対象 | なし。Xcelium向け、または資料・外部機能の実験。 |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
