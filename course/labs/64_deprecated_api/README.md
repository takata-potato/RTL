# 64_deprecated_api — この版で廃止された項目を確認する

「目次に章がある」ことと「この版に文法が定義されている」ことは別。

```bash
make learn LAB=64_deprecated_api
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | 41章は廃止の1文だけ。具体的APIは1800-2005参照と書かれている。 |
| 1か所変える実験 | 付録Cの推奨代替を54_legacy_storageのコードと比較する。 |
| 文法 | deprecated / Data read API / optional system task / optional compiler directive / compatibility |
| 仕様書 | §1.9、§41、§C、§D、§E（詳細なページは索引から開く） |
| 実験形式 | reference |
| Icarus対象 | なし。Xcelium向け、または資料・外部機能の実験。 |

添付2017版に存在しない旧41章のAPIを捏造した実験にはしない。付録D/Eはoptionalで、環境依存のため本文の必須機能と区別する。

コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
