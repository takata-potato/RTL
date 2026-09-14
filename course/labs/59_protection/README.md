# 59_protection — 保護エンベロープを分解して読む

暗号化前ソース→暗号化ツール→保護済みソース→復号してコンパイル、の境界を見る。

```bash
make learn LAB=59_protection
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | まずsource.svを通常実行。自分のXcelium版の暗号化コマンドで保護した後、同じTBで結果を比較する。 |
| 1か所変える実験 | run前にprotect_inspect.pyへ暗号化済みファイルを渡し、envelopeの構造と暗号方式を読む。 |
| 文法 | pragma protect / begin / end / begin_protected / end_protected / key_keyowner / key_keyname / key_method / key_block / data_method / data_block / encoding |
| 仕様書 | §34、§O、§22.11（詳細なページは索引から開く） |
| 実験形式 | external |
| Icarus対象 | なし。Xcelium向け、または資料・外部機能の実験。 |

暗号化にはツール提供の鍵・対応方式・暗号化コマンドが必要。ダミーの暗号文で復号に成功したことにはしない。平文のreference runと、外部で作ったprotected sourceのrunを同じTBで比較する手順をGUIDE.mdに記載。

コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
