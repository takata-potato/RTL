# 76_control_edges — unique0・priority・casex・event順序・final

値の分岐とイベント順序を別々に検査する。finalは終了時の表示に使う。

```bash
make learn LAB=76_control_edges
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | casexはXを無視する。first→secondのイベント順序でwait_orderが成功する。 |
| 1か所変える実験 | イベントの順を逆にしてORDER_FAILURE、casexをcaseにして一致しないことを確認する。 |
| 文法 | unique0 / priority / casex / forever / wait_order / final / event / disable |
| 仕様書 | §9、§12、§15.5（詳細なページは索引から開く） |
| 実験形式 | sim |
| Icarus対象 | なし。Xcelium向け、または資料・外部機能の実験。 |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
