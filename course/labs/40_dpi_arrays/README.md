# 40_dpi_arrays — DPIの配列・4値ベクトル・時間を進めるtask

C側で配列の添字範囲を調べ、4値を壊さずコピーし、SVのtaskへ制御を戻して待つ。

```bash
make learn LAB=40_dpi_arrays
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | 添字3..5の10+20+30=60。X/Zを含む8bitを保持。C経由のtaskで2ns進む。 |
| 1か所変える実験 | 配列の添字を[7:5]へ変え、Cが0始まりを仮定していないことを確かめる。 |
| 文法 | svOpenArrayHandle / svLow / svHigh / svGetArrElemPtr1 / svLogicVecVal / aval / bval / import context task / export task |
| 仕様書 | §35.5、§35.6、§35.8、§35.9、§H.8、§H.11、§H.12、§I、§J（詳細なページは索引から開く） |
| 実験形式 | dpi |
| Icarus対象 | なし。Xcelium向け、または資料・外部機能の実験。 |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
