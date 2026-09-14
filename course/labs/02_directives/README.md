# 02_directives — コンパイル前にコードが変わる

マクロはコンパイル時、plusargsはシミュレーション時に選ぶ。

```bash
make learn LAB=02_directives
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | 既定WIDTH=8。+define+LAB_WIDTH=12 では12。+LAB_WIDTH=12では8。 |
| 1か所変える実験 | make learn LAB=02_directives ARGS="+define+LAB_WIDTH=12" と ARGS="+LAB_WIDTH=12" を比べる。 |
| 文法 | include / include guard / define / undef / ifdef / ifndef / elsif / else / endif / default_nettype / timescale / begin_keywords |
| 仕様書 | §22、§3.14（詳細なページは索引から開く） |
| 実験形式 | sim |
| Icarus対象 | あり |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
