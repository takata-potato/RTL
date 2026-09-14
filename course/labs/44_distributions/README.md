# 44_distributions — 古典的な確率分布関数

seedを更新する古典RNGと、SystemVerilogのスレッドRNGを区別する。

```bash
make learn LAB=44_distributions
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | uniformは1..6、同じseedの別変数は同じ値。各分布のサンプルを表示する。 |
| 1か所変える実験 | seedを固定して2回実行する。平均の推定にはサンプル数が必要で、1回の値で分布を評価しない。 |
| 文法 | $random / $urandom / $urandom_range / $dist_uniform / $dist_normal / $dist_exponential / $dist_poisson / $dist_chi_square / $dist_t / $dist_erlang |
| 仕様書 | §20.15、§N（詳細なページは索引から開く） |
| 実験形式 | sim |
| Icarus対象 | あり |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
