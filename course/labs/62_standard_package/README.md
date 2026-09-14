# 62_standard_package — 標準パッケージstdを読む

付録Gの宣言と、15/16/20/52の呼出しを1対1で照合する。

```bash
make learn LAB=62_standard_package
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | mailbox#(int)のget(ref T)と、process::statusの返却enumを規格で確認する。 |
| 1か所変える実験 | mailbox#(int)にstringをputして型検査がどこで働くか試す。 |
| 文法 | std:: / mailbox / semaphore / process / randomize / built-in class signatures |
| 仕様書 | §26.7、§G、§15、§9.7、§18.12（詳細なページは索引から開く） |
| 実験形式 | reference |
| Icarus対象 | なし。Xcelium向け、または資料・外部機能の実験。 |

stdはシミュレータが提供する。付録Gをコピーしてpackage stdを再定義しない。宣言を読むための演習。

コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
