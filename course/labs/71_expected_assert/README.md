# 71_expected_assert — 失敗を学ぶ：assertが動いたことを確認

終了コード0だけでなく、実際に照合を行っていることを確かめる。

```bash
make learn LAB=71_expected_assert
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | EXPECTED_ASSERT_FAILUREで実行が失敗する。それを期待した実験として記録する。 |
| 1か所変える実験 | observedを8にすると意図した失敗が起きず、ランナー側が失敗を報告する。 |
| 文法 | immediate assert / fatal / expected failure / self checking |
| 仕様書 | §16.3、§20.10（詳細なページは索引から開く） |
| 実験形式 | runtime_fail |
| Icarus対象 | あり |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
