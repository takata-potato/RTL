# 07_collections — 動的配列・連想配列・キュー

伸縮する配列、キー検索、FIFO、配列メソッドを使い分ける。

```bash
make learn LAB=07_collections
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | 動的配列を3→5へ拡張して先頭を保持、連想配列は2件、キュー合計12。 |
| 1か所変える実験 | new[5](a)の(a)を外すと既存値がコピーされない。 |
| 文法 | new[] / delete / exists / first / next / num / push_back / push_front / pop_front / sort / reverse / find / unique / sum / with |
| 仕様書 | §7.5、§7.8、§7.9、§7.10、§7.12（詳細なページは索引から開く） |
| 実験形式 | sim |
| Icarus対象 | なし。Xcelium向け、または資料・外部機能の実験。 |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
