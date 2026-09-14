# 74_charge_strength — 電荷保持・抵抗性スイッチ・net種類

接続が切れたtriregは電荷を保持する。triのZとは異なる。

```bash
make learn LAB=74_charge_strength
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | 3種類の電荷強度で1を保持。抵抗性MOSとpass switchを通した値と%vを表示する。 |
| 1か所変える実験 | triregをtriへ変えると切断後の値はZ。weakとstrongの組合せで%vを比べる。 |
| 文法 | trireg / small / medium / large / tri0 / tri1 / triand / trior / scalared / vectored / supply0 / supply1 / pmos / rnmos / rpmos / rcmos / tran / rtran / tranif0 / rtranif0 / rtranif1 / weak0 / highz0 / highz1 |
| 仕様書 | §6.6、§6.9.2、§28.7、§28.8、§28.9、§28.11、§28.12、§28.13、§28.14（詳細なページは索引から開く） |
| 実験形式 | sim |
| Icarus対象 | なし。Xcelium向け、または資料・外部機能の実験。 |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
