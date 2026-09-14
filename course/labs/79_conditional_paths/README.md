# 79_conditional_paths — 条件付きパス・edge・パルス指令

modeによってパス遅延を選び、条件に合わないときのifnoneを使う。

```bash
make learn LAB=79_conditional_paths
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | mode=1の出力遅延2ns、mode=0ではifnoneの4ns。短パルスの扱いは拡張課題。 |
| 1か所変える実験 | 入力パルスを遅延より短くして、パルス指令によるX発生時刻の違いを波形で確認する。 |
| 文法 | ifnone / conditional specify path / pulsestyle_ondetect / pulsestyle_onevent / showcancelled / noshowcancelled / edge descriptor |
| 仕様書 | §30.4、§30.5、§30.6、§30.7、§31.5（詳細なページは索引から開く） |
| 実験形式 | sim |
| Icarus対象 | なし。Xcelium向け、または資料・外部機能の実験。 |



コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
