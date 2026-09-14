# 20_random — 制約付き乱数の基本

ランダム値の正しさは、具体的な乱数列ではなく制約を満たすかで検査する。

```bash
make learn LAB=20_random
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | lenは1..4、addrは偶数、payloadの各要素は添字以上。inline constraintでlen=3。 |
| 1か所変える実験 | inlineをlen==9に変えるとrandomize()が0を返す。戻り値を無視しない。 |
| 文法 | rand / randc / constraint / inside / dist / implication / foreach / soft / solve before / randomize with / rand_mode / constraint_mode / std::randomize |
| 仕様書 | §18.1、§18.2、§18.3、§18.4、§18.5、§18.6、§18.7、§18.8、§18.9、§18.11、§18.12（詳細なページは索引から開く） |
| 実験形式 | sim |
| Icarus対象 | なし。Xcelium向け、または資料・外部機能の実験。 |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
