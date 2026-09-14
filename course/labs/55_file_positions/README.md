# 55_file_positions — ファイルの位置・EOF・文字I/O

EOFは読み取りに失敗した後で分かる。位置を戻して同じ内容を読む。

```bash
make learn LAB=55_file_positions
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | ABCを出力しAを読んで戻し、seekでC、EOFで-1。 |
| 1か所変える実験 | EOF判定をreadより前だけに置くループと、戻り値を確認するループの差を見る。 |
| 文法 | $fputc via $fwrite / $fgetc / $ungetc / $fgets / $ftell / $fseek / $rewind / $fflush / $ferror / $feof / $fread |
| 仕様書 | §21.3（詳細なページは索引から開く） |
| 実験形式 | sim |
| Icarus対象 | あり |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
