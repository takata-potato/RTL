# 04_enum_cast — enumと型キャスト

enumは名前の付いた型。$castは値が列挙子に含まれるか検査する。

```bash
make learn LAB=04_enum_cast
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | IDLE→BUSY→DONE。3のdynamic castは失敗し、元の値を保存。 |
| 1か所変える実験 | $cast(state, 3) を $cast(state, 1) に変えて成功側を観察する。 |
| 文法 | typedef / enum / first / last / next / prev / num / name / 静的キャスト / $cast / $typename |
| 仕様書 | §6.18、§6.19、§6.24、§6.25（詳細なページは索引から開く） |
| 実験形式 | sim |
| Icarus対象 | なし。Xcelium向け、または資料・外部機能の実験。 |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
