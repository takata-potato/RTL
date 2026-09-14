# 61_keywords — 予約語と名前空間を検索する

付録Bの全予約語を一覧化し、コード内の使用箇所とBNFに繋げる。

```bash
make learn LAB=61_keywords
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | class、checker、randsequence、interconnectなどを検索して、定義と使用例へ移動する。 |
| 1か所変える実験 | 予約語cellを普通の識別子に使うと構文エラー。エスケープ識別子にした場合を比較する。 |
| 文法 | reserved keyword / escaped identifier / system task name / compilation unit / package namespace |
| 仕様書 | §5.6、§B、§3.13（詳細なページは索引から開く） |
| 実験形式 | reference |
| Icarus対象 | なし。Xcelium向け、または資料・外部機能の実験。 |

予約語の「コードあり」はコメントや文字列を除いたトークン検索。コード例がない語は「原文・発展課題」と明記し、使用済みと数えない。

コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
