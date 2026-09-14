# 78_interface_broadcast — interfaceのextern forkjoin task

interfaceの1回のtask呼出しで、接続された2つのmoduleの実装を並列に実行する。

```bash
make learn LAB=78_interface_broadcast
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | ID=0と1の各subscriberが各自のdone bitを立て、呼出しから戻ると11。 |
| 1か所変える実験 | 片方のsubscriberを取り除くとdone=01。共有の同一変数への競合書込みを避けて各bitを分ける。 |
| 文法 | extern forkjoin task / modport export / hierarchical task definition / broadcast task |
| 仕様書 | §25.7.4（詳細なページは索引から開く） |
| 実験形式 | sim |
| Icarus対象 | なし。Xcelium向け、または資料・外部機能の実験。 |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
