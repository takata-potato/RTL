# 68_bad_implicit — 失敗を学ぶ：暗黙netを禁止する

タイプミスを1bit wireとして通してしまう書き方を、コンパイルで止める。

```bash
make learn LAB=68_bad_implicit
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | TYPO_SIGNALの未宣言診断でコンパイル失敗。ランナーはその診断だけを期待失敗として記録。 |
| 1か所変える実験 | `default_nettype wireへ変えて暗黙netが作られるケースと比較する。 |
| 文法 | default_nettype none / implicit net / undeclared identifier / compile error |
| 仕様書 | §6.10、§22.8（詳細なページは索引から開く） |
| 実験形式 | compile_fail |
| Icarus対象 | あり |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
