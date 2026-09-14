# 33_switches — MOS・双方向スイッチ・電荷

スイッチは値を生成するのでなく、端子間を接続・切断する。

```bash
make learn LAB=33_switches
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | tranif1を閉じるとsource=1がbusへ伝わり、開くとbus=Z。 |
| 1か所変える実験 | tranif1をrtranif1へ変え、%vで抵抗性スイッチの強度減衰を見る。 |
| 文法 | nmos / pmos / cmos / rnmos / rpmos / rcmos / tran / rtran / tranif1 / rtranif0 / trireg / supply0 / supply1 |
| 仕様書 | §28.7、§28.8、§28.9、§28.13、§28.14、§6.6（詳細なページは索引から開く） |
| 実験形式 | sim |
| Icarus対象 | あり |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
