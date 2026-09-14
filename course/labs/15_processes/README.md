# 15_processes — fork・join・プロセス制御

並列処理の待ち方と、タイムアウト時に子プロセスを止める方法。

```bash
make learn LAB=15_processes
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | joinで2件完了、join_any後disable forkで遅い枝を停止、join_none後wait forkで待つ。 |
| 1か所変える実験 | disable forkを外すと遅い枝も完了する。 |
| 文法 | fork join / join_any / join_none / wait fork / disable fork / process::self / status / kill / await / wait |
| 仕様書 | §9.3、§9.4、§9.5、§9.6、§9.7（詳細なページは索引から開く） |
| 実験形式 | sim |
| Icarus対象 | なし。Xcelium向け、または資料・外部機能の実験。 |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
