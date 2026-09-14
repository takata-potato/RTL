# 43_utilities — 便利なシステム関数

幅・ビット数・数学関数・表示形式を一度に試す。

```bash
make learn LAB=43_utilities
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | countones(1011)=3、onehot(0100)=1、sqrt(16)=4、realのビット往復が一致。 |
| 1か所変える実験 | $clog2(1)の0を配列幅へ使うとどうなるか、前のsyntax_demoと比較する。 |
| 文法 | $time / $realtime / $timeformat / $printtimescale / $bits / $clog2 / $countones / $countbits / $onehot / $onehot0 / $isunknown / $signed / $unsigned / $realtobits / $bitstoreal / $sqrt / $pow / $ln / $fatal / $warning / $info |
| 仕様書 | §20.1、§20.2、§20.3、§20.4、§20.5、§20.6、§20.8、§20.9、§20.10、§20.11、§20.18（詳細なページは索引から開く） |
| 実験形式 | sim |
| Icarus対象 | あり |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
