# 67_reading_map — 規格の読み方・用語・参照先

規格の要求、説明、例、外部参照を分けて読む。

```bash
make learn LAB=67_reading_map
```

| 見るもの | 内容 |
| --- | --- |
| 期待する結果 | コンパイル→elaboration→simulationの3段階をmakeの各入口と対応させる。 |
| 1か所変える実験 | 未定義識別子、存在しないmodule、実行時assertの3つを作って失敗する段階を分類する。 |
| 文法 | shall / should / may / normative / informative / design element / compilation / elaboration / simulation / glossary |
| 仕様書 | §1、§2、§3、§P、§Q（詳細なページは索引から開く） |
| 実験形式 | reference |
| Icarus対象 | なし。Xcelium向け、または資料・外部機能の実験。 |

対応する定義はPDF索引の1/2/3章と付録P/Qへ。規格中の使用例はそれ自体が仕様全体ではなく、本文の制約も読む。

コードはこのフォルダーのファイルを編集します。各`CHECK`が観察点、`LAB_PASS`が完走の印です。
文法欄には発展課題も含まれます。コードで実際に使ったトークンは全体索引の「コードあり」で検索できます。
