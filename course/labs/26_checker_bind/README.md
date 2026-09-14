# 26_checker_bind — checkerをbindで後付けする

RTL本体を編集せず、全インスタンスに検査器を追加する。

```bash
make learn LAB=26_checker_bind
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | 2つのcounter_cellにcheckerをbind。各々のカウント増加を検査する。 |
| 1か所変える実験 | cellの+1を+2へ変更するとbindされた検査が失敗する。 |
| 文法 | checker / endchecker / checker instance / default clocking / default disable iff / bind / $inferred_clock / $inferred_disable |
| 仕様書 | §17、§23.11（詳細なページは索引から開く） |
| 実験形式 | sim |
| Icarus対象 | なし。Xcelium向け、または資料・外部機能の実験。 |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
