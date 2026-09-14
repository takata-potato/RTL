# 38_config — libraryとconfigで実装を選ぶ

同名のcellをfast/slowライブラリーに置き、configでfastを選択する。

```bash
make learn LAB=38_config
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | fast版のresult=11。configのuseをslowへ変えると22。 |
| 1か所変える実験 | select.cfgのfast.cell_modelをslow.cell_modelへ変え、TB期待値を22へ変える。 |
| 文法 | library / libmap / config / design / default liblist / instance use / cell use / endconfig |
| 仕様書 | §33、§23.10（詳細なページは索引から開く） |
| 実験形式 | config |
| Icarus対象 | なし。Xcelium向け、または資料・外部機能の実験。 |

xrunのライブラリーマップを使う専用実行。展開する絶対パスはcommand.txtに保存。Slangの通常SVチェックとは分けて扱う。

コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
