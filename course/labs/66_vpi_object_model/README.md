# 66_vpi_object_model — VPIの83種の対象・関係を辿る

37章の図は回路図でなく、VPIオブジェクト間を辿る地図。

```bash
make learn LAB=66_vpi_object_model
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | 37.1〜37.83を索引から読み、41/57のhandle取得を別の対象に拡張する。 |
| 1か所変える実験 | module→netをiterateし、name/size/typeを出力するCコードを追加する。 |
| 文法 | one-to-one relation / one-to-many relation / vpi_iterate / vpi_scan / vpi_handle / typespec / scope / net / variable / class / assertion / covergroup |
| 仕様書 | §37、§38（詳細なページは索引から開く） |
| 実験形式 | reference |
| Icarus対象 | なし。Xcelium向け、または資料・外部機能の実験。 |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
