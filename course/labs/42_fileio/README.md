# 42_fileio — ファイル・メモリー・plusargs・波形

実行時引数→変数→刺激→ファイル出力、を1本の流れで見る。

```bash
make learn LAB=42_fileio
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | 既定COUNT=4。メモリー0x10,20,30,40を読み、results.txtへ出力して読み戻す。 |
| 1か所変える実験 | ARGS="+COUNT=2 +WAVES"で回数とVCDの有無を変更する。 |
| 文法 | $display / $write / $monitor / $fopen / $fclose / $fdisplay / $fscanf / $fgets / $sscanf / $feof / $readmemh / $writememh / $test$plusargs / $value$plusargs / $dumpfile / $dumpvars |
| 仕様書 | §21（詳細なページは索引から開く） |
| 実験形式 | sim |
| Icarus対象 | あり |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
