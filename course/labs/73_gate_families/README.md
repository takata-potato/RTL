# 73_gate_families — 全ゲート系の真理値を比較する

全4入力組について各ゲートの論理式と比較し、三状態の有効極性も確認する。

```bash
make learn LAB=73_gate_families
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | nand/nor/xnor/notがそれぞれ反転結果。bufif0はen=0で通り、en=1でZ。 |
| 1か所変える実験 | bufif0とbufif1を入れ替え、enableの有効極性が逆になるのを確かめる。 |
| 文法 | and / nand / or / nor / xor / xnor / buf / not / bufif0 / bufif1 / notif0 / notif1 / pullup / pulldown |
| 仕様書 | §28.4、§28.5、§28.6、§28.10（詳細なページは索引から開く） |
| 実験形式 | sim |
| Icarus対象 | あり |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
