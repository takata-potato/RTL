# 52_process_handles — processハンドルで停止・再開・kill

子スレッドをハンドルで操作する。killはそのプロセスの将来の仕事を止める。

```bash
make learn LAB=52_process_handles
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | 待ち状態の子をsuspend→resume→killし、10ns後の完了フラグが立たない。 |
| 1か所変える実験 | killの代わりにawaitを使うと、完了を待ってフラグが1になる。 |
| 文法 | process::self / process::status / RUNNING / WAITING / SUSPENDED / FINISHED / KILLED / suspend / resume / await / kill |
| 仕様書 | §9.7（詳細なページは索引から開く） |
| 実験形式 | sim |
| Icarus対象 | なし。Xcelium向け、または資料・外部機能の実験。 |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
