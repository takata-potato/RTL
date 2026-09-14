# 32_gates — ゲートプリミティブと駆動強度

論理ゲートを直接インスタンス化し、三状態と強弱の解決を観察する。

```bash
make learn LAB=32_gates
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | enable=0でpullupにより1。enable=1でstrong0がweak1に勝つ。 |
| 1か所変える実験 | strong0をweak0へ変えると同強度の競合がXになる。 |
| 文法 | and / nand / nor / or / xor / xnor / buf / not / bufif1 / notif0 / pullup / pulldown / strong / weak / highz / gate delay |
| 仕様書 | §28.1、§28.2、§28.3、§28.4、§28.5、§28.6、§28.10、§28.11、§28.12、§28.15、§28.16（詳細なページは索引から開く） |
| 実験形式 | sim |
| Icarus対象 | あり |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
