# 16_communication — event・mailbox・semaphore

キューで値を渡し、セマフォで共有資源を保護し、イベントで通知する。

```bash
make learn LAB=16_communication
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | mailboxで42を受信。並列に更新した共有値が2。NBAイベントを取りこぼさない。 |
| 1か所変える実験 | wait(done.triggered)と@doneで、通知前後の開始順の影響を調べる。 |
| 文法 | event / -> / ->> / triggered / wait_order / mailbox#() / put / get / try_get / peek / num / semaphore / get / put |
| 仕様書 | §6.17、§15（詳細なページは索引から開く） |
| 実験形式 | sim |
| Icarus対象 | なし。Xcelium向け、または資料・外部機能の実験。 |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
