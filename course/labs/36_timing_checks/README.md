# 36_timing_checks — setup/hold・幅・周期を検査する

タイミングチェックはsetup/hold違反を通知する。論理値の正しさとは別の検査。

```bash
make learn LAB=36_timing_checks
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | 通常入力は違反なし。+VIOLATEでsetup違反を起こし、notifier変化を観察する。 |
| 1か所変える実験 | ARGS=+VIOLATEでdataをクロックの1ns前へ寄せる。 |
| 文法 | $setup / $hold / $setuphold / $recovery / $removal / $recrem / $skew / $timeskew / $fullskew / $period / $width / $nochange / notifier / &&& |
| 仕様書 | §31（詳細なページは索引から開く） |
| 実験形式 | sim |
| Icarus対象 | なし。Xcelium向け、または資料・外部機能の実験。 |

Icarusはタイミングチェックを十分に実行しないため対象外。+VIOLATEでnotifierが動かなければ合格にせず失敗する。Xceliumでtiming checkを無効化しないこと。

コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
