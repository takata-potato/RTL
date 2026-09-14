# 37_sdf — SDFで遅延を後から差し替える

同じセルにSDFを適用すると、コード内の1nsが4nsへ置き換わる。

```bash
make learn LAB=37_sdf
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | SDFのIOPATHによりa→yが4nsになる。入力ファイルは実行フォルダーへコピーされる。 |
| 1か所変える実験 | cell.sdfの4:4:4を6:6:6へ変え、期待値も6へ変更する。 |
| 文法 | $sdf_annotate / DELAYFILE / CELL / INSTANCE / IOPATH / ABSOLUTE / TIMESCALE / SDF mapping |
| 仕様書 | §32（詳細なページは索引から開く） |
| 実験形式 | sim |
| Icarus対象 | あり |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
